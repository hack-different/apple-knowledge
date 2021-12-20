EFI?
====


Apple Silicon don't run EFI but iBoot instead.
However, you can chainload to another bootloader if you want to, it's not prevented when Secure Boot is set to permissive.
That permissive option doesn't technically turn off Secure Boot. It allows you to enroll your own hashes to the Secure Boot policy on the system w/ user authentication instead.

They also do not have EL3 (only EL2, EL1 and EL0). There's no Arm GIC as the interrupt controller, but Apple AIC instead.

Our strategy at checkra1n so far is, because they're modern Armv8.4 parts supporting nested virtualization, reserve EL2 to ourselves. The goal is having a thin hypervisor layer to simulate a standard interrupt controller, IOMMUs and PCIe ECAM-compliant controllers, which would be impossible to provide otherwise. (then UEFI + ACPI will run on top, preferably with CPPC for power scaling). This approach will allow, at a minor performance cost for VMs, to reduce the amount of work necessary.

Another nice tidbit is that iBoot loads the firmware for the GPU and all the other on-SoC blocks before passing through control from iBoot. This removes the concerns on whether that firmware is redistributable or not in practice.

However, reversing all of those blocks will take quite some work for a fully usable system.