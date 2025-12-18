# Code With Me: iDetect
Stream URL: https://www.twitch.tv/su_rickmark

# The Why

In July 2020, I wrote a FOSS project called `isafety` - it was able to detect malware or stalker-ware on iDevices, but was not very accessible.  It required knowledge of Python, `libimobiledevice` etc to run and couldn’t be useful to the population at large.  Later Pegasus was discovered and the MVT was built, making the same error.  I want to take the work from around the edges and polish it into a FOSS tool that anyone can run, and can be leveraged by NGOs specializing in domestic abuse and stalking.

## Current Threat - Locked in Update
![](https://paper-attachments.dropbox.com/s_E2E32BF14C0E61D3218FF7D381DC5C5E62DF407759936A536399D5DB458BB4C5_1635128805125_image.png)

# The What

This is a capstone project of a few years of work.  It will exist as a macOS UI application that will guide users through the process and help interpret the results.  In order to accomplish this pulling from a vast set of dependencies is required…

- `macvdmtool` which used the USB-PD work from my team t8012.dev
    - https://github.com/AsahiLinux/macvdmtool
    - Because the question came up, the best IOKit documentation is classic “Programming Guides” from Apple:
        - https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.693.3915&rep=rep1&type=pdf
        - http://mirror.informatimago.com/next/developer.apple.com/documentation/DeviceDrivers/Conceptual/WritingDeviceDriver/WritingDeviceDriver.pdf
    - WIP on branch: https://github.com/rickmark/macvdmtool/tree/rickmark/libmacvdm
    - Will leave library as C++ code for now, technically it doesn’t need to be as IOKit consumers can use C instead of C++ which would make the library more portable
    - Could make this a more generic `libusbpd` or such - but that’s out of scope
- `libimobiledevice` which is the workhorse of the jailbreak / iDevice community outside of Apple
    - Refactor `idevicerestore` to be a dynamically loaded library - https://github.com/libimobiledevice/idevicerestore/issues/450
    - Partially Complete as https://github.com/libimobiledevice/libimobiledevice-glue/issues/4
    - Move all DFU code to `libirecovery` while maintaining full support for non Apple DFU implementations per the USB-IF spec - https://www.usb.org/sites/default/files/DFU_1.1.pdf
    - Move all non-recovery/restore common code up from `idevicerestore` to the `libimobiledevice-glue` library as this allows for easier maintenance of things like SHA, HTTP, ZIP, and the like - while also making the `libirestore` code simpler to understand and maintain
        - Move the following into LIMD-Glue 1.1 - SHA, Debug, Locking, JSON, Endianness and FixedInt (COMPLETE). - As these are new symbols exported and no existing code paths were modified this is a non-breaking API surface addition and does not require a major SemVer bump
- `isafety` which is more a prototype to show how detection could work on iDevices but didn’t reach its full potential
    - https://github.com/rickmark/isafety
- `libibackup` which was a library written by me to try to promote into `libimobiledevice` to gather data from iDevices by backup
    - https://github.com/rickmark/libibackup
- `awdd_decode` which is work to interpret the baseband and other core system metrics from iDevices
    - https://github.com/rickmark/awdd_decode
- `idetect` which is a AppKit user interface to drive the entire process and show the results
    - https://github.com/rickmark/idetect
## Stretch Goal
- A hardware project to create a “reliable reset and DFU cable”
# The How
1. Create a library from `macvdmtool` to be able to push USB-C devices to DFU mode reliably
2. Refactor `idevicerestore` to become a library providing the low level tools to boot to various stages of recovery without wiping a device
3. Integrate `awdd_decode` and find key IoCs in baseband logs
4. Refactor `isafety` and enhance with `getenv` support for `boot-command` and other OTA metrics
5. Create an XPC process in iDetect to load the embedded python environment and run `i`safety
6. Bit bang the SDQ protocol from a Cortex-M processor to be able to talk to the Hydra and trip reset / DFU



# Session 2 - XPC and the UI App… or whatever I “squirrel” to


- Progress was made and the Python framework successfully embeds in the UI app, allowing us to run the `isafety` codebase.  This will be sandboxed to only receive the files it is to use (the code itself pulled from github and verified by GPG key on the git repo, as well as the selected backup to scan)
- 

