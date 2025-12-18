# Industry: bridgeOS / checkra1n Questions
Enter any questions on the following lines and we will attempt to answer:


- How easy does this make it to bypass FileVault protections? Does it allow brute-forcing the password or other attacks?
- What does this mean for SEP-protected ECC keys? Does this allow extracting or cloning the secrets to another device?
- Does this allow forging the attestation provided for WebAuthN credentials or App Attest?
- How feasible is it to compromise the T2 directly from macOS instead of via a physical connection?
- Is this something Apple can firmware patch? Does it affect all T2 chips, or just older versions?
- Does this make it possible to run an implant or keylogger on the T2 to collect FDE credentials? Was that possible before?
- Is there a way this attack could be persistent?
- From @mjc59
    - What can an attacker do with a compromised T2
    - What can an attacker do with a compromised SEP
    - Is there any way for a user to reliably reset their T2 into a known good state
    - Is there any way to detect that this has happened


## Corrections from ironPeak
- The T2 is not the SEP, the T2 contains the SEP
- The boot sequence fully brings up the T2 / bridgeOS before the Intel is released from reset and allowed to boot EFI at all
- No T2 has SATA, it uses NVMe and PCIe to talk to NAND storage
- The T2 / bridgeOS is fully booted and stays on even when the computer is off, so the boot sequence holds here for the power button
- This is not the “next boot disk” since each processor has it’s own system volume, also replace “APFS encryption” with FileVault2 as that is a more accurate term
- Read: http://michaellynn.github.io/2018/07/27/booting-secure/
- The T2/bridgeOS is charged with approving kexts during load
- pongoOS is a shim not a replacement
- Filesystem seals: correctly called SSV (Signed System Volumes) is a iOS 14/Big Sur feature
- Break SSV and SIP apart
- Debug cable requires demotion, which is possible with checkm8
- I suggest leaving out the commands until checkra1n publishes the instructions since you have gaps in it
- `smcutil` is for older T1 and prior
- Cannot decrypt FV2, but likely can brute force it (waiting on PoC to confirm that though)


## Answer Session
    - Have you had an official reponse from Apple
        - Nothing
    - Can checkm8 be done remotely
        - It is a known unknown, no way is known as of today
    - What can an attacker do with a compromised T2
        - Steal computer (iCloud lock)
        - Steal Data (break SEP)
        - Persistent
            - nvram.plist
                - Disable SIP / other protections
        - Non-persistent
            - SecureBoot
            - Keyboard Logging
            - Camera / microphone
                - When lid is closed, electrical cutoff disables these
            - Bluetooth
        - DRAM persistence
            - `iBoot BAD MAGIC` on the T2
    - What can an attacker do with a compromised SEP
        - SEP does not have persistent storage so it cannot track attempts
    - Is there any way for a user to reliably reset their T2 into a known good state
        - Configurator Restore - also unplug the thing’s battery?
        - May not restore macOS
    - Is there any way to detect that this has happened
        - Yes, but not available as a tool. Just compare FS to known good IPSW. Time consuming…
    - Can I repair my own Mac
        - Not enough known
            - FDR trust object
    - Can you run Doom on it?
        - Probably


## From Answering in Slack
- lol okay got it, so my big question is just what are the crucial things that are wrong in the ironpeak post.  or put another way, what are things I might have wrong in my story draft right now that you all want to set straight
    - Technical inaccuracies
        - The difference between T2/bridgeOS and the SEP/SEPOS

From Siguza: There are three attacker scenarios we have in mind:
1. If an attacker steals your device, they can brute-force your FileVault encryption keys (this requires checkm8 + blackbird).
2. If an attacker gains temporary access to your device for a few minutes, they can compromise the entire T2 and Intel side, and run keyloggers or other exfiltration implants (this requires only checkm8). Rebooting the T2 will likely get rid of this, but it's important to understand that rebooting your Mac normally does NOT reboot the T2. To reboot the T2, see Apple's guide: [https://support.apple.com/en-us/HT201295](https://support.apple.com/en-us/HT201295)
3. If an attacker gains one-time access to your device for a few minutes, they can disable System Integrity Protection and Secure Boot, which then allows them to replace system components on the Intel side (this requires only checkm8). Then, even after rebooting the T2, the Intel side will keep running malicious software until a full restore is performed.


There are three attacker scenarios we have in mind:
1. If an attacker steals your device, it provides a platform to potentially bruteforce FileVault encryption keys (this would require checkm8 + blackbird).
2. If an attacker gains temporary access to your device for a few minutes, they can compromise the entire T2 and Intel side, and run keyloggers or other exfiltration implants (this requires only checkm8). Rebooting the T2 will likely get rid of this, but it's important to understand that rebooting your Mac normally does NOT reboot the T2. To reboot the T2, see Apple's guide: [https://support.apple.com/en-us/HT201295](https://support.apple.com/en-us/HT201295)
3. If an attacker gains one-time access to your device for a few minutes, they can disable System Integrity Protection and Secure Boot, which then allows them to replace system components on the Intel side (this requires only checkm8). Then, even after rebooting the T2, the Intel side will keep running malicious software until a full restore is performed. (edited) 

