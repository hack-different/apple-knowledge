#!/usr/bin/env python
import subprocess
import string
import os
Path = subprocess.check_output(['xcode-select', '-p'])
Path = Path + "/Platforms/iPhoneOS.platform/DeviceSupport"
Path = string.replace(Path, "\n", "")
print "Developer Images Located At:", Path
for Sub in os.listdir(Path):
    SubDire = os.path.join(Path, Sub)
    if (os.path.isdir(SubDire)):
    	print "Loading Developer Disk Image At:\n",SubDire
    	os.system("hdiutil mount "+"\""+SubDire+"\""+"/DeveloperDiskImage.dmg -mountpoint /Volumes/DeveloperDiskImage")
    	DebugSrvPath=SubDire+"/debugserver"
        print DebugSrvPath
    	print "Current DebugServer Copied To:\n"+DebugSrvPath
    	os.system("cp /Volumes/DeveloperDiskImage/usr/bin/debugserver "+"\""+SubDire+"\"")
    	os.system("codesign -s - --entitlements ./debugsrvEntitle.xml -f "+"\""+DebugSrvPath+"\"")
    	Version=os.path.basename(os.path.normpath(SubDire))#Thanks http://stackoverflow.com/questions/3925096/how-to-get-only-the-last-part-of-a-path-in-python
    	print "Version For Current DebugServer:\n"+Version
    	os.system("cp "+"\""+DebugSrvPath+"\""+" ./DebugServer"+"\""+Version+"\"")


    	print "Unloading Developer Disk Image At:\n",SubDire
    	os.system("hdiutil unmount /Volumes/DeveloperDiskImage")
        os.remove(DebugSrvPath)


