# The Mis-reporting

There were technical details that were inaccurate in the original reporting.  This was due to an attempt
to rush analysis, due to the importance of this issue.  We've since provided corrections to the details
in the original IronPeak blog.  Moreover several media outlets have misattributed the research that went
into the article.  Niels is an industry consultant who provided  impact analysis of the T2 and checkm8, but
was incorrectly referred to as the researcher.

## Existing T2 Coverage

<https://paper.dropbox.com/doc/Existing-T2-Coverage--BgHcAbQKNitYzgoF4FDo1J40AQ-n2ByvSgsY7EWACprZ1jBI>

## The Researchers

Naturally @axi0mX provided checkm8 allowing most of what follows to have been done.

The primary researchers responsible for T2/bridgeOS are @h0m3us3r, @mcmrarm, @aunali1 and Rick Mark(@su_rickmark).
The group met each other via the GitHub issue <https://github.com/axi0mX/ipwndfu/issues/141> and learned they
were interested in the topic broadly.

### The T2 Team

#### h0m3us3r

Twitter: @h0m3us3r
GitHub: github.com/h0m3us3r
An EE student, newcomer to iOS prior to this project. Brute-forced the offsets in the T2 BootROM needed for
checkm8 exploit. Started USB-C debug probe research and was first to SWD the T2 from a homemade probe. Currently
works on a retail version of USB-C debug probe.

#### aunali1

Twitter: @aunali1
GitHub: github.com/aunali1
CS/Neuroscience pre-med student. Involved with T2/Linux drivers and support and current maintainer prior to T2
exploitation. Analyzed Apple hardware designs to determine points of infiltration. Developed toolchain/SDK for
bridgeOS and SSH from host macOS using NCM interface. Created keylogger PoC and zero-click DFU PoC. Currently
completing hardware design of retail USB-C debug probe.

#### mrarm

Twitter: @mcmrarm
GitHub: github.com/mcmrarm
Computer Engineering student with an interest in reverse engineering. Helped in getting Linux running on T2 Macs
by reverse engineering important T2 Mac OS drivers and communication protocols, later implementing them for Linux.
Helped with the T2 BootROM bruteforce. Reverse engineered parts of T2 boot chain, kernel and user-space for how
they are designed and in search of attack vectors.

#### rickmark

Twitter: @su_rickmark
GitHub: github.com/rickmark
History as an internal security engineer at tech companies.  In this role his assessment of the workstations,
phones and other systems was a key concern.  He worked generally on macOS integrity, EFI and idevicerestore concerns.

### The checkra1n Team

The checkra1n team did substantive work in creating a full jailbreak from the checkm8 flaw.  It was the similarity
of bridgeOS and iOS that allowed the T2 version of checkm8 to be rapidly included and supported.  Much of the
further work is due to this framework and the jail-breaking community at large.  It was after the T2 checkm8 work
that the T2 team was added to checkra1n and credited.

## Timeline of Events

* Oct 27, 2017 - rickmark creates a utility to verify the integrity of T1 and prior Macs
  * <https://twitter.com/su_rickmark/status/1280590602690637824?s=20>
* Aug 13, 2018 - aunali1 begins inquiry regarding Linux support for Apple portables with the T2 chip.
  Subsequently begins research into T2 firmware payload.
  * <https://github.com/Dunedan/mbp-2016-linux/issues/71>.
* Jun 29, 2019 - mrarm begins investigating support for the T2 attached NVMe drive within Linux.
  * <https://github.com/Dunedan/mbp-2016-linux/issues/71#issuecomment-506987345>
* Jul 1, 2019 - mrarm completes PoC Linux driver support for T2 attached NVMe drive.
  * <https://github.com/Dunedan/mbp-2016-linux/issues/71#issuecomment-507325112>
* Jul 3, 2019 - mram begins investigating and reverse engineering the Apple BCE driver for supporting communication
  with the T2 on Linux and associated USB VHCI interface for supporting attached peripherals.
  * <https://github.com/Dunedan/mbp-2016-linux/issues/71#issuecomment-508199545>
* Aug 4, 2019 - aunali1 packages up Linux kernel patches and mrarm’s drivers into installable Arch packages for
  distribution. Becomes current maintainer of patchset and driver code.
  * <https://github.com/Dunedan/mbp-2016-linux/issues/71#issuecomment-517976727>
* Oct 6, 2019 - rickmark postulates the impact of checkm8 for the T2 and proposes that ipwndfu is extended
  to support it:
  * <https://github.com/axi0mX/ipwndfu/issues/141>
* Nov 9, 2019 - rickmark begins research into bridgeOS
  * <https://twitter.com/su_rickmark/status/1193396044752547840?s=20>
* Nov 17, 2019 - mrarm ports SMC Linux driver to support ACPI addressed T2 controller.
  * <https://github.com/Dunedan/mbp-2016-linux/issues/71#issuecomment-554794307>
* Nov 22, 2019 - aunali1 and mrarm begin collaborating on investigating T2’s SEP and overall security model for
  further supporting biometrics on Linux.
* Dec 3, 2019 - rickmark creates patches to libimobiledevice allowing the T2 to be restored outside of Apple
  Configurator and research to proceed
  * <https://twitter.com/su_rickmark/status/1202129990545887233?s=21>
* Dec 15, 2019 - team using version data from SecureROM, it is considered likely that the T2 should be vulnerable:
  * <https://twitter.com/su_rickmark/status/1206292115795271680?s=21>
* Jan 14, 2020 - rickmark performs analysis of USB Target Disk mode which can later be used to transfer data to
  and from the disk of an attached Mac
  * <https://twitter.com/su_rickmark/status/1217347628536492032?s=21>
* Feb 28, 2020 - rickmark postulates the security impact of the USB-C cable (power delivery pins) and how Apple
  factory cables can use these to affect a device
  * <https://twitter.com/su_rickmark/status/1233478919463960576?s=21>
* Mar 6, 2020 - First successful dump of SecureROM of the T2 performed, accepted as proof of the first to execute
  code on the device
  * <https://twitter.com/su_rickmark/status/1260456712898740224?s=20>
* Mar 7, 2020 - h0m3us3r publishes fork of checkm8/ipwndfu with T2 support
  * <https://github.com/h0m3us3r/ipwndfu/commit/4d7932a285ec04a1499694ed58be8d4f975d6dfe>
* Mar 10, 2020 - qwertyoriop uses that branch to add support for T2 into checkra1n
  * <https://twitter.com/su_rickmark/status/1237414287372500993?s=21>
* Mar 10, 2020 - rickmark assesses how this situation cannot be mitigated
  * <https://twitter.com/su_rickmark/status/1237419421913604096?s=21>
* Mar 11, 2020 - German coverage of the T2 jailbreak
  * <https://tweakers.net/nieuws/164492/hacker-omzeilt-beveiliging-t2-chip-in-recente-mac-computers.html?utm_source=dlvr.it&utm_medium=twitter>
* Mar 18, 2020 - Dutch coverage of the T2 jailbreak
  * <https://tweakers.net/nieuws/164492/hacker-omzeilt-beveiliging-t2-chip-in-recente-mac-computers.html?utm_source=dlvr.it&utm_medium=twitter>
* Mar 18, 2020 - First English press of the T2 jailbreak
  * <https://www.idownloadblog.com/2020/03/18/checkra1n-experimental-pre-release-adds-preliminary-support-for-ios-13-4-mac-t2-chip/>
* Mar 20, 2020 - rickmark assesses the impact of the T2 jailbreak on security of Apple Mac’s
  * <https://twitter.com/su_rickmark/status/1240532838555856897?s=21>
* Mar 22, 2020 - rickmark creates first writeup and analysis of the T2 impact created and circulated in industry and on Reddit
  * <https://paper.dropbox.com/doc/OUCHbar--A9CuZXZu3CBHYb2MzShFKQ2BAQ-OSBDo3SOCEetgQy3cGZqx>
* Mar 26, 2020 - rickmark highlights dangers of setting persistence in the T2 synthetic NVRAM (nvram.plist)
  * <https://twitter.com/su_rickmark/status/1243392084171558921?s=21>
* May 7, 2020 - rickmark uses checkra1n to jailbreak a 2020 Mac Pro
  * <https://twitter.com/su_rickmark/status/1258424888160735234?s=20>
* Jun 22, 2020 - rickmark and libimobiledevice add support for iOS 14 which makes use of Signed System Volumes
  * <https://twitter.com/su_rickmark/status/1275210160286265345?s=20>
* Jul 7, 2020 - h0m3us3r successfully connects to the debug interface of the T2 (ARM Single Wire Debug)
  * <https://twitter.com/h0m3us3r/status/1280432544731860993?s=21>
* Jul 7, 2020 - rickmark comments that Intel debug is exposed as well
  * <https://twitter.com/su_rickmark/status/1280590602690637824?s=20>
* Jul 24, 2020 - aunali1 completes PoC bridgeOS SDK and compiles a benchmarking utility which provides first speed
  testand specifications of the T2
  * <https://twitter.com/su_rickmark/status/1286886010681462784>
* Jul 24, 2020 - Pangu releases blackbird an un-patchable Secure Enclave Processor flaw similar to checkm8
  * <https://www.idownloadblog.com/2020/07/24/pangu-hacks-sep/>
* Aug 25, 2020 - rickmark postulates that macOS Big Sur will be installed over USB just like bridgeOS and that
  Signed System Volumes will reduce persistent jailbreaks on the T2
  * <https://twitter.com/su_rickmark/status/1298512629040910336?s=20>
* Sep 21, 2020 - Checkra1n 0.11.0 with T2/bridgeOS support released
  * <https://checkra.in>
* Sep 30, 2020 - News article covering checkra1n 0.11.0 released
  * <https://reportcybercrime.com/hackers-jailbreak-apples-t2-security-chip-powered-by-bridgeos/>
* Sep 30, 2020 - Article above discussed in industry Slack instance (of which Neils is a member),
  rickmark solicits questions, and answers those and others in Slack
* Oct 5, 2020 - A security consultant uses available information to assess the impact
  of checkra1n and the T2
  * <https://ironpeak.be/blog/crouching-t2-hidden-danger/>
* Oct 5, 2020 - Corrections of accuracy compiled and sent to Neils
  * <https://paper.dropbox.com/pad-desktop-redirect?relativePadUrl=%2Fdoc%2FNOTES-Crouching-T2-Hidden-Danger--A9D8yBay8_W2AWSvNn3ifN9fAg-5Fv29pghexoM9jT3KV38m>
* Oct 5, 2020 - rickmark publishes a blog with a more accurate T2 analysis
  * <https://blog.rickmark.me/checkra1n-and-the-t2/>