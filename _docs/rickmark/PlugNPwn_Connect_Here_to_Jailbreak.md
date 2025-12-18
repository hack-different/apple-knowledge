# Plug’nPwn - Connect Here to Jailbreak

# IMPORTANT: This document is embargoed until blog release expected at Monday Oct 12 at 12PM ET
# Tasks
[ ] @Aun-Ali Z - Working on merging DFU and jailbreak step for better screenplay, draft video Saturday
[x] @h0m3 u - [+t8012 Store Product Info](https://paper.dropbox.com/doc/t8012-Store-Product-Info-T1KPo5nbO1ep8urZq4ddT) 
[ ] @Aun-Ali Z `bridgeOS.sdk` - https://github.com/t8012/bridgeos-sdk
[x] More info on Intel SVT/DCI (optional)
[x] @Rick M - checkra1n 0.11.1 linux bugfix
[ ] @Rick M - How to use checkra1n with the T2 blog post
[x] @Rick M - Decide on video hosting service (YouTube ready)
[x] @Rick M - Press invitations
[x] @Rick M - Render USB-C plug on white
# Source Information
## Outline


- Story so far, background on T2/checkm8/checkra1n
    - https://i.blackhat.com/USA-19/Thursday/us-19-Davidov-Inside-The-Apple-T2.pdf
    - https://www.blackhat.com/docs/us-16/materials/us-16-Mandt-Demystifying-The-Secure-Enclave-Processor.pdf
    - https://www.apple.com/euro/mac/shared/docs/Apple_T2_Security_Chip_Overview.pdf
- Introduction to Apple’s debug cables
    - tweets and rumors about cables
        - https://bgr.com/2019/03/08/iphone-hack-what-dev-fused-iphones-are-and-why-theyre-important/
    - Apple leaks iBoot code, schematics routinely
    - apple’s own reporting at conferences on demotion of production devices
        - https://www.blackhat.com/docs/us-16/materials/us-16-Krstic.pdf
        - Therefore there must be some way to communicate with a demoted device
        - Demoted iPhones can be ARM SWD via Bonobo (clone of Kanzi) - https://shop.lambdaconcept.com/home/37-bonobo-debug-cable.html
        - Intel processors are debugged via Intel DCI - https://conference.hitb.org/hitbsecconf2017ams/materials/D2T4%20-%20Maxim%20Goryachy%20and%20Mark%20Ermalov%20-%20Intel%20DCI%20Secrets.pdf
    - the “serial number reader” in Apple stores
        - https://www.macrumors.com/2020/05/31/internal-usb-c-diagnostic-tool/
- Analysis of how the MacBook USB / TBT components are arranged
- Using USB-PD to place the device into DFU
    - USB-PD has Vendor Defined Messages
- VIDEO
- Creation of Debug clone cable and preorder
## Claims
- The ACE terminates the USB-PD protocol and handles negotiation / policy / plug orientation
- High speed lanes connect to the Thunderbolt controller, which is a MUX for Thunderbolt, USB3, and DP
- Each ACE uses I2C to communicate with the PMU to handle charging
- The DFU ACE also has the capability to connect the HS lanes of the USB-C port to:
    - The T2 USB providing DFU
    - PCH for Intel debugging
    - SWD debug
- Using USB-PD to enter DFU causes the following:
    - ACE receives Vendor Defined Message (VDM)
    - ACE holds GPIO (SOC_FORCE_DFU) to cause the T2 to enter DFU on reset
    - ACE pulls GPIO (UPC_PMU_RESET) 
    - T2 is reset by PMU
    - T2 pools `FORCE_DFU` line on boot and enters DFU since it is asserted by ACE
- Exiting DFU is the same sequence without asserting FORCE_DFU
# Blog Article
![Too cheeky?](https://pbs.twimg.com/media/Ej831EgUYAAK0Pt?format=jpg&name=medium)

# State of the World: `checkm8`, `checkra1n` and the T2

For those just joining us, news broke this week about the jailbreaking of [Apple’s T2 security processor in recent Macs](https://www.apple.com/euro/mac/shared/docs/Apple_T2_Security_Chip_Overview.pdf).  If you haven't read it yet, [you can catch up on the story here](https://blog.t8012.dev/on-bridgeos-t2-research/), and try this out yourself at home [using the latest build of checkra1n](https://checkra.in).  So far we’ve stated that you must put the computer into DFU before you can run checkra1n to jailbreak the T2 and that remains true, but today we are introducing a demo of placing the Mac into DFU from a command via a USB-C connection to another `TODO: Mac or a special built USB device`, and a complete demo of a device logging the keys of a victim Mac.

For what it is worth, Apple has remained silent on checkm8 for both the affected iPhones as well as for Macs and the T2.

# A Monkey by any Other Name

In order to build their products unlike app developers Apple has to debug the core operating system.  This is how firmware, the kernel and the debugger itself are built and debugged.  From the earliest days of the iPod, Apple has built specialized debug probes for building their products.  [These devices are leaked](https://bgr.com/2019/03/08/iphone-hack-what-dev-fused-iphones-are-and-why-theyre-important/) from Apple headquarters and their factories and have traditionally had monkey related names such as the “[Kong](https://www.theiphonewiki.com/wiki/Kong_Cable)”, “[Kanzi](https://www.theiphonewiki.com/wiki/Kanzi_Cable)” and “[Chimp](https://www.theiphonewiki.com/wiki/Chimp_Cable)”.  They work by allowing access to special debug pins of the CPU, (which for [ARM devices is called Serial Wire Debug](https://developer.arm.com/architectures/cpu-architecture/debug-visibility-and-trace/coresight-architecture/serial-wire-debug) or SWD), as well as other chips via JTAG and UART.  [JTAG is a powerful protocol](https://blog.senr.io/blog/jtag-explained) allowing direct access to the components of a device and access generally provides the ability to circumvent most security measures.  Apple has even spoken about their debug capabilities [in a BlackHat talk](https://www.blackhat.com/docs/us-16/materials/us-16-Krstic.pdf) describing the security measures in effect .  Apple has [even deployed versions of these](https://www.macrumors.com/2020/05/31/internal-usb-c-diagnostic-tool/) to their retail locations allowing for repair of their iPads and Macs.


![The Bonobo, a Kanzi Clone](https://shop.lambdaconcept.com/111-large_default/bonobo-debug-cable.jpg)

## The Bonobo in the Myst [[EXPAND]]

Another hardware hacker and security researcher [Ramtin Amin did work this year](http://ramtin-amin.fr/#tristar) to create an effective [clone of the Kanzi cable](https://shop.lambdaconcept.com/home/37-bonobo-debug-cable.html).  This combined with the checkm8 vulnerability from [axi0mX](https://twitter.com/axi0mX) allows iPhones 5s - X to be debugged.






# The USB port on the Mac

One of the interesting questions is how does the Macs [share a USB port](https://support.apple.com/guide/apple-configurator-2/revive-or-restore-mac-firmware-apdebea5be51/mac) with both the Intel CPU (macOS) and the T2 (bridgeOS) for DFU.  These are essentially separate computers inside of the case sharing the same pins.  Schematics of the MacBook leaked from Apple’s vendors (a quick search with a part number and “schematic”), and analysis of the USB-C firmware update payload show that there is a component on each port which is tasked with both multiplexing (allowing the port to be shared) as well as terminating [USB power delivery (USB-PD)](https://en.wikipedia.org/wiki/USB_hardware#PD) for the charging of the MacBook or connected devices.  Further analysis shows that this port is shared between the following:


- The Thunderbolt controller which allows the port to be used by macOS as Thunderbolt, USB3 or DisplayPort
- The T2 USB host for DFU recovery
- Various UART serial lines
- The debug pins of the T2
- The debug pins of the Intel PCH for debugging EFI and the kernel of macOS

Like the above documentation related to the iPhone, the debug lanes of a Mac are only available if enabled via the T2.  Prior to the checkm8 bug this required a specially signed payload from Apple, meaning that Apple has a [skeleton key to debug any device](https://www.vox.com/2016/2/17/11031902/apple-encryption-fbi-san-bernardino-backdoor) including production machines.  Thanks to `checkm8`, any T2 can be demoted, and the debug functionality can be enabled.  Unfortunately Intel has placed large amounts of [information about the Thunderbolt](https://thunderbolttechnology.net/developer-application) controllers and **protocol under NDA**, meaning that it has not been properly researched leading to a [string](https://www.kaspersky.com/blog/thunderstrike-mac-osx-bootkit/7164/) of [vulnerabilities](https://www.trendmicro.com/vinfo/tr/security/news/vulnerabilities-and-exploits/thunderstrike-2-rootkit-can-now-infect-macs-remotely) over the years.

# The USB-C Plug and USB-PD
![USB-C Pins (credit Wikipedia)](https://paper-attachments.dropbox.com/s_D4ED6C6808E376DCA7B8544BF11C136CAD08E3FFE429B7E5F8588D0815DA1877_1602486501912_USB_Type-C_Receptacle_Pinout.png)


Given that the USB-C port on the Mac does many things, it is necessary to indicate to the multiplexer what device inside the Mac you’d like to connect too.  The USB-C port specification provides pins for this exact purpose (`CC1`/`CC2`) as well as detecting the orientation of the cable allowing for it to be reversible.  On top of the `CC` pins runs another low speed protocol called `USB-PD` or USB power delivery.  It is primarily used to negotiate power requirements between chargers (sources) and devices (sinks).  USB-PD also allows for arbitrary packets of information in what are called “Vendor Defined Messages” or VDMs.

## Apple’s USB-PD Extensions

The VDM allows Apple to trigger actions and specify the target of a USB-C connection.  We have discovered USB-PD payloads that **cause the T2 to be rebooted and for the T2 to be held into a DFU state**.  Putting these two actions together, we can cause the T2 to restart ready to be jailbroken by checkra1n without any user interaction.  While we haven’t tested a Apple Serial Number Reader, we suspect it works in a similar fashion, allowing the devices ECID and Serial Number to be read from the T2’s DFU reliably.  The Mac also speaks USB-PD to other devices, such as when an iPad Pro is connected in DFU mode.  

**Apple needs to document the entire set of VDM messages** used in their products so that consumers can understand the security risks.  The set of commands we issue are unauthenticated, and even if they were they were undocumented and thus un-reviewed. **Apple could have prevented this scenario** by requiring that some physical attestation occurs during these VDMs such as holding down the power button at the same time.

# Putting it Together

Taking all this information into account, we can string it together to reflect a real world attack.  By creating a specialized device **about the size of a power charger**, we can place a T2 into DFU mode, run checkra1n, upload a key logger and capture all keys.  This is possible even though macOS is un-altered (the logo at boot is for effect but need not be done).  This is because in Mac portables **the keyboard is directly connected to the T2** and passed through to macOS.

![](https://paper-attachments.dropbox.com/s_D4ED6C6808E376DCA7B8544BF11C136CAD08E3FFE429B7E5F8588D0815DA1877_1602494292253_IMG_20201012_051419.jpg)

# VIDEO DEMO


- PLAN A: Use `sipeed maix dock + usbc breakout` for USB-PD to enter DFU, run checkra1n, boot with logo change and place key-logger and stream keys off
- PLAN B: Use `sipeed maix dock + usbc breakout` for USB-PD to enter DFU, run checkra1n
- PLAN Z: Use PD screamer to enter DFU, computer to checkra1n


# USB-C Debug Probe
https://shop.t8012.dev/products/usb-pd-screamer


