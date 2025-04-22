# PlugNPwn Reporting and Corrections


# AppleInsider

FIRST: We do not have a Chimp cable.  What we did with USB-PD is based on reverse engineering software.

SECOND: Home3us34 => h0m3us3r

THIRD: what we do in the video does not require a Chimp and can be accomplished from most USB-C devices


> Now, the team has demoed a real-world attack that takes advantage of a specialized USB-C cable used internally by Apple for debugging.

The team did not use an Apple internal debug cable, (that may get us sued).  We used custom USB-PD packets similar to those used by Apple internal cables.


> Earlier in October, the checkra1n team disclosed the [unfixable vulnerability](https://appleinsider.com/articles/20/10/05/apples-mac-t2-chip-has-an-unfixable-vulnerability-that-could-allow-root-access) that essentially allows an attacker to jailbreak the T2 security chip in a Mac. Once they do, all types of malicious attacks can be carried out on an affected [macOS](https://appleinsider.com/inside/macos) device.

To be correct twitter.com/axi0mX disclosed the vulnerability, we ported to the T2 and checkra1n used it to create a complete tool.


> the exploit causes a machine to crash once the cable is plugged in. A second video posted to the team's YouTube account showed that the attack was successfully carried out by modifying the Apple logo at boot.

More correctly the video shows shutting down the Intel processor, placing the device into DFU, and finally checkra1n running and giving a root SSH session


> researcher Ramtin Amin created an effective clone of the cable

To be precise the Bonobo is a clone of the Kanzi

