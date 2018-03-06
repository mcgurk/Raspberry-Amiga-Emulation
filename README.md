# Raspberry-Amiga-Emulation
Emulating Amiga with Raspberry Pi

PAL machine with 50Hz output using RetroPie and Amiberry.

(If you want standalone Amiga without RetroPie-menus, use Amibian.)

## Get RetroPie
Download RetroPie image and write it SD-card (If you use Windows, Rufus is easy. With Linux all you need is dd-command)

https://retropie.org.uk/download/

Use dedicated SD-card for Amiga-RetroPie-installation. Other RetroPie-emulators not necessarily work fine with 50Hz output.

## Prepare RetroPie
- At first boot teach only keyboard, do not teach gamepad/joystick at this point
- If you use wireless network, set Wifi-settings
- Use Raspi-config for timezone, keyboard-layout and enable ssh
- Use RetroPie setup (Manage packages -> Manage optional packages -> Amiberry -> Install from binary) to install Amiberry (27.2.2018: Amiberry v2.14)
- Optional: If you prefer "sony" style for gamepad (bottom X is basic fire/select and O is second fire/back in Playstation controller), use RetroPie setup (Configuration/tools -> emulationstation -> Swap A/B Buttons in ES) to swap A and B in Emulation station. If you don't, then "nintendo"-style is used where A is right side (Sony controller O is A) and B left side (Sony Controller X is B).
- Teach gamepad/joystick (optional: if you prefer "sony" style button order, teach A and B (and X and Y) backwards)

#### Important!
Some reason RetroPie-controller configuration is not default in Amiberry. Change path from Amiberry menu under Paths -> Controller files to `/opt/retropie/configs/all/retroarch/autoconfig/`. After that press "Rescan Paths". You can also change this setting from command line:
```
sed -i 's/\/opt\/retropie\/emulators\/amiberry\/controllers\//\/opt\/retropie\/configs\/all\/retroarch\/autoconfig\//g' /opt/retropie/emulators/amiberry/conf/adfdir.conf
```
Without this controller button mappings can be anything. You can check that setting is working by going Amiberry Custom controls -menu. Right side of Input device there is \[R\] if setting is working. If it is not working, there is \[N\].

## Video output settings
Raspberry Pi default output is most of time 60Hz. It detects it from television/monitor automatically. It is important to get 50Hz output. Other thing is that some televisions do overscan for so called CEA-modes. I have LG UJ750V and it overscans way too much, so I have to use DMT-modes. I use 1440x1050@50Hz DMT-mode. Mode affects also to black and white levels: RGB limited (16-235) for CEA, RGB full (0-255) for DMT.

Edit /boot/config.txt by ssh:ing to RetroPie (pi:raspberry) and give command sudo `nano /boot/config.txt`.

1440x1050@50Hz (DMT):
```
hdmi_group=2
hdmi_mode=87
hdmi_cvt=1440 1050 50 1 0 0 1
```
If you prefer normal television mode and it works without overscan in your television, use 1920x1080@50Hz (CEA):
```
hdmi_group=1
hdmi_mode=31
```

Videomodes and videosettings are listed here https://www.raspberrypi.org/documentation/configuration/config-txt/video.md.

## Preparing games
Copy packed files to these locations. My files are .lha -files. Full list of supported paths are in https://github.com/HoraceAndTheSpider/UAEConfigMaker/blob/master/settings/UAEConfigMaker_ScanPaths.txt
```
/home/pi/RetroPie/roms/amiga-data/Games_WHDLoad
/home/pi/RetroPie/roms/amiga-data/Games_WHDLoad_AGA
/home/pi/RetroPie/roms/amiga-data/Games_WHDLoad_CD32
/home/pi/RetroPie/roms/amiga-data/Demos_WHDLoad
```
Copying is easiest through network. RetroPie should show as `\\retropie` network share (SMB). If `\\retropie` doesn't work, use IP-address instead of retropie.

To unpack lha-files with Raspbian, you have to install p7zip-full:
```
sudo apt install p7zip-full
```
After that unpack files. E.g:
```
cd /home/pi/RetroPie/roms/amiga-data/Games_WHDLoad_AGA
7z x "*.lha"
```
It's better and safer to unpack files in Raspberry Pi, because some games includes files with characters, which are illegal in Windows.

## Prepare whdload and kickstarts
Unpack `WHDLoad_Booter.zip` to `/home/pi/RetroPie/roms/amiga-data/` from http://www.ultimateamiga.co.uk/HostedProjects/RetroPieAmiga/downloads/WHDLoad_Booter.zip

What kickstarts you need, depends what you want to emulate. I recommend at least following:
- Kickstart v3.1 rev 40.68 (1993)(Commodore)(A1200).rom	(or Kickstart v3.1 (A1200) rev 40.68 (512k).rom) (CRC 1483a091 / 1d9aa278)
- Kickstart v3.1 rev 40.60 (1993)(Commodore)(CD32).rom (or CD32 Kickstart v3.1 rev 40.60 (512k).rom) (CRC 1e62d4a5)
- CD32 Extended-ROM rev 40.60 (1993)(Commodore)(CD32).rom (or CD32 Extended rev 40.60 (512k).rom) (CRC 87746be2)
- Kickstart v1.3 rev 34.5 (1987)(Commodore)(A500-A1000-A2000-CDTV).rom (or Kickstart v1.3 (A500,A1000,A2000) rev 34.5 (256k).rom) (CRC c4f0f55f)

Copy them to `/home/pi/RetroPie/bios/Amiga/` with following names:
- kick31.rom
- cd32kick31.rom
- cd32ext.rom
- kick13.rom

Copy them also to WHDLoad "disk":
```
cp /home/pi/RetroPie/bios/Amiga/kick31.rom /home/pi/RetroPie/roms/amiga-data/_BootWHD/Devs/Kickstarts/kick40068.A1200
cp /home/pi/RetroPie/bios/Amiga/kick13.rom /home/pi/RetroPie/roms/amiga-data/_BootWHD/Devs/Kickstarts/kick34005.A500
```

## Creating UAE-files
UAE-files are amulator configuration files. One file for every game/program. They are in `/home/pi/RetroPie/roms/amiga`. We use UAEConfigMaker to generate those automatically.
```
cd ~
git clone https://github.com/HoraceAndTheSpider/UAEConfigMaker.git
mv UAEConfigMaker .uaeconfigmaker
cd /home/pi/.uaeconfigmaker
```
Then we do some tweaks. We change default 640x240 image area to 704x270 so games/demos are not chopped. `gfx_linemode=none` makes image little bit smoother. If you want fully sharp pixels, you can leave that out (default is `gfx_linemode=double`).
```
sed -i '0,/screen_height = 240/s//screen_height = 270/' /home/pi/.uaeconfigmaker/uae_config_maker.py
sed -i '0,/screen_width = 640/s//screen_width = 704/' /home/pi/.uaeconfigmaker/uae_config_maker.py
echo "gfx_linemode=none" >> /home/pi/.uaeconfigmaker/templates/hostconfig.uaetemp
```
Every game/demo can have exceptions to default settings. You can see all exceptions from here https://github.com/HoraceAndTheSpider/UAEConfigMaker/tree/master/settings. I want CD32 IK+ to be fullscreen, so I add it to screen height 216 list:
```
echo "InternationalKarate+CD32" >> /home/pi/.uaeconfigmaker/settings/Screen_Height_216.txt
```
After that you can start uae_config_maker:
```
python3 uae_config_maker.py --create-autostartup --force-config-overwrite
```
If you need use uae_config_maker many times, add --no-update -parameter to it so it doesn't try to download config-files from net everytime:
```
python3 uae_config_maker.py --no-update --create-autostartup --force-config-overwrite
```

## Links
- RetroPie https://retropie.org.uk/
- Amibian https://gunkrist79.wixsite.com/amibian
- Amiberry https://blitterstudio.com/amiberry/
- Amiberry, controllers https://github.com/midwan/amiberry/wiki/Setting-up-Input-Controllers
- Raspberry Pi video output options https://www.raspberrypi.org/documentation/configuration/config-txt/video.md
- WHDLoad_Booter.zip and Guide http://www.ultimateamiga.co.uk/HostedProjects/RetroPieAmiga/
- Rufus https://rufus.akeo.ie/
- UAEConfigMaker https://github.com/HoraceAndTheSpider/UAEConfigMaker

## Optional: 288p composite output
Raspberry Pi av-output is 3.5mm TRRS-plug. Sleeve is video, ring next to sleeve is GND. Tip is left audio and ring next to tip is right audio. Many cables have GND in sleeve: e.g. Nokia or Orange Pi cables doesn't work.

Activating 288p output from /boot/config.txt:
```
sdtv_mode=18
sdtv_aspect=1
framebuffer_width=720
framebuffer_height=576
```
Check that hdmi_force_hotplug=1 is not activated. with force_hotplug=1 composite output doesn't work.

Without framebuffer-lines `gfx_linemode=double` doesn't work. We need double scanlines so filtering are not messing with our image. Without double scanlines it can be that only bilinear filttered scanlines show up and image is not sharp.

Make copy of default template:
```
cp /home/pi/.uaeconfigmaker/templates/amiberry.uaetemp /home/pi/.uaeconfigmaker/templates/288p.uaetemp
```
Edit it with `nano /home/pi/.uaeconfigmaker/templates/288p.uaetemp`:
```
amiberry.gfx_correct_aspect=false
amiberry.horizontal_offset=0
amiberry.vertical_offset=-16

gfx_framerate=0
gfx_linemode=double
gfx_width=720
gfx_height=288
gfx_width_windowed=720
gfx_height_windowed=288
gfx_width_fullscreen=720
gfx_height_fullscreen=288
gfx_correct_aspect=false
```
You may want to change vertical offset. It depends from television.

Horizontal offset doesn't seem to work.

If your television overscans a lot, use 768 instead of 720 (in config.txt and 288p.uaetemp).

Generate .uae-files:
```
cd /home/pi/.uaeconfigmaker
python3 uae_config_maker.py --no-update --create-autostartup --force-config-overwrite --config-template 288p
```

## Misc stuff
### disable dynamic CPU frequency scaling
Maximum frequency all the time:
```
sudo sed -i 's/ondemand/performance/g' /etc/init.d/raspi-config
```
### Monitoring temperature and frequency
```
watch -n 0.5 "vcgencmd measure_temp; cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
```
### Monitoring CPU usage
```
sudo apt install htop
htop
```



## Todo
- Own menu for CD32 and AGA games and demos
