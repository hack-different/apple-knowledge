# Jailbreaking the T2 with checkra1n

## What is Jailbreaking a Mac Anyway?

This is a question we get a lot.  What does it mean to “jailbreak” a Mac, since you can already run any code you want (if you bypass code-signing, SIP, SecureBoot and Gate Keeper anyway).  When we say “jailbreak a Mac” what we mean is jailbreaking the AppleSilicon T2 processor.  This core runs a iOS derivative called `bridgeOS`.  Until now Apple has not allowed or supported any non-Apple code executing on this core.  Since this core comes up and aids in the operation of the Intel processor, it allows for a bunch of possibilities not possible before, such as completely replacing the Mac’s EFI.

An overview of the process is:

- Get a copy of `checkra1n` and `libimobiledevice`
- Place the Mac into DFU mode using the Apple support guide
- Connect to the technician workstation (yes you need a second computer)
- Run checkra1n
- Connect to SSH


## `checkra1n` 0.11 and T2 Support

With the release of 0.11 checkra1n began to support the T2 and bridgeOS as a target.  You will need to have downloaded (and in the cases of a Mac, run at least once to bypass Gate Keeper) this tool before proceeding.  If you haven't done so go on over to https://checkra.in to get a copy.

In order to access SSH you’ll also need the tools from https://libimobiledevice.org.  If you’re on a Mac you can install this from home-brew with `brew install libimobiledevice` and you can install on Linux by installing the package for your distribution. 


## Placing the T2 Into DFU Mode

Fortunately for us, Apple has provided instructions on how to place a T2 based Mac into DFU.  This is in their support guide “[Revive or restore Mac firmware in Apple Configurator 2](https://support.apple.com/guide/apple-configurator-2/revive-or-restore-mac-firmware-apdebea5be51/mac)”.  Per their instructions a USB-C to USB-C or USB-C to USB-A cable is required.  Thunderbolt is not supported.  Once you find the model of your Mac, connect the DFU port to the computer where you have installed `checkra1n`.  Follow the model specific guidance in that support article to place the computer into DFU mode.  Once that’s done, you can verify by running `lsusb` on Linux and `ioreg -p IOUSB` from a Mac.  You should see an `Apple Mobile Device (DFU)` mode attached if you successfully entered DFU.

A DFU device in `lsusb`

![](https://paper-attachments.dropbox.com/s_FA6AAA07030DF3145418B8DEBD132850C234EAA3DCDD633D14D24C758773CF23_1602572131766_t2_dfu_linux.png)


**A DFU device in** `**ioreg -p IOUSB**`

![](https://paper-attachments.dropbox.com/s_FA6AAA07030DF3145418B8DEBD132850C234EAA3DCDD633D14D24C758773CF23_1602572421525_t2_dfu_mac.png)

## Running `checkra1n`

Currently checkra1n can only be run in CLI mode (running any GUI mode will inform you the device is not supported).  If you have issues you can increase the debug output with `--verbose-boot` and `--verbose-logging`

**From a Mac**
`sudo ./checkra1n.app/Contents/MacOS/checkra1n` `--``cli`

**From Linux**
`sudo ./checkra1n` `--``cli`

![Running checkra1n against a T2](https://paper-attachments.dropbox.com/s_FA6AAA07030DF3145418B8DEBD132850C234EAA3DCDD633D14D24C758773CF23_1602572505677_t2_checkra1n_public.png)

## Connecting to SSH

Once the device has run checkra1n, it’s ready to accept a connection to dropbear for SSH.  You connect to SSH with a T2 by proxying the connection over `usbmuxd`.  The SSH server runs on the T2 on port `44` due to specialized handing of `22` in the kernel.  Also you will have to keep connected to the T2 because once the USB connection is broken, it will return the port to the Intel.  As always, the password like an iPhone is `alpine`


    $ iproxy 44 2202
    $ ssh root@localhost -P 2202
![A successful SSH session to the T2](https://paper-attachments.dropbox.com/s_FA6AAA07030DF3145418B8DEBD132850C234EAA3DCDD633D14D24C758773CF23_1602572565080_ssh_checkra1n.png)


