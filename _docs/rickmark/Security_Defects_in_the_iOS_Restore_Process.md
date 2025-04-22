# Security Defects in the iOS Restore Process

# Introduction

Based on iOS 13.3.1 Restore Image (Customer and Upgrade)

- https://www.dropbox.com/s/nq76d9ezha3mmm3/038-18986-007_extracted.dmg?dl=0
- https://www.dropbox.com/s/ozk9fkhl6bx2n46/038-20168-007_extracted.dmg?dl=0
# Defects


    load_address = 0x18001C000
    
    loop_gadget = 0x100000554
    
    write_ttbr0 = 0x100000444
    tlbi = self.write_ttbr0 + 0x50
    
    func_gadget = 0x100008da0
    nop_gadget = self.func_gadget + 0x18



    t8012_overwrite = '\0' * 0x500 + struct.pack('<32x2Q16x32x2QI',
                                                     t8012.nop_gadget, t8012.load_address + 0x0800,
                                                     t8012.nop_gadget, t8012.load_address + 0x0800,
                                                     0xbeefbeef)
## Unneeded USB Interfaces Exposed

The contents of the USB device capabilities at `/System/Library/AppleUSBDevice/USBDeviceConfiguration.plist` contains the following when this surface area could be greatly reduced.  (Note: this file is not code signed)


    {
            configurations = {
                    standardKeyboard = (
                            {
                                    Description = "Standard Keyboard";
                                    Interfaces = (
                                            AppleUSBMux,
                                            Keyboard,
                                    );
                                    DefaultConfiguration = YES;
                            },
                    );
                    AppleUSBTestDevice = (
                            {
                                    Description = "Apple Mobile Device";
                                    Interfaces = (
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                            {
                                    Interfaces = (
                                            "AppleUSBTestInterface",
                                    );
                                    Description = "Apple USB Test Configuration";
                            },
                    );
                    "standardCarDisplaySimAutoLock" = (
                            {
                                    Description = "Car Display Sim Auto Lock";
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                            "AppleUSBNCMControlDirect",
                                            AppleUSBNCMData,
                                    );
                                    DefaultConfiguration = YES;
                            },
                    );
                    muxNcmVal = (
                            {
                                    Description = "Apple Mobile Device + NCM";
                                    Interfaces = (
                                            AppleUSBMux,
                                            AppleUSBNCMControl,
                                            AppleUSBNCMData,
                                    );
                                    DefaultConfiguration = YES;
                            },
                            {
                                    "ExtendedConfiguration" = YES;
                                    Interfaces = (
                                            AppleUSBMux,
                                            AppleUSBNCMControl,
                                            AppleUSBNCMData,
                                            Valeria,
                                    );
                                    Description = "Apple Mobile Device + NCM + Valeria";
                            },
                    );
                    standardIMG = (
                            {
                                    Description = Nero;
                                    Interfaces = (
                                            iAP,
                                            Nero,
                                    );
                                    DefaultConfiguration = YES;
                            },
                    );
                    USBDeviceTester = (
                            {
                                    Interfaces = (
                                            USBDeviceTester,
                                    );
                                    Description = "Apple USB Device Tester";
                            },
                    );
                    standardMuxEthernet = (
                            {
                                    Interfaces = (
                                            AppleUSBMux,
                                            AppleUSBEthernet,
                                    );
                                    Description = "Apple Mobile Device + Ethernet";
                            },
                    );
                    emptyComposite = (
                            {
                                    Interfaces = ();
                                    Description = "Apple Charging Device";
                            },
                    );
                    "standardCarDisplaySimIAP" = (
                            {
                                    Description = "Car Display Sim iAP";
                                    Interfaces = (
                                            PTP,
                                            iAP,
                                            "AppleUSBNCMControlDirect",
                                            AppleUSBNCMData,
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                    );
                    stdMuxIDA = (
                            {
                                    Description = "Apple Mobile Device";
                                    Interfaces = (
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                            {
                                    Description = "Apple Mobile Device + Interdevice Audio";
                                    LockedConfiguration = YES;
                                    InterfaceAssociation = (
                                            {
                                                    FirstInterface = 1;
                                                    InterfaceCount = 4;
                                                    Description = "Interdevice Audio Interfaces";
                                            },
                                    );
                                    Interfaces = (
                                            AppleUSBMux,
                                            USBAudio2Control,
                                            USBAudio2StreamIN,
                                            USBAudio2StreamOUT,
                                            IDAMInterface,
                                    );
                            },
                    );
                    usbiotest = (
                            {
                                    Interfaces = (
                                            AppleUSBMux,
                                            "AppleUSBTestControlInterface",
                                            "AppleUSBTestBulkInterface",
                                            "AppleUSBTestInterruptInterface",
                                    );
                                    Description = usbiotest;
                            },
                    );
                    unknownHardware = (
                            {
                                    Interfaces = (
                                            AppleUSBMux,
                                            PTP,
                                    );
                                    Description = "Unknown Hardware - Apple Mobile Device";
                            },
                    );
                    stdMuxIAPVal = (
                            {
                                    Description = "Apple Mobile Device";
                                    Interfaces = (
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                            {
                                    Interfaces = (
                                            AppleUSBMux,
                                            IapOverUsbHid,
                                    );
                                    Description = "Apple Mobile Device + iAP";
                            },
                            {
                                    "ExtendedConfiguration" = YES;
                                    Interfaces = (
                                            AppleUSBMux,
                                            Valeria,
                                    );
                                    Description = "Apple Mobile Device + Valeria";
                            },
                    );
                    standardRestore = (
                            {
                                    Description = "Apple Mobile Device";
                                    Interfaces = (
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                            {
                                    Interfaces = (
                                            Reserved,
                                            AppleUSBMux,
                                    );
                                    Description = "Reserved 1 + Apple Mobile Device";
                            },
                            {
                                    Interfaces = (
                                            Reserved,
                                            AppleUSBMux,
                                    );
                                    Description = "Reserved 2 + Apple Mobile Device";
                            },
                            {
                                    Interfaces = (
                                            Reserved,
                                            AppleUSBMux,
                                    );
                                    Description = "Reserved 3 + Apple Mobile Device";
                            },
                    );
                    standardMuxPTP = (
                            {
                                    Interfaces = (
                                            PTP,
                                    );
                                    Description = PTP;
                            },
                            {
                                    Description = "iPod USB Interface";
                                    Interfaces = (
                                            USBAudioControl,
                                            USBAudioStreaming,
                                            IapOverUsbHid,
                                    );
                                    "AccessoryResistorSwap" = YES;
                            },
                            {
                                    Description = "PTP + Apple Mobile Device";
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                    );
                    "standardMuxPTPEthernetValeria" = (
                            {
                                    Interfaces = (
                                            PTP,
                                    );
                                    Description = PTP;
                            },
                            {
                                    Description = "iPod USB Interface";
                                    Interfaces = (
                                            USBAudioControl,
                                            USBAudioStreaming,
                                            IapOverUsbHid,
                                    );
                                    "AccessoryResistorSwap" = YES;
                            },
                            {
                                    Description = "PTP + Apple Mobile Device";
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                            {
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                            AppleUSBEthernet,
                                    );
                                    Description = "PTP + Apple Mobile Device + Apple USB Ethernet";
                            },
                            {
                                    "ExtendedConfiguration" = YES;
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                            Valeria,
                                    );
                                    Description = "PTP + Apple Mobile Device + Valeria";
                            },
                    );
                    muxNcm = (
                            {
                                    Interfaces = (
                                            AppleUSBMux,
                                            AppleUSBNCMControl,
                                            AppleUSBNCMData,
                                    );
                                    Description = "Apple Mobile Device + NCM";
                            },
                    );
                    "standardMuxPTPEthernet" = (
                            {
                                    Interfaces = (
                                            PTP,
                                    );
                                    Description = PTP;
                            },
                            {
                                    Description = "iPod USB Interface";
                                    Interfaces = (
                                            USBAudioControl,
                                            USBAudioStreaming,
                                            IapOverUsbHid,
                                    );
                                    "AccessoryResistorSwap" = YES;
                            },
                            {
                                    Description = "PTP + Apple Mobile Device";
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                            {
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                            AppleUSBEthernet,
                                    );
                                    Description = "PTP + Apple Mobile Device + Apple USB Ethernet";
                            },
                    );
                    stdMuxPTPEthValIDA = (
                            {
                                    Interfaces = (
                                            PTP,
                                    );
                                    Description = PTP;
                            },
                            {
                                    Description = "iPod USB Interface";
                                    Interfaces = (
                                            USBAudioControl,
                                            USBAudioStreaming,
                                            IapOverUsbHid,
                                    );
                                    "AccessoryResistorSwap" = YES;
                            },
                            {
                                    Description = "PTP + Apple Mobile Device";
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                    );
                                    DefaultConfiguration = YES;
                            },
                            {
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                            AppleUSBEthernet,
                                    );
                                    Description = "PTP + Apple Mobile Device + Apple USB Ethernet";
                            },
                            {
                                    "ExtendedConfiguration" = YES;
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                            Valeria,
                                    );
                                    Description = "PTP + Apple Mobile Device + Valeria";
                            },
                            {
                                    Description = "Apple Mobile Device + Interdevice Audio";
                                    LockedConfiguration = YES;
                                    InterfaceAssociation = (
                                            {
                                                    FirstInterface = 1;
                                                    InterfaceCount = 4;
                                                    Description = "Interdevice Audio Interfaces";
                                            },
                                    );
                                    Interfaces = (
                                            AppleUSBMux,
                                            USBAudio2Control,
                                            USBAudio2StreamIN,
                                            USBAudio2StreamOUT,
                                            IDAMInterface,
                                    );
                            },
                            {
                                    "ExtendedConfiguration" = YES;
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                            AppleUSBNCMControl,
                                            AppleUSBNCMData,
                                    );
                                    Description = "PTP + Apple Mobile Device + NCM";
                            },
                    );
                    "standardCarDisplaySim" = (
                            {
                                    Description = "Car Display Sim";
                                    Interfaces = (
                                            PTP,
                                            AppleUSBMux,
                                            "AppleUSBNCMControlDirect",
                                            AppleUSBNCMData,
                                    );
                                    DefaultConfiguration = YES;
                            },
                    );
                    standardMuxOnly = (
                            {
                                    Interfaces = (
                                            AppleUSBMux,
                                    );
                                    Description = "Apple Mobile Device";
                            },
                    );
                    muxNcmDirect = (
                            {
                                    Interfaces = (
                                            AppleUSBMux,
                                            "AppleUSBNCMControlDirect",
                                            AppleUSBNCMData,
                                    );
                                    Description = "Apple Mobile Device + NCM Direct";
                            },
                    );
            };
    }

Expected minimum value

    {
            configurations = {
                    standardMuxOnly = (
                            {
                                    Interfaces = (
                                            AppleUSBMux,
                                    );
                                    Description = "Apple Mobile Device";
                            },
                    );
            };
    };
## Unneeded Service Exposure
    An undocumented and unneeded service is launched by `/System/Library/LaunchDaemons/com.apple.PurpleReverseProxy.plist` that causes `/usr/libexec/PurpleReverseProxy` to run with the argument `-ramdisk` listening on sockets `1081`, `1082` and `1084`.  This service imports the symbols `dlopen` and `dlsym` implying that it may have broad access to dynamic symbols and dynamic loading.  If this service is not needed, it should not operate.  (It’s likely the combination of this with USBMuxD or the above USB change to a network adapter could cause access to these services).
## Poor Verification of Root Disk Image
- Image verified by SHA1 HMAC

SHA1 is considered insecure, and HMAC is not a secure method of signing an image where the key is known to all parties to verify.  Though `asr` only supports block level restore, the tailing end of the SHA and controlled input beyond the end of the partition allows for pre-image.  All files not protected by code signing need an alternate integrity system as preferences can change substantial security properties.  Perhaps a Merkle tree.  I have yet to investigate the “verifying” phase of `asr` but unless it has rendered the device un-bootable and the verify operation be ensured to happen, writing bad disks then issuing a crash can create a bad user-land.

## Lack of LockdownD Precludes Authenticated Command Channel
- No pairing records means TLS establishment is DH without identity (which MITM is possible) or in the clear
## Erase / Upgrade choice is not passed through to TSS as part of the personalization

This would indicate to the iCloud servers that the mobile data has been obliterated.  This allows for tombstoning activation and iCloud sign in records.  This could brick the device in this phase (so that data is not recoverable from a bad OS install, but requires a valid install before user data is available again) and also notify via FindMy that a device has been erased by other means.  Upgrades from version to same version or prior should also gain scrutiny.


## CarPlay has no place in the restore RAMDisk

This is compounded by the fact the accessory framework seems to allow for sharing of WiFi password / settings.  This may allow an attacker who has booted to “recovery mode” to recover WiFi settings.  One RAMDisk seems to include the extra file `/System/Library/PrivateFrameworks/CoreAccessories.framework/XPCServices/ACCCarPlayService.xpc`.  This seems to be a general failure of Apple recovery environments, which is that code from the full OS can be transposed into the environment without causing a code signing failure.  Security should not be requite that a file is not in the bundle, as code signing does not fail on “extra files”.  Add negative assertions to code signing.


## Binary Verification doesn’t Protect Roll-forward / back Attacks

Binaries do not require an embedded requirement in their signed region that indicates that it is paired with the particular kernel under which it should be launched.  All recovery mode binaries should include entitlements of `com.apple.recovery.ios` and `com.apple.kernel_id` matching the kernel build ID or a set of IDs.  This should ensure that the user-land code matches the kernel which was secured by earlier boot phases.

This will require separate OS and Recovery kernels which allows for stripping features from recovery (for instance majority of the network stack etc.)


## The Recovery Image should Either Erase or Validate NVMe outside Fsys


## Any failure of recovery should leave a device un-bootable


## There should be a visual indicator to differentiate upgrade from erase installs (and possibly iCloud wipe)

A malicious system may perform “upgrades” instead of erase on a device to maintain persistence.  It should be visually obvious that the device is being wiped vs restored.  This follows from the other fact that there should be a visual indication on T2 computers to indicate SecureBoot is disabled

