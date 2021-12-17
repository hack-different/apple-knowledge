# Apple Data Formats

A collection of reverse engineered Apple formats

Repo inspired by https://github.com/papers-we-love/papers-we-love

# Apple 4CC

A master index of Apple 4CCs exists at [iBoot/4CC.md](iBoot/4CC.md)

## Table of Contents

### Archive / Disk Formats
* `bom`
* `pbzx`
* `dmg`
* SSV - Signed System Volumes, `root_ha

### Databases
* iTunes database
  * https://github.com/jeanthom/libitlp
  * https://github.com/josephw/titl
  * https://metacpan.org/pod/Mac::iTunes::Library::Parse

### Image, Sound and Other Resources
* Apple Flavored PNG
  * http://www.jongware.com/pngdefry.html
* Apple IMA ADPCM
  * http://wiki.multimedia.cx/index.php?title=Apple_QuickTime_IMA_ADPCM
  * https://www.downtowndougbrown.com/2012/07/power-macintosh-g3-blue-and-white-custom-startup-sound/


### Code and Signature Formats
* Mach-O
  * https://github.com/sbingner/ldid
* img4 - Apple signed images, version 4
  * https://www.theiphonewiki.com/wiki/IMG4_File_Format
  * https://github.com/h3adshotzz/img4helper
* TrustCache - Pre-authorized Binary Hashes
  * https://support.apple.com/guide/security/trust-caches-sec7d38fbf97/web
  * https://github.com/t8012/go-aapl-integrity
* EALF - `eficheck` baselines
  * https://github.com/t8012/go-aapl-integrity
  * https://github.com/t8012/efivalidate
* ChunkList - Used to verify macOS Recovery / Internet Recovery
  * https://github.com/t8012/go-aapl-integrity
* `dyld` Shared Cache
  * https://github.com/rickmark/yolo_dsc
  * https://github.com/arandomdev/DyldExtractor
* iBoot LocalPolicy, RemotePolicy and BAA signing
  * [SEP/M1_Boot_Policy.dm](SEP/M1_Boot_Policy.md)
* Apple iDevice Backup Format
  * https://github.com/rickmark/libibackup

### USB Protocols
* Basically all iDevice iTunes
  * https://github.com/libimobiledevice/libimobiledevice
* DFU / Recovery
  * libimoibledevice/libirecovery
* usbmuxd - USB transport for iDevices
  * libimobiledevice/usbmuxd
* `com.apple.restored` - iDevice Restore Protocol
  * https://github.com/libimobiledevice/idevicerestore
* UTDM - USB Target Disk Mode
  * https://github.com/rickmark/apple_utdm
* USB-C Power Delivery - Vendor Defined Messages
  * https://blog.t8012.dev/ace-part-1/
  * https://github.com/rickmark/macvdmtool

### Network / Wireless / Transit
* Apple Wi-Fi Password Sharing
  * https://github.com/seemoo-lab/openwifipass
* AWDL
* Bluetooth Bonjour (Service Discovery)
* Apple Watch Pairing
* `com.apple.terminusd`
* Magic Pairing
* ATC - Air Traffic Control - iTunes Wi-Fi Sync
* RemoteXPC
* macOS Internet Recovery
  * https://github.com/rickmark/apple_net_recovery

### System Configuration and State
* FDR - Factory Data Restore
* SysCfg - System Configuration - Serial Number and other Device Info
* APTicket - The root of a authorized version set

### Diagnostic Protocols
* AWDD - Apple Wireless Diagnostics (misnomer, more then wireless, system trace)
  * [rickmark/awdd_decode](https://github.com/rickmark/awdd_decode)
* iCloud Keychain (Umbrella for multiple formats)
  * https://www.theiphonewiki.com/wiki/ICloud_Keychain
* Mojo Serial
* XHC20 USB Capture
  * https://github.com/t8012/demuxusb/blob/b6b1a1a6633449c2cb16ad44edcc22aab4dc29cd/ext/pcapng.h
