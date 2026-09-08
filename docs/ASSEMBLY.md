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

1. **Prep the front shell**
   - Insert `Lisa_Mini_LCD_Mount_Clips.obj` into the front bezel's LCD
     mounting points
   - TODO: describe clip orientation / fit

2. **Mount the LCD**
   - Seat the LCD panel into the front bezel
   - Secure with the 4 LCD mount clips, each fastened with an M3x4mm screw
   - TODO: describe cable routing to the driver board

3. **Attach the logo plates**
   - Press-fit or glue `Lisa_Mini_Lisa_Logo_Plate.obj` into the bezel's Lisa
     logo plate holder
   - Press-fit or glue `Lisa_Mini_Manufacturer_Blank_Logo_Plate.obj` into
     the bezel's second holder — this repo ships it blank rather than an
     Apple logo (see the README for why); swap in your own part there if
     you want a logo
   - TODO: confirm fit tolerance (press-fit vs. adhesive)

4. **Mount the power switch**
   - Install `Lisa_Mini_Power_Switch.obj` over the LisaFPGA board's own
     onboard switch — no separate switch hardware needed
   - TODO: confirm alignment/fit details

5. **Install the LisaFPGA board**
   - Mount the LisaFPGA board into the rear shell (`Lisa_Mini_Back_LisaFPGA.obj`)
   - TODO: confirm standoff/screw locations

6. **Wire it up**
   - Connect LCD driver board, power, and LisaFPGA board
   - TODO: wiring diagram or photo

7. **Join front and back shells**
   - The BOM's 4 M3x4mm screws are all accounted for by the LCD mount
     clips in step 2, so this joint is snap-fit
   - TODO: confirm snap-fit engagement points / any assembly order that
     matters

8. **Final check**
   - Power on and verify display output before fully closing up the case

## Photos

<!-- TODO: add build photos to ../images/ and reference them here -->
