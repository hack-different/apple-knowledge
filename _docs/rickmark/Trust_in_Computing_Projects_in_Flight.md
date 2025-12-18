# Trust in Computing - Projects in Flight

# Irresponsible Disclosure?

Everything on this list is a study of an event that has happened to me personally.  Therefore in none of these cases do I believe that a TTP is being disclosed to potential bad actors that is not already in enough circulation that it could land on my device.  At this stage, the goal is to socialize in the community potential TTPs of APTs and to get them resolved quickly.

Every one of these adventures ends with the same place for me, we need more documentation about devices we trust.  The knowledge to even form hypothesis in deep malware is, by definition, deep knowledge.  It’s that way in part because its complex, but more-so because it’s undocumented.

## About the Author…

I do analysis, a lot of it.  I try to explain why my devices always fight me.  The following document is stuff observed, things with various levels of completeness, and an otherwise longstanding attempt to get a phone or computer I pay for to do what I ask.  I know in some cases what I’m doing seems like wilding at the time, but over time I feel confident that my hit rate is pretty good here.  (many of these stories have me looking at an area 6-12 months before major disclosures)

## On The Web:

https://rickmark.me
https://checkra.in
https://t8012.dev
https://github.com/rickmark
https://twitter.com/su_rickmark

## 2016-2018: T1, SMC, Internet Restore, ChunkLists, `efivalidate` and MojoKDP

I was an early person to call out the EFI in T1 and prior Apple products (the use of MojoKDP against me, weaponized kernel debugging, a graphics card that never worked in the T1 (common at the time, because EFI/Thunderbolt/SMC recovery was only possible via logic board replacement, including downgrade attacks against the Internet Recovery protocols
**See Also:**

- https://github.com/rickmark/mojo_thor
- https://github.com/rickmark/peiutil
- https://github.com/rickmark/apple_net_recovery
- https://github.com/t8012/go-aapl-integrity
- https://github.com/t8012/smcutil
- https://github.com/t8012/efivalidate
- https://duo.com/blog/the-apple-of-your-efi-mac-firmware-security-research
## 2018-2020: The T2, `checkm8` and `checkra1n`

I wrote patches against `libimobiledevice` and was the first (I knew of anyway in public) to conjecture that the T2 might be compromised via DFU.  The patches broke Apple Configurator monoculture more critical before SSV yet still a thing… and `checkm8` became a key part of this - though I would have named it https://github.com/rickmark/lightning_strike (domains bought May 1, 2019 - captures taken by Beagle 480 between then and Aug 24, original and time stamps
At Dropbox) if I had finished analysis of USB captures at that time (aprox. 3-6 months before `checkm8` public disclosure). 
**See Also:**

- https://github.com/t8012
- https://blog.t8012.dev/
- https://blog.t8012.dev/on-bridgeos-t2-research/
## 2019-2020: ChromeOS, Linux and USB

I was looking into recovery failures via TOCTOU lies with a peer on Chromebooks and successfully laid down whatever bits we wanted to disk though `dm-verity`  protects this mostly… The early patch set I created to perform better validation of USB descriptors was even a patch set for ChromeOS.  The patch was rejected by the LKML, with the rationale that adequate checks existed (https://lkml.org/lkml/2020/5/25/791), only to come up a year later when someone used automated fuzzing to re-discover what I was looking at in that patch (in fairness they also sussed it out for other OS’es, https://www.zdnet.com/article/new-fuzzing-tool-finds-26-usb-bugs-in-linux-windows-macos-and-freebsd/)
**See Also:**
https://github.com/rickmark/badusb
[+USB Security in the Linux Kernel](https://paper.dropbox.com/doc/USB-Security-in-the-Linux-Kernel-J7SkLWqFTMJoz9MMdu9Cl) 
[+Puppeteer with ChromeOS](https://paper.dropbox.com/doc/Puppeteer-with-ChromeOS-vB29rQ0Bb7pVBUa18Pa4K) 

## 2020-2021: USB-PD, `usbmuxd` and WebUSB, and Pegasus

I was also able to (via bisection, failures occurred when restoring via USB3-A to USB-C cables but not USB-C to USB-C) of restore failures of a iPad Pro assert that USB-PD / SBU lanes might be leveraged by attacker, later culminating in our work placing iPad/T2/M1s into DFU forcibly via VDMs.  I wrote a toolkit to examine iDevice backups a year before the Pegasus malware was known (mine also showed pairing relationships … coming in pairs…).  I’ve abused the WebUSB protocol for iDevices (why, because I saw Chrome on a Mac with open `IOServiceClient` entries for my iPad).  In recent years I even built tooling designed to help with the analysis of the restore process out-of-band to discover deltas from baseline normal behavior.  To this day I think the fact Settings does not show pairing relationships is a security defect, especially given iTunes WiFi sync, and this not requiring developer enablement like on Android, add a baseband being able to tunnel such WiFi / `usbmuxd` over cellular if it chooses.
**See Also:**

- https://github.com/webmuxd/webmuxd
- https://github.com/rickmark/isafety
- https://blog.t8012.dev/plug-n-pwn/
- https://blog.t8012.dev/ace-part-1/
- https://github.com/t8012/demuxusb
# Project List - Recent / In-Progress
## Over-the-Air Qualcomm Baseband Exploits

Because the iPhone and Android device share a Qualcomm OS and chip for cellular functions, it is a rich target.  I’ve personally observed this occur with eSIM and standard SIM, on the iPhone 12 as well as a Pixel 4a.  In the case of the iPhone, the device temporarily reported being connected to AT&T 4G (as opposed to the 5G T-Mobile SIM in the device) implying it is mediated by the Cisco DPH-154 microCell disclosure below.

Most importantly because the Baseband is in communication with the SIM (either UICC or eUICC) it allows for a novel form of SIM-swap attack, by pass-the-hashing the Ki material used to authenticate to the cellular network.  This would allow an attacker to impersonate the user to the cellular network, or possibly in the case of a vulnerable SIM (like happened to Gemalto SIM years ago) full extraction (read Ki) or re-configuration of the SIM may also be possible.

Early iPhone 12’s I had actually seemed to have the IMEI changed during the first few boots.  The very first I bought would only stay on the cellular network for about 30 seconds after a hard reset before it would no longer work.  (SIM was fine in other phones).  Had to flat exchange the device.

Bringing up FieldTest showed my “unusual devices” didn’t respond to majority of the AT (yes those Modem AT commands) diagnostic commands and was an easy tell.  But without an adequate defense, I stopped going to pester the local Genius Bar, or obsessively wiping the device (the non-Atomic nature of the restore process means that the device can be wiped without assurance of the baseband as Apple doesn’t control this process as much as you’d believe, same of the `Vinyl` or eUICC as this is certified by the 3GPP)

Add to that, to this day my iPhone usually connects to any speaker as two MAC addresses causing my little Bose to announce it is connected to “Quanta” (the devices name upon first purchase) and iPhone (the name because naturally I’ve performed network settings resets…), with my Tile for my house keys going on a recent trip to Seattle, then Corvallis, OR….

A Pixel 4a that brings up WiFi while in `fastboot` even though there’s no drivers for that.  

All of these systems are mediated by a single subsystem, the Qualcomm based “radio” in Android or “baseband” in iDevice.  Live captures of LTE or licensed spectrum is a fundamentally difficult undertaking.

## The SIM Swap redux; vSIM Swapping

Imagine you have full control of the Baseband (usually a Qualcomm chip) running on a cell phone.  Imagine you encode a Ki / IMSI into your payload, and connect to the network as that identity.  Then you make the eUICC / UICC (the SIM) remotely accessible to your Command-and-Control (C2) network, much like a HSM.  Congratulations, you can now SIM swap the target without ever changing the SIM card or having physical access to the device.

## The AT&T 4G Micro Cell

[+Cisco DPH-154 Disclosure](https://paper.dropbox.com/doc/Cisco-DPH-154-Disclosure-OyDbytYYDqXstbOBgD2jj) 

This device has minimal tamper protections and no secure boot chain.  It also has an authenticated connection to the core of the AT&T network, along with a software defined radio making it the perfect tool for an attacker.

## Using the Titan-M2 Firmware to EoP a Pixel

[+WIP: Rewriting the Titan-M Root-of-Trust](https://paper.dropbox.com/doc/WIP-Rewriting-the-Titan-M-Root-of-Trust-4UPP6WWEjeTxU5ZhLHHrI) 
[+WIP: From the Citadel to the Dauntless](https://paper.dropbox.com/doc/WIP-From-the-Citadel-to-the-Dauntless-tDfW5rNMwpltwBneH0VXu) 

The Pixel 4a at one point via `fastboot oem citadel version` has a mistaken header for `RO_A` that later turned out to be the header for the “Dauntless” or the next generation of the Titan-M product line.  Due to the Dautless being twice the size of the `citadel` this caused a memory layout issue that unlocked portions of the `RO_B` allowing change of the root-of-trust value loaded early by the Pixel XBL code.  Because the Titan-M is consulted so early for the root-of-trust for XBL (Qualcomm’s eXtensable Boot Loader - based on UEFI) and `aboot` it allows an attacker to maintain persistence before `fastboot`.  The fact that XBL operates at EL2 (it brings up QHEE and only `xbl_sec` and EDL, “emergency download”, executes at EL3 to bring up QSEE) makes this a juicy target for device persistence as one can run at a higher level of privilege than the Android kernel itself, and has privileged access to EL3 though it would be unlikely that it could fully replace the QSEE as it is loaded very early and requires dual signatures, but likely can replace `keymaster` or other applets.  The EL2 was being used as a makeshift IOMMU on these devices running QHEE.

Interesting indicators here included:

- A Pixel 3XL with a fully re-written Device-Tree remapping IO regions of most devices
- A Pixel 4a with the Verified Access keys “backed up” (living on the `persist` volume of the device) in a second folder when these are usually sourced from the Titan-M `RO_*` region.
- The Pixel 4a connecting to WiFi when booted into `fastboot` - as there are no drivers for this in XBL or `aboot` still hard to imagine how is not a malicious sign.
## Handling of USB-PD and the Chromebook EC

Similar to the above problem, on multiple occasions I’ve had Google branded Chromebooks have their ECs become faulty, usually in the form of the charge indicator light showing crashes and boot-looping on the port, or boot loops on multiple Eves who’s battery got too low.  As the EC is the root-of-trust here (it in fact inspired the Titan-M of which it is very closely related) it would allow an attacker to run a modified OS without the normal warnings that appear on the device.

Because many Chromebooks “fall open” when the battery is removed to allowing the EC to be flashed over a SuzyQ, the question becomes can USB-PD cause enough of a power interruption to a device to allow it to be flashed, analogous to the way the iPad / T2 / M1 can be pushed into DFU mode via USB-PD VDMs.  Add to that, most power adapters Google branded are “firmware upgradable”.

## The Intel AMT, `ish_bup` and in the wild UEFI boot-kits

[+WIP: Intel Goa’uld (Dark Symbiote)](https://paper.dropbox.com/doc/WIP-Intel-Goauld-Dark-Symbiote-W2zOTnalFBinwmosi4ghG) 
[+Design: Surface Area Reduction of the CS/ME by Using Bogus Public Keys](https://paper.dropbox.com/doc/Design-Surface-Area-Reduction-of-the-CSME-by-Using-Bogus-Public-Keys-REARVsOcwXWf7mtapnQwq) 
[+Abusing EFI Variables and the AMT](https://paper.dropbox.com/doc/Abusing-EFI-Variables-and-the-AMT-lnawIcJBvIpbZj1zPSbxf) 
[+Intel x64 Hierarchy of Privilege](https://paper.dropbox.com/doc/Intel-x64-Hierarchy-of-Privilege-6uFseu7zXJg6v1gjLs1mq) 

Over the years I’ve had more then one computer which got “upgraded” to the vPro / AMT stack.  The first of which was a Lenovo laptop, later an Intel NUC (System76 branded).  The EoP that allows movement up the chain of trust to -3 is of interest here.  Also abuse of the SMM via power management (S3 sleep, hibernate etc) reminds me of other “dark wake” attacks.  I was very pleased to find that my suspicious of `ish_bup` during analysis landed with a known CVE, meaning that like `checkm8`, while not discovering a novel bug, being able to trace back connections to existing ones is very satisfying.

This ROM dump lead me down the path of needing to 

1. Enhance `chipsec` / `UEFITool` as the boot partition layout made use of shared code pages.  Thinking an enhancement could be to link parsing bugs too regions but still show in the tree.  Handling of the MFS partition in UEFITool might be useful as well.  Finally a SHA based duplicate region detection would hasten analysis, as well as integration of region type guessing.  (`file`, `binwalk`, and `cpu_rec`).
2. Realizing that a tainted ME11 with `ish_bup` can burrow in there like a tick only to be removed by SPI flash
3. Shows the clever usage of NVMe namespaces and PAVP for crypto persistence
4. Shows that VT-d and IR-IOV of network cards make packet capture of systems fairly useless
5. The managed network adapter and use of IPSec and the AMT was interesting but not altogether surprising, the enablement of vPro via the policy module was the interesting bit.  Intel should document known signed modules of the CSME.
6. 


## The UniFi Dream Machine, UNVR and U-Boot

[+EARLY ACCESS: Ubiquity UniFi Security and Boot-chain Analysis](https://paper.dropbox.com/doc/EARLY-ACCESS-Ubiquity-UniFi-Security-and-Boot-chain-Analysis-wIxG25IDV6oGt1CtEA2tT) 
[+Amazon Alpine v2 - Breaking the Secure Boot-Chain](https://paper.dropbox.com/doc/Amazon-Alpine-v2-Breaking-the-Secure-Boot-Chain-YzfFpGsgdrQo4XwVFnRmd) 

These devices make use of multiple stages of boot-loader, the first of which is called `al_boot` which then uses FIT (a form of flattened device tree) that also allows for signing of the kernel and DTB files.  By placing a developer build of `al_boot` into the early non-volatile memory, then placing a malicious overlay (DBTO) of the device tree’s signing keys, any arbitrary OS can be installed to these devices and booted.  Initial indications of compromise here were PCIe virtual functions in use when not expected to be, as well as the UART of the boot chain showing stage2, stage3 a device tree operation, then running stage2 again from the next persistent store.

## Maintaining Persistence on the M1

Because even in the latest versions of the Apple devices they refuse to indicate when a device is being booted in anything other then normal secure mode (like if the T2 is turned off, the M1 is booting an unsigned OS or an iDevice is being erased or restored) it is very likely that once an M1 is accessed, `bputil`  can install a payload such as `m1n1` or a fork, the device can be set to “auto start” and therefore an attacker can run early code without any indication.  It’s not clear that a MacMini can’t have its power indicator light turned off or orange from a high level of privilege.  This basically ends with a single question yet again, does Apple design minimalism and the `auto-boot` NVRAM variable hurt the security of the products they have otherwise toiled to get right?

**Work in Progress (content will update)**
[+Rosetta2 Carries Forward Security Risk](https://paper.dropbox.com/doc/Rosetta2-Carries-Forward-Security-Risk-NjKAgvdLyTOGYC3Si82MT) 
[+The Apple Watch is the Persistence Dream](https://paper.dropbox.com/doc/The-Apple-Watch-is-the-Persistence-Dream-voSVpUrMl1AS0JqLe1Gpp) 
[+Apple Recovery is Non-Atomic](https://paper.dropbox.com/doc/Apple-Recovery-is-Non-Atomic-g5EPmDnSOCqcEzSAPjEpP) 

# Ancient Work - Incomplete at Best

[+Security Defects in the iOS Restore Process](https://paper.dropbox.com/doc/Security-Defects-in-the-iOS-Restore-Process-wZMPQTWQWxI3h3FDG7H73) 
[+DataMigration iOS Mitigations](https://paper.dropbox.com/doc/DataMigration-iOS-Mitigations-1I0jz5ydUeUVSuOPMmbfR) 
[+Apple USB Target Disk Mode](https://paper.dropbox.com/doc/Apple-USB-Target-Disk-Mode-OLLgRvIhn4iAViyPzGdHw) 
[+Security Critical Kernel Object Confidentiality and Integrity](https://paper.dropbox.com/doc/Security-Critical-Kernel-Object-Confidentiality-and-Integrity-akFs9yNQ8YxLKP3BEaHZ8) 
[+Using the T2 for Detection and Forensics](https://paper.dropbox.com/doc/Using-the-T2-for-Detection-and-Forensics-B7nh0IhVlYLR3IysqGHZY) 

# It’s not fun…

I’ve come home to many a break-in the last 6 months.  It took a great personal toll, robbed me of a feeling of safety in my hometown and forced explanations of my field, prior work and such to LE that didn’t fully understand how alarms and cameras could be bypassed.  I’ve replaced the Ring base station twice (sacrifices to the hardware gods, showing how a USB Mass Storage VID/PID pair in that USB port can be used for boot), and it was only by the use of a SiLabs `ACC-UZB3-U-STA` that I was able to finally understand how the Z-Wave security network was being defeated (it occurred to me that the devices that were accessing the system might also be hiding events from the UI, and this might be in conjunction, but I caught enough and saw early base stations being run via Cellular backup etc to believe there was more too it).  Answer it’s easier to live as a relay in the network so you have control of the events being passed since pairing of devices is a unidirectional trust relationship (DSK), less so if an attacker ever gets a good scan of the DSK QR code.  I’ve had both iPhones and Pixels remote OTA broken (when this happened in SF in 2017 I thought less of it then in rural Washington state) and unless anyone can come up with a good explanation as to how a Verizon SIM stops working in a Pixel 4a upon arrival home, where the SIM works in other phones and other SIMs work in the Pixel…. This led to an accidental exposure of data that my iPhone with T-Mobile was connected to the AT&T HSDPA / 4G network, which led to the unfortunate reverse engineering sacrifice to the hardware gods of a Cisco DPH-154 I had handy (with the help of an EE student friend h0m3us3r, who in the end did almost all of it).  This showed it was fairly trivial to become a AT&T BTS, and almost all current fuzzing and analysis of LTE assumes that the attacker cannot emulate the cellular network.  (The types of accepted messages from the network before and after authentication are very different, for example SIM updates).  I still suspect the problem here is T-Mobile roams to AT&T in some foreign country.  

## Everything is Broken…

[+Design: Hybrid PROM / SPI Flash](https://paper.dropbox.com/doc/Design-Hybrid-PROM-SPI-Flash-rSFEgwzoAKeEjntBVHyiQ) 
[+Design: Surface Area Reduction of the CS/ME by Using Bogus Public Keys](https://paper.dropbox.com/doc/Design-Surface-Area-Reduction-of-the-CSME-by-Using-Bogus-Public-Keys-REARVsOcwXWf7mtapnQwq) 
[+Design: Z-Wave, Zigbee, LoRa, Bluetooth, WiFi and GSM/LTE monitoring…](https://paper.dropbox.com/doc/Design-Z-Wave-Zigbee-LoRa-Bluetooth-WiFi-and-GSMLTE-monitoring-aurNdhhPNzcdG7tysUY8t) 

