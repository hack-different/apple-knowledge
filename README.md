# Apple Data Formats and Knowledge

A collection of reverse engineered Apple formats, protocols, or other interesting bits.

Join us on Discord: <https://discord.gg/hackdifferent>

Repo inspired by <https://github.com/papers-we-love/papers-we-love>

## WARNING

This repo accepts (gleefully) PRs that enhance and enable development, but under no circumstances create a PR based on `AppleInternal`, or any other copyrighted words protected by the [DMCA](https://en.wikipedia.org/wiki/Digital_Millennium_Copyright_Act).  If you need help determining this, tag the PR with "license help", join the Discord server, and ask a `#Legit` or higher role for help.

Violation of the DMCA or Copyright law is the responsibility of the submitter.

## License

The contents of this repo are dual-licensed under the [MIT](https://opensource.org/licenses/MIT) license as well as the CC-SA-BY

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Apple Knowledge</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/hack-different/apple-knowledge" property="cc:attributionName" rel="cc:attributionURL">Hack Different</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

# Apple 4CC

A master index of Apple 4CCs exists at [iBoot/4CC.md](iBoot/4CC.md)

## Tools

* <https://hex-rays.com/ida-pro/>
  * <https://github.com/onethawt/idaplugins-list>
  * <https://github.com/bazad/ida_kernelcache>
  * <https://github.com/cellebrite-srl/ida_kernelcache>
  * <https://github.com/cellebrite-srl/PacXplorer>
  * <https://github.com/cellebrite-srl/FunctionInliner>
* <https://salmanarif.bitbucket.io/visual/index.html>
* <https://ghidra-sre.org>
* <https://www.hopperapp.com>

## Guides

* <https://github.com/OWASP/owasp-mstg/blob/master/Document/0x06c-Reverse-Engineering-and-Tampering.md>

## Protocols / Formats

### Archive / Disk Formats

* `bom`
* `pbzx`
* `dmg`
* SSV - Signed System Volumes, `root_hash`

### Databases

* iTunes database
  * <https://github.com/jeanthom/libitlp>
  * <https://github.com/josephw/titl>
  * <https://metacpan.org/pod/Mac::iTunes::Library::Parse>

### Image, Sound and Other Resources

* [Apple Flavored PNG](PNG.md)
* Apple IMA ADPCM
  * <http://wiki.multimedia.cx/index.php?title=Apple_QuickTime_IMA_ADPCM>
  * <https://www.downtowndougbrown.com/2012/07/power-macintosh-g3-blue-and-white-custom-startup-sound/>

### Code and Signature Formats

* Mach-O / Signing / Entitlements
  * <https://github.com/sbingner/ldid>
  * <http://newosxbook.com/ent.jl>
* img4 - Apple signed images, version 4
  * <https://www.theiphonewiki.com/wiki/IMG4_File_Format>
  * <https://github.com/h3adshotzz/img4helper>
* TrustCache - Pre-authorized Binary Hashes
  * <https://support.apple.com/guide/security/trust-caches-sec7d38fbf97/web>
  * <https://github.com/t8012/go-aapl-integrity>
* EALF - `eficheck` baselines
  * <https://github.com/t8012/go-aapl-integrity>
  * <https://github.com/t8012/efivalidate>
* ChunkList - Used to verify macOS Recovery / Internet Recovery
  * <https://github.com/t8012/go-aapl-integrity>
* `dyld` Shared Cache
  * <https://github.com/rickmark/yolo_dsc>
  * <https://github.com/arandomdev/DyldExtractor>
* iBoot LocalPolicy, RemotePolicy and BAA signing
  * [SEP/M1_Boot_Policy.dm](SEP/M1_Boot_Policy.md)
* Apple iDevice Backup Format
  * <https://github.com/rickmark/libibackup>

### USB Protocols

* Basically all iDevice iTunes
  * <https://github.com/libimobiledevice/libimobiledevice>
* DFU / Recovery
  * libimoibledevice/libirecovery
* usbmuxd - USB transport for iDevices
  * libimobiledevice/usbmuxd
* `com.apple.restored` - iDevice Restore Protocol
  * <https://github.com/libimobiledevice/idevicerestore>
* UTDM - USB Target Disk Mode
  * <https://github.com/rickmark/apple_utdm>
* USB-C Power Delivery - Vendor Defined Messages
  * <https://blog.t8012.dev/ace-part-1/>
  * <https://github.com/rickmark/macvdmtool>

### Network / Wireless / Transit

* Apple Wi-Fi Password Sharing
  * <https://github.com/seemoo-lab/openwifipass>
* AWDL
* Bluetooth Bonjour (Service Discovery)
* Apple Watch Pairing
* `com.apple.terminusd`
* Magic Pairing
* ATC - Air Traffic Control - iTunes Wi-Fi Sync
* RemoteXPC
* macOS Internet Recovery
  * <https://github.com/rickmark/apple_net_recovery>

### System Configuration and State

* FDR - Factory Data Restore
* SysCfg - System Configuration - Serial Number and other Device Info
* APTicket - The root of an authorized version set

### Diagnostic Protocols

* AWDD - Apple Wireless Diagnostics (misnomer, more then wireless, system trace)
  * [rickmark/awdd_decode](https://github.com/rickmark/awdd_decode)
* iCloud Keychain (Umbrella for multiple formats)
  * <https://www.theiphonewiki.com/wiki/ICloud_Keychain>
* Mojo Serial
* XHC20 USB Capture
  * <https://github.com/t8012/demuxusb/blob/b6b1a1a6633449c2cb16ad44edcc22aab4dc29cd/ext/pcapng.h>

### X-Plat

* <https://github.com/corellium/linux-m1>
* <https://github.com/corellium/projectsandcastle>
