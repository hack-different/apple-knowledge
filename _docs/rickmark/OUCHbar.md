# OUCHbar

![](https://paper-attachments.dropbox.com/s_533F70A0A9EF81E1332C995CBB3C7995934CD426FF54E38EBB199F01236D608E_1584932332448_T2.png)

## What is OUCHbar?

OUCHbar is a term to describe the impact of arbitrary code execution on the Apple T2 security coprocessor. OUCHbar allows an attacker to listen to the microphone, film the camera, control the power and firmware of the CPU, inject malware into macOS, affect bluetooth and wifi, hide or alter data on disk, and change serial numbers. 

## How does it relate to checkm8?

The name OUCHbar comes from the same impact that could have occurred had the T2 been vulnerable to a RCE from another processor on the computer.  Even if Apple patches the T2 SecureROM like they have in the XS and 11, it is possible we may end up in the same situation should a networking, DMA, or remote XPC defect in bridgeOS occur in the future. Checkm8 is a legendary exploit for vulnerable versions of the SecureROM found in Apple ARM based processors such as those found in iDevices. The T2 processor is in essence more similar to an iPhone then to a conventional computer. Apple reused large portions of their iDevice security model, as it had been tested for a number of years in the iPhone. Since the T2 was released with the original iMac Pro in 2016 it hasn't had it's SecureROM updated. This makes the device similar to the iPhone 7, which is of course vulnerable to checkm8.  OUCHbar is the impact of such a security defect, today checkra1n uses the checkm8 vulnerability to gain ACE to run pongoOS on the T2.

## Why isn't this just checkm8?

Because the T2 has persistent memory, and provides the root of trust to the Intel processor via way of EFI (using a system called FDR sealing), even if the T2 is restored to health, the machine can remain compromised.  Checkm8 was cleared by the return to a valid boot-chain on iOS devices but with MacEFI, NVRAM and the Intel ME, a valid T2 can still lead to a compromised macOS.  Because the T2 is operating as the security processor and hardware root of trust, the impact of breaking the T2 is different then an iPhone application processor.  This is especially true in laptops with a non-removable battery.  Because restarting the iPhone is enough to clear a checkra1n jailbreak, it can more easily be handled.  The T2 processor is running, connected to keyboard, microphones etc even when the computer is off.  

## What is pongoOS and what does it have to do with this?

[pongoOS](https://github.com/checkra1n/pongoOS) runs after the iBoot loader and loads the XNU kernel with patches.  This allows it to modify the XNU kernel on the T2 to disable various security features and is how we shim the dropbear SSH server into the T2.  While checkra1n uses this to enable the end user to access the T2, a malicious actor could use it to tamper with the T2.  With great power comes great responsibility.  

## Why are you releasing this if it could be used by criminals?

Releasing something like a jailbreak is always tricky.  There will always be people who use it for good, like security research (making the T2 even more secure), home repair, and adding valuable features.  Unfortunately, that also means bad guys can use it to add malware to macOS, steal credit card numbers as they are typed, use the microphone to listen to you, copy your encrypted files off disk (once you boot up macOS and login), sell stolen laptops and more.  We believe it is necessary and ethical to release this because it is probable that criminals and state actors are already using this same technique.  This puts the security researchers who defend you’re personal information on more equal ground with those who are willing to break the law.

## When will there be a patch?

Apple uses SecureROM in the early stages of boot.  ROM cannot be altered after fabrication and is done so to prevent modifications.  This usually prevents an attacker from placing malware at the beginning of the boot chain, but in this case also prevents Apple from fixing the SecureROM.  The net effect is Apple cannot fix this problem without replacing the T2 chip, but as long as a machine is bootable into DFU, it can be “repaired” by a trustworthy second machine.

## Will a firmware password mitigate this?

Because the firmware password is handled by the Intel processor and EFI, no a firmware password is evaluated later in the boot than the T2.  The EFI password requires the keyboard and display to be online to operate.

## But I have secure boot on in full mode, what gives?

Like the answer about firmware passwords, secure boot is a function of the T2 verifying boot components later in the boot chain then DFU.  Since we have ACE at such an early stage, secure boot can be completely circumvented, disabled, and alternate operating systems placed on the unencrypted portion of disk.

## What about encrypted disks, are they safe?

If you have FileVault2, arbitrary code execute on the T2 does not by itself allow decrypting of documents.  Unfortunately the simplest thing for an attacker to do is to place a shim into the operating system that reports the encryption key after the machine boots and you’re password is entered.

## What about Apple Pay and TouchID?

Checkm8 does not affect the payment card Secure Element itself, but the T2 processor and the SEP (secure enclave processor) are accessed via the T2.  It is feasible that the T2 could interfere with the enrollment of Apple Pay cards, or the enrollment of TouchID by emulating these components.

## Does an attacker need physical access to the machine?

Right now yes, physical access is required to exploit the T2, because the processes involves a boot time key combination and a second device to load the initial software.  There is reason to believe that the T2 may be able to be put into DFU via the power management processor but we are not ready to assert a remote attack is possible yet.

## Will I be able to repair my own Mac?

Many of the internal Apple tools used to perform hard drive swaps, serial number changes etc use Apple signed code that is run on the T2.  Since OUCHbar an ACE circumvents Apple code execution policies and has full access to NVMe, most modifications that were perviously only available to Apple would be possible.

## Does this impact iCloud and Find My Mac?

Because Find My Mac and the activation record are handled by the T2, it is likely that iCloud lock and Find My Mac can be removed from a device.  Apple can likely withhold activation records for the T2, but this can be circumvented much like hacktivation.

## How can I tell if my T2 has been tampered with?

Currently it is difficult to do so.  Any process of booting into DFU will loose the RAM of the processor.  Ensuring that you’ve truly reached DFU may require disconnecting system power, which is somewhat difficult in Apple portables.  There is evolving work from the author of this FAQ on adapting his open source T1 firmware validator (https://github.com/rickmark/efivalidate) for the T2.

## Have you attempted to contact Apple or Law Enforcement about this prior to disclosure?

At least one member of this team has made multiple attempts to disclose to both Apple and the FBI (San Francisco office).  The author of this FAQ has over the years attempted to notify Apple via email, phone call to the GSOC and numerous attempts to notify via the Apple store.  Apple and the FBI were given an advance draft and notice before this FAQ and the SSH build were released.  Due to the fact that Apple has not responded to the checkm8 vulnerability, affecting millions of iDevices, we are not surprised by apples lack of response.

## What can I do with SSH to the T2 anyway?

Initially, look around and perform additional research.  Once executing on the T2 core, the security of the T2 can be evaluated.

## Is it safe to jailbreak the T2? Can it harm my device / wipe my data? 

At this phase, yes it is absolutely possible to overwrite encryption keys and loose your data.  Trust us, a few of the gang have already done this!  Do not use on any machine you love or care about.  While we cannot speak to if this violates Apple Care, we suspect it may.  That being said, anyone can run checkra1n on anyone’s machine so Apple will need to sort out the warranty issue themselves.

## I want to recover my T2 to it’s factory configuration.

You have two choices, but either one requires a computer that you trust.  Remember just like where you download a jailbreak utility (which should always be from the official https://checkra.in) the security of the device being restored is only as secure as the device doing the restore.  This process might wipe disk encryption keys, so be careful!  If you’re using a Mac to restore the T2, Apple’s Configurator can be used by following their guidance here.  Linux and Windows machines can use the open-source [libimobiledevice](https://github.com/libimobiledevice) tools.

## I read your warning, disregarded it and had an issue with checkra1n…

You’re free to submit an issue on the [checkra1n issue tracker](https://github.com/checkra1n/BugTracker/issues).  Sorry about your computer brah.

## What if I have additional concerns or questions?

Well, we have questions and concerns as well.  While again we do not and cannot speak for Apple, we are of course curious about Apple and their overall security ecosystem.  Twitter ([@checkra1n](https://twitter.com/checkra1n) or #OUCHbar) is the best way to reach the gang.

## I want to read more.

As always, the [XNU source code](https://github.com/apple/darwin-xnu) and [Apple’s white-papers](https://support.apple.com/en-us/HT208862) are of great use.  If you want to study the impact of jailbreaks and [pongoOS](https://github.com/checkra1n/pongoOS) on the security of digital devices I recommend the [Blue Pill](https://en.wikipedia.org/wiki/Blue_Pill_(software)) description and [presentation](https://blackhat.com/presentations/bh-usa-06/BH-US-06-Rutkowska.pdf) and a paper called “[reflections on trusting trust](https://www.cs.cmu.edu/~rdriley/487/papers/Thompson_1984_ReflectionsonTrustingTrust.pdf)”.

## Can I help or contribute?

Like the checkra1n project, we do not accept monetary goods or donations at this time.  If you want to take a stab at contributing, please look at pongoOS, and use [checkra1n](https://checkra.in) to SSH into the T2.  If you find something interesting, make sure to tweet at [@checkra1n](https://twitter.com/checkra1n) and tag #OUCHbar.



## Who’s credited with this?

The [checkra1n](https://checkra.in) utility, [libimobiledevice](https://github.com/libimobiledevice) and other security research coming out of OUCHbar is the work of a few dozen engineers across the globe, listed on the [checkra.in](https://checkra.in) homepage.

![](https://paper-attachments.dropbox.com/s_533F70A0A9EF81E1332C995CBB3C7995934CD426FF54E38EBB199F01236D608E_1584933573027_image.png)


This work is licensed by Rick Mark under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/).

