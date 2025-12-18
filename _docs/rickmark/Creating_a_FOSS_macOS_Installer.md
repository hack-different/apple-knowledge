# Creating a FOSS macOS Installer

# Big Sur Method
- Download `InstallAssistant.pkg`
- (OPTIONAL) `InstallAssistant.pkg` should have a digital signature - verify it
- Use XAR to extract `SharedSupport.dmg` - (built minimal support in `pyxar`)
- Mount `SharedSupport.dmg`
- DMG will contain:
    - Brain
    - ARM System Firmware Restore Asset (`com_apple_MobileAsset_SFRSoftwareUpdate`)
    - Universal Recovery Asset (`com_apple_MobileAsset_MacSoftwareUpdate`)
- Verify the `_AssetReceipt` signature
- Extract `com_apple_MobileAsset_MacSoftwareUpdate`
- Create a new GUID partition format and HFS+ volume
- Copy the `Recovery/BaseSystem.dmg` and chunklist to `BaseSystem/BaseSystem.dmg`
    - Mount `BaseSystem` and extract `Install macOS Big Sur.app`
- Copy `SharedSupport.dmg` into HFS volume (matching chunklist) under the Install App
- Extract boot files `com_apple_MobileAsset_SFRSoftwareUpdate` bundle under `boot/` and should be extracted to the root
    - All folders go into the root
    - All root files go into `System/Library/CoreServices`
    - `boot.efi` goes into `System/Library/CoreServices`
    - `AssetData/boot/Firmware/Manifests/InstallerBoot/*` should contain im4m files
- Full File List:
    - `/System/Library/KernelCollections/BootKernelExtensions.kc` (T2)
    - `/System/Library/CoreServices/PlatformSupport.plist`
    - `/System/Library/CoreServices/boot.efi`
    - `/System/Library/CoreServices/SystemVersion.plist`
    - `/System/Library/CoreServices/BridgeVersion.bin`
    - `/usr/standalone/i386/SecureBoot.bundle` (T2)
        - Copy `BuildManifest.plist` into bundle
    - `/System/Library/PrelinkedKernels/immutablekernel` (pre-T2)
    - `/usr/standalone/bootcaches.plist` (pre-T2)
- (OPTIONAL) Download additional assets
    - Additional assets include SecureBoot config, bridgeOS updates, etc
- (OPTIONAL) Sign all im4’s for Full Security mode
    - Need at least ECID
    - Can this be done on a different machine?  Does it require some kind of nonce beyond APNonce?


    I LOVE IT. Did you make one?
    

And can you make it preconfigured to have Boot Camp Set up and Boot in to Windows instead of Mac if you hold down Option?

