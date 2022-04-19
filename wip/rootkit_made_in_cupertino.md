# Work-in-Progress: Using Apple internal builds for rootkits

## Backstory

Found this years ago while being stalked in SF [mojo_thor](https://github.com/rickmark/mojo_thor).  Recently I've found
more kernel extensions beyond just `MojoKDP` that are involved.  MojoKDP was originally found by running a VM, then
capturing the memory state providing a core dump. (see other repo)

Also, my ex at Apple is a total criminal for using this over many years to stalk me... But Apple refuses
to discuss the issue with me.

## Overall Theory

Two Possibilities:

* Apple signs internal builds for production hardware using production keys allowing anyone
  who gains a copy of one to use powerful internal kernel functionality that breaks the
  guarantees made in the platform security guide
* Changing a production device to trust DVT/PVT/EVT keys is trivial, then they run internal
  builds which have powerful debug capabilities that break the security model.
  * Seems this might be related to SMC `MOJO` key for switching to non-production builds.

## Leveraged Kernel Extensions

### com.apple.driver.AirPort.Brcm4360-MFG

### com.apple.driver.AirPort.BrcmNIC-MFG

Broadcom - perhaps these are the original manufacturer versions?  Implies that there are differs
but not enough data yet.

### com.apple.driver.AppleAstrisGpioProbe

Astris is a debug system for iDevices, partially documented elsewhere.  Just assume used to
do evil things to a iDevice restored on the computer.  GPIO implies general purpose IO pins.
This may provide a probed devices PMGR/`force_dfu` pins for iDevice restore avoidance or
re-infection.

### com.apple.driver.AppleBSDKextStarterVPN

Based on description, some form of VPN that lives in kernel mode and operates at boot?

### com.apple.driver.AppleHWAccess

Provides a user mode `AppleHWAccessUserClient` IOKit service that allows for direct access to physical memory

### com.apple.driver.AppleIntelCPUPowerManagementDriver

### com.apple.driver.AppleNVMePassThrough

Provides a IOKit user mode service `AppleNVMePassThroughUC` to pass through commands directly to the
NVMe controller.

Dangerous on Apple products as NVMe uses namespaces to store / read things like bridgeOS root filesystem
bridgeOS firmware, SysCfg, NVRAM, etc.  (oh and whatever AppleEAN is?)

### com.apple.driver.AppleRSM

### com.apple.driver.DrizzlePlatformSupport

Some god awful mashup of the SMC, bluetooth and 8254X ethernet...

Wonder if it can be tripped explicitly based on conditions even if intended to be used
via VMware to give a legit use case.

### com.apple.driver.DrizzleSMC

### com.apple.driver.KernelRelayTesterHost

Seems paired with `com.apple.driver.KernelRelayHost`.  Allows for a user mode application to open
the IOKit class `KernelRelayTesterUC` to be able to call the following:

#### extTestFunction

Demangled Symbol: `int64_t KernelRelayTesterUC::extTestFunction(KernelRelayTesterUC *__hidden this,
KernelRelayTesterUC *, void *, IOExternalMethodArguments *)`

#### extSendData

Demangled Symbol: `int64_t KernelRelayTesterUC::extSendData(KernelRelayTesterUC *__hidden this,
KernelRelayTesterUC *, void *, IOExternalMethodArguments *)`

#### externalMethod

Demangled Symbol: `int64_t KernelRelayTesterUC::externalMethod(KernelRelayTesterUC *__hidden this,
unsigned int, IOExternalMethodArguments *, IOExternalMethodDispatch *, OSObject *, void *)`

### com.apple.driver.LuaHardwareAccess

[Lua](https://en.wikipedia.org/wiki/Lua_(programming_language)) is a language often leveraged for lightweight
extension scripts (nginx for example does this).  For reasons beyond me, Apple created a Lua engine for kernel
mode and signed it...

A user mode program can evaluate code in the kernel by using `LuaHardwareAccessUserClient` and passing Lua code
to it.

### com.apple.driver.MEDetect

This appears to be a tool to detect and correct "neuter" Intel management engines.  This process is
acomplised one of two ways, by setting an undocumented "HAP" or high assurance profile bit that
disables the bulk of the ME functionality, crippling the boot code causing the ME to hang, or both.
This should only be applicable for T1 and prior as the MacEFI binary comes from the T2 later on.
The Intel ME is not generally used in the macOS platform, so (warning conjecture) this seems
to be primarily to ensure the device's ME / AMT / CSME is enabled for SigInt.

It is detection only as only the Intel ME can update its code, therefore it cannot be repaired
barring some non-standard method.  See also `eficheck`.

Boot Arguments:

* `no_medetect`
* `medetect_panic`

### com.apple.driver.kis.AppleKIS

Second hand knowledge says this is related to the Kanzi internal debug cable.  This would be needed
for demoting a device during restore.  I'm strongly starting to wonder if USB-C cables plumb through
pins that could be used for this purpose, or if it is used with a form of remote USB to tunnel over
other transits.

### com.apple.driver.usb.AppleUSBKDP

USB base kernel debug port.  Combine with below to bad effect.  Only documented kernel debuggers are ethernet,
and legacy Firewire serial.  This seems to allow for USB mode debug.  See also: MojoKDP

Boot Arguments:

* `kdp_match_name` with values `usb`, `XHC`
* `AppleUSBKDP-debug`
* `AppleUSBDebugControllerPCI-debug`
* `AppleUSBXHCIDebugController-debug`

### com.apple.iokit.RUSBHostFamily

Allow for USB devices to appear as though they are local when they are in fact not.  Has a user client
IOKit class, so logical that the device comes from user-mode on the system (which obviously depending
the user mode binary could be from anywhere, synthetic, network, etc)

Boot Arguments:

* RUSBHostPort-debug
* RUSBHostController-debug
* RUSBHostDevice-debug

### com.apple.iokit.fipscavs-kext-tool

Wanna just break crypto? <https://csrc.nist.gov/CSRC/media/Projects/Cryptographic-Module-Validation-Program/documents/fips140-2/FIPS1402DTR.pdf>

Seems you can just new up a `IOFIPSCipherUserClient`

### com.apple.kext.MojoKDP

A debug protocol with two versions (mojo1, mojo2).  Original find form 2017 via Parallels memory capture
and the professional edition ability to inject kernel debug.  In this year I had my logic board replaced
multiple times due to graphics issues, each time booting in recovery when the device was new would result
in no entry for `MojoKDP` in `ioreg` but seemingly after leaving my computer in my apartment alone this
node would appear, but only in recovery mode.

### com.apple.pae.driver.AppleQuaibridgePCIE

From my best guess seems to be direct access to the PCIe bus?