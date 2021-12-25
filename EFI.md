# EFI

## T1 and Historical Intel

The EFI firmware is loaded from a SPI flash chip as is typical in an Intel computer.  It just implements additonal services and communicates with the ARM SMC (System Management Controller).

Look into the Medussa from CMIzapper for direct access to the SPI Flash

`eficheck` is a utility provided in 10.13 to verify the firmware of the SPI flash chip, though it skips the Intel ME region.

`efivalidate` is a re-implementation of `eficheck` by Rick Mark

## T2

T2 systems boot EFI like their predicessors.  Unlike previous versions they use [eSPI](https://www.intel.com/content/dam/support/us/en/documents/software/chipset-software/327432-004_espi_base_specification_rev1.0_cb.pdf) to load the firmware and write back NVRAM to a virutal backing device prvided by the T2, thereby allowing the T2 to use img4 to verify the `MacEFI.im4` firmware and theoredically enhancing security.

## Apple Silicon

Apple Silicon don't run EFI but iBoot instead.  (Though it does emulate parts of the EFI system via IOKit for back compatibility)
However, you can chainload to another bootloader if you want to, it's not prevented when Secure Boot is set to permissive.
That permissive option doesn't technically turn off Secure Boot. It allows you to enroll your own hashes to the Secure Boot policy on the system w/ user authentication instead.

They also do not have EL3 (only EL2, EL1 and EL0). There's no Arm GIC as the interrupt controller, but Apple AIC instead.

Our strategy at checkra1n so far is, because they're modern Armv8.4 parts supporting nested virtualization, reserve EL2 to ourselves. The goal is having a thin hypervisor layer to simulate a standard interrupt controller, IOMMUs and PCIe ECAM-compliant controllers, which would be impossible to provide otherwise. (then UEFI + ACPI will run on top, preferably with CPPC for power scaling). This approach will allow, at a minor performance cost for VMs, to reduce the amount of work necessary.

Another nice tidbit is that iBoot loads the firmware for the GPU and all the other on-SoC blocks before passing through control from iBoot. This removes the concerns on whether that firmware is redistributable or not in practice.

However, reversing all of those blocks will take quite some work for a fully usable system.
