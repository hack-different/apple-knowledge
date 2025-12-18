# DataMigration iOS Mitigations

# Introduction

While iOS continues to advance security controls on code with signing and entitlements, key aspects of the OS are lacking in security hardening.  This paper proposes two features that could be included in iOS to increase the security of subsystems that handle untrusted data and uses the DataMigration framework as an example place for implementation.

This is compounded by the fact that DataMigration can be force triggered even when no OS upgrade has occurred

# DataMigration and Dynamic Plugins

The data restore and upgrade of iOS is known as DataMigration.framework and its associated XPC workers.  During a restore or upgrade, various plugins are allowed to process data to convert it to the current OS data formats (such as upgrading SMS databases etc).  I’ve identified two issues with this system:


1. There is a generic very entitled plugin host process.  It holds entitlements that is a strict superset of the entitlements needed by all of the supported plugins.  This means many plugins are running in a process with higher entitlements than needed for their work.  This could be resolved by introducing a method whereby a process starts with the entitlements embedded in the process, but code can opt to drop specific entitlements or all but a set of entitlements.  Similar functionality has existed in linux for the capability model for some time.
2. Entitlements are generally a function of the process binary.  Since the plugin host loads dynamic code, it would be beneficial if the shared object could embed an entitlement such as `com.apple.datamigration.plugin` that could would then allow the plugin host to choose to dlopen (without running dyld at that phase), ensure it has the proper entitlement, declare that it must be signed via the trust cache, then permit the remainder of dlopen to proceed.

To further strengthen sandbox profiles, a code check that the XPC connection is occurring from an entitled process as a belt and suspenders approach to XPC communication can further improve this system.

# The Over Entitled Process

Because the entitlements are processed at the process level, processes are over entitled.  This means that any migration plugin that has an error allowing for ACE (which, given they are processing untrusted user input is a likely source of such things) it may be able to pivot to a part of the system that is unrelated.  Let’s use a concrete example:


- The migration system begins migrating contacts
- A plugin host process is started and the contact plugin is loaded
- A malformed contact is able to gain code execute in the plugin process
- Because the plugin has entitlements to mange keychain and profiles these can be used to pivot to a higher level of privilege even though profiles are unrelated to contacts
# Trust Cache and Abusing Apple Libraries

Because there is no mechanism being used to to ensure that the code loaded in the migration plugin host was intended for that host, and the plugin host is a simple Objective-C proxy, this may mean that a process that is able to connect to the migration system can load either a Apple signed library that is unrelated to migration, or possibly depending on profile / other factors enterprise signed code into a privileged helper.

Since `dlopen` is an atomic operation, and doesn’t have a method to declare more information about how that loaded object is to be used, this leads to a potential EoP.  Ideally a module could be “loaded” in a pending state where the pages are mapped `R` and not `X`.  The hosting process could then check that the module meets requirements such as being Apple platform code (CDHash is part of the loaded Trust Cache), and that it is a data migration plugin.  Once those are satisfied, the dlopen could be “finalized” where the pages are given their pending `X`, and the normal dyld process and module init occur.

There is already a system for “preflight” and this model could be extended to include the use case outlined in the previous paragraph.  Preflight lacks the ability to perform the interrogation detailed above and more importantly doesn’t have a model that accounts for ToCToU, therefore the mapping of R → RX is key to the success of this system.


# Compounding Factors
## Inadequate Protection for MobileDevice Framework and Kext

Because these must be updated out of band of the operating system, they are able to be modified on the Data partition of a macOS system.  This allows for downgrading of the MobileDevice system without requiring it to be a entitled process.  SIP should only allow write access to `/Library/Apple` by installer and only by Apple signed installers that contain a right to that area of disk.
A computer was observed with `mds` downgrading MobileDevice after using Xcode’s upgrade pkgs (only the latest supports ARM macs).  The computer would briefly show configurator working, then the device would revert to an unknown device class when the older version of the framework and kext were loaded.

## Loading a Trust Cache for a Different Architecture Type

TrustCaches are img4 signed objects.  Is it possible to extend an arm64e system by loading the TrustCache for arm64 into the kernel to allow pointer signing bypass?  The processes that can extend the TrustCache are:
[MobileStorageMounter](http://newosxbook.com/ent.jl?osVer=iOS13&exec=MobileStorageMounter)
[softwareupdated](http://newosxbook.com/ent.jl?osVer=iOS13&exec=softwareupdated)
Do both of these processes ensure that they do not allow an iPhone 11 does not load the trust cache for the iPhone X (therefore allowing PAC-less binaries to be loaded).  This may result in the following part of the backtrace on an iPhone 11 (which does not contain a slice for arm64 in this binary):

    Powerstats for:   SpringBoard
    UUID:             E0BBCB0B-1570-367A-9F55-910F7DE374E0
    Beta Identifier:  CE46DF2B-7C46-45C7-9A97-FF949B633991
    App Version:      1.0
    Build Version:    50
    Path:             /System/Library/CoreServices/SpringBoard.app/SpringBoard
    Architecture:     arm64
## `execve` Reload Keeping Open Descriptors 

It may be possible that a process with entitlements opens resources (and has the connecting process entitlements checked at that time) which remain open after `execve` replaces the process.  This may allow executing a new binary inside of the data migration plugin where connections have been opened and entitlements have been checked but using those connections by the replacing image.  A solution would be for a process to mark the connection as “does not survive execve” from the other end before performing the entitlements checks.  This may be the source of this part of the backtrace:

     Binary Images:
               0x1000f8000 -                ???  ???                      <39964180-42A5-3A59-8AD1-6B72E7F9B51A>
               0x100940000 -                ???  ???                      <B95DE91A-D8DA-3B8A-A387-86A7B978A756>
## SoftLinking.framework and HID

