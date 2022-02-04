## Bypassing AMFI

AppleMobileFileIntegrity is the kernel extension that handles codesign enforcement. 
It uses MAC Framework in order to hook into the Mach-O loading related functions in XNU, as well as hooking into mmap and several other functions. 
Code sign enforcement also happens at page fault time.

When a mapping is added to an address space, it is not actually added to translation tables just yet. Instead, on the first access a page fault exception is generated and the kernel maps in the requested page. If a page is marked as executable, the kernel will also hash the page and compare it against the codesign blob for the vnode it's mapped from; if the hashes differ, the task is terminated. 

The main attack vector for AMFI has historically been dyld, the dynamic loader. Indeed, the dynamic loader is in charge for mapping Mach-Os such as dylibs into a given address space. Segments in a Mach-O describe a section of said address space; memory protection flags are also described by Mach-O segments and applied by dyld.

Dyld also enforces code signatures by requiring Mach-O load commands to be in a segment marked as executable (in function sniffLoadCommands) to counter against @comex's incomplete codesign; however there is a chicken-and-egg issue here; Load commands are themselves part of a segment, however segments aren't mapped until load commands are parsed. This means dyld just copies load commands on the stack (which is rw- memory and thus not codesign enforced), parses load commands and checks wether the load commands were in an executable segment or not; on failure, dyld abort()s.

Once segments are mapped in, dyld page faults into each of the segments's pages (in function crashIfInvalidSignature), which finally validates both the load commands and segments. 

The first attack against this was to mark a semgent as "textreloc", which would unprotect it to rw- after sniffLoadCommands checked load commands to be in a PROT_EXEC area, but before crashIfInvalidSignature could validate signatures.
Following attacks involved overlapping segments so load commands would be detected to be in a executable segment, but after getting mmap()ed, a second non-executable mapping would map on top of them, effectively killing the crashIfInvalidCodeSignature check.
