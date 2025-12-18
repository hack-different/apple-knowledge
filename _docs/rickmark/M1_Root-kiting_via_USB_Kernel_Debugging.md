# M1 Root-kiting via USB Kernel Debugging

# History

The M1 and later Apple macintoshes use a new technique for KDP (kernel debug port).  In the earliest macintoshes (PPC) and even supported through late Intels two machine debug was achieved using a direct FireWire serial port (as opposed to generations prior which used standard RS232 serial).  This is done in part because the FireWire hardware and protocol was simple to initialize allowing the debugger to be started from a very early phase, by OpenFirmware.  Later as FireWire was phased out (but still possible to use via a silly TBT3→TBT2→FireWire 800→TBT2→TBT3 dongle chain) the UDP based KDP was born.  This used a Apple network adapter over a in-the-clear protocol to achieve the same results.  Moreover Apple seems to have a “magic debug server” (fundamentally a meet-me) on their corporate network that allows DVT/EVT units to “automagically” connect to a central debug service which then can be connected to by engineer performing their work.  This is what the MojoKDP (https://github.com/rickmark/mojo_thor/blob/master/MojoKDP/mojo.kext.S) kernel port is, which should never have shown up on my consumer devices.  Because the protocol is unauthenticated, simply getting MojoKDP triggered on a laptop gives root level remote control of a machine, and therefore an escape hatch to the entire macOS security model.

# M1 - New Debug Hotness
## Aside

I hope we learned a lesson on network based debug, but 🤷‍♀️ .  From my understanding (someone checked for me, I’ve yet to play with one) the M1 Max and Pro respond to VDMs on all USB-C ports, meaning we’ve confirmed that a malicious USB device can force a device to hard restart by pulling the “reset pin”, no data on DFU yet.

## M1 Debug and USB

The M1 takes the approach of using a new transport, USB itself.  (https://github.com/AsahiLinux/docs/wiki/HW%3ADebug-USB). This means one can correctly control a guest OS as long as you can create a reliable USB link to the device, but how to do so if you cannot connect arbitrary USB devices as an attacker?  By leveraging FUOS and a early stage boot-loader such as m1n1 (https://github.com/AsahiLinux/m1n1) booting unaltered macOS for ASi with a hypervisor that presents USB devices to the subordinate OS becomes how one can do two machine debug on a single machine with the host partition in the control of an attacker.
**Indicators of Compromise**
As always, this is less hypothetical than practicum for me personally.  The manifest of this is a M1 macOS build with two sets of Thunderbolt Ethernet - the traditional TBT IP↔IP adapters (one per port) used for high speed transfers between devices (a feature which one seemly cannot disable but you can delete the TBT bridge device).  This adapter has a MAC address OUI corresponding to Intel’s OUI range.  Beneath that are Thunderbolt ethernet adapters which give an Apple OUI as though the port is populated with a TBT→ Ethernet adapter.  This provides a high speed interconnect for the interposing of the full network layer as well as high speed exfiltration.  

## Once Again, the Design Fixes
- If the machine is booting to anything other then macOS (FUOS is configured) or if using any mode but full security iBoot should provide a visual indicator that security is not assured
- Implement DFU based device verification.  By creating a new DFU downloads rather than upload capability one could use a trusted device to verify the security configuration of a device under test.  This would be a new option in Configurator 2 called “Verify”
# Why design root kits like this?

As it turns out patching a kernel with malware is difficult and unreliable.  This is why every new version of iOS/bridgeOS requires updates on the checkra1n team as the pongoOS KPF (kernel patch framework) needs to be updated to re-identify the loci for the patch set.  This is why being able to reliably trigger kernel debug is a far more reliable path to achieving the same ends.  One can elect to make no patches (making the machine come up normally but with a debugger) or take control of far more reliable means of controlling code flow and memory.

