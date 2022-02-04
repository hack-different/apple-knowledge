# To Convert

* [https://github.com/Proteas/apple-cve](https://github.com/Proteas/apple-cve)
* [kpwn / qwertyoruiop's Wiki](https://github.com/kpwn/iOSRE/tree/master/wiki)
* [kpwn / qwertyoruiop's Papers](https://github.com/kpwn/iOSRE/tree/master/resources/papers)
* [OWASP: iOS Tampering and Reverse Engineering](https://github.com/OWASP/owasp-mstg/blob/master/Document/0x06c-Reverse-Engineering-and-Tampering.md)
* [*OS Internals by Jonathan Levin](https://newosxbook.com/index.php)
* [bytepack/IntroToiOSReverseEngineering](https://github.com/bytepack/IntroToiOSReverseEngineering)
* [Remote Attack Surface](https://googleprojectzero.blogspot.com/2019/08/the-fully-remote-attack-surface-of.html)
* [Lakr233's Research](https://lab.qaq.wiki/Lakr233/iOS-kernel-research/-/tree/master))
* [T2 Dev Team: `t8012` / Apple T2 / bridgeOS](https://t8012.dev)
* [The iPhone Wiki](https://www.theiphonewiki.com/wiki/Main_Page)
* [Mach](https://developer.apple.com/library/content/documentation/Darwin/Conceptual/KernelProgramming/Mach/Mach.html)
  * <https://opensource.apple.com/tarballs/xnu/>
* [Mach and the Mach Interface Generator by nemo](https://www.exploit-db.com/papers/13176/)
* [Appl IPC by Ian Beer](https://thecyberwire.com/events/docs/IanBeer_JSS_Slides.pdf)
* [acidanthera/Lilu](https://github.com/acidanthera/Lilu)
* [osy/AMFIExemption](https://github.com/osy/AMFIExemption)
* [KTRR by Siguza](https://blog.siguza.net/KTRR/)
* [Tick Tock by xerub](https://xerub.github.io/ios/kpp/2017/04/13/tick-tock.html)
* [Casa de PPL by Levin](http://newosxbook.com/articles/CasaDePPL.html)
* [KTRW by Brandon Azad](https://googleprojectzero.blogspot.com/2019/10/ktrw-journey-to-build-debuggable-iphone.html)
* [Qwertyoruiopz Attacking XNU: Part 1](https://web.archive.org/web/20160131061526/http://blog.qwertyoruiop.com/?p=38)
* [Qwertyoruiopz Attacking XNU: Part 2](https://web.archive.org/web/20160131061526/http://blog.qwertyoruiop.com/?p=48)
* [Kernel Heap by Stefan Esser](http://gsec.hitb.org/materials/sg2016/D2%20-%20Stefan%20Esser%20-%20iOS%2010%20Kernel%20Heap%20Revisited.pdf)
* [Who needs task_for_pid anyway](http://newosxbook.com/articles/PST2.html)
* [NVRAM unlock](https://stek29.rocks/2018/06/26/nvram.html)
* [`apple/darwin-xnu`](https://github.com/apple/darwin-xnu)
* [`Factory_Firmware_Payloads`](docs/Factory_Firmware_Payloads)
* [*OS iBoot](http://newosxbook.com/bonus/iBoot.pdf)
* [SecureROM Binaries](https://github.com/hekapooios/hekapooios.github.io/tree/master/resources/APROM)
* APFS - Apple Filesystem
  * [Apple APFS Reference](https://developer.apple.com/support/downloads/Apple-File-System-Reference.pdf)
  * [`sgan81/apfs-fuse`](https://github.com/sgan81/apfs-fuse)
  * [`libyal/libfsapfs`](https://github.com/libyal/libfsapfs)
  * [`cugu/apfs.ksy`](https://github.com/cugu/apfs.ksy)
  * [bxl1989 APFS Remount](https://bxl1989.github.io/2019/01/17/apfs-remount.html)
* [LwVM Lightweight Volume Manager](https://stek29.rocks/2018/01/22/lwvm-mapforio.html)
* Apple Disk Image - `dmg`
  * [`jhermsmeier/node-udif`](https://github.com/jhermsmeier/node-udif)
  * [`nlitsme/encrypteddmg`](https://github.com/nlitsme/encrypteddmg)
  * [`darlinghq/darling-dmg`](https://github.com/darlinghq/darling-dmg)
* iTunes database
  * [`jeanthom/libitlp`](https://github.com/jeanthom/libitlp)
  * <https://metacpan.org/pod/Mac::iTunes::Library::Parse>
* Apple IMA ADPCM
  * <http://wiki.multimedia.cx/index.php?title=Apple_QuickTime_IMA_ADPCM>
  * <https://www.downtowndougbrown.com/2012/07/power-macintosh-g3-blue-and-white-custom-startup-sound/>
* [`notpeter/apple-installer-checksums`](https://github.com/notpeter/apple-installer-checksums)
* [ipsw.me](https://ipsw.me)
* [ipsw.dev](https://ipsw.dev)
  * [m4b Mach Binaries](http://www.m4b.io/reverse/engineering/mach/binaries/2015/03/29/mach-binaries.html)
  * [J's Entitlements Database](http://newosxbook.com/ent.jl)
  * [Levin's Code Signing](http://www.newosxbook.com/articles/CodeSigning.pdf)
* img4 - Apple signed images, version 4
  * <https://www.theiphonewiki.com/wiki/IMG4_File_Format>
  * [`h3adshotzz/img4helper`](https://github.com/h3adshotzz/img4helper)
* TrustCache - Pre-authorized Binary Hashes
  * [Apple Platform Security - Trust caches](https://support.apple.com/guide/security/trust-caches-sec7d38fbf97/web)
  * [`t8012/go-aapl-integrity`](https://github.com/t8012/go-aapl-integrity)
* EALF - `eficheck` baselines
  * [`t8012/go-aapl-integrity`](https://github.com/t8012/go-aapl-integrity)
* ChunkList - Used to verify macOS Recovery / Internet Recovery
  * [`t8012/go-aapl-integrity`](https://github.com/t8012/go-aapl-integrity)
* `dyld` and DSC (dyld Shared Cache)
  * [Levin's Dyld](http://www.newosxbook.com/articles/DYLD.html)
  * [`rickmark/yolo_dsc`](https://github.com/rickmark/yolo_dsc) - Used as last resort and depend on Xcode
  * [`arandomdev/DyldExtractor`](https://github.com/arandomdev/DyldExtractor) - Fixes up linking
  * [dyld_shared_cache_util.cpp](https://opensource.apple.com/source/dyld/dyld-195.5/launch-cache/dyld_shared_cache_util.cpp.auto.html)
* Rosetta2
  * [ProjectChampollion](https://github.com/FFRI/ProjectChampollion/)
* Swift
  * [Swift Mangling](https://github.com/apple/swift/blob/main/docs/ABI/Mangling.rst)
* [Levin's - The Apple Sandbox](http://newosxbook.com/files/HITSB.pdf)
* [iBSparkles Breaking Entitlements](https://sparkes.zone/blog/ios/2018/04/06/diving-into-the-kernel-entitlements.html)
* [stek29 Shenanigans Shenanigans](https://stek29.rocks/2018/12/11/shenanigans.html)
* [argp vs com.apple.security.sandbox](https://census-labs.com/media/sandbox-argp-csw2019-public.pdf)
* [nyuszika7h/sepfinder](https://github.com/nyuszika7h/sepfinder)
* <http://mista.nu/research/sep-paper.pdf?_x_tr_sch=http&_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=en-US>
* <https://www.theiphonewiki.com/wiki/Seputil>
* <https://github.com/mwpcheung/AppleSEPFirmware>
* <https://www.blackhat.com/docs/us-16/materials/us-16-Mandt-Demystifying-The-Secure-Enclave-Processor.pdf>
* <https://data.hackinn.com/ppt/2018腾讯安全国际技术峰会/SEPOS：A%20Guided%20Tour.pdf>
* <https://github.com/windknown/presentations/blob/master/Attack_Secure_Boot_of_SEP.pdf> - blackbird
* ARM General
  * [ARMv8 Overview](https://www.element14.com/community/servlet/JiveServlet/previewBody/41836-102-1-229511/ARM.Reference_Manual.pdf)
  * [ARMv8 ARM ARM (Architecture Reference Manual)](https://developer.arm.com/docs/ddi0487/latest)
  * [ARMv8-A Tools](https://developer.arm.com/products/architecture/cpu-architecture/a-profile/exploration-tools)
  * [ARM Software Standards](https://developer.arm.com/architectures/system-architectures/software-standards)
  * [Siguza's ARM Bootcamp](https://github.com/Siguza/ios-resources/blob/master/bits/arm64.md)
* Apple CPUs
  * [dougallj's applecpu](https://dougallj.github.io/applecpu/firestorm.html)
* Compilers
  * [ARM Clang PAC ABI](https://github.com/apple/llvm-project/blob/apple/main/clang/docs/PointerAuthentication.rst)
* ARM Mitigations
  * [APRR](https://blog.siguza.net/APRR/)
  * [PAN](https://blog.siguza.net/PAN/)
  * [SPRR & GXF](https://blog.svenpeter.dev/posts/m1_sprr_gxf/)
* Apple Hypervisor
  * <https://developer.apple.com/documentation/hypervisor>
  * <https://developer.apple.com/documentation/hypervisor/apple_silicon>
  * <https://habr.com/en/company/dsec/blog/472762/>
* [Qi Wireless Charging](https://www.wirelesspowerconsortium.com/knowledge-base/specifications/download-the-qi-specifications.html)
  * <https://googleprojectzero.blogspot.com/2020/12/an-ios-zero-click-radio-proximity.html>
* RemoteXPC
  * <https://duo.com/labs/research/apple-t2-xpc>
  * <http://newosxbook.com/tools/XPoCe2.html>
* macOS Internet Recovery
  * [`rickmark/apple_net_recovery`](https://github.com/rickmark/apple_net_recovery)
* FDR - Factory Data Restore
* SysCfg - System Configuration - Serial Number and other Device Info
* APTicket - The root of an authorized version set
* iCloud Keychain (Umbrella for multiple formats)
  * <https://www.theiphonewiki.com/wiki/ICloud_Keychain>
* Mojo Serial
  * [MojoKDP.kext.S](https://github.com/rickmark/mojo_thor/blob/master/MojoKDP/mojo.kext.S)
* XHC20 USB Capture
  * <https://github.com/t8012/demuxusb/blob/b6b1a1a6633449c2cb16ad44edcc22aab4dc29cd/ext/pcapng.h>
* [limera1n](https://github.com/Chronic-Dev/syringe/blob/master/syringe/exploits/limera1n/limera1n.c)
* [`OpenJailbreak/greenpois0n`](https://github.com/OpenJailbreak/greenpois0n)
* [`axi0mX/ipwndfu`](https://github.com/axi0mX/ipwndfu)
* [checkra1n](https://checkra.in)
* [unc0ver](https://unc0ver.dev)
* [Taurine](https://taurine.app)
* [evasi0n writeup by geohot](http://geohot.com/e7writeup.html)
* TaIG
  * [8.0](http://www.newosxbook.com/articles/TaiG.html)
  * [8.1.2](http://www.newosxbook.com/articles/TaiG2.html)
  * [8.1.3](http://www.newosxbook.com/articles/28DaysLater.html)
  * [8.4](http://www.newosxbook.com/articles/HIDeAndSeek.html)
* [`Chronic-Dev/syringe`](https://github.com/Chronic-Dev/syringe)
* [Cydia](https://cydia.saurik.com)
* [Asahi Linux for M1](https://asahilinux.org)
* [Corellium's M1 Branch](https://github.com/corellium/linux-m1)
* [Android on pongoOS](https://github.com/corellium/projectsandcastle)
  * [iphonelinux](https://github.com/planetbeing/iphonelinux)
* [`rickmark/isafety`](https://github.com/rickmark/isafety)
* [Mobile Verification Toolkit](https://docs.mvt.re/en/latest/)
* [`mvt-project/mvt`](https://github.com/mvt-project/mvt)
