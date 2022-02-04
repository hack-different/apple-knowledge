As of iOS9, all arm64 devices have kernel patch protection implemented wherein something likely other than the kernel checks every so often for kernel integrity, otherwise panics. 

Checked ranges are __TEXT and __DATA.__const.
It is speculated that checks are enforced by either the SEP or the Secure Monitor.

Current attempts to bypass KPP actually avoid it entirely and were demonstrated in Pangu9. 
The general idea is not to patch __TEXT, but rather data structures. 

In particular, Pangu9 replaced hooks in AMFI's MAC policy to either disable or alter the checks. 

This technique has been mitigated in iOS 9.2 by moving MAC policies in __const.

LwVM::_mapForIO patches on the other hand are applied by actually unprotecting the root partition in the partition structure rather than by patching the protection check out. This can be done by finding the LwVM manager, which contains an array of pointers to partition structures. To find the LwVM manager, take a look at a LightweightVolumeManagerUserClient object.


-------------------------------
Found this by @xerub [Tick (FPU) Tock (IRQ)](https://xerub.github.io/ios/kpp/2017/04/13/tick-tock.html)
