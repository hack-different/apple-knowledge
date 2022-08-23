# EFI

## T1 and Historical Intel

The EFI firmware is loaded from an SPI flash chip as is typical in an Intel computer.  It just implements additional
services and communicates with the ARM SMC (System Management Controller).

Look into the Medusa from CMIzapper for direct access to the SPI Flash.

`eficheck` is a utility provided in 10.13 to verify the firmware of the SPI flash chip, though it skips the
Intel ME region.

`efivalidate` is a re-implementation of `eficheck` by Rick Mark.

## T2

T2 systems boot EFI like their predecessors.  Unlike previous versions, they use
[eSPI](
    https://www.intel.com/content/dam/support/us/en/documents/software/chipset-software
/327432-004_espi_base_specification_rev1.0_cb.pdf)
to load the firmware and write back NVRAM to a virtual backing device provided by the T2, thereby allowing the T2 to
use img4 to verify the `MacEFI.im4` firmware and theoretically enhancing security.

## Apple Silicon

Apple Silicon chips don't run EFI but run iBoot instead (Though it does emulate parts of the EFI system via IOKit for
backwards compatibility).   Even so, you can still chainload to another bootloader if you want to; It's not prevented
when Secure Boot is set to permissive.  That permissive option doesn't technically turn off Secure Boot, but allows
you to enroll your own hashes to the Secure Boot policy on the system w/ user authentication instead.

They also do not have EL3 (only EL2, EL1, and EL0). There's no Arm GIC as the interrupt controller, but Apple
AIC instead.

Our strategy at checkra1n (so far) is to reserve EL2 for ourselves since modern Armv8.4 parts support nested
virtualization. The goal is to have a thin hypervisor layer to simulate a standard interrupt controller, IOMMUs, and
PCIe ECAM-compliant controllers. These would be impossible to provide otherwise. (then UEFI + ACPI will run on top,
preferably with CPPC for power scaling). This approach will (at a minor performance cost for VMs) reduce the amount
of work necessary.

Another nice tidbit is that iBoot loads the firmware for the GPU and all the other on-SoC blocks before passing
through control from iBoot. This removes concerns on whether that firmware is redistributable or not in practice.

However, reversing all of those blocks will take quite some work for a fully usable system.
