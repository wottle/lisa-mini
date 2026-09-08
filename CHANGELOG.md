# Changelog

## Unreleased

- Initial public repo scaffold: front/back shells, LCD mount clips, logo
  plate, and power switch bezel as print-ready OBJ files
- Documented full BOM (LCD, LCD controller, buck converters, barrel jack,
  screws, cabling)
- Documented bed size requirement (350mm), print orientation, and back
  shell's support requirement
- Corrected LCD spec: 11.6" 1080p widescreen, not 9.7" 4:3 iPad panel; noted
  the required LisaFPGA fork for offsetting the image to fit the case's
  screen opening
- Removed separate power switch hardware from BOM — the printed part sits
  over the LisaFPGA board's own switch; confirmed LCD mount clip qty is 4
- Removed incorrect FloppyEmu mention from BOM — LisaFPGA's built-in
  ESFloppy needs no separate hardware; documented the case's existing
  ESFloppy button cutouts and rear screen window, and noted a possible
  future front-mount revision
- Confirmed the 4 M3x4mm screws secure the LCD mount clips; front/back
  shell join is therefore snap-fit
- Documented layer height (0.2mm, 0.12mm + ironing for the logo plate)
- Clarified only the Lisa logo plate is included; the bezel's second badge
  holder is intentionally left blank to avoid distributing Apple's logo
- Added `Lisa_Mini_Manufacturer_Blank_Logo_Plate.obj` — the blank insert
  for the bezel's second badge holder
- Corrected supports guidance: the front shell also needs supports (under
  the logo plate badge holder, printed with a PETG support interface
  layer), not just the back; noted LCD clips + power switch print on the
  same plate as the front shell
- Added print orientation screenshots to PRINTING.md
- Rewrote ASSEMBLY.md into front/back/connect-and-close sections, and
  documented the barrel jack wiring, LCD controller mounting, and the
  quick-disconnect USB-C connectors between front- and back-mounted
  components
- Added 5 assembly photos and corrected the power switch step: the cap
  must be installed before the LisaFPGA board, since the board covers
  access to it afterward
- Added `Lisa_Mini_ESFloppy_Shroud.obj` — dresses up the rear ESFloppy
  screen opening; print in black, no supports needed
- Documented filament used: Polar Filament Retro Platinum PLA
- Filled in LCD mount clip orientation (LCD pushed all the way left,
  clips over the 4 mounting holes) and logo plate fit (press-fit, no
  glue — scale to 99% if too tight) in ASSEMBLY.md
- Documented ESFloppy shroud orientation (angles toward the top edge) and
  that it needs glue to hold (hot glue for removable, superglue for
  permanent) since the fit isn't perfect yet and an improved version may
  follow
- Added the 4 M3x4mm screws that secure the LisaFPGA board to the back
  shell's standoffs (8 total in the BOM now, with the LCD mount clip
  screws)
- Noted the low-profile USB-C cable and U-shaped HDMI adapter must be
  plugged into the LisaFPGA board before it's screwed down -- the case's
  tight clearance makes them hard to attach afterward
- Added a pre-assembly prerequisite: flash the LisaFPGA fork before
  closing up the case, since the low-profile USB-C cable carries power
  only, not data -- documented the reflash procedure (remove 4 screws,
  swap in a full USB-C power+data cable) for later updates
- Confirmed the front/back shell join is a plain press fit, with
  alignment bumps on the back shell and matching indentations on the
  front — closes out the last open TODO in ASSEMBLY.md
- Noted the power switch only switches the LisaFPGA, not the LCD — the
  plan is to pull the 12V input to power down both
