# WIP: Rewriting the Titan-M Root-of-Trust
**DANGER: Incomplete analysis and conjecture based on real world observation.**

# tl;dr

Google’s Titan-M (codename `citadel`) is based on the prior generation of designs for the Chromebook EC (embedded controller - Haven) which mediates the secure boot process.  While Google referrers to regions of the flash known as `RO_A` and `RO_B` these are in fact not read-only but instead write protected.  While the code is verified, it also includes data such as the `root-of-trust` for the next stage.  The next generation chip known as codename `dauntless` doubled the size of the non-volatile area of storage, leading to the ability to confuse a `citadel` chip about the location of `RO_*` and allowing the writing into `RO_B`.  As the `citadel` consulted very early by the Qualcomm `XBL` boot-loader via a UEFI DXE to verify `aboot`, this can allow code to run before the Android boot-loader and `fastboot` giving long term persistence despite a full device wipe and restore.

# Credit: Google fixed this problem

Later builds of the `dauntless` firmware checked for a eFUSE to ensure they don’t run on a `citadel` device.  It’s not clear when this was added and how many signed copies of early firmware got out before this correction was made, or if the eFUSE was always present and set since they handled this quietly.  It’s also not clear if the `oem stage ec.rec` and `oem citadel rescue` process with physical presence could undo this fix (yet, still researching, but it seems that some of the version hashes for PVT that were part of Google’s git history are no longer available).  Many of the affected versions seemed to reference `v0.0.3` specifically.

# The Titan-M doesn’t always update…

One percent of the Titan-Ms don’t reliably update.  That’s a huge failure rate for a security device.  Most early load / boot-kits maintain persistence at all costs as most consumers and even security professionals look the other way to update failures such as these.  I too had this happen to my first Pixel 4a.  Upon inspection using `fastboot oem citadel version` it became clear that `RO_A` had the wrong magic, which later was clearly the Dauntless.  I was able to somewhat restore the `citadel` via `fastboot stage ec.rec` and `fastboot oem citadel rescue`, but in reality may have locked in the change to the root-of-trust to the chip, as the goal isn’t entirely to get code execute on the Titan-M but instead to rewrite the portions used by XBL to verify `aboot` and for Verified Boot.

This also led to a very odd boot configuration for me, where `RO_B` and `RW_A` were being selected.  The updater isn’t very tolerant to this configuration by the way.

# The Pixel Boot Process and Qualcomm
## How to do some debug nonsense…

A Pixel device will let you watch it’s boot process, if you’re willing to get out the soldering iron and build a custom UART USB-C adapter.  In fact the Citadel will give up a full debug lane to you with `fastboot oem citadel suzyq on` and the right cable.  

