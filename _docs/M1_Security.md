# The Security Weakness of the M1

## tl;dr

The M1 and iBoot was overall a massive step forward in boot integrity for our devices, but the use of an encrypted
boot-loader (as opposed to EFI which was not encrypted) makes it’s security guarantees impossible to verify.  In
addition, other regressions are outlined.

## Static and Dynamic Analysis of the Boot-loader

The security industry routinely performs analysis of security critical code components (the linux kernel, uBoot,
TianoCore) or in cases where the source code is not available, by reverse engineering binary components (iBoot).  This
allows the “many eyes make bugs shallow” theory to improve the overall security of our devices.  Early boot components
get the most scrutiny due to the “secure-boot-chain” or that a device is only as secure as all the element in the
chain that precede it.  `checkm8` is a massive issue largely because the chain was broken permanently at the earliest
stage of the boot process, where it is fixed in ROM.

It is this authors belief that iBoot, had it been open source, would have had this bug discovered and corrected much
sooner than the span between the 5s (2013) and the X (2017) with the addition of the T2 (shipping today in 2022
devices).  Nothing in the iBoot loader is particularly trade secret (as evidenced as Apple left it in the clear in
the shipping of the M1 `applevm2` stack).  This allows us to examine a nearly complete M1 boot process, but leaves
out the possibility of full verification, save NDAs with Apple or illegally obtained source material.  Given how wide
spread the iBoot source disclosure was, I believe if Apple want’s to maintain its market position of “secure
devices” that is a cornerstone of the App Store debate, it should make this fully open to external review.

## Lack of ability to create measurements externally

Yes, again.  The only way to assure an iBoot based device is to restore it, which is potentially expensive in
time.  A high assurance path to performing a measurement (hashes of regions, reading APTicket) would allow a
device to be attested without restore.

## Relocation of SecureROM to volatile memory

The initial stages of SecureROM copy the executable region to mutable SRAM (static ram).  This provides no benefit, as
only the data region need be in mutable memory.  Cache shadowing of ROM is sufficient to ensure that performance is
acceptable.  By existing in DRAM, any coprocessor released from reset with DMA path, or any incomplete clearing of
SRAM (the detection of ROM vs SRAM run is via a `<` operator, which means it could be possible to execute SecureROM
code at neither ROM nor SRAM by being further into the address space) would potentially compromise the SecureROM
guarantees.  Given that the PMP is also an ARM core, and manages power state machine changes, this may indicate a
flaw in that core may cause errant PMGR sequences that may violate the secure boot chain “cold” boot state.

## Security dependence on Hydra/USB-C (ACE) etc

The ACE (USB-C port controller) was able to be used to push a device to DFU without user interaction.  This flow
should require a physical key be depressed while the command is received to prevent misuse.  All port controllers
must operate safely from ROM until SecureROM has exited as well and co-processor verification can take place.

## The PMP and PMGR

A malicious PMP firmware can prevent the DFU flow as it is the processor handling the DFU chord.  Apple should
return to a ROM based DFU entry method.

## Lack of documentation of escapes to secure boot flow

The usage of “dev build on production hardware” allows anyone with privileged access at Apple to create blue pill
operating systems that are nearly impossible to detect.  Other operating systems solve this with “big scary warning”
when a device is running a non-production / secure code path.

## Bonus Section

### XNU Kernel’s Failure to prevent `dlopen` of `MH_EXECUTABLE` objects

Every modern operating system guarantees that only dynamic libraries may be loaded by the dynamic symbol
system (`dlopen` in POSIX, `LoadLibrary` on Windows) and not executables.  The ‘quirk’ that macOS picked up by
allowing executables compiled as PIC (position independent code) as all code now is to support user mode ASLR,
violates the security axiom of “principal of least surprise”.  Apple should immediately prevent the loading
of `MH_EXECUTABLE` objects via `dlopen`.

### Implement trust-zone like secure and non-secure user task modes

Security of processes could be improved by allowing the dynamic linker to run in usermode in a similar way to how
trust-zone has two worlds.  This would allow the linker to stay in user mode but to only be able to bind from
secure mode - making the pages read only to normal user-task mode and rw to the privileged mode.  This prevents
malicious code from rebinding symbols.
