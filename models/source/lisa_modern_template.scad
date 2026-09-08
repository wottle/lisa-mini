
/*
Lisa-inspired modern LCD enclosure
Parametric starter model for OpenSCAD / TinkerCAD

Designed as a starting template for:
- 9.7-inch 4:3 LCD (approx. 197 x 148 mm visible area)
- single PCB behind the display
- printer bed up to about 350 mm wide
- shallow modern enclosure
- narrow left bezel with short vent lines
- wider right-side vent field
- wide Lisa-style feet
- rear recessed label area; ports themselves are not exposed in this template

QUICK START
1. Install OpenSCAD.
2. Open this file.
3. Press F5 for preview.
4. Change "part" below to export individual pieces.
5. Press F6, then File > Export > Export as STL.
6. Import the STL into TinkerCAD.

Important:
This is a concept template, not a production-ready mechanical enclosure.
Measure your exact LCD, PCB, cable plugs, and mounting-hole locations before printing.
*/

// -------------------------
// USER SETTINGS
// -------------------------

part = "front";
// Options:
// "assembly", "front", "back", "lcd_bracket", "pcb_plate"
// (the legs print as part of "back" -- there's no separate foot piece)

$fn = 48;

// Overall body
case_width        = 330;
case_height       = 189;
body_depth_bottom = 70;    // depth at floor level (wedge base)
body_depth_top    = 40;    // depth at top of case (wedge tip)
corner_radius     = 7;

// Shell
front_thickness  = 16;    // how much of the case's total depth belongs to the front piece (see rear_shell()) --
                          // bounded above by interior_depth needing to stay comfortably deeper than cap_depth
back_thickness   = 3.0;
wall_thickness   = 3.0;
assembly_gap     = 0.35;

// Front cap skirt -- lets the front bezel act like a cap that friction-fits
// INSIDE the rear shell's hollow interior (see front_cap_skirt()), instead
// of just butting up against it or wrapping around its outside.
cap_depth        = 14;    // how far the skirt reaches back into the rear shell's interior, past the face plate
cap_wall_t       = 1.8;   // skirt wall thickness
cap_clearance    = 0.2;   // per-side gap between the skirt's outer wall and the rear shell's interior cavity wall

// Screen opening
screen_open_w    = 200;
screen_open_h    = 150;
screen_left      = 115;      // adjacent to the narrow vent side, with room on the other side for the wide grille
screen_bottom    = 22;
screen_corner_r  = 2.5;
screen_bevel     = 2.5;      // chamfer softening the screen opening's front edge, beveling inward toward the LCD

// Front bezel's own outer perimeter edge -- separate from screen_bevel,
// which only softens the screen cutout's edge. 45-degree chamfer (see
// chamfered_prism()): must stay under corner_radius or the corner's
// inset radius would go negative.
front_edge_bevel = 2.5;

// Vent pattern
vent_count       = 10;
vent_slot_h      = 2.0;
vent_depth       = 0.8;  // how far the vent lines cut into the front surface -- decorative, not through-cuts
vent_pitch       = 8.0;
left_vent_w      = 8;                              // narrow, physically on the left as viewed
right_vent_w     = 107;                              // wide, physically on the right as viewed
vent_left_x      = case_width - left_vent_w - 4;   // hugs the model's high-x edge, renders on the left
vent_right_x     = 4.5;                             // near the model's low-x edge, renders on the right
vent_top_y       = screen_bottom + screen_open_h - 3;  // vents start level with the top of the screen

// Feet / stance -- per lisa_design.md, the legs are NOT separate parts
// bolted under the case: each is a left/right edge strip of the case's
// own tapered, tilted outer shell, continued straight down to the floor.
// Built inside body_tilt() (see leg_side_shape()) so the taper/tilt is
// shared with the case above it by construction, guaranteeing a seamless
// join instead of a separately-positioned part that has to be numerically
// matched to the case.
feet_height     = 40;   // visible stance height, floor to the case's own bottom edge
feet_width      = 35;   // width of each leg strip, flush with the case's left/right edges
leg_extra_reach = 15;   // how far past feet_height the leg is built before being clipped flush (see leg_side_shape())

// The leg is solid at this point (a plain block); giving it its L profile
// means cutting away the top-front mass, leaving: a riser (matching the
// display's tilt) at the back, bending partway down to a shallow,
// nearly-horizontal top surface that reaches forward to the foot's front
// tip. See leg_side_shape()'s notch_profile().
leg_riser_depth  = 30;  // thickness of the remaining riser, measured from the back
leg_riser_drop   = 22;  // how far down from the case the riser (display-angle) segment runs before bending
leg_toe_drop     = 18;  // how far further down the bend-to-foot segment runs before reaching the foot's front --
                        // this is the ceiling on how much lower the toe can end up than the knee (see notch_profile()
                        // comment on the riser/foot-slope math): with leg_foot_slope=0 this would be the full
                        // available drop (roughly leg_toe_drop*cos(tilt_angle())); bigger leg_foot_slope spends part
                        // of that ceiling on forward reach instead of drop, so the two need tuning together for a
                        // target toe height, not separately
leg_foot_slope   = 17;  // degrees below horizontal for the foot's top surface (see notch_profile()) -- also trades
                        // off against leg_toe_drop (see above): higher = steeper-looking wedge but less forward reach
leg_rear_extra_reach = 20;  // how far past the case's true depth the leg's back edge is built before being
                            // clipped flush by rear_plane_z() -- same build-deep-then-clip trick as leg_extra_reach/floor
leg_edge_round   = 2;  // fillet radius rounding the leg's exposed (convex) front corners -- knee, toe,
                                    // and the leg's own X-end caps (see leg_side_shape()). Matches corner_radius
                                    // deliberately: the leg's X-end cap fillet is the vertical continuation of the
                                    // case's own corner rounding right above it, so a mismatched radius here reads
                                    // as a visible seam/step at y=leg_overlap where the leg meets the case body.

// Leg skirt -- a thin solid wall filling the gap between the legs below
// the case's own bottom edge (see leg_skirt()), recessed from the true
// exterior surface. Closes off what would otherwise be open air there,
// both to read more like the original Lisa's solid underside and to
// provide a recess for cables to exit (this stood in for, and has now
// replaced, a separate I/O bay cutout in the back panel above it -- see
// lisa_design.md item 28).
skirt_width      = case_width - 2 * feet_width;  // matches the gap between the legs exactly
skirt_depth      = 25;    // how far behind the true exterior surface the skirt sits, before skirt_offset
skirt_thickness  = 6.365;
skirt_offset     = -10;  // shifts the skirt off of "flush with the true exterior surface, skirt_depth back":
                          // positive moves it forward (toward the true exterior surface), negative moves
                          // it backward (deeper into the case, away from the viewer)

// LCD bracket
lcd_overlap      = 4;
lcd_bracket_t    = 3;
lcd_bracket_d    = 8;

// PCB plate
pcb_plate_w      = 310;
pcb_plate_h      = 48;
pcb_plate_t      = 2.8;
pcb_hole_d       = 3.2;
pcb_hole_inset   = 9;

// -------------------------
// HELPER MODULES
// -------------------------

module rounded_2d(w, h, r) {
    offset(r = r)
        offset(delta = -r)
            square([w, h], center = false);
}

module rounded_prism(w, h, d, r) {
    linear_extrude(height = d)
        rounded_2d(w, h, r);
}

module rounded_cut(w, h, d, r) {
    linear_extrude(height = d)
        rounded_2d(w, h, r);
}

// A through-cut like rounded_cut, but with its front edge (z=0) chamfered:
// the opening is widened by `bevel` right at the surface and tapers back
// down to the true w x h size over a depth of `bevel`, softening the
// otherwise sharp edge where the hole meets the face.
module beveled_cut(w, h, d, r, bevel) {
    union() {
        hull() {
            translate([-bevel, -bevel, -0.5])
                rounded_cut(w + 2 * bevel, h + 2 * bevel, 0.01, r + bevel);
            translate([0, 0, bevel])
                rounded_cut(w, h, 0.01, r);
        }
        translate([0, 0, bevel])
            rounded_cut(w, h, d - bevel, r);
    }
}

// A solid prism like rounded_prism, but with its OUTER perimeter edge at
// the front face (z=0) chamfered: the footprint is inset by `bevel` right
// at z=0 and widens back out to the true w x h size over a depth of
// `bevel` -- the mirror image of beveled_cut()'s softened opening, but
// softening the case's own outer edge instead of a cutout. Inset and
// depth being equal (`bevel`) is what makes the chamfer read as 45
// degrees rather than some other angle.
module chamfered_prism(w, h, d, r, bevel) {
    union() {
        hull() {
            translate([bevel, bevel, 0])
                rounded_prism(w - 2 * bevel, h - 2 * bevel, 0.01, max(0.1, r - bevel));
            translate([0, 0, bevel])
                rounded_prism(w, h, 0.01, r);
        }
        translate([0, 0, bevel])
            rounded_prism(w, h, d - bevel, r);
    }
}

// How far to lift the case so its front-bottom pivot edge (y=0, z=0 --
// the one point body_tilt()'s rotation never moves) sits feet_height
// above the floor. leg_side_shape() builds the legs deliberately deeper
// than feet_height and rear_shell() clips the result to y>=0, so this
// only needs to set where that cut lands, not account for the tilt at
// all: unlike the leg's *back* corner (which sags lower the more the
// case tapers -- see leg_side_shape()), this pivot point never moves
// regardless of tilt_angle().
function required_lift() = feet_height;

// Global Z of the case's true (flat, post-tilt) rear plane -- the same
// plane the case's own tapered rear face lands on exactly by construction
// (rotating the taper line by tilt_angle() is precisely what makes it
// flat -- see body_tilt()). The leg's back edge is built as a plain
// constant-Z cut in the pre-tilt frame, which after rotation comes out
// parallel to the FRONT face's tilt instead -- flush only at the pivot
// (y=0) and increasingly off the further the leg's Y departs from it.
// leg_rear_extra_reach overshoots the leg's back edge deep enough that
// this plane cuts cleanly through solid material everywhere along its
// height, the same build-deep-then-clip trick required_lift()/
// leg_extra_reach use for the floor.
function rear_plane_z() = body_depth_bottom * cos(tilt_angle());

module body_position() {
    translate([0, required_lift(), 0])
        children();
}

module vent_slots(x, width) {
    // NOTE: offset(r=r) then offset(delta=-r) degenerates to an empty
    // shape when r equals exactly half of the shape's narrow dimension
    // (a Clipper/offset precision edge case) -- so the rounding radius
    // must stay strictly less than vent_slot_h / 2.
    slot_r = vent_slot_h / 2 - 0.1;
    for (i = [0 : vent_count - 1]) {
        y = vent_top_y - i * vent_pitch;
        // Shallow decorative groove, not a through-cut: starts at z=-0.2
        // (a small overshoot past the true front surface at z=0, for a
        // clean boolean there) and reaches vent_depth into the material.
        translate([x, y, -0.2])
            rounded_cut(width, vent_slot_h, vent_depth + 0.2, slot_r);
    }
}

// A simple (unrounded) wedge-shaped cutting volume: full width in X so it
// never clips the X-Y rounded corners of whatever it's intersected with,
// tapering in depth (Z) as a function of height (Y) from d_bottom at y=0
// to d_top at y=h.
module wedge_cutter(w, h, d_bottom, d_top) {
    slice_t = 0.1;
    hull() {
        translate([-1, 0, 0])
            cube([w + 2, slice_t, d_bottom]);
        translate([-1, h - slice_t, 0])
            cube([w + 2, slice_t, d_top]);
    }
}

// Body shell that keeps the same X-Y rounded-rectangle corners as a plain
// rounded_prism (so it matches the front bezel's corner rounding) but
// tapers in depth (Z) as it rises: d_bottom at y=0, d_top at y=h. The
// front face (z=0) stays flat; only the rear face slopes. Built as a
// full-depth rounded box trimmed by an unrounded wedge cutter, rather than
// hulling rounded footprint slices directly, so the X-Y corner rounding
// survives the taper instead of being replaced by X-Z rounding.
module tapered_shell(w, h, d_bottom, d_top, r) {
    intersection() {
        rounded_prism(w, h, d_bottom, r);
        wedge_cutter(w, h, d_bottom, d_top);
    }
}


// The skirt that lets the front bezel act like a cap: a thin ring sized to
// slide INSIDE the rear shell's own hollow interior cavity (see its
// dimensions in rear_shell()) with cap_clearance to spare on each side,
// running from the back of the face plate (z = front_thickness) for
// cap_depth further back. An earlier version wrapped a skirt around the
// OUTSIDE of the case instead, sized relative to a grown copy of the
// case's own tapered exterior -- but growing the exterior necessarily
// makes the cap piece wider (and differently cornered) than the case's
// true footprint, which reads as a visible step/ring around the seam
// rather than one continuous surface. Matching the cavity's own untapered
// rounded-rect footprint instead means the skirt has nothing to clear on
// the outside: the front and back pieces' outer dimensions stay identical
// everywhere, and the skirt itself is invisible from outside once
// assembled. cap_depth is kept well short of interior_depth so this stays
// an open-ended tube rather than bottoming out in the cavity.
module front_cap_skirt() {
    outer_w = case_width - 2 * wall_thickness - 2 * cap_clearance;
    outer_h = case_height - 2 * wall_thickness - 2 * cap_clearance;
    outer_r = max(0.5, corner_radius - wall_thickness - cap_clearance);
    translate([wall_thickness + cap_clearance, wall_thickness + cap_clearance, front_thickness])
        linear_extrude(height = cap_depth)
            difference() {
                rounded_2d(outer_w, outer_h, outer_r);
                translate([cap_wall_t, cap_wall_t])
                    rounded_2d(outer_w - 2 * cap_wall_t, outer_h - 2 * cap_wall_t, max(0.5, outer_r - cap_wall_t));
            }
}

// Angle the case (and legs) tilt back by. Extracted as a shared function
// since body_tilt(), required_lift(), and leg_side_shape() all need to
// agree on it exactly, not just approximate it.
function tilt_angle() = atan((body_depth_bottom - body_depth_top) / case_height);

// Tilts the case body (a true rotation, not a shear) so the FRONT face
// (screen side) becomes the sloped surface and the REAR face (ports)
// becomes flat. Using a rigid rotation -- rather than a Z-only shear --
// means the top and bottom caps, which start out perpendicular to the
// front face (both being flat prism caps at 90 degrees to it), stay
// perpendicular to it after tilting too: the top slopes down toward the
// back and the underside slopes correspondingly, instead of remaining
// flat and looking glued onto the now-sloped front. The rotation angle is
// derived from the same taper rate as before (so the front tilts back by
// exactly the amount needed to go from d_bottom at the floor to d_top at
// the top), and it pivots around the front-bottom edge (y=0, z=0), which
// is exactly the rotation axis, so that corner never moves.
module body_tilt() {
    rotate([tilt_angle(), 0, 0])
        children();
}

// How far the leg's (sharp, unrounded) top overlaps upward past the
// case's own y=0 -- past corner_radius, i.e. past the point where the
// case's bottom corner rounding ends and its side becomes perfectly
// straight. Rounding the leg's own top edge (where it meets the case)
// would put two independent rounded corners right next to each other at
// the seam, which reads as a doubled/pinched transition rather than one
// continuous wall. Instead the leg is left sharp-cornered and raised to
// overlap the case's rounded corner entirely, so that corner is filled in
// solid by the leg instead of showing its own curve, and the only visible
// rounding along this edge is wherever the case is rounded on its own
// (e.g. its top corners), unrelated to the leg.
leg_overlap = corner_radius + 0.2;

// A left/right edge strip of the case's own outer shell, continued
// straight down from just above the case's own y=0 (see leg_overlap), in
// the same case-local pre-tilt frame as the rest of rear_shell(). This
// must be called from inside the same body_tilt() as the case (see
// rear_shell()), so the shared rotation carries the leg's tilt seamlessly
// on from the case above it -- per lisa_design.md, the legs are a
// continuation of the case's own side, not a separately-shaped part
// positioned to match. Depth is left constant (matching the case's own
// z=0..body_depth_bottom cross-section exactly); the forward-projecting
// "foot" look comes for free from the tilt itself, since points below
// y=0 rotate to increasingly negative Z as they go down.
//
// Built deliberately deeper than feet_height (by leg_extra_reach) and
// meant to be clipped flush by rear_shell()'s floor cut, rather than
// stopping exactly at the visible stance height: since the leg shares the
// case's own tilt, its natural bottom face is slanted (the back sags
// lower than the front, same as the case's own underside), so a leg built
// to stop exactly at the intended floor height only grazes that slanted
// bottom's lowest corner -- the rest of the underside stays above the
// floor, tilted in the air. Extending well past the floor first and then
// slicing flat guarantees full, flush floor contact instead.
// The leg's Y-Z cross-section (constant across its width), giving it an L
// profile instead of a solid block: a vertical riser at the back, from the
// top (embedded in the case, see leg_overlap) down by leg_riser_drop, then
// a bend to a shallow segment reaching forward to the foot's front tip,
// then straight down through the floor (with the extra-reach overshoot
// leg_side_shape() needs for the floor clip -- see rear_shell()).
//
// The riser segment is a plain vertical cut (constant Z as Y varies): since
// the whole leg rotates together with the case in body_tilt(), any
// constant-Z segment stays parallel to the case's own front face after
// that shared rotation, automatically matching the display's angle without
// needing to compute the tilt at all.
//
// The bend-to-foot segment is trickier: naively using a constant-Y (locally
// horizontal) segment there does NOT come out horizontal after rotation --
// it comes out sloped at exactly tilt_angle() from horizontal (the same
// rotation that tilts the display tilts a locally-flat segment along with
// it). Solving for the local slope that, after that same rotation, reads
// as leg_foot_slope degrees below horizontal gives a clean result:
// local_slope = tan(tilt_angle() + leg_foot_slope) -- i.e. local_slope
// would exactly cancel the tilt (giving a perfectly level result) at
// leg_foot_slope=0, and leg_foot_slope tips it slightly further from there.
function notch_profile() =
    let (
        riser_front_z = body_depth_bottom - leg_riser_depth,
        local_slope = tan(tilt_angle() + leg_foot_slope),
        foot_front_z = riser_front_z - leg_toe_drop / local_slope,
        back_z = body_depth_bottom + leg_rear_extra_reach,
        y_top = leg_overlap,
        y_bend = leg_overlap - leg_riser_drop,
        y_toe = y_bend - leg_toe_drop,
        y_bottom = -(feet_height + leg_extra_reach)
    )
    [
        [y_top, back_z],
        [y_top, riser_front_z],
        [y_bend, riser_front_z],
        [y_toe, foot_front_z],
        [y_bottom, foot_front_z],
        [y_bottom, back_z]
    ];

module leg_side_shape(x_start) {
    // polygon()'s points are [Y, Z]; this pair of rotations remaps the
    // linear_extrude (which can only extrude along its own Z) so the
    // extrusion instead runs along X, giving final (X, Y, Z) = (extrude
    // param, Y, Z) -- verified against an isolated test case before use,
    // since getting an axis-remap rotation's sign wrong is an easy way to
    // silently mirror or scramble a shape.
    //
    // Every exposed edge of the leg gets rounded by leg_edge_round in one
    // pass -- the knee, the foot's front tip, AND the side-cap edges where
    // those faces meet the leg's left/right ends -- via the standard
    // "erode along X, then minkowski" rounded-box trick: build the core
    // extrusion inset by leg_edge_round on each end (feet_width - 2r wide,
    // shifted in by r), then minkowski it with a sphere of that same
    // radius. For any of the core's FLAT faces, minkowski with a sphere
    // just offsets that face outward along its own normal by r -- so
    // insetting by r first and growing by r after lands the two side caps
    // back at exactly x=0 and x=feet_width (no residual bulge to clip),
    // while every edge/corner in between comes out genuinely filleted.
    //
    // The back (rear-plane) and floor edges are deliberately NOT inset --
    // they're not meant to round over -- but minkowski still puffs them
    // out by r along with everything else, which is harmless: they're
    // already overshoot material (leg_extra_reach, leg_rear_extra_reach)
    // clipped exactly flush by rear_shell()'s global half-space cuts
    // regardless of the shape fed into them, and their margins comfortably
    // exceed leg_edge_round.
    //
    // The TOP edge (y_top = leg_overlap) got the same treatment for free
    // when leg_edge_round was small, but isn't actually protected by any
    // clip -- minkowski pushes it up by r too, and unlike the back/floor,
    // nothing ever trims that overshoot back down. At small r this stayed
    // harmlessly inside the case's own solid corner; at bigger r it
    // reached past where the case's interior hollow begins, adding
    // unhollowed material into what's supposed to be clear interior space
    // (and still not actually blending any better with the case's own,
    // differently-shaped corner rounding above it -- minkowski gives a
    // compound 3D fillet there, the case's corner is a simple constant-
    // radius sweep in Z, so no radius choice makes those two curvatures
    // match). Fixed the same way as the back/floor: let the rounding
    // overshoot past y_top freely, then shave it flush with an explicit
    // y<=y_top clip -- keeps the knee/toe/end-cap fillets (all well below
    // y_top) untouched, while guaranteeing the leg never contributes
    // material above the case's own seam regardless of leg_edge_round.
    r = leg_edge_round;
    y_top = leg_overlap;
    intersection() {
        translate([x_start + r, 0, 0])
            minkowski() {
                rotate([0, 90, 0])
                    rotate([0, 0, 90])
                        linear_extrude(height = feet_width - 2 * r)
                            polygon(notch_profile());
                sphere(r = r, $fn = 16);
            }
        translate([-1000, -3000, -1000])
            cube([2000, 3000 + y_top, 4000]);
    }
}

// -------------------------
// FRONT BEZEL
// -------------------------

module front_bezel() {
    body_position()
    body_tilt()
    union() {
        difference() {
            // Main front face, with its outer perimeter edge chamfered
            chamfered_prism(case_width, case_height, front_thickness, corner_radius, front_edge_bevel);

            // LCD opening, with a slight chamfer softening its front edge
            translate([screen_left,
                       screen_bottom,
                       0])
                beveled_cut(screen_open_w,
                            screen_open_h,
                            front_thickness + 0.5,
                            screen_corner_r,
                            screen_bevel);

            // Left and right Lisa-style vent lines:
            // same count and pitch, different horizontal length
            vent_slots(vent_left_x, left_vent_w);
            vent_slots(vent_right_x, right_vent_w);
        }

        // Skirt behind the face plate that friction-fits over the rear
        // shell's exterior, so the front piece acts like a cap.
        front_cap_skirt();
    }
}

// -------------------------
// REAR SHELL
// -------------------------

// Depth of the rear housing measured from the front face (z=0) taper.
rear_outer_extra = 10000; // far beyond any real depth, used to cap open cubes

// Depth of the tapered outer envelope at a given global Y (0 = floor,
// case_height = top), and that same depth expressed in rear_shell's own
// local z frame (which starts at the front/rear split line).
function depth_at_y(y) = body_depth_bottom + (body_depth_top - body_depth_bottom) * y / case_height;
function local_exterior_z(y) = depth_at_y(y) - front_thickness - assembly_gap;

// The interior hollow's own (tapered) inner boundary at a given Y --
// local_exterior_z(y) minus back_thickness, i.e. the cavity tracks the
// true exterior taper so the material left behind it stays a constant
// back_thickness everywhere, not just at the top. (An earlier version
// used a single untapered depth, sized to the shallowest point (the top)
// so it would never poke through the sloped rear wall -- structurally
// safe, but it meant the wall behind the cavity got progressively
// thicker/heavier toward the base, using far more print material than a
// back_thickness wall needs to be sturdy.)
function interior_boundary_z(y) = local_exterior_z(y) - back_thickness;

// The shallowest point of the (now tapered) cavity, at y=case_height --
// used as the conservative minimum depth when checking that cap_depth
// (the front skirt's reach into the cavity) stays comfortably short of
// the interior everywhere, not just at this one worst-case point.
interior_depth = interior_boundary_z(case_height);

vent_row_y       = case_height - 16;

// A thin (skirt_thickness) solid wall filling the gap between the legs
// below the case's own bottom edge (local y=0, in this same pre-tilt
// frame) -- closing off what would otherwise be open air there, both to
// read more like the original Lisa's solid underside and to provide a
// recess for cables to exit (this used to sit flush with a separate I/O
// bay cutout above it; that cutout has been removed -- the skirt's own
// recess serves the same purpose now, see lisa_design.md item 28).
// Recessed skirt_depth behind the true exterior surface
// (local_exterior_z(y) - skirt_depth), adjustable off of that point by
// skirt_offset (positive = forward/toward the exterior surface, negative
// = backward/deeper into the case), continued down through the legs' own
// Y-range (y=0 down to the floor).
//
// Built directly as a hull() of two thin (0.1mm in Y) slabs, each already
// the correct skirt_thickness-thick cross-section AT that Y -- NOT (as
// first tried) a difference() of two large wedge_cutter()s offset by
// skirt_thickness. wedge_cutter() computes volume from Z=0 up to its
// taper, which is right for a shape that's supposed to start at the
// origin (the case's own rear face, etc.) but wrong here: subtracting two
// such wedges whose d-values differ by only skirt_thickness=3mm, over a
// much larger h and much larger Z magnitude (tens of mm), turned out to
// be exactly the kind of thin-difference-of-two-similar-solids case
// CGAL's boolean can lose precision on -- the result came back as two
// degenerate slivers (matching wedge_cutter's own internal 0.1mm end
// slabs) instead of the sloped slab in between, empty everywhere else.
// Building the already-thin cross-section directly and hull()-ing between
// its two ends is both simpler and avoids the near-cancelling subtraction
// entirely.
//
// Small overlap in Y at the top (matching the case body) guards against a
// coincident-face seam in the union, the same reasoning leg_overlap uses
// for the legs themselves. The X overlap into the legs has to be bigger
// than that: leg_side_shape()'s minkowski rounding (leg_edge_round) pulls
// the leg's own material back from its nominal x=feet_width/
// case_width-feet_width edge near that corner, so anything flush with the
// *nominal* edge leaves a sliver gap against the leg's *actual* (rounded)
// surface there -- the X overlap needs to reach past that pullback, not
// just guard against float noise.
module leg_skirt() {
    y_overlap = 0.2;
    x_overlap = leg_edge_round + 0.5;
    y_bottom = -(feet_height + leg_extra_reach);
    y_top = y_overlap;
    x_start = feet_width - x_overlap;
    w_skirt = skirt_width + 2 * x_overlap;
    z_inner_bottom = local_exterior_z(y_bottom) - skirt_depth - skirt_offset;
    z_inner_top = local_exterior_z(y_top) - skirt_depth - skirt_offset;

    translate([x_start, 0, 0])
        hull() {
            translate([0, y_bottom, z_inner_bottom])
                cube([w_skirt, 0.1, skirt_thickness]);
            translate([0, y_top - 0.1, z_inner_top])
                cube([w_skirt, 0.1, skirt_thickness]);
        }
}

module rear_shell() {
    // The floor clip (below) only ever trims the legs' small safety
    // margin (see required_lift()) -- the case body itself stays safely
    // above y=0 -- but it needs to sit outside body_position() so it
    // operates in the final global frame, at the true floor.
    intersection() {
    body_position()
    body_tilt()
    difference() {
    union() {
    translate([0, 0, front_thickness + assembly_gap])
    difference() {
        // Outer rear housing: a tapered envelope sized to only the portion
        // of the case's total depth behind the front piece -- d_bottom/
        // d_top are local_exterior_z(0)/local_exterior_z(case_height)
        // (the total taper minus front_thickness+assembly_gap) rather than
        // the full body_depth_bottom/body_depth_top, so this piece's own
        // front face lands exactly at the split line (see rear_shell()'s
        // outer translate) instead of redundantly re-modeling the front
        // piece's own rim all the way out to the true front tip. The far
        // (true rear) face is unaffected, since reducing both endpoints by
        // the same constant just shifts tapered_shell's linear taper,
        // without changing where it ends -- so the case's total depth
        // stays exactly what body_depth_bottom/body_depth_top say
        // regardless of how front_thickness is tuned.
        intersection() {
            tapered_shell(case_width, case_height, local_exterior_z(0), local_exterior_z(case_height), corner_radius);
            translate([-1, -1, -0.2])
                cube([case_width + 2, case_height + 2, rear_outer_extra]);
        }

        // Full-width row of thin horizontal vent slats near the top of the back.
        // Rounding radius kept strictly under half of the 2.2mm slat height
        // to avoid the offset() degenerate-empty-shape edge case (see
        // vent_slots() note in front_bezel section).
        //
        // Depth spans from just inside the interior hollow's own boundary
        // at this Y (interior_boundary_z(vent_row_y), minus a small
        // overshoot) out to just past the true exterior surface here
        // (local_exterior_z(vent_row_y), plus a small overshoot). Now that
        // the hollow itself tracks the taper (see interior_boundary_z()),
        // this span really is just back_thickness plus overshoot margin at
        // every Y -- unlike the earlier untapered cavity, where the actual
        // remaining wall thickness varied with Y and a plain back_thickness
        // depth here fell short of the hollow (leaving blind grooves)
        // everywhere except the one point the old cavity depth was
        // conservatively sized from.
        for (i = [0 : 14]) {
            translate([20 + i * 20,
                       vent_row_y,
                       interior_boundary_z(vent_row_y) - 0.5])
                rounded_cut(14, 2.2, local_exterior_z(vent_row_y) - interior_boundary_z(vent_row_y) + 1.0, 1.0);
        }
    }

    // Legs: left/right edge strips of the case's own outer shell,
    // continued down to the floor. Deliberately inside body_tilt() (see
    // leg_side_shape()) so they share the case's exact taper and tilt.
    leg_side_shape(0);
    leg_side_shape(case_width - feet_width);

    // Skirt filling the gap between the legs, flush with the I/O bay floor.
    leg_skirt();
    }

    // Hollow interior, subtracted from the WHOLE union above (case body +
    // legs + skirt) rather than just the case body -- this is what
    // actually reclaims the interior space the legs' own overlap material
    // (see leg_side_shape()'s y<=leg_overlap clip) would otherwise sit in.
    // That clip stops the leg from growing past the case's own seam, but
    // by itself has no idea where the interior cavity begins; legs are
    // feet_width wide (much wider than corner_radius), so their overlap
    // region was filling in a large swath of genuine interior clearance
    // space, not just the small rounded-corner area it needs to. Tracks
    // the true exterior taper (via tapered_shell(), the same technique
    // the outer shell itself uses) so the wall left behind it is a
    // constant back_thickness everywhere rather than ballooning thicker
    // toward the base. Wrapped in the same front_thickness+assembly_gap
    // translate as the case body's own local frame, so it lines up
    // correctly against both that (built in this same local frame) and
    // the legs/skirt (built directly in the true global frame this
    // translate maps into).
    translate([0, 0, front_thickness + assembly_gap])
    translate([wall_thickness, wall_thickness, -0.2])
        tapered_shell(case_width - wall_thickness * 2,
                      case_height - wall_thickness * 2,
                      interior_boundary_z(wall_thickness) + 0.2,
                      interior_boundary_z(case_height - wall_thickness) + 0.2,
                      max(1, corner_radius - wall_thickness));
    }

    // Floor clip (Y) + rear-plane clip (Z): trims the small safety margin
    // from required_lift() so the legs end in a clean flat cut exactly at
    // y=0 instead of floating just above it, AND trims the legs'
    // leg_rear_extra_reach overshoot flush with the case's true flat rear
    // plane (see rear_plane_z()) instead of leaving the back edge parallel
    // to the front's tilt.
    translate([-1000, 0, -1000])
        cube([case_width + 2000, 10000, 1000 + rear_plane_z() + 0.05]);
    }
}


// -------------------------
// LCD RETAINING FRAME
// -------------------------

module lcd_bracket() {
    outer_w = screen_open_w + lcd_overlap * 2;
    outer_h = screen_open_h + lcd_overlap * 2;
    inner_w = screen_open_w - 1;
    inner_h = screen_open_h - 1;

    difference() {
        rounded_prism(outer_w, outer_h, lcd_bracket_d, 3);
        translate([(outer_w - inner_w) / 2,
                   (outer_h - inner_h) / 2,
                   -0.2])
            rounded_cut(inner_w, inner_h, lcd_bracket_d + 0.4, 2);
    }
}

// -------------------------
// PCB MOUNTING PLATE
// -------------------------

module pcb_plate() {
    difference() {
        rounded_prism(pcb_plate_w, pcb_plate_h, pcb_plate_t, 3);

        for (x = [pcb_hole_inset, pcb_plate_w - pcb_hole_inset])
            for (y = [pcb_hole_inset, pcb_plate_h - pcb_hole_inset])
                translate([x, y, -0.2])
                    cylinder(h = pcb_plate_t + 0.4, d = pcb_hole_d);
    }

    // Four generic standoffs; move these after measuring the actual PCB.
    for (x = [pcb_hole_inset, pcb_plate_w - pcb_hole_inset])
        for (y = [pcb_hole_inset, pcb_plate_h - pcb_hole_inset])
            translate([x, y, pcb_plate_t])
                difference() {
                    cylinder(h = 6, d = 8);
                    translate([0, 0, -0.2])
                        cylinder(h = 6.4, d = pcb_hole_d);
                }
}

// -------------------------
// ASSEMBLY PREVIEW
// -------------------------

module assembly() {
    color([0.88, 0.84, 0.72])
        front_bezel();

    color([0.82, 0.79, 0.69])
        rear_shell();

    // LCD visual placeholder
    color([0.03, 0.03, 0.035])
    body_position()
    body_tilt()
        translate([screen_left + 1.5,
                   screen_bottom + 1.5,
                   -0.8])
            cube([screen_open_w - 3,
                  screen_open_h - 3,
                  0.7]);

    // Internal bracket preview, tucked behind the front bezel
    color([0.45, 0.45, 0.45, 0.35])
    body_position()
    body_tilt()
        translate([screen_left - lcd_overlap,
                   screen_bottom - lcd_overlap,
                   front_thickness + 1])
            lcd_bracket();
}

// -------------------------
// OUTPUT SELECTOR
// -------------------------

if (part == "assembly")
    // The body is modeled with height along Y and depth along Z (so each
    // individual piece lies flat on the print bed when exported on its
    // own). Rotate just this assembled preview so it stands upright with
    // Z as vertical, matching how OpenSCAD's default view and TinkerCAD
    // both expect "up" to be Z.
    rotate([90, 0, 0])
        assembly();
else if (part == "front")
    front_bezel();
else if (part == "back")
    rear_shell();
else if (part == "lcd_bracket")
    lcd_bracket();
else if (part == "pcb_plate")
    pcb_plate();
else
    echo("Unknown part selection.");
