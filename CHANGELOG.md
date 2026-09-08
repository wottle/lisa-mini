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
