# Intel Baseband

## Intel Baseband Firmwares

Primary package is a PKZip in a `.bbfw` file

* `ebl.bin` - Bootloader
* `bbcfg.bin` - Configuration data - unknown format, more research needed, tabular structure
* `ant_cfg_data.elf` - Antenna Calibration Data
* `Info.plist` - Manifest File
* `Options.plist`
* `legacy_rat_fw.elf` - For downlevel radio technologies (Edge, 3G, etc)
* `psi_ram.bin` / `psi_ram2.bin` - (Processor State Image?)
  * References PCIe
  * References USB-SS (USB3)