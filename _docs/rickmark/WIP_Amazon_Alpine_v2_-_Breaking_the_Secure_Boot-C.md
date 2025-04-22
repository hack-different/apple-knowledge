# WIP: Amazon Alpine v2 - Breaking the Secure Boot-Chain

# Note

This paper is about the generic `alpine v2` and `al_boot` problems.  For specifics about how it relates to the UDM, UDM-Pro, UXG, and UNVR ensure you also read:
[+WIP: Ubiquity UniFi Security and Boot-chain Analysis](https://paper.dropbox.com/doc/WIP-Ubiquity-UniFi-Security-and-Boot-chain-Analysis-wIxG25IDV6oGt1CtEA2tT) 

## `al_boot` as a Fork of U-Boot

The Annapurna (now Amazon) Alpine v2 System-on-a-Chip is an AArch64 device designed for headless high performance networking gear.  Majority of the newer UniFi offerings are based on this base system.  It makes use of both NAND and SPI flash in the boot process, and has a few quirks that are `al_boot` specific.  

