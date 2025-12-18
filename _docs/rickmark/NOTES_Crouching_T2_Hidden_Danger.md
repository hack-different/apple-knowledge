# NOTES: Crouching T2, Hidden Danger

- **completely exposing your macOS (and iPad Pro) - the debug cable may be compatible with the iPad Pro, but since checkm8 is not this isn’t the case**
- The T2 is not the SEP, the T2 contains the SEP
- The boot sequence fully brings up the T2 / bridgeOS before the Intel is released from reset and allowed to boot EFI at all
- No T2 has SATA, it uses NVMe and PCIe to talk to NAND storage
- The T2 / bridgeOS is fully booted and stays on even when the computer is off, so the boot sequence holds here for the power button
- This is not the “next boot disk” since each processor has it’s own system volume, also replace “APFS encryption” with FileVault2 as that is a more accurate term
- Read: http://michaellynn.github.io/2018/07/27/booting-secure/
- The T2/bridgeOS is charged with approving kexts during load
- Filesystem seals: correctly called SSV (Signed System Volumes) is a iOS 14/Big Sur feature
- Break SSV and SIP apart
- Debug cable requires demotion, which is possible with checkm8
- I suggest leaving out the commands until checkra1n publishes the instructions since you have gaps in it
- `smcutil` is for older T1 and prior
- Cannot decrypt FV2, but likely can brute force it (waiting on PoC to confirm that though)
- 

