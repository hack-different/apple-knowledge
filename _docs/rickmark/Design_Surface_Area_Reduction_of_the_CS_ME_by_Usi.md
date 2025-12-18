# Design: Surface Area Reduction of the CS/ME by Using Bogus Public Keys

# The CS/ME is Scary…

Because the CS/ME is run before the CPU comes up, and it has complete access to a system and is even designed for remote management (see Intel AMT) perhaps our classic approach isn’t working.  Classic “High Assurance” of the Intel ME has centered around the undocumented “High Assurance Profile” bit and “nuttering” by crashing the ME after the `bup` or “bring up” module.  System integrators like System76 have used a slim profile for the ME where it cannot be eliminated, as it is antithetical to the FOSS nature of the systems they build.

## Perhaps using bogus public keys (using verifiably random data) to lock down features not shipped.

The CS/ME uses the `MFS` for data storage.  It’s clear that it is possible to integrate signed modules not intended for a SKU into a device that isn’t supposed to have them as the manifest of shipping modules is not device specific and an entire module `policy` seems to have the ability to influence the SKU of the PCH/CPU.  Where features like the AMT exist, perhaps the best approach is to set the configuration even though the module isn’t enabled to ensure that if the `mctp` module is loaded, it is cut off at the pass by reading a useless management key.  

