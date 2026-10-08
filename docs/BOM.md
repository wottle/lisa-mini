# Bill of Materials

> **Software requirement:** this build uses an 11.6" 1080p widescreen LCD
> behind a case opening sized for the original 9.7" 4:3 Lisa window. You
> need [the LisaFPGA fork](https://github.com/wottle/LisaFPGA) that offsets the
> displayed image to fit — stock LisaFPGA firmware won't position it
> correctly.

## Printed parts

Pick **one** design (see the [README](../README.md#choose-your-design)),
then print its parts plus the common parts.

### Common (either design) -- `models/print-ready/common/`

| Qty | File |
|---|---|
| 4 | `Lisa_Mini_LCD_Mount_Clips.obj` |
| 1 | `Lisa_Mini_Lisa_Logo_Plate.obj` — Lisa logo badge |
| 1 | `Lisa_Mini_Manufacturer_Blank_Logo_Plate.obj` — plain insert for the bezel's second badge holder; no Apple logo plate is included (see [README](../README.md) for why) |
| 1 | `Lisa_Mini_Power_Switch.obj` — cap over the LisaFPGA's power switch |
| 1 | `Lisa_Mini_Back_LisaFPGA_SD_Slot_Covers.stl` |

### Design A: ESFloppy on back -- `models/print-ready/Lisa_Mini_With_ESFloppy_Screen_And_Buttons_On_Back/`

| Qty | File |
|---|---|
| 1 | `Lisa_Mini_Front.obj` |
| 1 | `Lisa_Mini_Back_LisaFPGA.obj` |
| 1 | `Lisa_Mini_ESFloppy_Shroud.obj` — dresses up the rear ESFloppy screen opening; print in black, no supports needed. Fit isn't perfect and needs a bit of glue to hold — see [ASSEMBLY.md](ASSEMBLY.md) |

### Design B: ESFloppy on front -- `models/print-ready/Lisa_Mini_With_ESFloppy_Screen_And_Buttons_On_Front/`

| Qty | File |
|---|---|
| 1 | `Lisa_Mini_Front_With_ESFloppy_Screen.obj` |
| 1 | `Lisa_Mini_Front_With_ESFloppy_Slot_Filler_Black.obj` — print in black |
| 1 | `Lisa_Mini_Back_LisaFPGA_ESFloppy_Moved_To_Front.obj` |
| 1 | `Lisa_Mini_ESFloppy_Screen_Clip.obj` |
| 1 | `Lisa_Mini_ESFloppy_Button_Cap.obj` |
| 3 | `Lisa_Mini_ESFloppy_Button_Inner_qty3.obj` — single part, print 3 copies |
| 3 | `Lisa_Mini_ESFloppy_Button_Outer_qty3.obj` — single part, print 3 copies |
| 1 | `Lisa_Mini_Power-Button.stl` — front-mounted lit power button |

### Design B extra parts

| Qty | Item | Notes |
|---|---|---|
| 3 | [Push buttons](https://a.co/d/0cvuNnPx) | The front ESFloppy buttons |
| 1 | [Master power rocker switch](https://a.co/d/08oj8ZMu) | Added by this design; same switch used in the author's Raspberry Pi build |
| 1 | Header pins and Dupont wires | Extend the ESFloppy buttons and the ESFloppy LCD to the front |
| 1 | Hookup wire | More wire for the new buttons and the power button |
| 1 | LED | For the lit power button; amber or yellow suits the board's 3.3V rail (see [ASSEMBLY.md](ASSEMBLY.md#design-b-extra-steps-esfloppy-and-power-on-the-front)) |
| 1 | Soldering iron | Required for the board modifications |
| 1 | Optional: [replacement ESFloppy LCD](https://www.aliexpress.us/item/3256809306858810.html) | If you damage the original while removing it. Get the **4-pin** version. The author used the white-text version; a blue-text version is also available |

## Electronics

| Qty | Item | Notes |
|---|---|---|
| 1 | [LisaFPGA](https://www.tindie.com/products/lisafpga/) board | FPGA re-implementation of the Apple Lisa |
| 1 | [11.6" 1080p widescreen LCD panel](https://www.aliexpress.us/item/3256812306199991.html) | Requires [the LisaFPGA fork](https://github.com/wottle/LisaFPGA) to offset the image within the case's screen opening |
| 1 | [LCD controller board](https://www.aliexpress.us/item/2251832782455852.html) | Drives the LCD panel above |
| 2 | [Buck converter](https://www.amazon.com/dp/B07VVXF7YX) | Steps 12V input down for the LCD/controller and LisaFPGA |
| 1 | [Panel-mount barrel jack, 12V input](https://www.amazon.com/dp/B0DLKN8J7M) | Mounts through the rear shell for power input |
| 1 | [Right-angle USB-C cable, thin/low-profile](https://www.amazon.com/dp/B0FGNB87BX) | LisaFPGA fits tightly in the case — a straight or bulky connector won't clear |
| 1 | [U-shaped HDMI adapter/connector](https://www.amazon.com/dp/B0DB5KKDN2) | Routes HDMI out of the LisaFPGA within the case's tight clearance |
| 1 | [Thin HDMI cable](https://www.amazon.com/dp/B0FB3YDYTT) | LisaFPGA to LCD controller board, low-profile to fit the case |
| 1 | [5V USB-C pigtail cable](https://www.amazon.com/dp/B0GBGLNR52) | Powers the LCD controller board off one of the buck converters |

Links are the specific parts used in the build — equivalents will generally
work, but panel/controller pairing in particular should match (a mismatched
LCD/controller pair won't drive correctly). The LisaFPGA sits in a tight
fit inside the case, so the right-angle USB-C, U-shaped HDMI, and low-profile
HDMI cable aren't just convenience picks — standard straight connectors or
thicker cables may not clear.

Both 5V power runs (buck converter → LisaFPGA, buck converter → LCD
controller) use USB-C connectors rather than permanent wiring. This is
deliberate: it lets the front-mounted parts (LCD + controller board) and
back-mounted parts (LisaFPGA + power) quick-disconnect from each other,
making it much easier to separate the shells for maintenance.

## Hardware

| Qty | Item | Used for |
|---|---|---|
| 4 | M3 x 4mm screws | Secure the LCD mount clips holding the LCD panel in place |
| 4 | M3 x 4mm screws | Secure the LisaFPGA board to the back shell's standoffs |

## Optional

- A few capacitors across the LCD and LisaFPGA power rails, to smooth
  inrush/startup current draw — not required, but helps if you see
  brownout/reset issues at power-on
