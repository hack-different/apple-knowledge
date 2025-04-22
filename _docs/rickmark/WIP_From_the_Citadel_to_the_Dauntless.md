# WIP: From the Citadel to the Dauntless
To be merged with:
[+WIP: Rewriting the Titan-M Root-of-Trust](https://paper.dropbox.com/doc/WIP-Rewriting-the-Titan-M-Root-of-Trust-4UPP6WWEjeTxU5ZhLHHrI) 

# The Origins and the “Haven”

The modern Titan-M in the Pixel 3 and later has it’s roots in the Chromebook EC (embedded controller).  The EC was the “B” series chip named the Haven.  This was evolved into the Titan-M which is known as the “Citadel”.  Google of course does publish some source code in this area but the design and technical documentation is generally internal.  The Titan-M2? (name unknown) will be codenamed the Dauntless (I think they are going to an A, B, C, D series of naming to make generational identification easier ala Ubuntu).


# The Pixel and the Citadel

The Pixel uses Qualcomm chips for both the AP (application processor) and BP or `radio` (Baseband Processor).  Others have written on the boot-up process of the Qualcomm chips.  For the Pixel AP, the PBL verifies and executes first, then `xbl_sec` which is the EL3 TrustZone loader for the next stage against both the Qualcomm signing keys as well as OEM_PKEY_HASH (the OEM signing key, in this case Google).  This loads what is known as the QSEE or Qualcomm Secure Execution Environment.  The `xbl_sec` then drops to non-secure EL2 and runs the verified `xbl` (extendable boot loader).  XBL is a UEFI environment, and therefore follows the same process of PEI (platform initialization), DXE (driver execution environment) and then APP or payload execution.  It lacks a SEC phase as that assurance is provided by PBL and `xbl_sec`.  XBL then loads the hypervisor `hyp` or Qualcomm QHEE, which is in essence a abused EL2 / hypervisor for IOMMU or memory isolation.   The Pixel XBL includes a DXE for interfacing with the Titan-M over SPI, allowing XBL to use the Titan early in the boot process for verification of other boot components.  Unfortunately in this case they have not verified the Titan-M's security state prior and this allows any compromise of the Titan-M to become an EoP to early boot loader malware.  Bear in mind that all of this is happening before a single pixel is written to the display (no fastboot yet).  The DXE is used to verify aboot` or the Android Bootloader and provides services to it for the security state and dm-verity status.  The Titan-M also includes the root-of-trust for the Android operating system as Google attempted to eject early from dependence on the Qualcomm secure boot chain and bring it back under their own control.  





# The Citadel / Dauntless Bug

Google made some sensible choices in the layout of the non-volatle memory layout of the Titan-M.  The copied the Chromebook EC design of cutting the memory in half, designating the top half as A and the bottom half as B.  This allows for A/B updating which has the benefit of upgrade as well as failsafe against a bad flash.  They then (unfortunately a misnomer) set the initial portions of A and B to “read-only” and by “read-only” we really mean “write protect” - the difference here is critically important and I urge companies to stop conflating the two.   The Citadel and Dauntless are largely comparable and an evolution.


## Now the bug…

The Dauntless has a non-volatle memory that is twice the size of the Citadel.   If you flash the Citadel A region with the Dauntless firmware, it will accidentally place the RO_B region into the dauntless RW_A region.  This breaks the security model of write protection and A/B for the Titan-M.  It seems this error only occurred with early builds of the Dauntless firmware, as there is now a one way fuse that disables booting Dauntless code on a Citadel.  It also indicates the failure of ever reusing signing keys between generations of devices that were not co-designed.  

