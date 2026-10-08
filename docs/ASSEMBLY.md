# Assembly Instructions

## Pick a design first

Choose **one** before printing (details in the
[README](../README.md#choose-your-design)):

- **Design A: ESFloppy on back.** Leaves the LisaFPGA untouched. Uses
  the parts in `models/print-ready/Lisa_Mini_With_ESFloppy_Screen_And_Buttons_On_Back/`.
- **Design B: ESFloppy on front.** Moves the ESFloppy screen and buttons,
  and the lit power button, to the front. This requires modifying the
  LisaFPGA: soldering wires to the ESFloppy buttons, and removing the
  board's own power LED and soldering wires to it for the front power
  button. Uses the parts in `models/print-ready/Lisa_Mini_With_ESFloppy_Screen_And_Buttons_On_Front/`.

Both designs also use the parts in `models/print-ready/common/`. Steps
below apply to both designs unless marked **Design A only** or
**Design B**.

## Before you start

- Confirm you have all parts from [`BOM.md`](BOM.md)
- Test-fit the LCD panel and LisaFPGA board against the printed shells
  before final assembly
- Clean up any stringing/support marks around the vent lines and screen
  opening
- **Flash [the LisaFPGA fork](https://github.com/wottle/LisaFPGA) before
  assembling the case.** It adds the image offset this case needs, plus
  USB host improvements (USB hub support for keyboards and mice) and
  persistent settings. Clone the fork and run `./program_board.sh` from
  the clone, with the board plugged into your computer over a full USB-C
  power+data cable and its power switch on. If your computer asks whether
  to allow the board's USB hub, approve it, then unplug and reconnect the
  board before running the script. Reflashing erases saved settings, so
  re-apply them afterward. See the fork's
  [README](https://github.com/wottle/LisaFPGA#about-this-fork-lisa-mini)
  for details. Once assembled, the LisaFPGA's USB-C port only
  has the low-profile power cable plugged in (no data), so you lose the
  ability to flash new software. To update later, remove the 4 screws
  holding the LisaFPGA to the back shell, unplug the low-profile USB-C
  power cable, and plug in a full USB-C power+data cable to reflash it.

## Steps

### Front assembly

1. **Mount the LCD**
   - Seat the LCD panel into the front bezel, pushed all the way to the
     left side
   - Set a `Lisa_Mini_LCD_Mount_Clips.obj` clip above each of the 4
     mounting holes and screw it down with an M3x4mm screw to hold the
     LCD in place
   - Stick the LCD controller board to the back of the LCD panel with
     double-sided tape, and connect the LCD's ribbon cable and small
     2-pin power connector to it

   ![LCD and controller board mounted in the front shell](../images/1_lcd_mounting.jpg)

2. **Attach the logo plates**
   - Press-fit `Lisa_Mini_Lisa_Logo_Plate.obj` into the bezel's Lisa logo
     plate holder — no glue needed. If it's too tight to press-fit, scale
     the plate down to 99% and reprint
   - Press-fit `Lisa_Mini_Manufacturer_Blank_Logo_Plate.obj` into the
     bezel's second holder the same way — this repo ships it blank rather
     than an Apple logo (see the README for why); swap in your own part
     there if you want a logo

### Back assembly

3. **Install the power input and buck converters**
   - Mount the 12V panel-mount barrel jack into the rear shell
   - Mount the two buck converters along the top edge of the rear shell
   - Wire the barrel jack's 12V output, splitting it into two leads — one
     to each buck converter's input

   ![Back shell with barrel jack and buck converters wired](../images/2_back_power_and_buck_converters.jpeg)

4. **Install the ESFloppy shroud (Design A only)**
   - Fit `Lisa_Mini_ESFloppy_Shroud.obj` into the rear ESFloppy screen
     opening — it dresses up that opening, which currently sits well below
     the back surface
   - Double-check orientation before gluing: the shroud should angle
     toward the top edge of the case
   - The press-fit alone may not hold it — a bit of glue is recommended.
     Use hot glue if you want to be able to remove it later, or superglue
     for a permanent mount. Hot glue is the safer choice for now: the
     current shroud's fit isn't perfect (it exposes a bit too much of the
     area below the ESFloppy LCD), so an improved version may replace it
     without needing to reprint the back shell

5. **Install the power switch cap (Design A; Design B see below)**
   - Before installing the LisaFPGA board, snap `Lisa_Mini_Power_Switch.obj`
     into its mounting point in the rear shell — the photo below shows its
     orientation. Do this now: once the LisaFPGA board is installed in the
     next step, it covers this area and the switch cap can no longer be
     placed.

   ![Power switch cap orientation before installing the LisaFPGA board](../images/3_power_switch_orientation.jpeg)

6. **Install the LisaFPGA board**
   - Before mounting the board, plug the low-profile right-angle USB-C
     cable and the U-shaped HDMI adapter into the LisaFPGA's own ports.
     Do this first — the case's tight clearance around the board makes
     both connectors difficult or impossible to attach once it's screwed
     down
   - Mount the LisaFPGA board into the rear shell
     (`Lisa_Mini_Back_LisaFPGA.obj`) and secure it to the standoffs with 4
     M3x4mm screws — this also covers up the barrel jack wiring
     underneath, and seats the board's onboard switch under the power
     switch cap from step 5
   - Connect the buck converters' 5V outputs to the LisaFPGA board's power
     input and, optionally, an inrush capacitor at the LisaFPGA's power
     connector

   ![LisaFPGA board installed and screwed to standoffs](../images/4_LisaFPGA_board_install.jpeg)

### Connect and close

7. **Wire it up**
   - Connect the second buck converter's 5V output to the LCD controller
     board via a USB-C connector rather than a permanent connection
   - Connect the LisaFPGA's U-shaped HDMI adapter (installed in step 6) to
     the LCD controller board with the thin HDMI cable

   These connections use USB-C connectors rather than soldered/permanent
   wiring, deliberately — it lets the front-mounted parts (LCD + controller
   board) and back-mounted parts (LisaFPGA + power) quick-disconnect from
   each other, making it much easier to separate the shells for
   maintenance.

   ![HDMI and 5V power connections between the back and front shells](../images/5_connections_between_back_and_front.jpeg)

8. **Join front and back shells**
   - The BOM's 8 M3x4mm screws are all accounted for elsewhere (4 for the
     LCD mount clips in step 1, 4 for the LisaFPGA standoffs in step 6) —
     the shells themselves simply press together
   - Small bumps on the back shell align with matching indentations on
     the front shell to help hold the press fit in place

9. **Final check**
   - Power on and verify display output before fully closing up the case
   - Plug a USB keyboard and mouse (directly or through a hub) into the
     LisaFPGA and confirm both respond

## Design B: extra steps (ESFloppy and power on the front)

Design B replaces the Design A back-assembly steps (3-9 above) with the
sequence below. Do steps 1 and 2 above (mount the LCD, attach the logo
plates) as written, using `Lisa_Mini_Front_With_ESFloppy_Screen.obj` and
the other parts in `models/print-ready/Lisa_Mini_With_ESFloppy_Screen_And_Buttons_On_Front/`
instead of the Design A parts, and skip the ESFloppy shroud. Do the board
modifications (B1-B2) **before** mounting the LisaFPGA, since the board
covers the work area afterward.

### Modify the LisaFPGA

**B1. Move the ESFloppy LCD to the front**
   - Desolder the ESFloppy LCD's pins and remove the LCD. This takes a fair
     amount of heat and can damage the LCD; a replacement 4-pin LCD is
     listed in the BOM
   - Solder header pins to the back of the LCD, and to the LisaFPGA's
     ESFloppy LCD pads, then extend the connection with Dupont wires.
     Match pin 1 to pin 1, and double-check SDA/SCK, power and ground
     against the schematic: a miswired screen just stays black

   ![Desoldering the ESFloppy LCD pins](../images/design_b_assembly/1_1_remove_ESFloppy_LCD_desolder_pins.jpg)

   ![Header pins on the back of the LCD](../images/design_b_assembly/1_2_remove_ESFloppy_LCD_add_header_pins_to_back_of_LCD.jpg)

   ![Header pins on the LisaFPGA, from the top](../images/design_b_assembly/1_3_remove_ESFloppy_LCD_add_header_pins_to_back_of_lisaFPGA_main_board_from_top.jpg)

   ![Header pins on the LisaFPGA, from the bottom](../images/design_b_assembly/1_4_remove_ESFloppy_LCD_add_header_pins_to_back_of_lisaFPGA_main_board_from_bottom.jpg)

**B2. Wire the buttons and the power LED**
   - Solder a wire to two legs of each of the ESFloppy LEFT, SEL and RIGHT
     buttons and of the LISA POWER button (6 wires for the ESFloppy
     buttons, plus 2 for the power button)
   - Remove the board's own power LED (LED5) and solder two wires to its
     pads, giving 4 wires for the lit power button in total

   ![Wires soldered to the ESFloppy buttons, power button and power LED pads](../images/design_b_assembly/2_1_solder_wires_to_ESFloppy_buttons_and_power_button_and_power_led.jpg)

   ![Closeup of the power button and LED pads, with the LED removed](../images/design_b_assembly/2_2_closeup_of_power_button_and_LED-note_LED_removed.jpg)

   ![Closeup of the power button and LED with all 4 wires](../images/design_b_assembly/2_3_closeup_of_power_button_and_LED-all_4_wires.jpg)

   The board's LED current is limited by a fixed resistor on a 3.3V rail,
   so use a low forward-voltage LED: a warm white LED (about 3V) was far
   too dim, whereas amber or yellow (about 2V) is the better fit.

### Front assembly

**B3. Assemble the buttons and clip in the LCD**
   - Fit the outer button parts (`Lisa_Mini_ESFloppy_Button_Outer_qty3.obj`),
     and seat the push buttons' legs in the button holders
   - Add the inner button pieces (`Lisa_Mini_ESFloppy_Button_Inner_qty3.obj`)
   - Secure the ESFloppy LCD with `Lisa_Mini_ESFloppy_Screen_Clip.obj`
   - Tape the LCD controller board in place

   ![Outer buttons installed, with the legs in the button holders](../images/design_b_assembly/3_1_button_assembly_add_outer_buttons_and_install_button_legs_in_button_holders.jpg)

   ![Inner button pieces added](../images/design_b_assembly/3_2_button_assembly_add_inner_button_pieces.jpg)

   ![Button assembly complete, with the LCD secured by its clip](../images/design_b_assembly/3_3_button_assembly_complete_with_LCD_secured_with_clip.jpg)

   ![Front case with the LCD installed, controller board taped, and buttons and LCD assembled](../images/design_b_assembly/3_4_front_case_with_LCD_installed_controller_board_taped_and_button_and_lcd_assembly_complete.jpg)

**B4. Wire the lit power button**
   - Wire the 4 wires to the lit power button's switch and LED
     (`Lisa_Mini_Power-Button.stl`). Glue the LED in place first
   - Fish the 4 wires through the power switch opening

   ![Wiring the switch and LED](../images/design_b_assembly/4_1_wire_keyboard_switch_and_led_glue_LED_in_place_first.jpg)

   ![Fishing the 4 wires through the power switch opening](../images/design_b_assembly/4_2_fish_4_wires_through_power_switch_opening.jpg)

   ![Fishing the 4 wires through the power switch opening, second view](../images/design_b_assembly/4_3_fish_4_wires_through_power_switch_opening.jpg)

**B5. Bundle the wires**
   - Bundle the button and LED wires and pull them up toward the other side
     of the main board

   ![Bundled button and LED wires](../images/design_b_assembly/5_1_bundle_wires_for_buttons_and_led_and_pull_them_up_towards_other_side_of_main_board.jpg)

### Back assembly

**B6. Prepare the back case**
   - Connect the 12V barrel jack to the master power rocker switch, and
     from the switch to the buck converters

   ![Back case with the 12V jack, master switch and buck converters](../images/design_b_assembly/6_1_prepare_back_case_connect_12v_jack_to_switch_then_buck_converters.jpg)

**B7. Install the LisaFPGA**
   - Install the LisaFPGA with `Lisa_Mini_Back_LisaFPGA_ESFloppy_Moved_To_Front.obj`,
     making sure the power switch cap aligns with the switch on the board
   - Pull the wires out the top, avoiding any buttons

   ![LisaFPGA installed with the power switch aligned](../images/design_b_assembly/7_1_install_lisaFPGA_ensure_power_switch_aligns_to_switch_on_board_pull_wires_out_top_avoiding_any_buttons.jpg)

**B8. Connect the lit power button**
   - Connect the 4 wires from the lit power button to the 4 wires coming
     from the LisaFPGA board

   ![Connecting the lit power button's wires to the LisaFPGA board's wires](../images/design_b_assembly/8_1_connect_4_wires_from_lighted_power_switch_to_wires_on_LisaFPGA_board.jpg)

**B9. Install the SD card slot cover**
   - Take `Lisa_Mini_Back_LisaFPGA_SD_Slot_Covers.stl`, align it with the
     SD card opening, and press it gently into place

   ![SD card opening cover](../images/design_b_assembly/9_1_take_sd_card_opening_cover.jpg)

   ![Aligning the cover and pressing it into place](../images/design_b_assembly/9_2_align_sd_card_cover_and_gently_press_in_place.jpg)

### Connect and close

**B10. Connect the front to the back**
   - Connect the ESFloppy LCD, the HDMI and power to the LCD controller
     board, and the 6 wires for the ESFloppy buttons

   ![ESFloppy LCD, HDMI, power and button wires connected between the front and back](../images/design_b_assembly/10_1_connect_ESFloppy_LCD_HDMI_Power_To_Controller_and_6_wires_for_ESFloppy_buttons.jpg)

**B11. Close the case**
   - Tuck in the wires and snap the front piece into the back piece

   ![Tucking in the wires and snapping the front onto the back](../images/design_b_assembly/11_1_tuck_in_wires_and_snap_front_piece_into_back_piece.jpg)

Finish with the final check (step 9 above).
