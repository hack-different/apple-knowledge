# Apple Data Formats and Knowledge

A collection of reverse engineered Apple formats, protocols, or other interesting bits.

Join us on Discord: <https://discord.gg/hackdifferent>

Repo inspired by <https://github.com/papers-we-love/papers-we-love>

## Contributing and a warning...

We want this collection to be around for new jailbreakers and hobbiests for years to come, so we must say: this 
collection accepts (with gratitude) pull-requests that improve it, but under no circumstances 
will a PR based on `AppleInternal`, or any other copyrighted works protected by the 
[DMCA](https://en.wikipedia.org/wiki/Digital_Millennium_Copyright_Act) be accepted.  If 
you need help determining this, tag the PR with `license help`, join the 
[Discord server](https://discord.gg/hackdifferent), and ask a `#Legit` or higher role for help.

Violation of the DMCA or Copyright law is the responsibility of the submitter.

### Why not \<insert wiki here\>?

Wiki's best serve prose, and part of the goal here is to leverage machine readable and ingestable information with
human augmentation wherever possible.  Also GitHub is more conducive to allowing any user to fork and PR the repo lowering
the barrier to entry.  The core team reviews PRs for quality before merging.

## License

The contents of this repo are dual-licensed:

Licensed under the [MIT](https://opensource.org/licenses/MIT) license

Also licensed under the CC-BY-SA

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Apple Knowledge</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/hack-different/apple-knowledge" property="cc:attributionName" rel="cc:attributionURL">Hack Different</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

# Primary Data Source

All data is derived from machine readable files (YAML) in this repo under `_data`

Updates and additions there should automatically be reflected in the documents

[`hack-different/apple-knowledge/_data`](https://github.com/hack-different/apple-knowledge/tree/main/_data)

## Tools

* [IDA Disassembler by HexRays](https://hex-rays.com/ida-pro/)
  * [`onethawt/idaplugins-list`](https://github.com/onethawt/idaplugins-list)
  * [`cellebrite-srl/ida_kernelcache`](https://github.com/cellebrite-srl/ida_kernelcache)
  * [`cellebrite-srl/PacExplorer`](https://github.com/cellebrite-srl/PacXplorer)
  * [`cellebrite-srl/FunctionInliner`](https://github.com/cellebrite-srl/FunctionInliner)
* [VisUAL ARM Simulator](https://salmanarif.bitbucket.io/visual/index.html)
* [Ghidra Disassembler](https://ghidra-sre.org)
* [Hopper Disassembler](https://www.hopperapp.com)
* [`blacktop/ipsw`](https://github.com/blacktop/ipsw)

## Guides and General

* [OWASP: iOS Tampering and Reverse Engineering](https://github.com/OWASP/owasp-mstg/blob/master/Document/0x06c-Reverse-Engineering-and-Tampering.md)
* [Kernel Debug Kit](docs/kdk)
* [*OS Internals by Jonathan Levin](https://newosxbook.com/index.php)
* [T2 Dev Setup](docs/T2)

## Devices

* [T2 Dev Team: `t8012` / Apple T2 / bridgeOS](https://t8012.dev)
* [The iPhone Wiki](https://www.theiphonewiki.com/wiki/Main_Page)

## Protocols / Formats

### Bootloader Related

* [`EFI`](docs/efi)
* [`NVRAM`](docs/nvram)
* [`SEP_memmap`](docs/SEP_memmap)
* [`apple/darwin-xnu`](https://github.com/apple/darwin-xnu)

### Archive / Disk Formats

* APFS - Apple Filesystem
  * [Apple APFS Reference](https://developer.apple.com/support/downloads/Apple-File-System-Reference.pdf)
  * [`sgan81/apfs-fuse`](https://github.com/sgan81/apfs-fuse)
  * [`libyal/libfsapfs`](https://github.com/libyal/libfsapfs)
  * [`cugu/apfs.ksy`](https://github.com/cugu/apfs.ksy)
* NeXT / Apple "Bill of Materials" / `pkg` / `bom`
  * [`iineva/bom`](https://github.com/iineva/bom)
* `pbzx`
* Apple Disk Image - `dmg`
  * [`jhermsmeier/node-udif`](https://github.com/jhermsmeier/node-udif)
  * [`nlitsme/encrypteddmg`](https://github.com/nlitsme/encrypteddmg)
  * [`darlinghq/darling-dmg`](https://github.com/darlinghq/darling-dmg)
* Signed System Volumes (SSV) / `root_hash`

### Databases

* Property Lists
  * [`libimobiledevice/libplist`](https://github.com/libimobiledevice/libplist)
* iTunes database
  * [`jeanthom/libitlp`](https://github.com/jeanthom/libitlp)
  * [`josephw/titl`](https://github.com/josephw/titl)
  * <https://metacpan.org/pod/Mac::iTunes::Library::Parse>
* Apple iDevice Backup Format
  * [`rickmark/libibackup`](https://github.com/rickmark/libibackup)

### Image, Sound and Other Resources

* [Apple Flavored PNG](docs/png)
* Apple IMA ADPCM
  * <http://wiki.multimedia.cx/index.php?title=Apple_QuickTime_IMA_ADPCM>
  * <https://www.downtowndougbrown.com/2012/07/power-macintosh-g3-blue-and-white-custom-startup-sound/>
* AirPlay2
  * [`mikebrady/shareport-sync`](https://github.com/mikebrady/shairport-sync)

### Software Update / Installers

* [`notpeter/apple-installer-checksums`](https://github.com/notpeter/apple-installer-checksums)

### Code and Signature Formats

* Mach-O / Signing / Entitlements
  * [`sbingner/ldid`](https://github.com/sbingner/ldid)
  * [J's Entitlements Database](http://newosxbook.com/ent.jl)
* img4 - Apple signed images, version 4
  * <https://www.theiphonewiki.com/wiki/IMG4_File_Format>
  * [`h3adshotzz/img4helper`](https://github.com/h3adshotzz/img4helper)
* TrustCache - Pre-authorized Binary Hashes
  * [Apple Platform Security - Trust caches](https://support.apple.com/guide/security/trust-caches-sec7d38fbf97/web)
  * [`t8012/go-aapl-integrity`](https://github.com/t8012/go-aapl-integrity)
* EALF - `eficheck` baselines
  * [`t8012/go-aapl-integrity`](https://github.com/t8012/go-aapl-integrity)
  * [`t8012/efivalidate`](https://github.com/t8012/efivalidate)
* ChunkList - Used to verify macOS Recovery / Internet Recovery
  * [`t8012/go-aapl-integrity`](https://github.com/t8012/go-aapl-integrity)
* `dyld` Shared Cache
  * [`rickmark/yolo_dsc`](https://github.com/rickmark/yolo_dsc)
  * [`arandomdev/DyldExtractor`](https://github.com/arandomdev/DyldExtractor)
* iBoot LocalPolicy, RemotePolicy and BAA signing
  * [`M1_Boot_Policy`](docs/M1_Boot_Policy)


### USB Protocols

* Basically all iDevice / iTunes
  * [libimobiledevice.org](https://libimobiledevice.org)
  * [`libimobiledevice/libimobiledevice`](https://github.com/libimobiledevice/libimobiledevice)
* DFU / Recovery
  * [`libimoibledevice/libirecovery`](https://github.com/libimobiledevice/libirecovery)
* usbmuxd - USB transport for iDevices
  * [`libimobiledevice/usbmuxd`](https://github.com/libimobiledevice/usbmuxd)
  * [`t8012/demuxusb`](https://github.com/t8012/demuxusb)
* `com.apple.restored` - iDevice Restore Protocol
  * [`libimobiledevice/idevicerestore`](https://github.com/libimobiledevice/idevicerestore)
* UTDM - USB Target Disk Mode
  * [`rickmark/apple_utdm`](https://github.com/rickmark/apple_utdm)
* USB-C Power Delivery - Vendor Defined Messages
  * [USB-C Port Controller (ACE) Secrets](https://blog.t8012.dev/ace-part-1/)
  * [`rickmark/macvdmtool`](https://github.com/rickmark/macvdmtool)

### Network / Wireless / Transit

* Apple Wi-Fi Password Sharing
  * [`seemoo-lab/openwifipass`](https://github.com/seemoo-lab/openwifipass)
* AWDL - Apple Wireless Distribution Link
  * <https://googleprojectzero.blogspot.com/2020/12/an-ios-zero-click-radio-proximity.html>
* Bluetooth Bonjour (Service Discovery)
* Apple Watch Pairing
* `com.apple.terminusd`
* Magic Pairing
* ATC - Air Traffic Control - iTunes Wi-Fi Sync
* RemoteXPC
  * <https://duo.com/labs/research/apple-t2-xpc>
  * <http://newosxbook.com/tools/XPoCe2.html>
* macOS Internet Recovery
  * [`rickmark/apple_net_recovery`](https://github.com/rickmark/apple_net_recovery)

### System Configuration and State

* FDR - Factory Data Restore
* SysCfg - System Configuration - Serial Number and other Device Info
* APTicket - The root of an authorized version set

### Diagnostic Protocols

* AWDD - Apple Wireless Diagnostics (misnomer, more then wireless, system trace)
  * [`rickmark/awdd_decode`](https://github.com/rickmark/awdd_decode)
* iCloud Keychain (Umbrella for multiple formats)
  * <https://www.theiphonewiki.com/wiki/ICloud_Keychain>
* Mojo Serial
  * [MojoKDP.kext.S](https://github.com/rickmark/mojo_thor/blob/master/MojoKDP/mojo.kext.S)
* XHC20 USB Capture
  * <https://github.com/t8012/demuxusb/blob/b6b1a1a6633449c2cb16ad44edcc22aab4dc29cd/ext/pcapng.h>

## Jailbreaks

* [limera1n](https://github.com/Chronic-Dev/syringe/blob/master/syringe/exploits/limera1n/limera1n.c)
* [`OpenJailbreak/greenpois0n`](https://github.com/OpenJailbreak/greenpois0n)
* [`axi0mX/ipwndfu`](https://github.com/axi0mX/ipwndfu)
* [checkra1n](https://checkra.in)
* [unc0ver](https://unc0ver.dev)

### Jailbreak Tooling

* [`Chronic-Dev/syringe`](https://github.com/Chronic-Dev/syringe)
* [Cydia](https://cydia.saurik.com)

## X-Plat

* [pongoOS](https://github.com/checkra1n/pongoOS)
* [Asahi Linux for M1](https://asahilinux.org)
* [Corellium's M1 Branch](https://github.com/corellium/linux-m1)
* [Android on pongoOS](https://github.com/corellium/projectsandcastle)

## Safety / Protection

* [`rickmark/isafety`](https://github.com/rickmark/isafety)
* [Mobile Verification Toolkit](https://docs.mvt.re/en/latest/)
* [`mvt-project/mvt`](https://github.com/mvt-project/mvt)

# Credits

Hack Different's Knowledge is a product of the entire community and belongs to the community.  It is
facilitated by the volunteer work of the Hack Different moderation team.

Portions of data and knowledge come from <https://theiphonewiki.org>, <https://libimobiledevice.org> and 
<https://checkra.in> as well as the individuals who brought you those projects.

Tooling is being written to credit all parties using GitHub's API

## Dedication

> Here’s to the crazy ones, the misfits, the rebels, the troublemakers
> 
> the round pegs in the square holes… 
>
> the ones who see things differently — they’re not fond of rules… 
> 
> You can quote them, disagree with them, glorify or vilify them, but the only thing you can’t do is ignore them because they change things… 
> 
> They push the human race forward, and while some may see them as the crazy ones, 
> 
> we see genius, 
> 
> because the ones who are crazy enough to think that they can change the world, 
> 
> are the ones who do.
>
> — Steve Jobs, 1997

Also dedicated to the volunteer work of those who use this for good, and deny the shadow to those who seek to harm.
