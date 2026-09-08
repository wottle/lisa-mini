# Bill of Materials

## Printed parts

| Qty | File |
|---|---|
| 1 | `Lisa_Mini_Front_11.6_LCD_Mount_With_Logo_Plate_Holders.obj` |
| 1 | `Lisa_Mini_Back_LisaFPGA.obj` |
| — | `Lisa_Mini_LCD_Mount_Clips.obj` (qty TODO — confirm how many clips are used) |
| 1 | `Lisa_Mini_Lisa_Logo_Plate.obj` |
| 1 | `Lisa_Mini_Power_Switch.obj` |

## Electronics

| Qty | Item | Notes |
|---|---|---|
| 1 | [LisaFPGA](https://www.tindie.com/products/lisafpga/) board | FPGA re-implementation of the Apple Lisa |
| 1 | [9.7" 4:3 LCD panel](https://www.aliexpress.us/item/3256812306199991.html) | iPad-style panel, ~197×148mm visible area |
| 1 | [LCD controller board](https://www.aliexpress.us/item/2251832782455852.html) | Drives the LCD panel above |
| 2 | [Buck converter](https://www.amazon.com/dp/B07VVXF7YX) | Steps 12V input down for the LCD/controller and LisaFPGA |
| 1 | [Panel-mount barrel jack, 12V input](https://www.amazon.com/dp/B0DLKN8J7M) | Mounts through the rear shell for power input |
| 1 | Power switch (rocker or pushbutton) | Mounts in `Lisa_Mini_Power_Switch.obj` |

Links are the specific parts used in the build — equivalents will generally
work, but panel/controller pairing in particular should match (a mismatched
LCD/controller pair won't drive correctly).

## Hardware

| Qty | Item | Used for |
|---|---|---|
| 4 | M3 x 4mm screws | Assembly (TODO: confirm exactly which joints these secure) |

## Optional

- A few capacitors across the LCD and LisaFPGA power rails, to smooth
  inrush/startup current draw — not required, but helps if you see
  brownout/reset issues at power-on
- FloppyEmu (slot not yet modeled — case allows for future add-on)
