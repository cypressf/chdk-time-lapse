# How to shoot time-lapse videos of a snowstorm

1. Install CHDK (http://chdk.wikia.com/wiki/CHDK)
2. Copy the script, `rawopint.lua`, to your SD card at `PHOTOS/CHDK/SCRIPTS/`
3. Copy the settings, `RAWOPINT.1`, to your SD card at `PHOTOS/CHDK/DATA/`
4. Lock the SD card and insert it into the camera (CHDK will boot)
5. Open the CHDK menu, then press the button to "Load Script from File"
6. Select `rawopint.lua`
7. Load the saved settings `1`, changes from default described below

## The settings to change for a night-to-day snowstorm

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
