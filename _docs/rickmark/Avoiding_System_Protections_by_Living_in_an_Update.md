# Avoiding System Protections by Living in an Update Volume

# Observations

In the earliest days of my DTK, I noticed two things:

- The “Signed System Volume” was always “Sealed” at both the volume and snapshot level after restoring the DTK via DFU / IPSW yet the Volume seal was “Broken” and the Snapshot was “Sealed” after a delta update.
- Destroying the hidden, permanent update partition from recovery had, after reboot shows gigabytes of data hidden under `oahd` - or Rosetta II
- The update process is highly dependent on state, largely unsigned.  Given that booting update avoids many security protections it becomes *the* primary target of persistence on macOS / iOS: https://gist.github.com/rickmark/14edc51cb30636609c3e8844e63187d9
- The update process is largely, as expected, undocumented and therefore the security guarantees made by Apple are not verified.  Remember that other vendors may not be open source, but do publish substantially more information or utilize specified open standards (e.g. UEFI Update Capsules).
# Boot Mode Selection and Tasking is Controlled by NVRAM

Delta updates are sequenced as a complex communication utilizing restarts, non-volatile storage (both the Update volume as well as NVRAM), and signatures such as APTicket.  Early in the boot process the device (iDevice, M1 macOS etc) will check for the `boot-mode=update` variable to inform that the boot process should follow along the update sequence path.  A number of other NVRAM variables with `ota-*` names also communicate both information to the update boot as well as store information about progress, failures and retries.  Booting to the update flow is by design more privileged then booting to “normal mode”.  This is true because it is required to have privilege to update and replace the System volume seal.  This is broadly in line with the design of most update systems, for example UEFI will take an update, store it in memory, verify it then pull the processor through reset to unlock the write protection of the SPI flash, perform the update then apply the WP pin (this is in fact done every boot where updates are not being performed as well).


## Never Say the Update is Done

As it is the responsibility of the updater to clear the boot mode, staying inside update is as simple as never clearing the mode.


## The Design Flaw

By mixing a privileged mode that can write “System” with a privileged update of “Data” they have in fact not provided any additional security guarantees beyond a reduced surface area (the passing of data in a ramdisk is egregious).  The privileged update of the System partition should include any data migrators, and the migration step shouldn’t be able to modify system, but should be able to modify data, and finally the normal mode should be able to do neither in a privileged way.

This changes Apples current design from Normal → Update → Normal to a Normal → Update → Migrate → Normal.  Of course each state should do a better job of verifying preconditions as well.  A pressure for perceived reliability means that any recoverable error is silently handled, when the author suspects that the bulk of these in the wild are signal exploitation.  


## Prevention Using the Boot Progress Register


## Verification of Boot Mode via DFU

By using a DFU boot, an IPSW and a personalized version of iBoot / APTicket we can bring up just enough early load code without loading the filesystem (as there is not yet a kernel or Device Tree) to inspect the NVRAM variables using `getenv` commands against the USB recovery protocol. Work is in progress to bring about Python bindings to the required `libimobiledevice` codebase to make this inspection accessible to the field:


https://github.com/rickmark/libibackup

https://github.com/rickmark/libirecovery/tree/python_bindings

https://github.com/rickmark/idevicerestore/tree/python_bindings

# Closing Thoughts

We must ask ourselves would you rather have phones and computers that always seem to be reliable or ones that actually are reliable.  In many ways the “golden era” of personal computer security was the early 2000’s where there was no Intel ME, few co-processors, ROM based BIOS implementations that had been verified for many years, lack of encrypted non-volatile enclaves to hide in, reliable boot from media and Norton Utilities on CD-ROM which could scan the disk for malware.

