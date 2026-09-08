# Lisa Mini

A 3D-printable, Apple Lisa–inspired enclosure for building a mini all-in-one
around a [LisaFPGA](https://www.tindie.com/products/lisafpga/) board and a
9.7" 4:3 LCD panel (iPad-style, ~197×148mm visible area).

![Lisa Mini](images/hero.jpg)
<!-- TODO: replace with a real photo once uploaded to images/ -->

## About

This case is designed to house a LisaFPGA board — an FPGA-based
re-implementation of the original Apple Lisa — behind a compact modern LCD,
in an enclosure that echoes the look of the original 1983 Lisa: front vent
lines, a screen that leans back while the case stays vertical, and integrated
L-shaped feet with no visible seams between leg and case.

Designed for FDM printing on a standard-size bed, no supports required for
the main shell (all overhangs kept under 45°).

## What's here

```
models/
  print-ready/   Final OBJ files, ready to slice and print
  source/        Parametric OpenSCAD source + design notes
images/           Build photos and renders
docs/
  ASSEMBLY.md     Step-by-step build instructions
  BOM.md          Parts and hardware you'll need
  PRINTING.md     Slicer settings and printing notes
```

## Parts to print

| File | Part |
|---|---|
| `Lisa_Mini_Front_11.6_LCD_Mount_With_Logo_Plate_Holders.obj` | Front bezel / LCD mount |
| `Lisa_Mini_Back_LisaFPGA.obj` | Rear shell, sized for the LisaFPGA board |
| `Lisa_Mini_LCD_Mount_Clips.obj` | LCD retaining clips |
| `Lisa_Mini_Lisa_Logo_Plate.obj` | Lisa logo badge insert |
| `Lisa_Mini_Power_Switch.obj` | Power switch bezel/housing |

See [`docs/BOM.md`](docs/BOM.md) for the LCD panel, LisaFPGA board, and
hardware you'll need, and [`docs/ASSEMBLY.md`](docs/ASSEMBLY.md) for the
build sequence.

## Editing the design

The parametric source (`models/source/lisa_modern_template.scad`) is an
OpenSCAD model of the case shell and covers the overall body/vent/leg
geometry. `models/source/lisa_design.md` documents the design reference
image this was built against and the reasoning behind the current shape —
read it before changing proportions.

Note: the `print-ready/` OBJs are further along than the `.scad` source
file. The OpenSCAD model produced a simplified starter shell, which was
then brought into TinkerCAD for significant additional work — mounting
points, port/switch openings, LCD clip geometry, and the logo plate —
that isn't reflected in the `.scad` file. Treat the `.scad` file as the
best starting point for overall shell/vent/leg proportions, not as a 1:1
source for the exact release files; there's currently no single parametric
source that captures the final printed geometry end to end.

## Power design notes

The original plan was to power the LCD controller board directly off a 5V
USB-C input. That controller board didn't work reliably on 5V USB-C — the
board was later damaged during troubleshooting, so it's unconfirmed whether
5V USB-C itself was the actual problem or just correlated with what killed
it. The working setup, and what the BOM/case now assume, is a single 12V
barrel jack input split across two buck converters into separate 5V lines
for the LisaFPGA and the LCD controller. If you try 5V USB-C directly into
the controller board, treat it as unverified and have a fallback plan.

## Printing

See [`docs/PRINTING.md`](docs/PRINTING.md). Quick summary:

- Wall thickness: ~2.4mm
- Infill: 15–20%
- No overhangs > 45° on the main shell
- Snap-fit / screw assembly, no glue required

## License

Design files are released under
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) —
free to share and remix for non-commercial use, with attribution, under the
same license. See [`LICENSE`](LICENSE).

## Also published on

<!-- TODO: fill in once uploaded -->
- Thingiverse: _link pending_
- MakerWorld: _link pending_
- Creality Cloud: _link pending_
