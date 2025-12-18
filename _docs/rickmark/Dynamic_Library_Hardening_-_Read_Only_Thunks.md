# Dynamic Library Hardening - Read Only Thunks
Problem
Today, late binding makes use of “thunks” to bind a call site to its eventual import.  These regions are setup as initialized mutable memory, meaning an errant instruction stream may be able to over write the function pointers arbitrarily.  Alternatives include static linking (infeasible due to size and update concerns) as well as early binding before transferring control to the process, and giving up write to the associated pages.  Most programs prefer to do late binding to avoid startup delays.

Proposed Solution
By implementing either a page-fault or syscall, processes should be able to get assistance from the kernel to enter a meta-user-mode, or EL3 with privilege to modify the process.  This could immediately be consumed by the dyld functionality to perform binding of thunks in a priveledged user mode (keeping symbol binding in user mode and out of the kernel).  The initial indirect symbols would point to a thunk that would have the kernel pause all threads in the process, wait for them to quinenese, start the privileged thread (single thread for simplicity) which would be able to write the bound symbols and then drop write permission again.  

This could even be supported by PAC by allowing the signing operations to occur in privledged mode but not in regular mode.  For this to work arm64e would need bits to control if the arbitrary sign instructions are available.  Another useful flag would be the ability to disable the read/write of keys except in “meta-mode”

Many traditional kernel services could then be moved out to the process meta-mode, decomplicating the kernel.  Modern kernels have absorbed a number of non kernel concerns because of the need for a privledged meta-process execution mode.  For example the creation of new threads via this method would allow stack setup to occur in user mode and simply the passing of a new thread structure into a collection with the only kernel interaction being the global process pause (objectively could be configuratble per entry)



