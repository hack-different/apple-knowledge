# Intel x64 Hierarchy of Privilege 
Speaking here for running on bare metal, not as a Virtual Machine

A security component that spans the entire boot process would be invalid handling of any NVRAM variables.  These are stored / parsed throughout the entire boot process and at runtime.  Improper handling or for example, the non-volatile storage of a boot-services / runtime-services variable can break security models.  (An example of this seemed to be NV storage of the firmware regions taking precedence over the runtime ROM layout)


- Intel ME / AMT (Ring -4) - “Intel Implant Engine?”
    - This must execute `kernel` and `bup` from the SPI flash chip before the first x86 core is released from reset and allowed to enter real mode
    - Supposedly this may also have to bring up the GBe firmware as well as it can use the GBe adapter with the CPU powered down
    - As this is before SPI lockdown, it could arbitrary modify UEFI / TPM
    - Intel ME is handled differently on various platforms.  When Apple released `eficheck` in macOS 10.13 the Intel ME region was completely ignored for an unknown reason.
    - Intel ME / AMT region is usually handled differently for updates as it must contain its own non-volatile storage for configuration
    - It is impossible to test for the AMT / truly read anything further down as the AMT could easily hide from any later boot phases
- Intel’s “BootGuard” phases (Ring -3.75)
- IBB / OBB / UEFI `SEC` phase (Ring -3.5?)
- Intel FSP including uCode (part of `PEI` phase) (Ring -3.25)
    - Intel was able to fix parts of Meltdown/Spectre with a uCode update, it’s not known how much power exists here to re-map instructions, such as AESNI or VENTER/VEXIT.  uCode updates seem to be applicable if the uCode is newer then the currently executing one.  uCode is a dark spot and the validation process is not known.
- Remaining PEI phase
- Pre-SMM UEFI DXEs
- SMM / SMBios (Ring -3)
    - If there is no UEFI update, SPI lockdown occurs here.
    - This will often have a UEFI Capsule update handler, and will require transitioning through power levels to reset the SPI flash chip releasing lockdown, while maintaining a in-memory copy of the update capsule to execute.  Good implementations validate the UEFI capsule on both sides of the power transition.
- Intel Virtualization / VT-d / IOMMU setup (Ring -2.5)
- Option ROMs / DXEs (Ring -2.25)
    - This includes any hardware that can DMA into UEFI during early phase boot, such as Thunderbolt
- EFI Runtime Services (Ring -2)
- ACPI Tables (Ring -1.75)
    - Includes AML byte code and key system layout information.  Could be used to present “faked hardware” to the next HLOS by remapping IO ranges.
- BDS / PXE (Ring -1.5)
    - “SecureBoot” starts here - Verification of the selected UEFI runtime app
- Bootloader (GRUB, etc) (Ring -1.25)
- Hypervisor (Ring -1)
- Para-virtualized kernel (XEN / kexec) (Ring -0.5)
- Kernel (Ring 0)


## Areas of Lacking in the Intel Security Model
- Lack of early phase attestation or measurement (a user should be able to test / display the version of firmware components and test for the AMTs presence)
    - Should include names / key-hashes of all boot components and should be a highly resilient operation.
    - Intel NUCs allow for the removal of a security jumper to perform a physical presence attestation for TPM reset, and UEFI recovery, this already brings up a basic console / input driver and may well be a good location.  This can be provided in a future UEFI update as well.  (Might be difficult to do completely as the AMT does not respect this, and would require a major PCH revision to include AMT measurement / presence detection)
## Kernel EoPs can include the following:
- Invalid uCode update
- NVRAM variables or other UEFI runtime services
- Hypervisor / SMM escape handler
- Abuse of DMA / other hardware such as Thunderbolt to rewrite memory / SPI, see Vault 7 “Sonic Screwdriver” and all of the Thunderstrikes
- Intel Silicon Debug / DCI / SVT - Specifically xHCI PCH debugging
- ACPI Table / power state transition tampering (aka darkwake attack)
- UEFI Update Capsule handling
- Usage of the Intel ME / AMT runtime services

