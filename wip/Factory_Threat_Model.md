# Exploring What AppleInternal Users Can Abuse

This article dedicated to those I've personally known who've worked in Factory Process,
the misuse of which drives this research.

## Factory Trust

From data gathered by looking at disk images in the wild, it appears that
there are not just "customer" variants of the Restore and Upgrade disk images
typically used in DFU based recovery, but also factory versions used in initial
imaging and refurbishment.  The factory variants, unlike customer, do not use a strict,
internal state machine to perform this process.  This is logical as factory
needs to do additional privileged operations such as:

* Component Testing / Quality Control (burn-in)
* Calibration
* Configuration of device specific identity (setting of wireless and bluetooth MAC addresses)
* Creating the device parts manifest (the wrapped set of serial numbers that make up the unit,
  including main logic board, display, TouchID, etc) which is then stored in FDR (SysCfg in the
  cloud) and placed onto the device storage.
* Pairing, or the process of cryptographically binding the SEP with the TouchID or FaceID
  components.  Because these use a secure channel, they must exchange keys before use.
  (This lead to numerous issues related to FaceID and TouchID with unauthorized repairs,
  as the repairing worker was unable to modify the SysCfg manifest and pair the new components).
  This key exchange ensures that the components are protected from MitM (Man-in-the-Middle)
  attacks.
* Generation of key material.  The UID is generated on the AP/SEP itself during an initial run
  and stored in non-extractable fused memory of the AES hardware.  Should this not occur the
  UID would be a "clear key" consisting of all zeros/ones, and would not provide protection for user
  data.  Furthermore, it's likely that a blank board can run a "less then authorized" payload
  to fixate the key to a known value (Key Pre-imaging Attack)
* Fusing.  Devices must be moved from PVT (Production Validation Test) to MP (Mainline Production)
  after successful testing to put it into a customer ready state.  This takes devices and lowers
  them to `CPFM:03` which is a secure production device.
  * There are additional OPCODE based operations that can be executed when the boot manifest
    includes the `rcfg` (reconfigure boot) and `recm` (reconfigure mode) or "Reconfigure"
    entitlement.  These operations center around the reading, modification and writing of
    protected registers.  This is likely how key components setting board ID, of fusing and
    device identity change in refurbishment.
  * Additional details in iBoot indicate that the fuses are "sealed" (meaning its cryptographically
    validated) and that it is somewhat mutable via the correct `rcfg` provider.
* Refurbishment.  Refurbishment of a unit requires that components be re-tested and paired.
* Installing the initial operating system and firmware

Evidence of factory programming occurs in tickets that are issued from `Factory` ICAs (intermediate
certificate authorities) as opposed to the typical DataCenter seen in customer based device restore.
There are additional manifest properties that are respected by these internal signing servers,
some of which include `sika`, `ftap`, `ftsp`, `rfta`, `rfts`, `uidm`, `sidm`, along with the
`DPRO`, `DSEC`, `MPRO`, and `MSEC` properties to establish the effective security mode.
These properties, in addition to the Factory Boot Disks, Developer Disks and Personal Disk Images
allow for non-customer restore flows.

## Reconfigure to PVT, and Factory Trust

The usage of `rcfg` boot to alter the board ID down to the PVT variant permits the usage of
factory trust keys for boot.  By switching down to these keys, the protections of TSS can
be avoid, and other privileged IM4M keys can be utilized.

## RamRod

Ramrod is a plugin to the OTA process (`patchd`) that allows for the restore of a full OTA, as well
as other unusual features, such as NVRAM shadowing, custom sequencing and skipped phases.  It will
often end up as `(null)` as the component in some OTA logs.  The combination of a restore of a
lower macOS version, plus the usage of `ramrod` to update it permits the security of the
operating system to be subverted and can be made persistent by failing to complete the update flow.
This is advantages for a few reasons, one it uses a supported component to enter the recovery
environment, which has lower security settings to enable the laying down of firmware to hardware
component and lacks System Integrity Protection.

Ramrod also has native support for NVRAM shadowing, or the ability to redirect writes to protected
keys to a backing NVRAM plist.

## Clear (Zero) Hashes and Keys

By fixing hashes to a sequence of zeros, once a APTicket is issued it may be re-placed onto a device.
Zero keys can be observed both the for xART root UUID (00000000-0000-0000-0000-000000000000) as well
as the initial values for BNCH domain nonces.

This combined with the usage of Zero nonces for the boot nonce domains further extends predictable
concerning to the other components of the boot path.

## HyperVisor `hypr`, Application Virtualization (Rosetta) `appv`, Root Domain (`hop0`) and `hop0`'s SysCfg `0Cfg`

For Apple systems historically the `hypr` role is filled by the SPTM, but with newer Apple Silicon
this have moved from EL2 to Guarded Execution Roles.

In "self hosted factory trust" the `hop0` partition is used to act as the restoring station, and
a `hypX` partition is the restored station.  This manifests in the FDR cached data as unlabeled
parts (those without any prefix such as `fCfg`, `dCfg`, etc), those of the `hop0` host station
(`mansta`) and those of the restored device station `mandev`.  This allows the `fSys` or Firmware
SysCfg and `0Cfg` or `hop0` domain 0 SysCfg to be stored at the root NOR part, while EAN can be
leveraged for the per OS `fCfg`.

The domain zero kernel is privileged above other virtual machine instance, and `hypX` lacks root level permission.
An example of this would be access to the `system` NVRAM namespace.  This means that should an
attacker gain control of `hop0` they can start a blue-pill like environment for any other domains.
To do so would typically require a local recovery policy with lowered security settings, as
non-recovery is a limited permission boot mode.

### The Trusted Execution Monitor

`appv` is considered a boot image to begin execution once a new EL1 domain is established.  Typically
this is simply a small shim to begin execution of the XNU kernel once EL1 is properly configured and
to service minimal HVC requests.

## Re-entrant iBoot and SEP

To support differing versions of the sepOS and related services the device root SEPROM will load
the system level `sepf`,`sepi`.  SEP Firmware or `sepf` payloads are de-novo images that are
decrypted by the SEP GID and then executed at the root firmware level.  Booted Image Firmware
(`sepi`) are combinations of the firmware as well as memory data that is launched per-operating
system (typically used for restoring the SEP memory after hibernation).

To support updates to the booted image, supplemental `sep-patches` images can be applied to
alter the code and readonly regions on the fly.

## iBoot (`ibot`), iBoot Data (`ibdt`), secondary iBoot (``)

### iBoot Data

Typically provides DDR timing data, which can affect the security of the system by reducing the
time for a bank clear operation (the number of nano/pico seconds) a cell must be drained to be
considered to be a zero state.  Additionally lengthening the charge time for a cell can cause it
to be over-charged, increasing its durability across a PoR or Power-on-Reset event.  The combination
of these two properties can allow for conditions where memory is retained across a PoR, permitting
situations such as the existence of a SecureROM copy at the DRAM address thereby subverting the
typical assurances of being copied from ROM (The header stub copes from ROM to memory, and is
only tested by if the execution location is greater or less then the SecureROM base address).

## Usage of Local Policy and Local Trust Keys

## FDR, Managed Station and Managed Device

FDR or "SysCfg in the Cloud" allows blobs of data to be retrieved by the restoring system through
a proxy mechanism implemented by the restore station.  This permits the restoring device to
request and retrieve the 4CC binary objects for placement onto persistent memory.  There are multiple
trust primitives in the FDR system:

* The `trst` or at rest signing certificate
* The `rssl` or TLS trusted root certificate for communications with the FDR service
* The `rvok` or revoked Certificate / Key list
* The `trpk` or trusted public keys (additional to the one in the `trst` certificate)
  normal restore process appears to contain the `trst`, `rssl`, an empty `rvok` and no `trtk`.
  Factory trusted installs seem to contain a `trpk` that is a sequence of public keys that may
  additionally be used.

## Communication with `hop0` via RemoteXPC

The HyperVisor Partitions are connected using synthetic USB NCM/CDC devices, usually annotated as
apniX (Apple Private NCM Interface).  This provides a transport mechanism between the domains over
the virtualized USB and IPv6 Fabric similar in nature to the system utilized by the T1/T2 chips.
For this reason the `/usr/libexec/remotectl` command line app can be used to interrogate the remote
system's `remoted` service.

## Dual NVMe Endpoints, and Emulated Apple NOR

The ANS3 (Apple NAND Storage components) are capable of multiple endpoints (a capability of
the RTKit system, whereby RTBuddy has various service endpoints), where each endpoint
is a configuration of mappings of LBAs (Logical Block Addresses) to Namespaces, with a given type.
On systems where a hypervisor is used, typically two such endpoints can be observed, the "true" or
"root" endpoint, as well as a shadow mapping used for the guest operating system thereby allowing
a different set of namespaces and their LBAs.  This is the reason that `eCfg` becomes problematic
in FDR as the one component that cannot truly be virtualized is the NAND storage component, due
to the need to service both the `dom0` guest as well as the boot component.  Errors will includes
`eCfg` being missing from sealing keys, or that it is not required to seal depending on which
personality the message originates from.

* `afi-ns-name` - Apple Firmware Image?
  * NS1
  * NS2
  * NS3
  * NS4
  * NS5
  * NS6
  * NS0
  * NS9
  * NS7
  * NS8
  * NS10
  * NS11
  * NS12
  * NS13
  * NS14
  * NS15
  * NS16
  * NS17
* `afc-ns-names` - Apple File Conduit?
  * NS1
  * NS2
  * NS3
  * NS4
  * NS0
  * NS5
* `afr-ns-names` - Apple Firmware Restore?
  * 0SN
  * NS1
  * NS2
  * NS3
  * NS4
  * NS5
  * NS6
  * NS7
  * NS46
  * NS56

## Custom Sequencing via the PMGR

The Mac contains multiple PMGR devices

## The Trust Object, and Embedded Trust Keys `trpk`

The firmware object `trst` sets non mask ROM security certificate and public keys.

## Authentication to the Device via MoPED

The `MdlC` SysConfig value (Model Configuration) contains the key `MoPED` which is used to authenticate
factory based sessions from the station device to the Device-Under-Test.  Given it is the length of a SHA1
hash, ... (insert HMAC parameters here from `FactoryProcess`).

## Passing out of USB via Synthetic Network from Host to Guest

## Using Rosetta to Weaken Platform Security

## Keeping a Place of Privilege - The Never Ending Update

## Using AVD and Multiple Hypervisor Domains to Simulate iDevices

In addition to an attacker controlled `hop0`, additional domain can be used with any
number of developer disk images (DDIs).  This allows an attacker to use an internal build of
iOS / padOS / watchOS to pretend to be a device.  Since the Apple Silicon mac is a full fledged
Apple ARM Device, it can gather nearly identical rights to systems like APNS and iCloud.
