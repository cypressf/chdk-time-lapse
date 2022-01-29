# How to shoot time-lapse videos of a snowstorm

## Download CHDK

Click to download [CHDK version s90-101c-1.5.1-6058-full](s90-101c-1). I found that version by identifying my camera and firmware version, and looking it up in [this table](http://mighty-hoernsche.de))

- Camera: Canon PowerShot S90
- Firmware Version: GM1.01C

## Install CHDK on a memory card

Follow instructions for the "[Firmware Update Method](https://chdk.fandom.com/wiki/Prepare_your_SD_card#Firmware_Update_Method.2A)". This is much easier than creating an auto-booting CHDK memory card, and just requires a little overhead every time you turn the camera on.

## Set up the time-lapse script

1. Copy the script, `rawopint.lua`, to your SD card at `/CHDK/SCRIPTS/`
2. Copy the settings, `RAWOPINT.1`, to your SD card at `/CHDK/DATA/`
3. Lock the SD card and insert it into the camera (CHDK will boot)
4. Half-press the shutter button to go into "shoot" mode
5. Press the S (shortcuts) button to open the CHDK menu
6. Press FUNC/SET to open the Script Menu
7. Press FUNC/SET to Load Script from File...
8. Select `RAWOPINT.LUA`
9. Go to `Saved Parameters Set` and click right on the wheel until `1` is selected (that's the `RAWOPINT.1` settings file)

## Lock focus and white balance

Press `S` (shortcuts) button to deactivate CHDK. Set the camera to `M` (manual mode). Set focus to infinity. Set white balance to cloudy day.

## Run the script

- Press the `S` (shortcuts) button to activate CHDK. It should say `raw meter intervalometer` at the bottom of the screen.
- Press the shutter button to start the time-lapse.

## The pertinent settings for a night-to-day snowstorm

These are the settings in [`RAWOPINT.1`](RAWOPINT.1) that are changed from the defaults.

See what they do in the [documentation](https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#Bv__Ev_Shift)

|     Variable Name     |        Name         | Enum Value | Human Value |
| :-------------------: | :-----------------: | :--------: | :---------: |
|    ui_interval_s10    |   Interval Sec/10   |    100     |     100     |
|  ui_max_ev_change_e   |    Max Ev change    |     5      |      1      |
|  ui_bv_ev_shift_pct   |    Bv Ev shift %    |     49     |     49      |
| ui_bv_ev_shift_base_e | Bv Ev shift base Bv |     23     |     10      |
|     ui_tv_max_s1k     |   Max Tv Sec/1000   |    5028    |    5028     |
|     ui_sv_max_mkt     |       Max ISO       |    300     |     300     |
|     ui_use_raw_e      |       Use raw       |     2      |     No      |
|   ui_display_mode_t   |       Display       |     1      |     Off     |
