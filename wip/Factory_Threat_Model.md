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

Ramrod is a plugin to the OTA process (patchd) that allows for the restore of a full OTA, as well
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

## HyperVisor `hypr`, Application Partitions `appv`, Root Domain (`hyp0`) and `0Cfg`

For Apple systems historically the `hypr` role is filled by the SPTM, but with newer Apple Silicon
this have moved from EL2 to Guarded Execution Roles.

### `hyp0` XNU and the TXM

EL2 execution, as well as the initial

## Re-entrant iBoot and SEP

## iBoot (`ibot`), iBoot Data (`ibdt`), secondary iBoot (`)

## Usage of Local Policy and Local Trust Keys

## FDR, Managed Station and Managed Device

## Communication with `hop0` via RemoteXPC

## Dual NVMe Endpoints, and Emulated Apple NOR

## Custom Sequencing via the PMGR

## The Trust Object, and Embedded Trust Keys `trpk`

## Authentication to the Device via MoPED

## Passing out of USB via Synthetic Network from Host to Guest

## Using Rosetta to Weaken Platform Security

## Keeping a Place of Privilege - The Never Ending Update
