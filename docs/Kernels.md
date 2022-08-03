# Apple Kernel and Formats

## macOS 11 and 12

The kernel is a single immutable file at `/System/Library/Kernels/kernel`

Kernel collections are at `/System/Library/KernelCollections` for the immutable and
`/Library/KernelCollections` for the AuxiliaryKernelCollection

The kernel then loads from the following additional collections:

* Immutable BootKernelCollection - all Kexts are loaded and considered boot critical
* Immutable SystemKernelCollection - all additional system immutable Kexts
* User approved AuxiliaryKernelCollection, which contains Kexts added by the user, it must be rebuilt
  through a reboot

## Apple Silicon and Boot Policy

Part of the reason for the required reboot is that the 1TR must generate the AuxiliaryKernelCollection then integrate
its hash into the LocalPolicy prior to the next boot cycle.  This ensures that the kernel is only modified from a
trusted environment.
