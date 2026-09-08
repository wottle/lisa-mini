# Printing Notes

## Recommended settings

| Setting | Value |
|---|---|
| Wall thickness | ~2.4mm (2 perimeters at 0.4mm nozzle, or adjust to match) |
| Infill | 15–20% |
| Layer height | TODO (0.2mm is a safe default) |
| Supports | Front: none needed. Back: needed (see below) |
| Bed size required | 350mm — the model is 330mm wide |

## Orientation

- `Lisa_Mini_Front_11.6_LCD_Mount_With_Logo_Plate_Holders.obj` — print face
  down
- `Lisa_Mini_Back_LisaFPGA.obj` — print face up
- `Lisa_Mini_LCD_Mount_Clips.obj` — TODO
- `Lisa_Mini_Lisa_Logo_Plate.obj` — TODO
- `Lisa_Mini_Power_Switch.obj` — TODO

## Bed size / smaller printers

The model is 330mm wide, so front/back shells need a 350mm print bed to
print in one piece as designed. If your printer's bed is smaller, you can
slice the front/back shells in half and print in two pieces — but the seam
where the halves join will be visible on the finished part. There's
currently no version of this design pre-split for smaller beds.

## Supports

The design was optimized to minimize supports overall, but the back shell
(`Lisa_Mini_Back_LisaFPGA.obj`) currently needs supports — the skirt
between the legs is the cause. It's possible to remove that skirt to
eliminate most/all of the back's support requirement, but that variant
hasn't been made yet.

## Material

<!-- TODO: note tested filament (PLA/PETG/ABS) and any warping considerations
     for the larger front/back shells -->

## Known print issues

<!-- TODO: note any issues found while dialing in prints (warping,
     stringing on vents, tolerance on LCD clips, etc.) -->
