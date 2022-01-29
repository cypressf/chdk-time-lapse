# How to shoot time-lapse videos of a snowstorm

[![Snow accumulates in a time-lapse video of a balcony and street at dusk. As the sun sets, the street lights turn on and illuminate the street in a yellow glow. Cars and people whiz by.](snowy-dusk.gif)](https://www.youtube.com/watch?v=gHC3DE4PHYs)

Instructions for my camera.

- Camera: Canon PowerShot S90
- Firmware Version: GM1.01C

## Download CHDK

Download [CHDK s90-101c-1.5.1-6058-full](s90-101c-1). This is the same as the version you can find in [this table](http://mighty-hoernsche.de)), but with an added time-lapse script, [`rawopint.lua`](s90-101c-1/CHDK/SCRIPTS/rawopint.lua) and good settings for a night-to-day snowstorm time-lapse [`RAWOPINT.1`](s90-101c-1/CHDK/DATA/RAWOPINT.1).

## Install it on a memory card

Follow instructions for the "[Firmware Update Method](https://chdk.fandom.com/wiki/Prepare_your_SD_card#Firmware_Update_Method.2A)". This is much easier than creating an auto-booting CHDK memory card, and just requires a little overhead every time you turn the camera on.

## Set up the time-lapse script

1. Lock the SD card and insert it into the camera (CHDK will boot)
2. Half-press the shutter button to go into "shoot" mode
3. Press the S (shortcuts) button to open the CHDK menu
4. Press FUNC/SET to open the Script Menu
5. Press FUNC/SET to Load Script from File...
6. Select `RAWOPINT.LUA`
7. Go to `Saved Parameters Set` and click right on the wheel until `1` is selected (that's the `RAWOPINT.1` settings file)

## Lock focus and white balance

The script [uses the focus in the first photo](https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#metering-and-exposure-control) for the rest of the photos, so you must take care to focus correctly in the first photo. Press `S` (shortcuts) button to deactivate CHDK. Set the camera to `M` (manual mode). Set focus to infinity. Set white balance to cloudy day.

## Run the script

- Press the `S` (shortcuts) button to activate CHDK. It should say `raw meter intervalometer` at the bottom of the screen.
- Press the shutter button to start the time-lapse.

## The pertinent settings for a night-to-day snowstorm

These are the settings in [`RAWOPINT.1`](RAWOPINT.1) that are changed from the defaults.

See what they do in the [documentation](https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#Bv__Ev_Shift)

|           Name           | Value |     Variable Name     | Enum Value |
| :----------------------: | :---: | :-------------------: | :--------: |
|   [Interval Sec/10][1]   |  100  |    ui_interval_s10    |    100     |
|    [Max Ev change][2]    |   1   |  ui_max_ev_change_e   |     5      |
|    [Bv Ev shift %][3]    |  49   |  ui_bv_ev_shift_pct   |     49     |
| [Bv Ev shift base Bv][4] |  10   | ui_bv_ev_shift_base_e |     23     |
|   [Max Tv Sec/1000][5]   | 5028  |     ui_tv_max_s1k     |    5028    |
|       [Max ISO][6]       |  300  |     ui_sv_max_mkt     |    300     |
|       [Use raw][7]       |  No   |     ui_use_raw_e      |     2      |
|       [Display][8]       |  Off  |   ui_display_mode_t   |     1      |

[1]: https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#Interval_sec10
[2]: https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#Max_Ev_change
[3]: https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#Bv_Ev_shift_
[4]: https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#bv-ev-shift-base-ev
[5]: https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#max-tv-sec1000
[6]: https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#max-iso
[7]: https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#Use_CHDK_raw
[8]: https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#display

Read up on [exposure control](https://github.com/reyalpchdk/chdkscripts/tree/main/src/rawopint#metering-and-exposure-control) to understand why those settings are important.

## Create the video

I forget exactly the best command to combine the images into a video, but [this stack overflow question](https://stackoverflow.com/questions/24961127/how-to-create-a-video-from-images-with-ffmpeg) might help.

```bash
brew install ffmpeg
???
profit
```
