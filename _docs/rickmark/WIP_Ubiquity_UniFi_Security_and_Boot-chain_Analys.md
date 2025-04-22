# WIP: Ubiquity UniFi Security and Boot-chain Analysis

# This Paper Under Revision

Due to further analysis, it seems that swapping the secure boot chain for alpine v2 devices early in the boot process via a device tree overlay is possible.  Therefore, this analysis may be based on a malware stack running on a device rather than UniFi’s intended firmware.
[+WIP: Amazon Alpine v2 - Breaking the Secure Boot-Chain](https://paper.dropbox.com/doc/WIP-Amazon-Alpine-v2-Breaking-the-Secure-Boot-Chain-YzfFpGsgdrQo4XwVFnRmd) 

# The UDM, UDM-Pro and the UNVR

These are all devices based on a SoC design from Annapurna Labs (now aquired by Amazon) known as the `alpine` and built on multi-core AArch64 CPUs.  As the devices are not designed for a graphical display they lack the Mali graphics core, and instead emphasize both PCIe and MII interconnects for high speed networking.  UniFi, putting its own spin on the devices also include a STM32 controller over a USB bus to provide for the touch display at the front of the unit.  
The boot chain
As often is the case, it all starts with a Flash SPI chip.  This contains `al_boot`  which is a customized version of das U-Boot.  Unfortunately Flash SPI is not ROM, and at best can be write protected in regions.  This means there lacks a true root-of-trust link from the SoC to the early boot code.  
In order for any device to have a true high integrity boot the OEM public key or public key hash must be burned into OTP ROM.  This is what is done with the iPhone and other Apple devices as SecureROM, the first running code is masked into the actual silicone and immutable.  While this has its own set of problems (see checkm8) it does mean that devices can be restored to health by either restarting them, or restoring them.  This means designers should always favor initial boot phases in ROM not SPI flash.  Qualcomm implements something similar with their PBL (primary boot loader) which will only take one of two paths, dropping to EDL (emergency download mode) waiting for a valid signed payload over an external bus, or booting SBL/XBL with a valid signature.  

It does appear that UniFi does do some secure boot verification in later phases, but the break in the chain early makes this fairly pointless.  They also failed to ensure that one stage of the boot chain cannot boot to an earlier stage of the boot chain providing a problem of boot loader re-enterency.  Executing boot loader code with a state that doesn’t match it’s expected state can and does weaken the secure stance of the system (for example configuring hardware registers or memory layout prior calling the boot loader causing a different outcome).

The UDM and UNVR do have U-Boot that allows for TFTP booting a payload (I usually prefer USB DFU mode, but checkm8 showed how much happens in that stack, ideally a high security device could get UART ZMODEM images), which could allow for recovery from deep malware, or provide a tool for integrity attestation.  The UDM-Pro already has a UART connection inside the case, and could very easily expose this using standard network cable “console cable” like they do on other SKUs.  It does appear though that the UDM and UNVR took different approaches to how recovery is handled.  The UDM uses a partition with a uBoot image for recovery, loading a `rootfs` and kernel, then starting `recoveryd`  which is pretty much a nginx front end taking an uploaded payload which gets passed to the firmware update routines.  

Now here’s where things get weird.  Having only my own devices to analyze it’s hard to tell if the behavior I’m seeing is “as designed” or just more of the “of course this happens to me”.  First thing to note is that on my hardware stack it seems that the kernel is both built with and running debugfs.  It shows as having configured elements of the PCIe bus as both PF (physical functions) and VF (virtual functions).  It is possible the the `alpine` is using the HV and PF/VF as a form of IOMMU, but this again puts us in a hard position of abusing virtualization hardware for memory isolation (virtualization provides this yes, but it is not the intended use, and provides for additional functionality that can weaken the security outcome).  


## `al_boot` and I2C Devices in Preboot

One fascinating detail of the `alpine`  hardware is it allows for any i2c (inter-integrated circuit) device defined on the `i2c-pld` bus to participate in the boot process before the “boot application’. This is similar to option ROM loading in classical PC architecture.  From my experience with the UDM-Pro at least one device does make use of this functionality to execute from stage 2 to stage 3 at “SPD I2C Address 57”.  Stage 3 of al_boot from EEPROM.  Strangely to me the stage 3 loader then re-detects I2C device 57, and executes stage 3 again (with the title “agent_wakeup v2.10”).  The first time stage 3 ends up loading stage 2 again, the second it loads U-Boot.  I think this is just a me thing though as the image is `Jenkins-Bootloaders-BL_al_boot_multi-develop-6` which sounds like the developers are given real boot keys, or that there was a production signed al_boot that would boot developer keys…

More clarification is needed as to what I2C device 57 on the i2c-pld bus is.  I suspect it is the SPI flash chip that backs the al_boot stage.  The full boot log is here (https://gist.github.com/rickmark/f84cc36a7ddf3dd9d76dd9c231855447).   You can clearly see stage2, stage3, an I2C device titled `agent_wakeup` on the `i2c-pld` bus and back to stage2, stage3, then finally U-Boot.  I still need to gather more information about what I2C device this is and in what way it is modifying the system before causing the system to go back to the initial boot phases.  From a very course gist, it seems to be selecting the FDT (flattened device tree) or modifying it in memory before re-entering the stage2 boot loader.  

## Warning - Wilding Here

Since the signing keys are also embedded into the FDT, this might mean a rouge I2C device is able to modify the existing secure boot chain by modifying the FDT and re-entering stage2.  The device would then ignore the call to it by stage3 if it has already executed.


## Fixing Bad Boot Chains

In the case that a SoC doesn’t provide for the ability to do a stage 1 verification on the next boot stage payload, manufacturers should be using ROM instead of SPI Flash for the next stage of boot-loader.  It would be trivial to create an industry accepted branch of u-boot that does nothing but boot a verified next stage, much like SecureROM.  This would mean that no matter the EoP - a device would always boot a valid signed image (albeit possibly outdated without a monotonic counter providing rollback protection).  While this is not totally foolproof, as a motivated attacker could actually use solder rework to replace the ROM chip… this case means that it would require physical tampering to prevent a physically present restore.


## Sign Everything Not in ROM

It doesn’t matter if you have marked your SPI flash “write protected”, a screwdriver, 10 minutes and a SPI flasher can make the device evil forever (hears the song Good Girl Gone Bad by Rhianna).  Every portion of mutable storage critical to boot security must be signed.  These systems are now well understood and manufactures can choose between using a manufacturer signing key, or placing a “device signing key” into OTP memory, or a manufacturer signed “device signing key” into EEPROM.  Manufacturer keys are great for portions that are the same on all systems, such as boot loaders.  Device specific keys are great for portions that are specific to the device that the device itself must sign.  This is usually not for boot loader config, but instead runtime configuration.


## Provide a ROM Based Recovery System

Because “shit happens”, in order to reduce RMA, waste and long term persistence every device should have a “path to health”.  Apple did a decent job of implementing this early with their iPhone / iPod recovery protocols.  The USB specification even includes a fully specified DFU protocol (in fact used by the UDM to configure the STM32 for the LCD display), or using ZMODEM over a console line, or TFTP, just something…


# Debug Kernels and KVM

For reasons I don’t fully understand, the kernel for the UNVR has kernel debug support on.  I think the goal here is to enable some debug functionality like lock debugging.  If these are normal functions of the kernel, they should be moved out of debug.  Production devices should never need “debug” kernels to be able to diagnose in the field hardware problems.  It gives attackers way too much surface area.  Also one I can’t get my head around here is the building in of KVM.  If the UniFi OS system is based on containers instead of virtualization, then it seems to be an unnecessary and huge risk to the device security.  I know it is somewhat in use from `dmesg` log lines about setting up PCIe PF and VF (physical and virtual functions).  I think that the bootloader should be disabling EL3 and EL2 early in the boot phase if they are unused.  KVM should also be removed as it can use para-virtualization technology such as QEMU to blue pill the device.  If the case were that KVM was being used to provide strong isolation between applets, which don’t trust eachother I might understand, but as the technique is `cgroups` and 


# BSD OpenSSH on the UNVR and Dropbear on the UDM/UDM-Pro?

This is one that makes little sense to me, but could have to do with design differences.  From my looking the UNVR uses traditional and hardened `sshd` from the OpenBSD project.  On the other hand my UDM-Pro is running both `dropbear` as well well as an odd script at `/sbin/ssh-proxy` that looks like:

    root@ubnt:/# cat /sbin/ssh-proxy 
    #!/bin/sh
    ssh -p "$(cat /etc/unifi-os/ssh_proxy_port)" -o StrictHostKeyChecking=no -q root@localhost -- "$@"

I can’t tell if this is again, normal behavior for some reason, but promoting all `ssh` connections to `root` seems extreme in this case.

Another interesting quirk of my UDM-Pro, is that it seems to install a SSH key from some part of flash memory.  From my quick reading and understanding, a fixed key like this can given persistent access to the device across reboots without having to place they key directly into the filesystem.  A script at `/usr/sbin/ubnt-ssh-keys-install` looks like this:

    # cat ubnt-ssh-keys-install 
    #!/bin/sh -e
    
    DROPBEAR_DIR=/etc/dropbear
    
    mkdir -p "$DROPBEAR_DIR"
    offset=$((0xe000))
    part=$(cat /proc/mtd | grep '"EEPROM"' | sed -e 's/:.*//')
    
    if [ ! "$part" ]; then
      exit 1
    fi
    
    mtd=/dev/$part
    dss_file="$DROPBEAR_DIR"/dropbear_dss_host_key
    rsa_file="$DROPBEAR_DIR"/dropbear_rsa_host_key
    rm_offset="s/^[^ ]\+ *//"
    
    write_key() {
      offset=$1
      len=$2
      file=$3
      dd if=$mtd skip=$offset bs=1 count=$len of=$file 2>/dev/null
      chmod go-rwx $file
    }
    
    magic=$(od -j$offset -N 8 -t x1 $mtd | sed "$rm_offset")
    if [ "$magic" != "ff ff ff ff 39 31 4e 54" ]; then
      echo Bad magic
      exit 1
    fi
    
    offset=$((offset+8))
    
    while true; do
      # Type: 1 byte, Length: 2 bytes BE
      type_len=$(od -j$offset -N 3 -t x1 $mtd | sed "$rm_offset")
    
      type=$(echo "$type_len" | cut -d' ' -f1)
      len=$((0x$(echo "$type_len" | sed -e "s/^[^ ]\+//" -e "s/ //g")))
    
      offset=$((offset+3))
    
      case $type in
        01) write_key $offset $len $dss_file;;
        02) write_key $offset $len $rsa_file;;
        *) exit
      esac
      offset=$((offset + len))
    done
    
# Abusing the Mutable Data Partition to Override the `rootfs`

In my viewing of `/mnt/.rwfs/` it contains a single directory `data` - this directory creates the entire root filesystem again.  This is then combined with `/mnt/.rofs` which comes from the boot `rootfs`.  The overlay of these two create the full system.  Why Ubiquity would elect to allow for a mutable partition to override the entire filesystem, including such things as `passwd` and the binaries feels like a strange choice.  Yes, some values in `/etc` have to be mutable sure, but overlaying at the root allows for persistent modification of any part of the rootfs, making cryptographic verification of it, well, silly.  Options here could have included linking the mutable portions of rootfs to the peristent volume, and I think this is a huge area where Linux and embedded devices just, aren’t there yet.  There’s no real way to configure what parts of the file tree are default, read-only, or mutable in a simple clear way.  It takes a hacking together of links, overlays and other such trickery to get this to work.   One can also use MAC (mandatory access controls) and SELinux / AppArmor to further prevent modification of mutable regions that shouldn’t be mutable, but that doesn’t fix offline attacks.  As a final option, scanning the mutable partition to ensure that it has the correct data shape, and doesn’t override key folders such as `/lib`, `/bin`/, `/sbin` and the like before mounting the overlay as a belt and suspenders approach is a great one here.

Going another direction, one could implement full on `dm-verity`, but that seems overkill given that these immutable root filesystems are small, and easily verified on boot.  The reason this is suggested is because it is a more widely and heavily invested in solution being the basis of Android and Chromebook security.

As a final “new solution” one could create a LSM (Linux Security Module) that enforced that particular parts of the VFS (virtual file system) come from particular backing block devices.  This would allow for a declarative model of the security of the filesystem tree. 


# UDM-Pro and RAM Disk Union Mounting

In the same vein as above, instead of using a mutable partition as was done on the UNVR, it seems that the UDM-Pro allows for the union mount of the immutable root file system with a RAM disk allowing the overwriting of the `rootfs` files.


## Slightly Suspicious…

While attempting to pull my `.rwfs` I was first greeted to a SEGFAULT as it seemed to recurse into `conf/` though my `tar` command should have correctly respected hard and soft links (wonder if one has a subdirectory hard-link to the parent what happens??).  The second time around I saw this in my output:

    tar: Removing leading `/' from member names
    tar: Removing leading `/' from hard link targets
    tar: /mnt/.rwfs/data/etc/rc2.d/S01ssh: File removed before we read it
    tar: /mnt/.rwfs/data/etc/localtime: File removed before we read it
    tar: /mnt/.rwfs/data/etc/rc4.d/S01ssh: File removed before we read it
    tar: /mnt/.rwfs/data/etc/rc3.d/S01ssh: File removed before we read it
    tar: /mnt/.rwfs/data/etc/mtab: File removed before we read it
    tar: /mnt/.rwfs/data/etc/rc5.d/S01ssh: File removed before we read it
# Using `ubnt` as an Alias to `root`

Again, knowing that I only have my devices to analyze, this one shocked me.  By making `ubnt` and `ubnt@local` equivalent to UID 0 any user/root privilege separation is not possible.  To me this seems like someone is one cookie grab away (and given that UniFi has really no audit trail of user sessions this is way worse… the new UID product improves this) from enabling and setting SSH / root’s password, logging into the box and gaining persistence.  I honestly question the value of user accessible root in the base “UniFi OS” at all.  All root like operations in the base system should be mediated by privileged tools, such as `fwupdate`.  As “UniFI OS” is really an embedded system designed to run containers, removing privileged and most of the tool set from the root slice other then what is required to run, upgrade, backup, restore and attest / diagnose should be the goal.  


## Using a PAM Module to Allow Login over SSH, Without Setting the Password, or SSH Keys Only

Because of the risk of making `/etc/passwd` and `/etc/shaddow` mutable, even if just to set the password hash for SSH access, a PAM module should be used so that these can be set to value where there is not a valid password, or allow them to be generated to random values per boot (dicey because it makes it again mutable…).  Too often either the default password for an embedded device is leaked, cracked, or set by some EoP on the device.  Embedded devices should always prefer SSH public key authentication as this can be FAR stronger like in the case of Yubikey backing.  Also for safety, the device “management console” clearly needs to display the SSH host key to prevent MitM attacks.


# If You Own the Ecosystem, Build a PKI

This is the full subject of another paper, but it comes down to a simple fact.  All device manufactures should place device certificates onto their hardware.  They, if appropriate should also make use of a non-extractable private key via a PUF (physically un-clonable function) to derive this certificate / key into a key that is used per restore / reset.  This prevents a malicious party from simply “running the embedded system” as a QEMU image, and connecting it to the UniFi cloud provider.  This gives strong assurance of connecting to the right device from management consoles.

On top of authenticating the devices to the cloud, if embedded into other devices like the cameras, switches etc, it would allow a much more secure adoption process, knowing that the devices are in-fact both from the same origin.

# Get Rid of Executable Scripts on Embedded Devices, at Least in the Root CGroup

This wont be popular, but when it comes to security, bash is trash.  It can’t be signed and is the source of the term “shell code”.  An embedded device is a closed ecosystem.  There is no reason that all binaries can’t be ELF and signed by the manufacturer.  Along similar lines, there is also no need of Ruby, Python, Perl, Node or any other interpreter in the root slice.  These just provide tools for an attacker to execute arbitrary code once the file is on the device and they can issue an `exec` call of any kind.  This is not to say signed ELF only is a panacea, many programs fail to properly sanitize their arguments, but it does greatly cripple this down to a few known things.  Adding AppArmor or SELinux greatly fixes those problems of improper input handling


# If the Device Updates Atomically, Does it Need APT?

Apt is a great tool, but in the case of the root slice of UniFi device, it is probably overkill.  That and its ability to add sources, or change keys may in fact allow an attacker to pull down additional tooling or override the update source.  This concern is only raised because it seems heavyweight to use apt/dpkg to update the 4 Ubiquity applets, which all share a container.  A better design would be a root immutable system, 4 containers (one per applet) and a final “diagnostic container” that contains tools for the power user.  These could easily be handled by a far simpler system then a full apt database and dpkg install process, since they are in reality just downloading a `rootfs` for each container and some metadata.  And then once inside the container, `apt` and `dpkg` is clearly not needed as the container should update atomically.  Any data files can be updated to the mutable data source atomically as well as a second filesystem image.  `apt`/`dpkg` are fine in the diagnostic image as various tools may wish to be pulled down.

As an example of the insanity for reasons that utterly escape me I see the entire AArch64 GCC collection on my UDM:

    root@ubnt:/usr/bin# ls -la /usr/bin/aarch64*          
    -rwxr-xr-x 1 root root   27488 May 10  2017 /usr/bin/aarch64-linux-gnu-addr2line
    -rwxr-xr-x 1 root root   52040 May 10  2017 /usr/bin/aarch64-linux-gnu-ar
    -rwxr-xr-x 1 root root  354464 May 10  2017 /usr/bin/aarch64-linux-gnu-as
    -rwxr-xr-x 1 root root   22992 May 10  2017 /usr/bin/aarch64-linux-gnu-c++filt
    -rwxr-xr-x 1 root root 3359704 May 10  2017 /usr/bin/aarch64-linux-gnu-dwp
    -rwxr-xr-x 1 root root   31336 May 10  2017 /usr/bin/aarch64-linux-gnu-elfedit
    -rwxr-xr-x 1 root root   94288 May 10  2017 /usr/bin/aarch64-linux-gnu-gprof
    lrwxrwxrwx 1 root root       6 May 10  2017 /usr/bin/aarch64-linux-gnu-ld -> ld.bfd
    -rwxr-xr-x 1 root root 1155088 May 10  2017 /usr/bin/aarch64-linux-gnu-ld.bfd
    -rwxr-xr-x 1 root root 5425256 May 10  2017 /usr/bin/aarch64-linux-gnu-ld.gold
    -rwxr-xr-x 1 root root   40600 May 10  2017 /usr/bin/aarch64-linux-gnu-nm
    -rwxr-xr-x 1 root root  195632 May 10  2017 /usr/bin/aarch64-linux-gnu-objcopy
    -rwxr-xr-x 1 root root  336080 May 10  2017 /usr/bin/aarch64-linux-gnu-objdump
    -rwxr-xr-x 1 root root   52048 May 10  2017 /usr/bin/aarch64-linux-gnu-ranlib
    -rwxr-xr-x 1 root root  505424 May 10  2017 /usr/bin/aarch64-linux-gnu-readelf
    -rwxr-xr-x 1 root root   27344 May 10  2017 /usr/bin/aarch64-linux-gnu-size
    -rwxr-xr-x 1 root root   27456 May 10  2017 /usr/bin/aarch64-linux-gnu-strings
    -rwxr-xr-x 1 root root  195640 May 10  2017 /usr/bin/aarch64-linux-gnu-strip
    


