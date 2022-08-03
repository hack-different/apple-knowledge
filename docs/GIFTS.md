# Apple's Best Hits

This page details accidental releases by Apple that make it impossible for Apple to claim trade secret.

## iOS 14 Beta for iPhone XR SRD (Security Research Device) Kernel

This release of iOS for the XR also includes the research version of the kernel

* <https://updates.cdn-apple.com/2020SummerSeed/fullrestores/001-32635/423F68EA-D37F-11EA-BB8E-D1AE39EBB63D/iPhone11,8,iPhone12,1_14.0_18A5342e_Restore.ipsw>

## iOS DSC `.symbols` File

With some releases of `com.apple.dyld` caches, the dyld shared cache has sideband symbols.  The companion
`.symbols` file contains not only the symbols needed for binding, but also internal symbols for libraries.  This may
not technically be a "gift" in that its just more symbols then are needed for iOS to operate, but none-the-less are
very useful.

## iBoot Source Leak

While not technically a 'gift' in that it was an employee leak, the iBoot sources from around iOS 9 were disclosed,
and widely available including being able to be downloaded from GitHub.com.  Apple succeeded in having it removed
under the DMCA, but it came into such common usage before that many were able to review a copy.
