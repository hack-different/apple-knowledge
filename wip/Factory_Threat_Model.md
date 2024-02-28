# Exploring What AppleInternal Users Can Abuse

This article dedicated to those I've personally known who've worked in Factory Process,
the misuse of which drives this research.

## Factory Trust

From data gathered by looking at disk images in the wild, it appears that
there are not just "customer" variants of the Restore and Upgrade disk images
typically used in DFU based recovery, but also factory variants.  The factory
variants, unlike customer, do not use a strict, internal state machine to
perform this process.  This is logical as factory needs to do additional
privileged operations such as:

* Component Testing / Quality Control (burn-in)
* Calibration
* Configuration of device specific identity (setting of wireless and bluetooth MAC addresses)
* Creating the device parts manifest (the wrapped set of serial numbers that make up the unit,
  including main logic board, display, TouchID, etc)
* Pairing, or the process of cryptographically binding the SEP with the TouchID or FaceID
  components.  Because these use a secure channel, they must exchange keys before use.
  (This lead to numerous issues related to FaceID and TouchID with unauthorized repairs,
  as the repairing worker was unable to modify the SysCfg manifest and pair the new components)
* Generation of key material.  The UID is generated on the SEP itself during an initial run
  and stored in non-extractable fused memory of the AES hardware.  Should this not occur the
  UID would be a "clear key" consisting of all zeros, and would not provide protection for user
  data.
* Fusing.  Devices must be moved from PVT (Production Validation Test) to MP (Mainline Production)
  after successful testing to put it into a customer ready state.  This takes devices and lowers
  them to `CPFM:03` which is a secure production device.
* Refurbishment.  Refurbishment of a unit requires that components be re-tested and paired.
* Installing the initial operating system and firmware

Evidence of factory programming occurs in tickets that are issued from `Factory` ICAs (intermediate
certificate authorities) as opposed to the typical DataCenter seen in customer based device restore.
There are additional manifest properties that are respected by these internal signing servers,
some of which include `sika`, `ftap`, `ftsp`, `rfta`, `rfts`, `uidm`, `sidm`, along with the
`DPRO`, `DSEC`, `MPRO`, and `MSEC` properties to establish the effective security mode.
These properties, in addition to the Factory Boot Disks, Developer Disks and Personal Disk Images
allow for non-customer restore flows.

## RamRod

Ramrod is a plugin to the OTA process (`patchd`) that allows for the restore of a full OTA, as well
as other unusual features, such as NVRAM shadowing, custom sequencing and skipped phases.  It will
often end up as `(null)` as the component in some OTA logs.  The combination of a restore of a
lower macOS version, plus the usage of `ramrod` to update it permits the security of the
operating system to be subverted and can be made persistent by failing to complete the update flow.
This is advantages for a few reasons, one it uses a supported component to enter the recovery
environment, which has lower security settings to enable the laying down of firmware to hardware
component and lacks System Integrity Protection.

## Clear (Zero) Hashes and Keys

By fixing hashes to a sequence of zeros, once a APTicket is issued it may be re-placed onto a device.
Zero keys can be observed both the for xART root UUID (00000000-0000-0000-0000-000000000000) as well
as the initial values for BNCH domain nonces.

The usage of `uidm` and `UID_MODE` can be used to disable the UID key entirely, preventing the usage
of hardware specific tweaks.  Even though this APTicket is "personalized" in that the ECID is set,
because of explicit UID disable, there's no cryptographic material typing to the device, which
broadly prevent the usefulness of the BNCH boot nonce, as it is not entangled with any device
specific key material.  In this case, any other ECID can generate valid BNCH values for any other
ECID.

This combined with the usage of Zero nonces for the boot nonce domains further extends predictable
concerning to the other components of the boot path.

## HyperVisor `hypr`, Application Partitions `appv`, Root Domain (`hyp0`) and `hyp0`'s SysCfg `0Cfg`

For Apple systems historically the `hypr` role is filled by the SPTM, but with newer Apple Silicon
this have moved from EL2 to Guarded Execution Roles.

In "self hosted factory trust" the `hyp0` partition is used to act as the restoring station, and
a `hypX` partition is the restored station.  This manifests in the FDR cached data as unlabeled
parts (those without any prefix such as `fCfg`, `dCfg`, etc), those of the `hyp0` host station
(`mansta`) and those of the restored device station `mandev`.  This allows the `fSys` or Firmware
SysCfg and `0Cfg` or `hyp0` domain 0 SysCfg to be stored at the root NOR part, while EAN can be
leveraged for the per OS `fCfg`.

The hypervisor for XNU systems is configured by setting the boot argument `-entry` for the initial
EL2 setup, then it is called again with `-virtual` for hypervisor domain zero (`hyp0`).  The domain
zero kernel is privileged above other virtual machine instance, and `hypX` lacks root level permission.
An example of this would be access to the `system` NVRAM namespace.  This means that should an
attacker gain control of `hyp0` they can start a blue-pill like environment for any other domains.
To do so would typically require a local recovery policy with lowered security settings, as
non-recovery is a limited permission boot mode.

### The Trusted Execution Monitor

`appv` is considered a boot image to begin execution once a new EL1 domain is established.  Typically
this is simply a small shim to begin execution of the XNU kernel once EL1 is properly configured and
to service minimal HVC requests.

## Re-entrant iBoot and SEP

To support differing versions of the sepOS and related services the device root SEPROM will load
the system level `sepf`,`sepi`.  SEP Firmware or `sepf` payloads are de-novo images that are
decrypted by the SEP GID and then executed at the root firmware level.  Image files (`sepi`) are
combinations of the firmware as well as initial data structure that is launched per-operating system.

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

The Apple NAND Storage 2/3 components are capable of multiple endpoints, where each endpoint
is a configuration of mappings of LBAs (Logical Block Addresses) to Namespaces, with a given type.
On systems where a hypervisor is used, typically two such endpoints can be observed, the "true" or
"root" endpoint, as well as a shadow mapping used for the guest operating system thereby allowing
a different set of namespaces and their LBAs

* `afi-ns-name`
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
* `afc-ns-names`
  * NS1
  * NS2
  * NS3
  * NS4
  * NS0
  * NS5
* `afr-ns-names`
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
