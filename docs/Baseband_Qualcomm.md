# Qualcomm Baseband

## `bbfw`

Zip package containing:

* `sbl1.mbn` - Secondary Bootloader (after ROM PBL)
* `Info.plist`
* `Options.plist` - Zero?
* `qdsp6sw.mbn` - Qualcomm Hexagon Digital Signal Processor
* `tz.mbn` - Qualcomm TrustZone Implementation - QSEE
* `hyp.mbn` - Qualcomm Hypervisor Execution Environment - QHEE - EL2
* `xbl_cfg.mbn` - For XBL (eXtensible Boot Loader) or EFI based SPL signed static data
* `restoresbl1.mbn` - Secondary program loader (bootloader) for baseband recovery
* `acdb.mbn` - Accessory Calibration Database (seems to be initial)