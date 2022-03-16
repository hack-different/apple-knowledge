# Apple Silicon Virtualization.framework Notes

* arm64e only
* `AVPBooter.bin` serves as SecureROM

## Hypercalls

Because the SysCfg / NVRAM / Firmware is largely "synthetic", iBoot uses "hypercalls" or para-virtualization to
access these services.  They are bound into the device tree by the `AVPBooter` and `iBoot` from the `utils` node
of the device tree.

### Services Provided

SysCfg Entries (generated):

* EMac
* EMc2
* WMac
* BMac

SysCfg Entries (pass-through):

* SrNm
* Mod#
* Regn

## Firmwares

* ibec
* ibot
* cfel
* hmmr
* pert
* phlt
* rbmt

## Graphical Images

* chg0
* chg1
* batF
* bat0
* bat1
* glyP
* liqd
* logo
* lpw0
* lpw1
* recm
* rlg1
* rlg2
* rlgo

## `vmapple2` FTAB

* virt_firmware
* nvram
* virt_syscfg
* control_bits
* paniclog
* virt_ean