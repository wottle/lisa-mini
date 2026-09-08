# Assembly Instructions

<!-- TODO: replace with real step-by-step instructions + photos once the
     build has been done and documented. Structure below is a starting
     framework. -->

## Before you start

- Confirm you have all parts from [`BOM.md`](BOM.md)
- Test-fit the LCD panel and LisaFPGA board against the printed shells
  before final assembly
- Clean up any stringing/support marks around the vent lines and screen
  opening

## Steps

### Front assembly

1. **Prep the front shell**
   - Insert `Lisa_Mini_LCD_Mount_Clips.obj` into the front bezel's LCD
     mounting points
   - TODO: describe clip orientation / fit

2. **Mount the LCD**
   - Seat the LCD panel into the front bezel
   - Secure with the 4 LCD mount clips, each fastened with an M3x4mm screw
   - Stick the LCD controller board to the back of the LCD panel with
     double-sided tape

3. **Attach the logo plates**
   - Press-fit or glue `Lisa_Mini_Lisa_Logo_Plate.obj` into the bezel's Lisa
     logo plate holder
   - Press-fit or glue `Lisa_Mini_Manufacturer_Blank_Logo_Plate.obj` into
     the bezel's second holder — this repo ships it blank rather than an
     Apple logo (see the README for why); swap in your own part there if
     you want a logo
   - TODO: confirm fit tolerance (press-fit vs. adhesive)

### Back assembly

4. **Install the power input**
   - Mount the 12V panel-mount barrel jack into the rear shell
   - Wire the barrel jack's 12V output, splitting it into two leads — one
     to each buck converter's input

5. **Install the LisaFPGA board**
   - Mount the LisaFPGA board into the rear shell
     (`Lisa_Mini_Back_LisaFPGA.obj`) and secure it to the standoffs with
     screws — this also covers up the barrel jack wiring underneath
   - TODO: confirm standoff/screw count

### Connect and close

6. **Wire it up**
   - Connect each buck converter's 5V output to the LisaFPGA and to the
     LCD controller board via USB-C connectors rather than a permanent
     connection — this lets the front-mounted parts (LCD + controller
     board) and back-mounted parts (LisaFPGA + power) quick-disconnect
     from each other, which makes it much easier to separate the shells
     later for maintenance
   - Connect video (HDMI) between the LisaFPGA and the LCD controller
     board

7. **Join front and back shells**
   - The BOM's 4 M3x4mm screws are all accounted for by the LCD mount
     clips in step 2, so this joint is snap-fit
   - Snap `Lisa_Mini_Power_Switch.obj` on over the LisaFPGA board's own
     onboard switch as the shells close — no separate switch hardware
     needed
   - TODO: confirm snap-fit engagement points / any assembly order that
     matters

8. **Final check**
   - Power on and verify display output before fully closing up the case

## Photos

Planned build photos, to be added once taken:

- Front shell with the LCD mounted and the LCD controller board taped to
  its back
- Back shell with the barrel jack installed and wiring split to the two
  buck converter inputs (before the LisaFPGA covers it)
- Back shell with the LisaFPGA installed and screwed down to its standoffs

<!-- TODO: add the photos above to ../images/ and reference them here -->
