
# Firmware Encryption

Wasn't fully working until iOS 2.0. The 8900 format was used first, then img3 and now im4p. Common workarounds are low level exploits which allow to turn devices into key oracles.

# Code Signing

Introduced in iOS 2.0. Enforced by AppleMobileFileIntegrity, or AMFI.

Common workarounds are unprotecting codesigned pages to rw- to avoid code sign enforcement, and neutering MISValidateSignature in amfid (these tricks are often combined in order to get dyld to load a fake dylib which interposes MISValidateSignature without triggering any code sign fault, which kills effectively codesigning system-wide, allowing arbitrary ad-hoc binaries to be loaded at will). 

For patching, amfi_get_out_of_my_way is a good technique.

# LLB Validation

On the S5L8900 no sigchecking was performed by the bootrom before jumping into the LLB- note that with a solid chain of trust this wouldn't be an issue since sigchecks are performed when flashing the image, but this allowed for easy persistance once a single injection vector was acquired. This changed with the introduction of the iPod Touch 2G, whose bootrom validated also the LLB image. 

Common workarounds are bootrom exploits or similar low level exploits, or an userland persistency vector (look for Code Signing workarounds).

# dyld data-only dylib hardening
# ASLR
# Free List Hardening
# Poisoning
# Stack Guard
# KASLR
# Info Leak Mitigation Strategy
# Proper kernel memory protection flags
# Address Space Isolation
# CS_RESTRICT
# LwVM Write Locking
# mmap hook TeamID validation
# validateFirstFewPages
# KPP
# Modern AMFI
# LaunchDaemons plists moved to xpcd_cache.dylib
1. First attempt (iOS x.y) just moved plists to code-signed xpcd_cache.dylib
2. Second attempt (iOS x.y) added a dummy function to xpcd_cache.dylib that launchd runs to make sure AMFI kicks in and checks integrety.

Commond workarounds usually involve replacing daemons directly. A good target for this is softwareupdated, since stashing breaks OTA (and OTA is an unwanted feature, too).

__TODO__
