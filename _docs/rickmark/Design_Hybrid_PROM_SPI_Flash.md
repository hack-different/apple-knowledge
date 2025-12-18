# Design: Hybrid PROM / SPI Flash

# Todays Problem:

Nearly every device makes use of SPI flash for early load boot-loader as well as recovery environments.  These devices are Non-Volatile storage areas that provide the foundation of security in modern computing.  Due to a rash of boot-kits, many manufacturers now make use of PKI based verification of the SPI flash from mask ROM (Intel BootGuard for example).  While this does assist in reducing the likely-hood of arbitrary code execution, it doesn’t solve several problems:


- It doesn’t allow for per-device configuration such as license data, MAC addresses, Serial Numbers, SKUs etc
- “Valid Signed Code” can include malware if the manufacturer looses control of their private key or ever signs a malicious payload, or a development payload/vulnerable payload that can load an arbitrary payload
- May still require complex SPI programmer hardware to read / write in the case of recovery
- Is not clear or understandable to the end user of what it’s guarantees are.  “restore” implies restore to a known good secure configuration like the device was shipped with, while signed boot-loaders just guarantee signed payloads.  Plenty of opportunity exists for other mutable configuration to break those security models (NVRAM for example)
## What consumers really want:

With the physical presence they want the ability to 100% of time get a device back to health.  We will go ahead and make the assumption physical presence may be either trivial or non-trivial.  Trivial may include holding the power button for an extended period, a specialized “reset” button, or the like.  Non-trivial would include opening the case of a computer and removal of a jumper.  Both of these should be hardened processes that make use of the PMU directly to ensure the device is pulled though hard reset, all memory is flushed, all other hardware is pulled into power down and they cannot be accessed via software control.  

By using this it can be put into true “factory restore” as in exactly what the device originally came with.  This prevents the use of a valid signed configuration / payload to prevent the user from reclaiming hardware where an attacker had unmitigated physical access for a moment in time.  While this does in fact downgrade the firmware by design, an old, physically attested firmware is a better choice than an inability to get to a valid state (examples include PKI changes, or AMT enablement on Intel hardware, changing anti-rollback tokens to higher then available values).

**Apple implemented this largely with their** `**SecureROM**` **concept but fell short in a number of ways:**

- Firmware for various other controller come up that can interfere with this process, such as the Power Manager, and the USB-C / Thunderbolt controllers
- The restore process for an iDevice is non-atomic and complex.
- A lack of visual indication of this mode or the restore process means that malicious restore devices can choose to spin cycles then exit restore maintaining presence.  
- `SysCfg` is conserved between restores, making it a target for long term persistence.  Any configuration such as this should be:
    - Non-confidential and measurable from the restoring machine
    - Signed by a valid signature to ensure only hardware OEM approved mutations occur

**Intel Implemented this on various firmware restore processes such as the Visual BIOS but failed in other ways:**

- The Intel ME contains large amounts of `MFS` data partition that cannot be reset and can affect the security of the device (CVE `ish_bup`)
- Measurements of the BIOS and OEM keys are not displayed, allowing key-swaps
- Clearing the NVRAM operation doesn’t seem to be respected

**Google implemented this in the** `**fastboot**` **flashing protocol but failed in yet other ways:**

- The Titan-M is consulted for root-of-trust and therefore its own SPI flash is at risk
- It’s not clear that it is possible to pull the device entirely though reset, analysis of the PMIC would be needed
- The EDL mode of the Qualcomm chip can circumvent this
- Portions of the flash area are not restored by this process, such as the radio GM, the FDT/CDT areas (device specific) etc.
- The surface area has been expanded by QSEE / QHEE before `aboot` is run

**Amazon/Annapurna Labs Alpine v2 has yet other issues (common to headless devices, like those that use U-Boot):**

- Re-use of signing keys allowing for developer builds to be flashed to production hardware
- An expectation that recovery comes from later boot components (Serial not exposed, and therefore large HTTP stacks have to be brought up with a full kernel later)


## Implementation Choices

**High Scale Devices - Mask ROM and eFuses and Signed Configuration**
The reason that high scale devices like the iPhone are not entirely from ROM for this are multi-faceted.  Most center around a device and the ability to be refurbished and production-like verification testing.  By making everything ROM it makes it impossible for the device (barring solder reworking) to ever be re-configured for a new consumer.  This is why Apple approached the problem with a SecureROM and SysCfg.  This is overall the most restorable device I’ve encountered, and should the device be taken to an Apple store, and restored on a secure machine is generally highly effective.  The only additions I would add would be PKI based signing of SysCfg (may have to be checked by a later stage) and “breaking” the boot-chain once in recovery, so that a failed restore doesn’t just re-enter a bad state as there is very little visual indication.  (basically, wipe APTicket and iBoot and restore them last, don’t boot if the Baseband isn’t successfully restored etc.).  In addition careful care to ensuring other devices such as PMP cannot avoid restart / DFU with debounce on the volume keys, and the USB-C port controller firmware are the remaining threat vectors.

In addition, Apple and Google like to have “production like” devices.  These are usually gated by some form of eFuse or other tech that selects the SKU version, but a PVT/EVT is not obvious, especially when a tech can move a board between cases. 

Google and Android suffer from being subject to multiple masters.  This means more of the restore process lives in Flash than an Apple device where they have tight ecosystem control.  Still, the use of Mask ROM for the Titan-M, signing of device specific config like the FDT/CDT/Radio GM, and the like would improve the Android restore of higher end devices.

**Moderate Scale - Hybrid chips with write once flash regions**
These devices would still clearly need to make use of PKI verification of SPI as de-soldering and re-chipping a device would otherwise allow unbounded access.  In this case the SPI chip might support 3 region types.  RW/WP/RO.  RW is of course the read write portion.  WP is the traditionally “read-only” (in this case clearly a misnomer as in the case of the Chromebook EC/Titan-M) as this is really an area that is “locked down” early in the boot process and becomes non-RW.  And a third PROM version by blowing a PROM fuse.  This may require doubling the size of the SPI flash chip in these cases, but I find for the several hundred dollar devices in scope that cost is offset by support costs easily.  

**Small Scale Devices - Make Firmware Measurable**
In these devices just being able to pull the firmware and verify the version / if the device is running a particular hash would be an improvement.  

