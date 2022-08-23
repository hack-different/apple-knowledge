---
title: Plug'nPwn - Connect to Jailbreak
subtitle: Building on checkm8 and checkra1n, we demo real-world attack scenarios.
authors:
  - Rick Mark
  - mrarm
  - Aun-Ali Zaidi
  - h0m3us3r
published: Oct 12, 2020
---
# Plug'nPwn - Connect to Jailbreak

## State of the World: checkm8, checkra1n and the T2

For those just joining us, news broke last week about the jailbreaking of Apple’s T2 security processor in
recent Macs. If you haven't read it yet, you can catch up on the story here, and try this out yourself at home
using the latest build of checkra1n. So far we’ve stated that you must put the computer into DFU before you can
run checkra1n to jailbreak the T2 and that remains true, however today we are introducing a demo of replacing a
target Mac's EFI and releasing details on the T2 debug interface.

## A Monkey by any Other Name

In order to build their products unlike app developers Apple has to debug the core operating system. This is how
firmware, the kernel and the debugger itself are built and debugged. From the earliest days of the iPod, Apple has
built specialized debug probes for building their products. These devices are leaked from Apple headquarters and their
factories and have traditionally had monkey related names such as the “Kong”, “Kanzi” and “Chimp”. They work by allowing
access to special debug pins of the CPU, (which for ARM devices is called Serial Wire Debug or SWD), as well as other
chips via JTAG and UART. JTAG is a powerful protocol allowing direct access to the components of a device and access
generally provides the ability to circumvent most security measures. Apple has even spoken about their debug capabilities
in a BlackHat talk describing the security measures in effect. Apple has even deployed versions of these to their retail
locations allowing for repair of their iPads and Macs.

## The Bonobo in the Myst

Another hardware hacker and security researcher Ramtin Amin did work last year to create an effective clone of the
Kanzi cable. This combined with the checkm8 vulnerability from axi0mX allows iPhones 5s - X to be debugged.

## The USB port on the Mac

One of the interesting questions is how does the Macs share a USB port with both the Intel CPU (macOS) and the
T2 (bridgeOS) for DFU.  These are essentially separate computers inside of the case sharing the same pins.  Schematics
of the MacBook leaked from Apple’s vendors (a quick search with a part number and “schematic”), and analysis of the
USB-C firmware update payload show that there is a component on each port which is tasked with both multiplexing
(allowing the port to be shared) as well as terminating USB power delivery (USB-PD) for the charging of the MacBook or
connected devices.  Further analysis shows that this port is shared between the following:

* The Thunderbolt controller which allows the port to be used by macOS as Thunderbolt, USB3 or DisplayPort
* The T2 USB host for DFU recovery
* Various UART serial lines
* The debug pins of the T2
* The debug pins of the Intel CPU for debugging EFI and the kernel of macOS

Like the above documentation related to the iPhone, the debug lanes of a Mac are only available if enabled via the
T2.  Prior to the checkm8 bug this required a specially signed payload from Apple, meaning that Apple has a skeleton
key to debug any device including production machines.  Thanks to checkm8, any T2 can be demoted, and the debug
functionality can be enabled.  Unfortunately Intel has placed large amounts of information about the Thunderbolt
controllers and protocol under NDA, meaning that it has not been properly researched leading to a string of
vulnerabilities over the years.

## The USB-C Plug and USB-PD

Given that the USB-C port on the Mac does many things, it is necessary to indicate to the multiplexer what device
inside the Mac you’d like to connect too.  The USB-C port specification provides pins for this exact purpose (CC1/CC2)
as well as detecting the orientation of the cable allowing for it to be reversible.  On top of the CC pins runs another
low speed protocol called USB-PD or USB power delivery.  It is primarily used to negotiate power requirements between
chargers(sources) and devices (sinks).  USB-PD also allows for arbitrary packets of information in what are called
“Vendor Defined Messages” or VDMs.

## Apple’s USB-PD Extensions

The VDM allows Apple to trigger actions and specify the target of a USB-C connection.  We have discovered USB-PD payloads
that cause the T2 to be rebooted and for the T2 to be held into a DFU state.  Putting these two actions together, we can
cause the T2 to restart ready to be jailbroken by checkra1n without any user interaction.  While we haven’t tested a Apple
Serial Number Reader, we suspect it works in a similar fashion, allowing the devices ECID and Serial Number to be read from
the T2’s DFU reliably.  The Mac also speaks USB-PD to other devices, such as when an iPad Pro is connected in DFU mode.

Apple needs to document the entire set of VDM messages used in their products so that consumers can understand the security
risks.  The set of commands we issue are unauthenticated, and even if they were they were undocumented and thus
un-reviewed.  Apple could have prevented this scenario by requiring that some physical attestation occurs during these VDMs
such as holding down the power button at the same time.

## Putting it Together

Taking all this information into account, we can string it together to reflect a real world attack.  By creating a specialized
device about the size of a power charger, we can place a T2 into DFU mode, run checkra1n, replace the EFI and upload a key
logger to capture all keys.  This is possible even though macOS is un-altered (the logo at boot is for effect but need
not be done).  This is because in Mac portables the keyboard is directly connected to the T2 and passed through to macOS.

## VIDEO DEMO

### PlugN'Pwn Automatic Jailbreak

PlugNPwn is the entry into DFU directly from connecting a cable to the DFU port

[![PlugNPwn](https://img.youtube.com/vi/LRoTr0HQP1U/0.jpg)](https://youtu.be/LRoTr0HQP1U)

### Replacing the T2 MacEFI with SecureBoot Enabled

In the next video we use checkra1n to modify the MacEFI payload for the Intel processor

[![PlugNPwn](https://img.youtube.com/vi/uDSPlpEP-T0/0.jpg)](https://youtu.be/uDSPlpEP-T0)

## USB-C Debug Probe

In order to facilitate further research on the topic of USB-PD security, and to allow users at home to perform
similar experiments we are pleased to announce pre-ordereing of our USB-PD screamer.  It allows a computer to directly
"speak" USB-PD to a target device.  Get more info here: