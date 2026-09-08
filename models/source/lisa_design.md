# Lisa Mini — Design Reference

Source image: `lisa_design.png` (four views: front 3/4, angled front, side
profile, rear). This file captures what that image specifies, and how the
OpenSCAD model (`lisa_modern_template.scad`) maps to it, so future edits can
check back against the original intent instead of just the current code.

## Spec sheet (as stated in the image)

- **Width:** 330 mm (13.0 in)
- **Height:** 240 mm (9.4 in)
- **Depth:** 95 mm (3.7 in)
- **Weight (est.):** ~1.1 kg (2.4 lb)

**Design features called out in the image:**
- 9.7" 4:3 LCD (iPad panel), ~197×148mm visible area
- Inspired by the original Apple Lisa
- Optimized for 3D printing
- Minimal parts, no visible joins
- Front vent lines preserved
- Single PCB mount
- Integrated stand (legs)
- FloppyEmu slot (optional, not modeled)

**Printing notes called out in the image:**
- Designed for FDM printing
- No overhangs > 45°
- Snap-fit or screw assembly
- Wall thickness: 2.4mm
- Infill: 15–20% recommended

## What the image actually shows (visual detail, since dimensions alone
don't capture the shape)

- **Front:** screen roughly centered-left, with short horizontal vent
  ticks in a narrow strip on the left of the screen, and a noticeably
  wider block of the same vent lines on the right of the screen. Rainbow
  Apple logo bottom-right of the bezel (not modeled — decorative decal,
  out of scope). Vent lines start about level with the top of the screen
  and run for roughly the screen's upper half — they don't span the full
  case height.
- **Side profile:** the whole unit reads as a wedge — deep flat base at
  the feet, narrowing toward the top. Critically, the *screen leans back*
  (like the original Lisa's CRT housing) while the *back panel stays
  vertical*. The foot is clearly an L-shape: a slim, tapering riser
  attached under the case, meeting a flat pad that reaches forward along
  the floor — not a simple wedge or cone.
  - Now that the model's front actually leans back per the tilt fix, the
    case's real proportions (`body_depth_bottom=80`, `body_depth_top=45`,
    `case_height=189` currently) are shallower than the image's stated
    330×240×95 — see "Deliberate deviations" below.

### Legs: seamlessness is the critical detail

In the reference image, the leg is **not a bolted-on foot** — each side
panel of the case reads as *one continuous piece* that simply keeps going
past the bottom of the electronics housing, all the way to the floor, with
a subtle forward flare only right at the base (where it steps out from
under the case's own front-bottom overhang). There is no separate "foot"
element visually distinguishable from the case's own side — no step, seam,
or change of plane anywhere along that edge, front or back. This is the
single biggest reason the reference reads as "Lisa-like" rather than
"generic monitor stand": a leg that is numerically positioned to *match*
the case's dimensions still reads as an attached accessory if it's built
as an independent part; only a leg that *is* the case's own geometry,
merely continued, reads as seamless.

**First attempt (superseded):** anchored a separately-shaped L-bracket
(flat pad + tapered riser, its own independent width/depth parameters) so
its back face lined up with the case's rear-plane Z depth. This fixed the
back-face gap but still looked like "a leg" rather than "the case's own
side" — narrower than the case, inset from its edges, with its own corner
radius and taper rate that had to be separately chosen and matched. The
result was correct by the numbers but still visually read as a separate
part, which is exactly the complaint this section exists to prevent.

**Current approach:** the leg is a left/right edge strip of the case's own
outer shell, sliced to `feet_width` at each edge via `leg_side_shape()`,
continued from the case's own y=0 down to the floor — and — critically —
built and called *from inside the same `body_tilt()` rotation as the case
itself* (see `rear_shell()`). Because it shares the case's width reference
(flush with the case edges, no inset) and rotation, there is no separate
shape to keep in sync — the leg's continuity with the case is guaranteed
by construction, not by matching numbers. The forward flare "under the
protruding screen" falls out of the rotation for free: points below the
case's own y=0 rotate to increasingly negative Z (more forward) as they go
down, since the tilt pivots on the case's front-bottom edge.

**Wrinkle 1 (fixed): floor contact wasn't actually flush.** Rotating the
leg the same way as the case means its underside is no longer level (the
same rotation that tilts the screen back also tilts the leg's floor
contact, sagging the back lower than the front). The first attempt at
`required_lift()` computed the exact lift that puts the leg's lowest point
(the back-bottom corner) precisely at y=0 -- which sounds right, but means
the clip-to-floor intersection has *nothing left to cut*: the leg's
underside just grazes the floor at that one back corner, with the rest of
the underside (most visibly the front) tilted up in the air above it,
15mm+ in the numbers this was caught at. The fix: decouple how deep the leg
is *built* from where it's *lifted to*. `leg_side_shape()` now builds each
leg `feet_height + leg_extra_reach` deep (deliberately well past the
intended floor), `required_lift()` simply sets the case's front-bottom
pivot edge (the one point `body_tilt()` never moves) `feet_height` above
the floor, and `rear_shell()`'s y≥0 clip then slices through *solid*
material across the whole leg footprint -- verified by exporting
`rear_shell()` alone and confirming the vertices at the true minimum Y
span each leg's full width (`x: 0-40` and `290-330`, not a single point),
i.e. a genuine flat cut, not a corner graze.

**Wrinkle 2 (fixed): rounding doubled up at the seam.** `leg_side_shape()`
originally reused the case's own `rounded_prism` (same `corner_radius`),
which rounds the leg's own top edge right where it meets the case --
directly on top of the case's own bottom-corner rounding, at the same Y.
Two independently-rounded corners stacked at one seam reads as a pinched
double-curve rather than one clean transition. Fixed by dropping rounding
from the leg entirely (a plain `cube()`, no radius) and raising it up by
`leg_overlap` (`corner_radius + 0.2`) past the case's own y=0, so the
leg's sharp material fills in solid over the case's rounded corner instead
of showing its own curve there -- the only rounding left along that edge
is wherever the case is rounded on its own (its top corners), unrelated to
the leg. `tilt_angle()` was pulled out of `body_tilt()` into its own
function so `required_lift()` and `leg_side_shape()` can't drift out of
sync with the case's own tilt.

**The L profile itself.** Up to this point the leg was still a solid
block (flush back, flush width, floor-clipped, seam-hidden -- but no
notch). Giving it the actual L shape means cutting away the top-front
mass, per this shape (constant across the leg's width, via
`notch_profile()`):
- A **riser** segment at the back, `leg_riser_depth` thick, running from
  the case down by `leg_riser_drop`. Built as a plain constant-Z cut (no
  trig at all): since the whole leg shares the case's own `body_tilt()`
  rotation, any constant-Z segment automatically stays parallel to the
  case's own tilted front after that shared rotation -- it can't help but
  match the display's angle.
- A **bend-to-foot** segment continuing down by `leg_toe_drop` to the
  foot's front tip, meant to read as `leg_foot_slope` degrees below
  horizontal in the *final*, post-tilt view. This one isn't free: a
  locally-horizontal cut does not come out horizontal after the same
  rotation that tilts the display -- it comes out sloped at exactly
  `tilt_angle()` from horizontal, since the rotation tips whatever's
  locally flat right along with everything else. Solving for the local
  slope that cancels that and adds the requested tilt gives a clean
  closed form: `local_slope = tan(tilt_angle() + leg_foot_slope)` (derived
  via the angle-addition identity; `leg_foot_slope=0` would give a
  perfectly level result).
- Below the toe, the cross-section is constant again, straight down
  through the floor (with `leg_extra_reach`'s overshoot for the floor
  clip, unchanged from before).

Implementation note: since `polygon()`/`linear_extrude()` can only extrude
along OpenSCAD's own Z axis, and this profile needed to run along the
leg's *width* (X) instead, `leg_side_shape()` defines the profile in
`[Y, Z]` pairs and remaps axes with `rotate([0,90,0]) rotate([0,0,90])` so
the final solid comes out as `(X, Y, Z) = (extrude parameter, Y, Z)` --
verified against an isolated test polygon (checking the exact X/Y/Z value
sets in the exported STL) before relying on it, since an axis-remap
rotation is an easy place to silently mirror or scramble a shape.

**Wrinkle 3 (fixed): the leg's back edge wasn't flat.** The notch
profile's back edge was a plain constant-Z cut, same trick as the riser
segment above (see riser bullet) — which is exactly the problem: that
trick relies on staying *parallel* to the case's front face after
rotation, but the case's actual rear panel is supposed to come out **flat**
(perpendicular to the floor, not parallel to the tilted front — see item
5 in the log below). A constant-Z leg-back only coincides with that flat
plane at the pivot (y=0); moving up the leg's height, it drifts further
off, parallel to the front's tilt instead. Fixed the same way as Wrinkle
1 (floor contact): overshoot first, then clip flush in the *global*
frame. `leg_rear_extra_reach` pushes the back edge deep enough that
`rear_plane_z()` — the global Z where the case's own tapered rear face
lands after `body_tilt()` (`body_depth_bottom * cos(tilt_angle())`, since
that's precisely the rotation that flattens the taper line into a flat
plane) — always cuts through solid material, never grazing a corner.
Verified by exporting `rear_shell()` alone and confirming every leg-back
vertex collapses to that single Z value rather than a spread of values.

**Rounded the leg's exposed edges — profile corners AND side caps.** The
knee (where the riser bends into the foot), the foot's front tip, and the
leg's left/right side faces (both the riser's and the foot's) were all
sharp — reads as "cut out of a block" rather than a finished part, and
sharp edges print worse than filleted ones. First pass only rounded the
knee/toe (via the same dilate/erode `offset()` trick as `rounded_2d()`,
applied to the 2D notch polygon) since that only rounds edges that run
*along* the extrusion axis (X, the leg's width) — it can't touch the
edges at the leg's two ends, where those front faces meet the flat
side-cap planes.

Rounding the side-cap edges too needs an actual 3D fillet, done via the
standard "erode along X, then `minkowski()` with a sphere" rounded-box
trick: build the core extrusion inset by `leg_edge_round` on each end
(`feet_width - 2r` wide, shifted in by `r`), then `minkowski()` it with
`sphere(r)`. For any of the core's flat faces, minkowski with a sphere
just offsets that face outward along its own normal by `r` — so insetting
by `r` first and growing by `r` after lands the two side caps back at
exactly `x=0`/`x=feet_width` (no residual bulge needing a clip), while
every edge/corner in between — the knee, the toe, *and* now the side-cap
edges — comes out genuinely filleted, all from one `leg_edge_round`
radius. This replaced the earlier 2D-only `rounded_notch_2d()` /
`offset()` approach entirely (real 3D rounding subsumes it; using both
would double up).

The back (rear-plane) and floor edges are deliberately left un-inset —
minkowski still puffs them outward by `r` too, but that's harmless: as
established above, they're already overshoot material clipped exactly
flush by the global half-space cuts regardless of the shape fed into
them, and the existing margins (`leg_extra_reach`, `leg_rear_extra_reach`)
comfortably exceed `leg_edge_round`. Verified both that the fillets show
up correctly (rendered close-ups of a single leg and of the assembly) and
that the floor/back flush cuts survived unchanged (re-checked the
exported STL: the leg's back face is still a single flat Z value, and the
floor contact is still a full-width flat patch, just with its two front
corners now rounded instead of square).
- **Rear:** flat vertical panel, full-width row of short horizontal vent
  slats near the top, and a lower recessed strip for Mouse / Keyboard /
  USB ports and their labels, plus the feet visible at the base. The model
  currently stands in for that lower strip with a plain rectangular I/O
  bay (`io_bay_*` params) rather than modeling individual ports/labels —
  see item 15 below; real port cutouts and labels are meant to return once
  the board layout is designed.
- **Corners:** rounded on every visible edge, front and back consistently
  (not just the front bezel).
- **No chin, no visible seam** at the bottom of the screen bezel — the
  image's front face is one continuous surface from top to bottom.

## How the model maps to this (session history, newest last)

1. **Base template → resized to spec.** Started from a generic flat-front
   Lisa-style starter template (`lisa_modern_template_README.txt`
   describes the original). Resized to 330mm width, adjusted height, and
   widened/repositioned the right vent grille to match "narrow left,
   wide right."
2. **Wedge body + tapered legs.** Replaced the flat-depth body with a
   tapered shell (deep at the floor, shallow at the top) and tapered fin
   feet, to get the wedge silhouette from the side-profile image.
3. **Fixed a real bug:** `rounded_2d()`'s `offset(r=r)` /
   `offset(delta=-r)` rounding pattern silently produces empty geometry
   when `r` equals exactly half the shape's narrow dimension — meaning no
   vent slots were ever actually being cut in the original template. Fixed
   by keeping rounding radii strictly under half the narrow dimension.
4. **Corrected vent/screen left-right mapping and case proportions.**
   Rendering with a camera matching the actual OpenSCAD viewing angle
   showed the vent widths were swapped from the image (wide should be
   right, narrow left) and the case was much taller than the screen
   needed — fixed both, and later renamed the vent variables so their
   names match their actual rendered side.
5. **Front tilts back, rear stays flat — via rotation, not shear.** The
   image's screen leans back while the back panel is vertical. A Z-only
   shear achieves the lean but leaves the top/bottom caps perpendicular
   to the *original* vertical axis instead of to the tilted front, which
   looked glued-on. Switched to a true rotation (`body_tilt()`) pivoting
   on the front-bottom edge, which keeps the top/bottom faces
   perpendicular to the tilted front (matching the image's continuous
   surface) while the rear stays flat, by construction (same taper rate
   that tilts the front by the right amount also cancels the rear's
   slope to zero).
6. **Removed the chin, unified corner rounding.** The template had a
   protruding lower "chin" not present in the reference image, and the
   rear shell rounded a different plane than the front bezel (so corners
   didn't match front-to-back). Removed the chin; rebuilt the rear
   shell's taper as a full rounded box trimmed by an unrounded wedge
   cutter, so it shares the front bezel's exact corner rounding.
7. **Chamfered the screen opening's front edge** — a detail not visible
   at the image's resolution, but a reasonable real-world softening of
   the sharp edge (`screen_bevel`).
8. **Front bezel as a cap, not a butt-joint (later reworked — see #13).**
   Original front/rear pieces just met at a flat seam. Gave the front
   bezel a skirt (`front_cap_skirt()`) that friction-fits over the rear
   shell's exterior with a small clearance, so it now caps over the back
   instead of butting up against it — "minimal parts, no visible joins"
   (image's design-features list) driven by an actual physical assembly
   method rather than glue.
9. **Legs redesigned as L-brackets, merged into the back piece.** Per the
   side-profile image: a flat floor pad plus a tapering riser meeting the
   case underside, not the earlier simple tapered fin. Folded into
   `rear_shell()` (kept outside `body_tilt()` so they stay upright) so
   the legs print as one piece with the back — matching "minimal parts."
   First attempt tapered the riser's depth as well as its width, which
   made the riser's back face a diagonal ramp (read as a wedge/cone, not
   an L) — fixed by holding riser depth constant and tapering width only.
10. **Legs anchored to the case's actual rear plane (superseded by #11).**
    Added `leg_back_z()` and anchored `foot_shape()` to it, so the leg's
    back face lined up with the case's own (flat, post-tilt) rear surface
    instead of an arbitrary local depth. Fixed the back-face gap, but the
    leg was still an independently-shaped part positioned to match the
    case rather than a literal continuation of it — still read as "a leg"
    rather than "the case's own side," per user feedback after seeing it
    rendered.
11. **Legs rebuilt as literal continuations of the case's own side shell.**
    Replaced the independent L-bracket (`foot_shape()`, `tapered_foot()`,
    `footprint_slice()` — all removed) with `leg_side_shape()`: a
    left/right edge strip of the case's own `rounded_prism`, continued
    below the case's y=0 by `feet_height`, called from *inside*
    `rear_shell()`'s `body_tilt()` so it shares the case's exact rotation
    instead of being built upright and positioned to match. `tilt_angle()`
    was pulled out of `body_tilt()` into its own function so
    `required_lift()` (replacing the old fixed `feet_height +
    body_floor_gap` in `body_position()`) can compute exactly how far to
    lift the tilted assembly so its lowest point (the legs' back-bottom
    corner, which sags below the front due to the rotation) lands at
    y=0 — `rear_shell()` then clips to y≥0 for a flat floor cut. See
    "Legs: seamlessness is the critical detail" above for the full
    reasoning and why the previous entry's fix wasn't sufficient.
12. **Legs given their L-profile notch, then flush back + rounded edges.**
    Carved the top-front mass away per `notch_profile()` (riser matching
    the display's angle, foot sloped per `leg_foot_slope`). Follow-up fixes
    once the notch was visible: the leg's back edge was parallel to the
    tilted front instead of flat like the case's real rear panel (fixed
    with the same build-deep-then-clip trick as the floor, via
    `leg_rear_extra_reach` + `rear_plane_z()`), and the exposed knee/toe
    corners were sharp (rounded via `rounded_notch_2d()`, which only
    rounds convex corners so the hidden seam corner stays untouched). See
    "Wrinkle 3" and "Rounded the leg's exposed front corners" above.
13. **Front cap skirt reworked to slide inside the back piece, not wrap
    around its outside.** The original `front_cap_skirt()` (item 8) sized
    itself relative to a *grown* copy of the case's own tapered exterior
    (`grown_tapered_shell()`, since removed) — mechanically sound (a real
    friction-fit lip) but visually wrong: growing the exterior necessarily
    makes the front piece's footprint wider, and differently cornered,
    than the back piece's, which read as a visible stepped ring right at
    the seam — exactly the opposite of "minimal parts, no visible joins."
    User feedback: the cap should keep the *same* outer dimensions as the
    front/back pieces everywhere, sliding inside the back piece's own
    interior instead. Fixed by sizing the skirt off the rear shell's
    hollow interior cavity footprint (`case_width/height - 2*wall_thickness`,
    corner radius `corner_radius - wall_thickness` — see the "Hollow
    interior" cut in `rear_shell()`) shrunk by `cap_clearance` per side,
    rather than off a grown copy of the exterior. Since the interior
    cavity happens to be untapered (a plain `rounded_cut`, not
    `tapered_shell`), the new skirt is just a straight rounded-rect ring —
    simpler than the old version, and needs no taper-aware helper at all.
    Verified numerically: exporting the front piece alone now shows its
    X bounding box is exactly `[0, case_width]`, identical to the back
    piece, with no protrusion.
14. **Front/back depth split made adjustable via `front_thickness`, and a
    real redundancy fixed along the way.** User wanted the front piece to
    read as a visibly deeper section (more of the case's total depth) and
    the back piece correspondingly shallower, with the *overall* case
    depth unchanged. Tracing through `rear_shell()` turned up a
    pre-existing bug that was blocking this: the outer tapered shell was
    built from the *full, untrimmed* `body_depth_bottom`/`body_depth_top`
    (via a `translate(-(front_thickness+assembly_gap))` pre-shift that
    exactly cancelled the outer wrapper's `+(front_thickness+assembly_gap)`
    translate) — meaning the rear piece's outer rim always re-modeled the
    *entire* case depth starting from the true front tip (global z=0),
    fully coincident with and redundant to the front piece's own rim over
    `[0, front_thickness]`, regardless of what `front_thickness` was set
    to. Every *interior* feature (the hollow cavity, rear recess, vent
    slats, port cutouts) was already correctly anchored to
    `local_exterior_z(y)` — i.e. already built assuming the rear piece's
    own local frame starts at the split line — so only the outer rim
    itself was out of step with that intent.

    Fixed by building the outer tapered shell directly from
    `local_exterior_z(0)`/`local_exterior_z(case_height)` (the total taper
    minus `front_thickness+assembly_gap`) with no pre-shift needed at all.
    Since both endpoints shrink by the same constant, the far (true rear)
    face — and thus the case's total depth — is completely unaffected;
    only the near face moves back from the true front tip to the split
    line, exactly matching the front piece's own extent. `front_thickness`
    (5.5 → 16 as of this writing) is now a genuine "how much of the total
    depth belongs to the front piece" dial, bounded above by needing
    `interior_depth` (which shrinks as `front_thickness` grows) to stay
    comfortably deeper than `cap_depth`. Verified via `echo()`: total
    depth at y=0 and y=case_height reproduce `body_depth_bottom`/
    `body_depth_top` exactly regardless of `front_thickness`.
15. **Individual port holes and labels pulled out, replaced with a plain
    I/O bay placeholder (later reshaped — see #16).** The mouse/keyboard
    (round) and USB (slot) cutouts, their "MOUSE"/"KEYBOARD"/"USB"
    engraved labels, and the narrower label recess they sat in were all
    removed — the user wants to design the actual board layout and
    connector placement later rather than keep nominal placeholder
    positions/sizes around. Replaced with a single plain rectangular
    pocket (`io_bay_w/h/d/y/r`) at bottom-center: 280mm wide, 50mm tall,
    cut 25mm into the back panel, sitting a bit above the floor. Used the
    same flat-cut-at-center-Y technique the old label recess used (a
    single flat `rounded_cut` rather than following the taper across the
    bay's own height). The top vent slat row is unaffected.
16. **I/O bay widened to match the leg gap and opened down to the floor —
    which exposed a real angle bug in the flat-cut technique item 15
    used.** User wanted the bay's width to match the gap between the two
    legs exactly, and its bottom to reach the floor so it reads as one
    continuous opening running down between the legs, rather than a
    pocket floating mid-panel. Straightforward part: `io_bay_w` became
    `case_width - 2*feet_width` (derived, so it stays in sync with
    `feet_width`) positioned starting at `x=feet_width`; `io_bay_y` was
    dropped since the bottom is now always the floor (0) by design; the
    footprint overshoots below y=0 by `io_bay_r` (same trick as the leg's
    knee/toe rounding hiding its unwanted corner) so only the *top* two
    corners round over, leaving a clean flat cut where the opening meets
    the case's own bottom edge.

    Reaching the floor is what surfaced the bug: user reported "the cut in
    is set to mirror the screen's angle, where it should be vertical like
    the back panel." The old flat `rounded_cut` for io_bay's depth was a
    plain constant-Z boundary in the pre-tilt frame — exactly the same
    mismatch `leg_rear_extra_reach`/`rear_plane_z()` fixed for the leg's
    back edge (see "Wrinkle 3" above): a constant-Z plane comes out
    parallel to the tilted *front* face after `body_tilt()`, not
    vertical/parallel to the true (flat) back panel. At the bay's old
    small height (31mm) and away from the floor, this was subtle enough to
    go unnoticed; stretched to 50mm and now visible all the way to the
    floor, it read clearly as a slanted gouge.

    Fixed using the *other* technique already established in this file for
    exactly this problem — the one `tapered_shell()`/`wedge_cutter()` use
    for the case's own true rear face — rather than the leg's
    overshoot-and-clip approach: build the pocket's Z-bounds as the
    `difference()` of two `wedge_cutter()`s sharing `y=[0,io_bay_h]`, one
    for "out to the true surface (+0.3 overshoot)" and one for "out to
    `io_bay_d` short of it." Since `wedge_cutter()`'s taper is linear and
    exactly matches `local_exterior_z(y)`'s own slope by construction (both
    endpoints are set from that same function), the resulting slab tracks
    the true surface's taper across the bay's height instead of using one
    flat value — coming out genuinely flat/vertical after rotation.
    Verified directly (not just by inspection) by probing where the
    pre-tilt points `(y=0, floor_z(0))` and `(y=io_bay_h, floor_z(io_bay_h))`
    land after `body_position()+body_tilt()`: both mapped to the *same*
    global Z, confirming the floor is flat; also confirmed visually from a
    straight-on rear view, where the opening's boundary lines are
    perfectly horizontal across the full width instead of sloped.
17. **Fixed a hairline sliver left at the floor.** After #16, user spotted
    a thin sliver of material left over right at the bottom of the
    opening. Cause: the two `wedge_cutter()`s only spanned `y=[0,io_bay_h]`
    (matching `io_bay_h` exactly) — but `wedge_cutter()`'s `hull()` doesn't
    extend past its own `y=[0,h]` domain at all, so it had nothing to
    offer below `y=0`, right where the footprint's rounding-hiding overshoot
    (`io_bay_r` below the floor — see #16) needed something to intersect
    against. Fixed by extending both wedge_cutters' domain down to
    `y=-io_bay_r` too (matching the footprint's own overshoot exactly), so
    the cut has a genuine safety margin below the floor instead of
    stopping precisely at `y=0`. Verified no facets at all remain in that
    region of the exported STL (previously the sliver would have shown up
    as small facets right at `y≈0`).
18. **Foot slope made dramatically steeper to match the original Lisa.**
    User could tune the back (riser) height fine via `feet_height`, but
    the front (toe) always stayed too tall — the foot read as a fairly
    uniform-thickness pad rather than the original's pronounced
    thick-at-back/sharp-at-front wedge. Root cause, found by numerically
    probing where the knee and toe points land in the final (post-tilt)
    frame: `leg_foot_slope` (6° at the time) really was only producing a
    ~4mm height difference between knee (~16.8mm) and toe (~12.75mm) —
    correct per its definition, but too shallow to read as dramatic. The
    real ceiling on how low the toe can go is set by `leg_toe_drop` (a
    pre-tilt Y-distance, capped at roughly `leg_toe_drop*cos(tilt_angle())`
    of actual final height drop as `leg_foot_slope→90°`) — `leg_foot_slope`
    then trades off between spending that ceiling on forward reach
    (shallow angle) versus height drop (steep angle). At the old
    `leg_toe_drop=12`, no angle could produce more than about 11.7mm of
    drop, nowhere near enough. Fixed by increasing both together —
    `leg_toe_drop` 12→20, `leg_foot_slope` 6°→15° — chosen by probing
    several combinations and picking one that dropped the toe to ~5.4mm
    (from a ~16.8mm knee, roughly 3x taller in back) while keeping
    comfortable clearance above y=0 (combinations pushing much further,
    e.g. `leg_toe_drop=30`+, drove the toe's pre-clip position *below* the
    floor entirely, which would've just been clipped away flat rather than
    forming a sharp point). Re-verified both the floor-flush and
    back-flush fixes (items in "Legs: seamlessness…" above) still hold
    unchanged after this — they don't depend on these two params.
19. **Front bezel's outer perimeter edge chamfered at 45 degrees.** User
    wanted the sharp edge running around the front piece (where the flat
    front face meets its sides) softened — distinct from `screen_bevel`,
    which only softens the screen cutout's own edge, not the case's outer
    edge. Added `chamfered_prism()`, the mirror image of the existing
    `beveled_cut()` trick: instead of hulling a *larger* ring at the true
    surface down to the true-size opening (softening a cutout from the
    outside in), it hulls a *smaller*, inset footprint at z=0 out to the
    true-size footprint at `z=front_edge_bevel` (softening a solid's own
    outer edge from the inside out). Equal inset and depth
    (`front_edge_bevel=2.5`) is what makes it read as 45 degrees rather
    than some other angle. Used in place of the plain `rounded_prism()`
    for the front face's outer shape in `front_bezel()`, with the screen
    opening and vent cuts subtracted from it exactly as before.
20. **Front vent lines made shallow decorative grooves instead of
    through-cuts.** They were cutting all the way through `front_thickness`
    (now 16mm — see item 14 — so this became very visible), showing the
    hollow interior behind them instead of reading as surface detail.
    Added `vent_depth=0.8` and changed `vent_slots()`'s cut depth from
    `front_thickness + 0.5` to `vent_depth + 0.2` (small overshoot past
    z=0 only, no longer reaching anywhere near the back of the piece).
21. **Rear vent slats found to be blind grooves instead of the through-cuts
    they were meant to be — a real, pre-existing bug.** User asked to
    confirm/keep the rear vents as through-cuts (unlike the front ones,
    fixed the opposite way in item 20) and then caught that they in fact
    weren't. Their depth was `back_thickness + 1.5`, starting
    `back_thickness` behind the true exterior surface — correct *only* at
    `y=case_height`, the single point `interior_depth` was conservatively
    sized from (see the "Conservative (untapered) interior cavity depth"
    comment on `interior_depth` above). `vent_row_y = case_height - 16`
    sits enough below that for the wedge taper to leave noticeably more
    wall material there — the fixed `back_thickness` depth fell short of
    the hollow cavity by a couple mm, leaving blind grooves. Fixed by
    deriving the cut's span from the actual local geometry instead of a
    constant: start at `interior_depth` (the hollow's own true boundary,
    regardless of Y) and run out to `local_exterior_z(vent_row_y)` (the
    true exterior surface at that specific Y), each with a small overshoot
    margin (0.5) baked in on first pass, then doubled after the user
    still spotted a sliver on inspection. Verified by intersecting the
    exported back shell against the vent cut's own exact target volume —
    empty, confirming nothing is left uncut.
22. **Added a solid skirt between the legs, closing off what was open
    air.** User felt the open gap between the legs (below the case's own
    bottom edge, above the floor) didn't match the original Lisa, which
    reads as having a solid closed underside — and noted it'd also hide
    any wiring routed down through the future I/O bay. Added `leg_skirt()`
    (`skirt_thickness=3`), positioned "flush with the back of the port
    cutout" by reusing the I/O bay's own floor formula
    (`local_exterior_z(y) - io_bay_d`) continued down through the legs'
    own Y-range instead of the bay's — the two are coplanar by
    construction, forming one continuous flat surface across the
    transition rather than a step.

    First implementation used the same `difference()` of two
    `wedge_cutter()`s io_bay's own cut uses (one wedge for the outer
    bound, one for the inner, `skirt_thickness` apart) — this is exactly
    the technique that works for io_bay, but broke here: `wedge_cutter()`
    computes volume from Z=0 up to its taper, appropriate when the shape
    is meant to start at the origin (io_bay's cut does), but for the
    skirt both wedges' d-values differ by only `skirt_thickness=3mm` over
    a much larger `h` and Z magnitude (tens of mm) — exactly the kind of
    near-cancelling subtraction of two similar large solids that lost
    precision in CGAL's boolean, coming back as two degenerate slivers
    (matching `wedge_cutter()`'s own internal 0.1mm end-slabs) with
    nothing in between. User caught this immediately ("shifted forward
    and... a second very thin slice floating in front of the legs").
    Fixed by building the already-thin cross-section directly instead:
    `hull()` of two 0.1mm-in-Y slabs, each already the correct
    `skirt_thickness`-thick slice at that Y, interpolated smoothly between
    them — the same *spirit* as `wedge_cutter()` (a hull of two thin
    reference slabs) but without ever computing a large intermediate
    volume to subtract away. Also needed a bigger X overlap into the legs
    than a simple float-noise epsilon: `leg_side_shape()`'s minkowski
    rounding (`leg_edge_round`) pulls the leg's actual material back from
    its nominal edge near that corner, so the overlap has to reach past
    that pullback (`leg_edge_round + 0.5`), not just guard against
    coincident-face noise.

    Along the way, confirmed (by rendering with `leg_skirt()` commented
    out) that a small pre-existing concave notch visible at the leg/bay
    junction from certain steep angles is unrelated to the skirt — an
    inherent, previously-hidden feature of the leg's own L-profile that
    the I/O bay's recess exposes to view from some angles. Left alone
    (out of scope here); the model is confirmed manifold either way.
23. **Skirt depth made adjustable (`skirt_offset`).** Even with the geometry
    bug in item 22 fixed, the skirt sitting exactly flush with the I/O
    bay's floor still read as too far forward (too close to the true
    exterior surface / the legs' own front faces) once actually seen
    correctly positioned. Added `skirt_offset` on top of the flush
    position from item 22 (`local_exterior_z(y) - io_bay_d - skirt_offset`):
    positive moves the skirt forward, toward the true exterior surface;
    negative moves it backward, deeper into the case. Set to `-10` as a
    first pass, recessing the skirt visibly behind the legs' own front
    faces rather than sitting flush with them.
24. **`leg_edge_round` matched to `corner_radius` (partial fix, see item
    25).** User noticed a seam where the leg meets the case body. Cause:
    the case's own corner rounding (`corner_radius=7`) and the leg's edge
    fillet (`leg_edge_round`, 3 at the time — see item 12) are two
    independent rounding operations that happen to sit right next to each
    other vertically (the leg's own X-end cap fillet is the natural
    continuation, below `y=leg_overlap`, of the case's corner rounding
    immediately above it) — but with different radii, so the curvature
    visibly changed right at that boundary instead of flowing
    continuously. Fixed by deriving `leg_edge_round` from `corner_radius`
    instead of hardcoding it separately. This turned out to be incomplete
    — see item 25 — and the user has since retuned `leg_edge_round` back
    to its own independent value (2) once item 25's real fix was in place.
25. **Leg's top edge clipped flush instead of left to float — fixes both
    the remaining seam and a real interior-clearance bug.** Matching the
    radius (item 24) didn't fully fix the seam, and increasing
    `leg_edge_round` made the legs protrude up into the interior cavity
    space. Root cause of both: the leg's `minkowski()` rounding pushes
    *every* boundary outward by `leg_edge_round`, including the top edge
    at `y=leg_overlap` — but unlike the back and floor edges (already
    protected by `rear_shell()`'s global half-space clips, see items 6–7
    and "Wrinkle 1"), nothing ever trimmed that top overshoot back down.
    At small radii this stayed harmlessly inside the case's own solid
    corner; at bigger radii it reached past where the interior hollow
    begins, adding unhollowed material into space meant to stay clear for
    the PCB/LCD bracket — a real bug, not just cosmetic. It also could
    never have fixed the seam on its own: the case's corner is a simple
    constant-radius sweep in Z, while minkowski gives the leg a *compound*
    3D fillet there, so no radius choice makes those two curvature types
    match — only clipping the leg flat before that compound curvature
    becomes visible actually resolves it.

    Fixed with the same build-it-oversized-then-clip-flush technique used
    for the back and floor: `leg_side_shape()` now intersects the
    minkowski result with a `y <= leg_overlap` half-space, in the same
    local (pre-tilt) frame the case body itself uses — safe here (unlike
    a naive constant-Z cut) because we're not trying to match some
    externally-defined flat plane, just capping the leg's own extent to
    stay consistent with the case's own coordinate frame. Only the
    (currently unrounded) top region is affected; the knee, toe, and
    X-end fillets are all well below `y=leg_overlap` and untouched.
    Verified directly: with `leg_edge_round` deliberately set to 7 (matching
    `corner_radius`, the case that triggered the bug), the isolated leg's
    max Y came back as exactly `7.2` (`leg_overlap`) regardless — confirms
    the clip holds regardless of rounding radius, not just for whatever
    radius happened to be set at test time.
26. **Interior hollow cavity reshaped to track the taper, for a constant
    (not ballooning) wall thickness.** User printed a test piece and found
    the back wall got noticeably thicker toward the base than at the top
    — using far more material than a `back_thickness`-thick wall needs to
    be sturdy. This was fully intentional in the original design (see the
    old "Conservative (untapered) interior cavity depth" comment,
    documented back in the early spec-mapping log): `interior_depth` was a
    single, Y-independent cut depth, deliberately sized to the shallowest
    point (the top, `y=case_height`) so it would never poke through the
    sloped rear wall — safe, but it meant the cavity stayed the same
    absolute depth everywhere while the exterior kept taper *deeper*
    toward the base, leaving progressively more (unneeded) solid material
    behind it lower down.

    Fixed by replacing the flat `rounded_cut()` hollow with
    `tapered_shell()` — the exact same technique the case's own outer
    shell already uses for its true (tapered) rear face — driven by a new
    `interior_boundary_z(y) = local_exterior_z(y) - back_thickness`
    function. Since `tapered_shell()`'s linear interpolation is set from
    the true endpoint values of this same linear function, it reproduces
    `interior_boundary_z(y)` exactly at every Y in between, not just the
    two ends. `interior_depth` (used elsewhere as the conservative
    minimum-clearance reference for `cap_depth`) is now simply
    `interior_boundary_z(case_height)` — the same value it always
    represented, just derived rather than hand-picked, since the
    shallowest point is still exactly where the old constant was sized
    from. The rear vent slats (item 21) also switched from referencing
    the old constant to `interior_boundary_z(vent_row_y)`, since the
    hollow's boundary is no longer Y-independent — this actually
    simplified that fix too: with the cavity now genuinely tracking the
    taper, the vent depth really is just `back_thickness` plus overshoot
    at every Y, rather than needing a special-cased non-constant formula.
    Verified numerically: wall thickness computed at both
    `y=wall_thickness` (near the base) and `y=case_height-wall_thickness`
    (near the top) both came back as exactly `3` (`back_thickness`) —
    confirms the taper-tracking is exact, not approximate.
27. **Legs still protruding into the interior — item 25's clip wasn't
    enough on its own; a second bug.** After item 26, the user reported
    the legs still poked into the interior cavity space. Root cause: the
    interior hollow cut has *always* only been subtracted from the case
    body's own `difference()` — legs are `union()`-ed in afterward,
    completely untouched by that cut. Item 25's `y<=leg_overlap` clip
    stops the leg from growing past the case's own seam as
    `leg_edge_round` grows, but it has no idea where the interior cavity
    begins — and since legs are `feet_width` (35mm) wide, far wider than
    `corner_radius` (7mm), their entire overlap region (`y` from 0 to
    `leg_overlap`, the *full* leg width in X) was unconditionally solid,
    plugging a large swath of genuine interior clearance space wherever
    it geometrically overlapped the hollow — not just the small
    rounded-corner sliver the overlap is actually meant to fill.

    Fixed by restructuring `rear_shell()` so the interior hollow cut
    applies to the *whole* union (case body + legs + skirt) instead of
    just the case body: `union() { case_body; legs; skirt; }` is now
    itself wrapped in `difference() { ...; hollow_cut; }`, with the hollow
    cut wrapped in the same `front_thickness+assembly_gap` translate as
    the case body's own local frame so it lines up correctly against both
    that (built in this local frame) and the legs/skirt (built directly
    in the true global frame the translate maps into). Verified by
    probing a point inside the leg's overlap band, well past the interior
    boundary: empty, where it previously would have been solid leg
    material. Also checked what actually remains at that overlap point —
    exactly a `back_thickness`-thick connecting wall between the leg and
    the case's own hollow boundary, matching the wall thickness
    everywhere else (rather than either the old unwanted thick block or
    a full disconnect). Re-verified floor-flush contact still holds.
28. **I/O bay cutout (items 15, 16, 17) removed entirely — the skirt's own
    recess now serves the same purpose.** With the leg skirt in place
    (item 22) providing a recessed area between the legs for cables to
    exit, the user felt the separate I/O bay pocket in the back panel
    above it was redundant — asked about improving its "big open hole"
    look first, then concluded it wasn't needed at all once the skirt was
    accounted for. Removed the whole cutout (footprint, wedge-tracked
    floor, all `io_bay_*` params) from `rear_shell()`. Since `leg_skirt()`
    depended on `io_bay_w` (for its width) and `io_bay_d` (for its "flush
    with the bay's floor" depth reference), those became standalone
    `skirt_width` (`= case_width - 2*feet_width`, same value as before)
    and `skirt_depth` (`=25`, same default as the old `io_bay_d`) params
    instead — the skirt's actual position and size are unchanged, just no
    longer defined in terms of a feature that no longer exists. The back
    panel is now a plain continuous surface (aside from the vent slats)
    down to where the legs begin.
29. **Attempted a small bevel around the back panel's outer perimeter and
    the legs' back-bottom corner — reverted, not currently in the model.**
    First pass added two separate features: a diagonal clip chamfering the
    legs' back-bottom corner (where the floor clip meets the rear-plane
    clip — verified working via probes), and a `chamfered_tapered_shell()`
    meant to fillet the case body's own outer edges via the same "erode
    every axis by `bevel`, then `minkowski()` back out" trick
    `leg_side_shape()` uses.

    User feedback after seeing it rendered: only the leg's corner read as
    bevelled; the case's own edges didn't, and the leg's corner bevel
    wasn't wanted in the first place ("the back of the leg actually
    shouldn't have a bevel"). Removed the leg's diagonal clip per that
    feedback. Re-investigating the case's own bevel then turned up a real
    bug, not just a subtlety of rendering: probing the same edge location
    at `back_edge_bevel=0.01` vs `5` returned *identical* geometry,
    meaning the parameter wasn't doing anything there — and a wider probe
    found the "bevel" was in fact distorting a large swath of the side
    face (most of the case's height), not a small edge fillet. The
    earlier claim in this log that the erode/regrow round-trip "returns
    flat faces to their exact original position" was checked with too
    coarse a probe (bulk facet dumps that turned out to be picking up
    unrelated geometry — vent slats, ordinary corner-radius curvature —
    rather than the bevel itself) and didn't actually catch this.

    Rather than ship geometry with a known, not-yet-understood defect,
    removed `chamfered_tapered_shell()` entirely and reverted the outer
    rear housing to plain `tapered_shell()` (its pre-item-29 state,
    re-verified manifold and floor-flush). The case's own back panel
    currently has no edge bevel; revisiting this is an open item — likely
    needs the erosion math re-derived (probably the linear
    `d_bottom + slope*b - b` approximation for how far to erode the taper
    doesn't correctly account for the sloped face's normal direction not
    being axis-aligned) and should be checked with a tight, single-point
    probe at the specific edge in question before being reported as
    working, not a bulk-region facet scan.

## Deliberate deviations from the image's numbers

The image's 330×240×95mm spec sheet was the *starting point*, but the
depth and height have since been tuned smaller
(`body_depth_bottom=80`/`body_depth_top=45`/`case_height=189` as of this
writing) based on the user's own hands-on adjustments while iterating in
OpenSCAD — the image's dimensions describe the reference concept, not a
locked target. When guiding future changes, treat the image as the source
of *shape and proportion* (wedge profile, L-leg silhouette, vent
layout/position, rounded corners, front tilt vs. flat back) rather than as
exact millimeter targets — check current values in
`lisa_modern_template.scad` before assuming the spec-sheet numbers still
apply.

## Known open gaps vs. the image

- Apple logo decal — not modeled (decorative, out of scope for a
  printable template).
- FloppyEmu slot — mentioned as optional in the image, not modeled.
- Mouse/keyboard/USB port cutouts and labels — deliberately removed (see
  item 15) and no placeholder cutout remains as of item 28; the leg
  skirt's own recess (see "Legs: seamlessness…" and item 22) is where
  cables are expected to exit once real ports are designed.
- Back panel edge bevel — attempted and reverted (see item 29); the back
  panel's outer perimeter currently meets its sides at a plain
  `corner_radius`-only edge, no additional small chamfer/fillet like the
  front's `front_edge_bevel`.
