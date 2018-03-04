# Raspberry-Amiga-Emulation
Emulating Amiga with Raspberry Pi

## Get RetroPie
Download RetroPie image and write it SD-card (if you use Windows, Rufus is easy. with Linux all you need is dd-command)

https://retropie.org.uk/download/

## Prepare RetroPie
- In first boot teach only keyboard, do not teach gamepad/joystick at this point
- If you use wireless network, set Wifi-settings
- Use raspi-config for timezone, keyboard-layout and enable ssh
- Use RetroPie settings to install Amiberry from binary
- If you prefer "sony" style for gamepad (bottom X is basic fire/select and O is second fire/back in Playstation controller), use RetroPie settings to swap A and B in Emulation station. If you don't, then "nintendo"-style is used where A is right side (Sony controller O is A) and B left side (Sony Controller X is B).
- Teach gamepad/joystick (if you prefer "sony" style button order, teach A and B (and X and Y) backwards)

- sed -i 's/es_swap_a_b = "0"/es_swap_a_b = "1"/g' /opt/retropie/configs/all/autoconf.cfg

/boot/config.txt:
https://www.raspberrypi.org/documentation/configuration/config-txt/video.md
1440x1050, DMT (kirkkaat värit ja vähemmän säätöjä kuin CEA:ssa. Ei overscannia!):
hdmi_group=2
hdmi_mode=87
hdmi_cvt=1440 1050 50 1 0 0 1
(CEA 1920x1080 50Hz:)
(hdmi_group=1)
(hdmi_mode=31)

Pelitiedostot (kopsaa lha:t näihin):
/home/pi/RetroPie/roms/amiga-data/Games_WHDLoad
/home/pi/RetroPie/roms/amiga-data/Games_WHDLoad_AGA
/home/pi/RetroPie/roms/amiga-data/Games_WHDLoad_CD32
/home/pi/RetroPie/roms/amiga-data/Demos_WHDLoad
sudo apt install p7zip-full
7z x "*.lha"

/home/pi/RetroPie/roms/amiga-data/:
http://www.ultimateamiga.co.uk/HostedProjects/RetroPieAmiga/downloads/WHDLoad_Booter.zip

/home/pi/RetroPie/bios/Amiga/:
kick31.rom	Kickstart v3.1 rev 40.68 (1993)(Commodore)(A1200).rom	1483a091 / 1d9aa278
cd32kick31.rom	Kickstart v3.1 rev 40.60 (1993)(Commodore)(CD32).rom	1e62d4a5
cd32ext.rom	CD32 Extended-ROM rev 40.60 (1993)(Commodore)(CD32).rom	87746be2
kick13.rom	Kickstart v1.3 rev 34.5 (1987)(Commodore)(A500-A1000-A2000-CDTV).rom	c4f0f55f

cp /home/pi/RetroPie/bios/Amiga/kick31.rom /home/pi/RetroPie/roms/amiga-data/_BootWHD/Devs/Kickstarts/kick40068.A1200
cp /home/pi/RetroPie/bios/Amiga/kick13.rom /home/pi/RetroPie/roms/amiga-data/_BootWHD/Devs/Kickstarts/kick34005.A500
(cp /home/pi/RetroPie/bios/Amiga/kick12.rom /home/pi/RetroPie/roms/amiga-data/_BootWHD/Devs/Kickstarts/kick33180.A500)

UAE-tiedostot (/home/pi/RetroPie/roms/amiga):
cd ~
git clone https://github.com/HoraceAndTheSpider/UAEConfigMaker.git (27.2.2018)
mv UAEConfigMaker .uaeconfigmaker
cd /home/pi/.uaeconfigmaker
sed -i '0,/screen_height = 240/s//screen_height = 270/' /home/pi/.uaeconfigmaker/uae_config_maker.py
sed -i '0,/screen_width = 640/s//screen_width = 704/' /home/pi/.uaeconfigmaker/uae_config_maker.py
echo "gfx_linemode=none" >> /home/pi/.uaeconfigmaker/templates/hostconfig.uaetemp
echo "InternationalKarate+CD32" >> /home/pi/.uaeconfigmaker/settings/Screen_Height_216.txt
python3 uae_config_maker.py --no-update --create-autostartup --force-config-overwrite



## Links
- RetroPie https://retropie.org.uk/
- Amibian https://gunkrist79.wixsite.com/amibian
- Amiberry https://blitterstudio.com/amiberry/
- Raspberry Pi video output options https://www.raspberrypi.org/documentation/configuration/config-txt/video.md
- Guide http://www.ultimateamiga.co.uk/HostedProjects/RetroPieAmiga/
- Rufus https://rufus.akeo.ie/
