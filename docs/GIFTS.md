# Apple's Best Hits

## iOS 14 Beta for iPhone XR SRD (Security Research Device) Kernel

This release of iOS for the XR also includes the research version of the kernel

* <https://updates.cdn-apple.com/2020SummerSeed/fullrestores/001-32635/423F68EA-D37F-11EA-BB8E-D1AE39EBB63D/iPhone11,8,iPhone12,1_14.0_18A5342e_Restore.ipsw>

## iOS 15 `.symbols` File

With the release of `com.apple.dyld` caches in iOS 15, the dyld shared cache is no longer a single file.  The companion
`.symbols` file contains not only the symbols needed for binding, but also internal symbols for libraries.