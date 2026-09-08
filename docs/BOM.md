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

## Hardware

| Qty | Item | Used for |
|---|---|---|
| 4 | M3 x 4mm screws | Assembly (TODO: confirm exactly which joints these secure) |

## Optional

- A few capacitors across the LCD and LisaFPGA power rails, to smooth
  inrush/startup current draw — not required, but helps if you see
  brownout/reset issues at power-on
- FloppyEmu (slot not yet modeled — case allows for future add-on)
