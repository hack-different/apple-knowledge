#Firmwares&Keys
>Firmwares comes as .ipsw packed format.Which, in fact, is only ZIPPED Archive
>When Unlocked.The Folder Structure Looks Like This(Extracted From iPhone5,4 iOS 9.2.1 (13D15) ):
#Structure
>>058-32080-015.dmg

>>058-32173-015.dmg

>>058-32359-015.dmg

>>BuildManifest.plist

>>Firmware

>>>>Mav7Mav8-6.01.00.Release.bbfw

>>>>Mav7Mav8-6.01.00.Release.plist

>>>>all_flash

>>>>>>all_flash.n49ap.production

>>>>>>>>DeviceTree.n49ap.img3

>>>>>>>>LLB.n49.RELEASE.img3

>>>>>>>>applelogo@2x~iphone.s5l8950x.img3

>>>>>>>>batterycharging0@2x~iphone.s5l8950x.img3

>>>>>>>>batterycharging1@2x~iphone.s5l8950x.img3

>>>>>>>>batteryfull@2x~iphone.s5l8950x.img3

>>>>>>>>batterylow0@2x~iphone.s5l8950x.img3

>>>>>>>>batterylow1@2x~iphone.s5l8950x.img3

>>>>>>>>glyphplugin@1136~iphone-lightning.s5l8950x.img3

>>>>>>>>iBoot.n49.RELEASE.img3

>>>>>>>>manifest

>>>>>>>>recoverymode@1136~iphone-lightning.s5l8950x.img3

>>>>dfu

>>>>>>iBEC.n49.RELEASE.dfu

>>>>>>iBSS.n49.RELEASE.dfu

>>>>usr

>>>>>>local

>>>>>>>> standalone

>>Restore.plist

>>kernelcache.release.n49

#All of these files could be Extracted using corresponding keys and xpwn
#Some keys are available at https://ipsw.me/keys/
For The KernelCache. First run:

*xpwntool PATH/TO/CACHE /PATH/TO/OUTPUT -k YOURKEYHERE -iv YOURIVHERE -decrypt*

Then:
*wget http://nah6.com/~itsme/cvs-xdadevtools/iphone/tools/lzssdec.cpp*
Use clang to compile and install it.
lzssdec -o 448 < /PATH/TOPREVIOUS.OUTPUT > /PATH/TO/FINAL/OUTPUT
