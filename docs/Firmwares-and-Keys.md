# Firmwares and Keys

Firmwares come as .ipsw files, which are .zip files in disguise.

Here's what the folder structure looks like (example: iPhone5,4 on iOS 9.2.1):

```
iPhone5,4_9.2.1_13D15_Restore.ipsw/
├── 058-32080-015.dmg
├── 058-32173-015.dmg
├── 058-32359-015.dmg
├── BuildManifest.plist
├── Firmware/
├──── Mav7Mav8-6.01.00.Release.bbfw
├──── Mav7Mav8-6.01.00.Release.plist
├──── all_flash/
├────── all_flash.n49ap.production/
├────── DeviceTree.n49ap.img3
├────── LLB.n49.RELEASE.img3
├────── applelogo@2x~iphone.s5l8950x.img3
├────── batterycharging0@2x~iphone.s5l8950x.img3
├────── batterycharging1@2x~iphone.s5l8950x.img3
├────── batteryfull@2x~iphone.s5l8950x.img3
├────── batterylow0@2x~iphone.s5l8950x.img3
├────── batterylow1@2x~iphone.s5l8950x.img3
├────── glyphplugin@1136~iphone-lightning.s5l8950x.img3
├────── iBoot.n49.RELEASE.img3
├────── manifest
├────── recoverymode@1136~iphone-lightning.s5l8950x.img3
├──── dfu/
├────── iBEC.n49.RELEASE.dfu
├────── iBSS.n49.RELEASE.dfu
├──── usr/
├────── local/
├────── standalone/
├── Restore.plist
└── kernelcache.release.n49
```

All of these files can be extracted using keys and xpwn.

Firmware keys are posted on
- https://theiphonewiki.com/wiki/Firmware_Keys 
- https://ipsw.me/keys
- https://ipswcentral.com//keys

For the kernelcache, run:

`xpwntool path/to/cache /path/to/output -k KEY -iv IV -decrypt`

The root filesystem is in the largest DMG file of the .ipsw. To extract it, download dmg ([OS X](http://www.ifans.com/forums/attachments/dmg-zip.68330/), [Windows](https://intdev.googlecode.com/files/dmg.exe)). Make sure dmg or dmg.exe is in your path and execute one of the following:

`./dmg input.dmg output.dmg -k KEY` (OS X)

`dmg.exe input.dmg output.dmg -k KEY` (Windows)
