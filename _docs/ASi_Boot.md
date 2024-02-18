# Boot Process of the Apple Silicon Mac

## The Primary AP Ticket

After Silicon macOS first boots up like the traditional SecureROM, reading from NOR the `aptk` image.

### Manifest Properties

* `BNCH`
* `BORD` - Board ID
* `CEPO` - Chip Epoch
* `CHIP` - AP Chip ID
* `CPRO` - Chip Promotion State
* `CSEC`
* `ECID`
* `SDOM` - Security Domain
* `esdm`
* `love`
* `prtp`
* `sdkp`
* `snon`
* `snuf`
* `svrn`
* `tatp`
* `uidm`
* `augs`
* `uidm`

### Objects

* `anef`
* `ansf`
* `aopf`
* `aubt`
* `aupr`
* `avef`
* `bat0`
* `bat1`
* `batF`
* `bstc`
* `chg0`
* `chg1`
* `ciof`
* `csys`
* `dcp2`
* `dcpf`
* `dtre`
* `dven`
* `ftap`
* `ftsp`
* `gfxf`
* `glyP`
* `ibd1`
* `ibdt`
* `ibec`
* `ibot`
* `ibss`
* `illb`
* `ipdf`
* `ispf`
* `isys`
* `krnl`
* `logo`
* `msys`
* `mtfw`
* `mtpf`
* `pmpf`
* `rans`
* `rdcp`
* `rdsk`
* `rdtr`
* `recm`
* `rfta`
* `rfts`
* `rkrn`
* `rlg1`
* `rlg2`
* `rlgo`
* `rosi`
* `rsep`
* `rtmu`
* `rtsc`
* `sepi`
* `siof`
* `tmuf`
* `trst`

## NVRAM

* `boot-volume` - Set to "Data" volume
* `upgrade-boot-volume` - Does not exist?
* `update-volume` - Update volume in OS group
