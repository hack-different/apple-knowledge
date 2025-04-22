# WIP: Intel Goa’uld (Dark Symbiote)
**WARNING: Contains early research and conjecture…**

******OTHER WARNING: Probably no new major CVE, just an analysis of real world usage of existing ones and potential MFS misconfiguration with OEM signing keys.  (E.G. the finding of AMT tech on a consumer Intel NUC + PCH debugging enabled)**

# About the name…

Look… Lots of Stargate SG1 was playing while I slept, waking up to realize why the Intel ME layout was like it was (two copies of the Boot partition sharing pages making it impossible for it to be for reasons of resiliency).  Because it includes an Intel AMT/ME/CSME host and “guest” as well as a UEFI host/guest division, and it’s an evil force that takes advantage of its host, can hide in plain sight….  Also SymBIOSis makes ma laugh, and it has similarities to other ACPI dark-wake attacks…

Also when you’re looking at `maestro`, `vermanus loader`, `arben`, `hotham`, `snowball`, `sigma` you have to be a little punchy too.  (Not saying every word of that is kit specific).  It’s also highly likely that I’m observing an in-the-wild usage of this CVE: https://www.zdnet.com/article/intel-csme-bug-is-worse-than-previously-thought/ trying to detangle undocumented components vs malicious ones.

# Play at home with the capture…
https://www.dropbox.com/sh/6gcgbeor709hqig/AAC5InYhG_uRFf3QOCcBiNIxa?dl=0?dl=0


[https://www.dropbox.com/sh/6gcgbeor709hqig/AAC5InYhG_uRFf3QOCcBiNIxa?dl=0](https://www.dropbox.com/sh/6gcgbeor709hqig/AAC5InYhG_uRFf3QOCcBiNIxa?dl=0)

# Apriori:

[+Intel x64 Hierarchy of Privilege](https://paper.dropbox.com/doc/Intel-x64-Hierarchy-of-Privilege-6uFseu7zXJg6v1gjLs1mq) 
https://blog.t8012.dev
[+Abusing EFI Variables and the AMT](https://paper.dropbox.com/doc/Abusing-EFI-Variables-and-the-AMT-lnawIcJBvIpbZj1zPSbxf) 
https://www.intel.com/content/dam/www/public/us/en/security-advisory/documents/intel-csme-security-white-paper.pdf
https://edk2-docs.gitbook.io/understanding-the-uefi-secure-boot-chain/secure_boot_chain_in_uefi/intel_boot_guard

https://www.intel.com/content/www/us/en/architecture-and-technology/intel-active-management-technology.html

https://www.intel.com/content/www/us/en/support/articles/000007452/intel-nuc.html

# Current Working Hypothesis
## The Core, `ish_bup`, The AMT and a CSME kit
- ME runs old Intel ME 11 with `ish_bup` CVE (this chipset lacks ROM rollback prevention) from one ME partition.  (`CSE Main` containing `bup`, `kernel`, `syslib`, `icc`, `dal_ivm`, `tcb`, `sigma`)
- ME runs hybrid CSME 11/12 with custom AMT OEM key + Boot Guard and `rbe` as well as essential features such as power management, snowball, and the Java VM
- The `MFS` data partition is shared amongst both personalities, easily done as the Main is lightweight
- These two personalities are stored in two Boot tables that share pages:
- 
![](https://paper-attachments.dropbox.com/s_3995126A312D89C3B54B9B9EE6A9EC443D492BAA5111D7A8A2B8B0DEC8C639AB_1631377672887_image.png)

- Intel ME makes use of SR-IOV to share the Intel Gigabit Ethernet hardware
## The UEFI Hosting Environment
- `rbe` decompresses `8MB` SPI flash into `16.8MB` runtime area
- UEFI Boots AMI Text BIOS (NB)
- Loads early DXEs causing the dual driver issue later
- Contains custom PK/KEK/db/dbx
- Delta compression also explains the dual NVRAM areas which are largely or wholey duplicate (loaded at base address `0x800078` and `0x830078`)
- Intel VT-d is leveraged to control hardware during the OS runtime phase
## The UEFI Guest Environment
- Runs Intel Visual BIOS payload as a secure boot UEFI Capsule under AMI BIOS (SB)
- Update / Restore Code copies out only the “Intel Visual BIOS” EFI App - maintaining persistence, as any UEFI Protocols would maintain backward compatibility
- Causes reloading of core UEFI modules (double driver problem)
- By now it is too late to access the root UEFI
- By the time the Gig Ethernet adapter is brought up in UEFI Shell it is ID 0x6 - making it a highly virtualized device, likely to facilitate loopback AMT / iSCSI / PXE (it also seems to like to use the MAC address `888888888788` for these purposes:
![](https://paper-attachments.dropbox.com/s_3995126A312D89C3B54B9B9EE6A9EC443D492BAA5111D7A8A2B8B0DEC8C639AB_1631377277923_image.png)

- The Gig Ethernet adapter comes up under the “Managed Network Profile” and is immediately attempting to reach back over IPv4/IPv6 to a IPSec host via IKE (port 500)
## Restore / Update Persistence
- By using `RomLegacyLayout` DXE and a Faked JDEC part (`parseIntelImage: SPI flash with unknown JEDEC ID 207018 found in VSCC table`, decoding to `STMicro` as a manufacturer part ID `0x701B`), a firmware update capsule can be “applied” and then delta compressed against the working payload, with blacklist DXEs removed.  A new runtime capsule is generated and stored
- A capsule is just a verified, UEFI executable, so the payload and the loadable code areas are separate and parseable
- The capsule then drops permissions to be able to write to real SPI 
- Explains the usage of NVRAM to store the version of the UEFI payload and lack of variation on some components across updates
    - `FirmwareIdGuid` stored in NVRAM as example
    - 
![](https://paper-attachments.dropbox.com/s_3995126A312D89C3B54B9B9EE6A9EC443D492BAA5111D7A8A2B8B0DEC8C639AB_1631377440962_image.png)

- Avoid SVN increments by being `0xFF`
----------
## EFI Variable (offset = 0x0):
    > Name : SinitSvn
    > Guid : ee5edcac-1490-a44d-820f-d43b78010ec3
    > Attributes: 0x3 ( NV+BS )
    > Data:
    > FF |
## Tricking the Runtime with NV vars shadowing BS / RT vars


## Storage / Hiding of data in RAW areas and “Invalid” vars


## Analysis: Nothing Novel / new-CVE - But a Real World Kit-Ware and TTPs
- Usage of AMT maliciously isn’t new (has happened to me in the past San Francisco circa 2017)
- `ish_bup` flaw plus a ME rollback seems plausible
- Dual-personality of CSME via `ish_bup` seems new, they share a MFS
- Usage of BootGuard to keep into a malicious UEFI 
- Usage of SecureBoot to keep locked into a UEFI BIOS as a Capsule / App is new
- Ramdisk / iSCSI / ACPI injection into next HLOS is new / advanced
- Abuse of Intel Silicon Debug MSR80, especially from an OS seems novel
- CSME Java VM / loader is interesting
- Long term persistence via `snowball` and DRM of code via PAVP is novel


# Delta in the ME File-System (MFS is stored generationally):

The “OEM” configuration: https://www.dropbox.com/home/Public/Dark%20Symbiote/unpacked_ime/MFS%200000%20%5B0x006000%5D/007%20OEM%20Configuration?preview=home_records.txt
My custom configuration (with a new defaults section with prior values): https://www.dropbox.com/home/Public/Dark%20Symbiote/unpacked_ime/MFS%200000%20%5B0x006000%5D/008%20Home%20Directory?preview=home_records.txt


# The Two Personalities of the CSME:

Note: Not at all mad at them (it’s not in their scope of control), but this is from a System76 version of the Intel NUC known as the `meer4`, these devices did not and never have had the AMT as an option.  It appears there is a file in the MFS that is called `cse_part` which mediates which CSE boot profile is used.  (Note one is CSE Main while the other is another variant of the CSE with `rbe` defined as the CS/ME injected ROM Boot Extension - typically for implementation of BootGuard)

![](https://paper-attachments.dropbox.com/s_3995126A312D89C3B54B9B9EE6A9EC443D492BAA5111D7A8A2B8B0DEC8C639AB_1631202638038_image.png)


Both boot partitions reuse the same pages for code modules and share one MFS, one is more advanced than the other and includes a non-fully intel chain of signing.  The latter “CSE Main” includes the AMT portion (`mctp`) including the Java VM (`dal_*`) and the OEM signed Intel Sensor Hub bring-up `ish_bup`, while the other contains a full BootGuard stack (`rbe`) - coresponding to `RB` in UEFI, power manager, and custom signing elements.  In order to get a better view it might be required to patch UEFITool NE to be more forgiving of clever use of the partition tables in this way…

![](https://paper-attachments.dropbox.com/s_3995126A312D89C3B54B9B9EE6A9EC443D492BAA5111D7A8A2B8B0DEC8C639AB_1631202897319_image.png)

## Living through S5 without a battery…

Enter `snowball` - a module that takes advantage of NVMe to save and persist host state even when power is fully removed.  This allows for a much larger kit to live through power removal than would exist if only NVRAM / SPI Flash were in use.  It’s preferred method seems to be NVMe namespace or encrypted swap.  The CSME was already able to persist small portions of data using `susram` (aprox 3kb) but snowball is intended for a much larger hibernate like persistance of data.  References to `bioscomm`, `svimgboot` and `imagesrc` in `susram` imply that the CSME is able to push the x64 cores into restore from suspend to disk at any time.


## The Converged Security / Manageability Engine (CS/ME), brought to you *MOSTLY* by Intel…

The `Intel Sensor Hub` allows OEMs to sign `ish_bup` which puts them in the critical path for security of the CSME.  What if you brought up the CSME as a sensor of itself?  Add to this the `OEMP` which allows the OEM key to be included into the CSME portion of SPI, this with `rot.key` seem to allow arbitrary change of the trust anchors that Intel spends doc after doc convincing us it has a valid chain of trust for…. The PMC is signed and included in one of the two personalities.  Finally a signed `RBEP` / `rbe` module is included in one personality but not the other.  (Those are the portions of this system that seem to be signed via valid chains, meaning other components are either valid or signed by those keys).


## How to weaponize the Intel Sensor Hub…

It appears to me that someone somewhere created an ISH based on a x86 core, just like the one running the ME 12 on the PCH.  This has the unfortunate effect of making it possible for the PCH to become a sensor hub unto itself.  Combine that with the custom signing of `ish_bup` and a little IPC (inter-process communication) magic and you can run the Intel ME as a guest of itself.  There’s even a module known as `ish_srv` that is intended to serve the boot image from the CSME to the sensor hub for boot (assuming it has no mutable storage of its own).

**Taking control of the dTPM and giving clients the fTPM…**
By integrating `fpf` the TPM can be used to replace the dTPM on a board.  The dTPM can then be used by the kit for its on purposes.  This includes the Secure Boot policy system.

**Leveraging the Power Manager**



## Living off the land… Java VM, AMT, HDCP/DRM…

One thing I’ve observed is if it isn’t broke, don’t fix it applies.  Instead of inventing new network protocols, use `mctp`, protect your code and data with `pavp` (protected Audio/Video path) or the default DRM / HDCP component… Even have the guest CSME re-use the standard `ish_svr` (and `/home/ish_srv/INTC_pdt` and `/home/ish_srv/trace_config`) to send itself its CSME image.  The AMT / ME has grown to such a large closed source and undocumented size that any kit only need glue valid signed modules (and the Java runtime + the dynamic loader is wonderful glue…) together to be able to exist.  Combine this with a lack of the ability to test for the presence of these modules until far after they are loaded…. Mine were stored in a signed module called `NFTP` that included many core AMT technologies in the second ME personality.  The generic `loader` module is configured for the non Intel signed code regions that make use of dynamic loading capabilities.  (It is configured in the MFS data portion, mine had configuration for `arben`, `audio`, `ish`, `iunit` and `iup_upd` as well as `svns`).


## The AMT has always been able to control boot flow…

Because one is using the AMT in the stack, we have signed modules that can influence a valid signed UEFI boot process.  


## USB HECI - USB Host Controller Interface



## Did we really need nested virtualization???

Still looking but I suspect `HVMP` is part of the bringup of a hypervisor that is UEFI capable.  


## Inter-process communication on the CSME…
![](https://paper-attachments.dropbox.com/s_3995126A312D89C3B54B9B9EE6A9EC443D492BAA5111D7A8A2B8B0DEC8C639AB_1631274322464_image.png)



## The `policy` module and the `MFS`

Recall that the data portion of the Intel ME is far more malleable than code.  This is by design, as for instance we want to set our AMT configurations, but not by definition allow the AMT to run arbitrary code in the CSME.  The `policy` module makes use of data found in the `MFS` but can configure greatly powerful things like gating the debug policy of the silicon as well as enable `vPro` or the AMT stack.  One bad write to the SPI flash and your Intel ME can become much larger in scope due to this.  (The area is not signed).  


## The Intel Power Manager

Looks to be a custom signed OEM module built on ARCCore (the same ISA of previous Intel ME versions).  Lives in its own `PMCP` that includes the `PMCC000` code section and an `ERTABLE` as well (verify but likely the config run on the CSME side).  This would have to be customized for `/snowball` to work correctly and to transition through power states such as firmware flashing.


## Abusing Intel BootGuard to inject early EFI code…

Now that we can demonstrate that the root of trust can be broken by `ish_bup` it’s not surprising that we can affect lower levels of privilege such as the UEFI region.  Typically the CSME does BootGuard by booting to an authenticated boot area which then verifies the SPI flash before continuing.  Our evil host can do the same by modifying `IVBP` as well (See Integrity Check-Value and Integrity Check Private Key).

**A cooperative host EFI payload…**
The UEFI partition has a DXE called `MePlatformReset` which may be the point which switches from the AMT version to the lowered version locking away the services behind SMBios.  My hosting EFI payload was a AMI UEFI from 2018 while the “guest” was the Intel Visual BIOS from 2021, strangely the version name was stored in NVRAM, implying that the evil host wants to allow arbitrary “guest” UEFI upgrades without disturbing the host.

Other interesting portions included DXEs being loaded without an identifiable backing FFV.  This must mean they are coming from another source such as directly being placed into DRAM via DMA.

`**iunit**` **and Serving OS Boot over iSCSI**
The same references to `DUMMY` ATA devices occurred in the `iunit` module, making me fairly sure the intent is to support iSCSI virtual LUN boot redirection (more advanced then IDEr which isn’t approprate for IDE’less systems and is more compatible with the `sg` or SCSI generic  / `bsg` block SCSI generic driver surface area)


## Once in EFI…

It’s not too hard to hand a faked HOB to a “guest” BDS, use and modify the result to leverage iSCSI and PXE to boot from a faked image on the other side of the ME personality (persisted thanks to snowball).  This lets a large adaptive kit run to inject itself intelligently into hypervisors, para,-virtualized kernels, boot-loaders, etc.

It seems this partitions the UEFI into a `SB` (Secure Boot) and a `NB` (Native Boot?) area mediated by `SBRun`.  This is a clever use of the Secure Boot system locking our user into a specific UEFI workload, the UEFI bios of our expected system itself (in my case Visual BIOS).  The Secure Boot policy of the native UEFI (AMT Text BIOS in my image) is held in the dTPM, while a new fTPM is presented to the guest image for its use.  Because of the use of copy on write or other non-reset technique, this has the unfortunate effect of causing DXEs to be loaded from both portions.  I noticed `NTFS` and `iSCSI` and a large part of iPXE being loaded a second time.  UEFITool also found two `FIT` tables in the payload, where the host appears to be a 2018 copy of AMI text BIOS and the guest is a 2021 copy of the Intel Visual BIOS.  Two copies of the uCode also exist at the two points in time as well.


![](https://paper-attachments.dropbox.com/s_3995126A312D89C3B54B9B9EE6A9EC443D492BAA5111D7A8A2B8B0DEC8C639AB_1631200068986_image.png)

## Handing UEFI Updates…

A specialized DXE providing access to the ROM layout allows a synthetic SPI flash to be created, accept an update then have the firmware layout pulled apart to a point where it can be persisted for run from `SBRun`.  This is because UEFI updates come often in the form of “UEFI Capsules” which are signed payloads that can be executed from high privilege levels where SPI is unlocked.  It’s a combination of the update code as well as the payload, therefore the easiest way to be adaptive is to let the code run and to inspect the results from a virtual backing store.  This explanation validates why the Intel NUC suddenly no longer wises to accept updates from the recovery mode of having the security jumper removed.

## Downstream effects…

**Warning: don’t put too much stock in this section…. By now things are sufficiently hosed up (DUBIOUS AT BEST analysis)**

Overall the theme here is I kinda refuse to believe that the OS that requires me to manually configure loading of `lvm2` and device mapper would automatically bring up a NFSv4 server, a static key for `brltty` generate and activate `sshd` and `GPG` keys…. But I could be wrong…

I found that `snowball` preferred my NVMe drive, as the concept of NVMe namespaces already exist and allow it to “carve” a portion of storage for itself.  For AHCI / SATA drives, it seems that `dummy` ATA devices are the method.  (The device is unplugged once it’s been used).  My NMVe device had a `wwn` or iSCSI world-wide name associated with it across a mac address that cannot exist.  The initrd of my Arch install also made use of a ieee1394 device for serial (assuming this is used for SOL / KGDB when KGDBoE isn’t possible).  During kernel load a number of PAT table mappings overlapped.  The initrd also created a number of units such as `remote-fs.target` that were cleaned-up on transition, also units that dynamiclly generate initrd on every shutdown, including the early load kernel event that stores uCode in initrd `save_microcode_in_initrd`.  The first protocols to come up included `NetLink` and `CALIPSOv4` (`remoteproc_init`, `ras_init`, `nvmem_init`, `devlink_init` and `nexthop_init`) all before initrd is unpacked.  `brltty`  and “bluetooth meshing” were then included.  The `batman`  network protocol also is brought into scope.  The remote FS also made use of cyrpto as well.  Arch ZKOs were signed by a dynamic generated key rather then the true Arch x509 and iwlan `sforshee: 00b28ddf47aef9cea7` key.  The ethernet adapter complained bitterly about being brought up the third time in the device with the same DMTF WMI GUID.  TTYs on the system were backed by the driver Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled.  The "agp arbiter” came up as well in a strange way as well as many many calls to the `fjes` module as well.  A number of generated initrd units are later “cleaned up” which only leave the trace that they executed, without the ability to inspect the unit file.  They are symbolic links in initrd to hash file names that do not exist.  The system also seems to invalidate the entire GPG keyring from arch and creates its own.

Generated systemd units (may well be legitimate but easy to trigger incorrectly - like nfs-server):

    [   76.029865] systemd-hibernate-resume-generator[293]: Not running in an initrd, quitting.
    [   76.033309] systemd-fstab-generator[290]: Parsing /etc/fstab...
    [   76.037654] systemd-bless-boot-generator[287]: Skipping generator, not booted with boot counting in effect.
    [   76.039296] systemd-gpt-auto-generator[292]: Reading EFI variable /sys/firmware/efi/efivars/LoaderDevicePartUUID-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f.
    [   76.040289] systemd[281]: /usr/lib/systemd/system-generators/systemd-bless-boot-generator succeeded.
    [   76.043949] systemd-gpt-auto-generator[292]: open("/sys/firmware/efi/efivars/LoaderDevicePartUUID-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f") failed: No such file or directory
    [   76.052434] systemd-gpt-auto-generator[292]: EFI loader partition unknown, exiting.
    [   76.056795] systemd-gpt-auto-generator[292]: (The boot loader did not set EFI variable LoaderDevicePartUUID.)
    [   76.061329] systemd-gpt-auto-generator[292]: Neither root nor /usr file system are on a (single) block device.
    [   76.085134] systemd[281]: /usr/lib/systemd/system-generators/systemd-cryptsetup-generator succeeded.
    [   76.087600] systemd[281]: /usr/lib/systemd/system-generators/systemd-gpt-auto-generator succeeded.
    [   76.089842] systemd[281]: /usr/lib/systemd/system-generators/rpc-pipefs-generator succeeded.
    [   76.092091] systemd[281]: /usr/lib/systemd/system-generators/systemd-veritysetup-generator succeeded.
    [   76.203831] x86/PAT: Overlap at 0x7a9a4000-0x7a9a5000
    [   76.206008] x86/PAT: memtype_reserve added [mem 0x7a9a4000-0x7a9a4fff], track write-back, req write-back, ret write-back
    [   76.208324] x86/PAT: memtype_free request [mem 0x7a9a4000-0x7a9a4fff]
    [   76.987132] systemd[281]: /usr/lib/systemd/system-generators/cloud-init-generator succeeded.
    [   76.989545] systemd[281]: /usr/lib/systemd/system-generators/systemd-system-update-generator succeeded.
    [   76.991947] systemd[281]: /usr/lib/systemd/system-generators/nfs-server-generator succeeded.
    [   76.994410] systemd[281]: /usr/lib/systemd/system-generators/systemd-debug-generator succeeded.
    [   76.996842] systemd[281]: /usr/lib/systemd/system-generators/systemd-hibernate-resume-generator succeeded.
    [   76.999296] systemd[281]: /usr/lib/systemd/system-generators/netplan succeeded.
    [   77.001764] systemd[281]: /usr/lib/systemd/system-generators/systemd-fstab-generator succeeded.
    [   77.004239] systemd[281]: /usr/lib/systemd/system-generators/systemd-run-generator succeeded.
    [   77.006733] systemd[281]: /usr/lib/systemd/system-generators/systemd-getty-generator succeeded.
    [   77.009227] systemd[281]: /usr/lib/systemd/system-generators/lvm2-activation-generator succeeded.


- Netplan uses Open Virtual Switch to setup a network between elements of the system (LAN, BT PAN, WiFi)
- Hibernate resume generator seems to be handling the creating of initrd re-generation logic.


Strange Targets:

- `brltty-device` - useful as a bluetooth based tty into the system
- `darkhttpd.service` - great for becoming one’s own pacman mirror
- `initrd-switch-root.service` under `/usr` - for a second root-fs switch away from the network mounted version to the “real” root.
- `machine.slice` - a part of the namespace control group tree that cannot be seen in cgtop
- `mkinitcpio-generate-shutdown-ramfs.service` - initrd is normally only regenerated on shutdown when updates are applied, this one seemed unconditional
- `nfsv4-exportd.service`
- `nbd.service`


## Terms - Made up mostly

`/snowball/sbbistres` - secure/secondary boot BIST (built in self test) response
`/home/mca/3LVLSCD.dat` - 3rd level SCD (reminds me of SLAT)
/fpf/intel/SbAcmSvn
/fpf/intel/SbBsmmSvn - secondary boot B? System Management Mode - Security version number
/fpf/intel/SbKmSvn 
**Storage Mechanisms for fTPM**
/fpf/intel/Emmc
/fpf/intel/Ufs
/fpf/intel/Spi

# Whats the point?

Year after year we add additional phases of security and boot integrity.  Hypervisors here, secure elements there… but in reality what we have done is ensure a failure of any of these systems is non-observable.  By focusing on confidentiality, we truly have lost integrity in our computing environments (👀  TCG).  Why “restore from ROM” and “create measurements using ROM” and “export code from ROM” are not things that more IoT and devices implement might (grabs tin-foil hat) be motivated by state actors who want control of environments without it being possible to observe (👀 NSA).  Sadly they missed one important point, any such engineered design flaw will quickly be reverse engineered, and re-weaponized.  The TCG should re-focus on publishing known good configuration, making specifications and code for early load boot security FOSS, and creating high integrity read-only out of band measurement (remove jumper, boot from ROM and have OEM hash displayed on the screen without executing any non-Intel code) a higher priority.

