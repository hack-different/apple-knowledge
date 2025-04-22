# Abusing the Titan

# tl;dr

A specially crafted version of ABOOT is capable of being installed to a device with critical flashing unlocked, and in doing so can suppress the insecure notification, modify the booted image, and lie about the unlock or lock status of the device.  The only way to detect this for pixel devices is to enter EDL mode and run an image to validate the boot environment, which is not provided at this time.  This may not be possible either, given that the DWC3 (USB-C controller) similar to the ACE in the Apple ecosystem, if corrupt, may prevent connection to EDL.


# Method on Pixel 8
## Theory 1
- OEM Unlock
- Access Fastboot
- `fastboot oem gsc sjtag-cfg` - Provides JTAG
- Reset
- Flash to EVT before lockdown in RO region
- Provides ripcurrent bootloader
- Board 0?  
- Can read Dauntless with `fastboot oem gsc header <RO_A|RO_B|RW_A|RW_B>` 
- `fastboot oem gsc` - Access to Dauntless (Second Gen Titan-M)
- `fastboot oem gsa` - Access to Titan-M trustee applets
- 
## Theroy 2
- OEM Unlock
- fastboot flashing unlock_critical
- Reboot to Exynos EBM
- Stream sb1
- ?
- Get to Aboot or some other state
- Stage evt.bin for Titan (having side-stepped anti rollback)
- Recover titan
- Now in factory mode
- set new root of trust
- EL2
- ABOOT that lies
- Remainder of image is blue pill



# Recommended Fix
## PROM Fuse to Set Minimal Version (Epoch)

Apple has a similar concept but only roll this value when there is a known reason to do so.  This is totally foolish as many exploits are not discovered for a number of years and rolling back is a simple attack.  With only 16 bits of PROM you could easily increment every week to the current version of the Titan-M firmware.


## Do not allow a MP AP to flash EVT Titan-M firmware

This seems like a simple statement, but the determination of what makes an MP is difficult.  Similar to above, the determination of if the Titan-M is MP or EVT should not be based on the firmware but a PROM value that can only ever fuse downward from EVT → MP

## Support EDL / EUB modes on recovery / restore google sites


## Properly Document the EVT → MP and Titan-M security functionality


