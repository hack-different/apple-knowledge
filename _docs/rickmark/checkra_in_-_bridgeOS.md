# checkra.in - bridgeOS

    On macOS
            - Install DevTools
            - Install Homebrew
            - brew install libplist automake autoconf pkg-config openssl libtool llvm libusb
            - Clone and install the following (./autogen.sh, make, make install)
                - https://github.com/sbingner/ldid
                - https://github.com/libimobiledevice/libusbmuxd
                - https://github.com/libimobiledevice/libimobiledevice
                - https://github.com/libimobiledevice/usbmuxd
    How to SSH
            - Run checkra1n and wait for T2 to boot. It will stall when complete.
            - Unplug and replug the usb connection. Checkra1n should now send the overlay.
            - Bring up a proxy to dropbear with iproxy 2222 44 &
            - SSH ssh -p 2222 root@127.0.0.1 - Profit
    Fun Utilities and Locations on the T2
            - MacEFIUtil
            - /private/var/MobileSoftwareUpdate/nvram.plist
    Things of interest for the T2
            - CoreBoot - https://www.coreboot.org
            - OpenCore - https://github.com/acidanthera/OpenCorePkg
            - EFI Protocols - https://github.com/acidanthera/EfiPkg
            - Cursed NVMe - https://github.com/acidanthera/NVMeFix


## What can I do with SSH to the T2 anyway?

Initially, look around and perform additional research.  Once executing on the T2 core, the security of the T2 can be evaluated.  In this environment you are both `root` and have full kernel execute (because the kernel is rewritten before execute).

## What is pongoOS and what does it have to do with this?

[pongoOS](https://github.com/checkra1n/pongoOS) runs after the iBoot loader and loads the XNU kernel with patches.  This allows it to modify the XNU kernel on the T2 to disable various security features and is how we shim the dropbear SSH server into the T2.  While checkra1n uses this to enable the end user to access the T2, a malicious actor could use it to tamper with the T2.  With great power comes great responsibility.  

## When will there be a patch?

Apple uses SecureROM in the early stages of boot.  ROM cannot be altered after fabrication and is done so to prevent modifications.  This usually prevents an attacker from placing malware at the beginning of the boot chain, but in this case also prevents Apple from fixing the SecureROM.  The net effect is Apple cannot fix this problem without replacing the T2 chip, but as long as a machine is bootable into DFU, it can be “repaired” by a trustworthy second machine.

## I want to recover my T2 to it’s factory configuration.

You have two choices, but either one requires a computer that you trust.  Remember just like where you download a jailbreak utility (which should always be from the official https://checkra.in) the security of the device being restored is only as secure as the device doing the restore.  This process might wipe disk encryption keys, so be careful!  If you’re using a Mac to restore the T2, Apple’s Configurator can be used by following their guidance here.  Linux and Windows machines can use the open-source [libimobiledevice](https://github.com/libimobiledevice) tools.

## Is it safe to jailbreak the T2? Can it harm my device / wipe my data? 

At this phase, yes it is absolutely possible to overwrite encryption keys (read AppleEffacableStorage) and loose your data.  Trust us, a few of the gang have already done this!  Do not use on any machine you love or care about.  While we cannot speak to if this violates Apple Care, we suspect it may.  That being said, anyone can run checkra1n on anyone’s machine so Apple will need to sort out the warranty issue themselves.

## How can I tell if my T2 has been tampered with?

Currently it is difficult to do so.  Any process of booting into DFU will loose the RAM of the processor.  Ensuring that you’ve truly reached DFU may require disconnecting system power, which is somewhat difficult in Apple portables. 

## Will I be able to repair my own Mac?

Many of the internal Apple tools used to perform hard drive swaps, serial number changes etc use Apple signed code that is run on the T2.  Since this is an ACE circumvents Apple code execution policies and has full access to NVMe, most modifications that were perviously only available to Apple would be possible.

## What about encrypted disks, are they safe?

If you have FileVault2, arbitrary code execute on the T2 does not by itself allow decrypting of documents.  Unfortunately the simplest thing for an attacker to do is to place a shim into the operating system that reports the encryption key after the machine boots and you’re password is entered.

## Will a firmware password mitigate this?

Because the firmware password is handled by the Intel processor and EFI, no a firmware password is evaluated later in the boot than the T2.  The EFI password requires the keyboard and display to be online to operate.

## But I have secure boot on in full mode, what gives?

Like the answer about firmware passwords, secure boot is a function of the T2 verifying boot components later in the boot chain then DFU.  Since we have ACE at such an early stage, secure boot can be completely circumvented, disabled, and alternate operating systems placed on the unencrypted portion of disk.

