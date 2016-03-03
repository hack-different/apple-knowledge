# The Mach-O Format

The Mach-O file format is the executable format of choice for XNU and dyld. 
It serves a purpose analog to what ELF or PE do; to put it simply, it describes a portion of an address space.
Support for multi-architecture executables is also provided thanks to the fat format, which allows you to join multiple different architecture Mach-OS letting the kernel pick which to load. Note that it is possible to influence this with posix_spawn APIs.

# Working with Mach-Os

1. otool is provided out-of-the-box with the xcode cli utils.
2. jtool, by Jonathan Levin, author of MOXiI and MOXiI II, is an analog but more flexible and advanced tool. On the other hand, it lacks support for disassembling architectures other than arm64.
2. lipo is a tool for working with fat files
3. Apple headers, specifically <mach-o/fat.h>. 

# Fat Mach-Os

A fat Mach-O is simply made out of a fat header, which contains a magic value (which allows you to derive endianess of the fat image; in case magic equals FAT_CIGAM, remember to endian flip your values) and multiple architecture structures.
Each architecture is defined as a section of the fat file itself (which is itself nothing more than a thin Mach-O) and is specific for a particular cpu(sub)type. 


__ TODO __
# mach_header(_64)
	struct mach_header (for 64-Bit Devices it's mach_header_64. Only difference is size. a.k.a. uint32_t or uint64_t)
# Load Commands

# Segments

# Sections

# nlist / nlist_64

# Symbols

# Lazy Linking

# Position Independent Executables
 a.k.a. ASLR-Enabled Executables.
 PIE Flag is in the *thin* mach_header with value 0x200000 
 Minus that from the original flag value will disable ASLR, and vice verse

# Special Segments
	__PAGEZERO is a special segment with *ZERO* disk space and takes a page in VM.
	When code access NULL, it will land there
	Mach-O containing __RESTRICT/__restrict will be flagged by dyld and thus DYLD_INSERT_LIBRARIES EnvVar will be ignored.(This is added after iOS6)

# Other common load commands

# Malformed Mach-O

# Two Level Namespace

# The Mach-O Address Space in xnu/dyld based OSes

# Dyld Shared Cache
Download the latest dyld source from Apple [Apple OpenSource](http://opensource.apple.com/source/dyld/)
open ./launch-cache/dsc_extractor.cpp and change *\#if 0 * to *\#if 1 *
Then just clang++ -o dsc_extractor dsc_extractor.cpp dsc_iterator.cpp
and run dsc_extractor on the cache to extract.
##Known Issues:
  Seems like segment VM Address is wrong. So the binary is not class-dump able (Just use runtime dump instead)
  not nm-able(Solution:Simple replace LC_SEGMENT_SPLIT_INFO to  LC_SOURCE_VERSION)

# References
__ add apple docs here maybe? __

# Talk
I "refactored" Naville's contribution to somewhat better layout and added a bunch of possible topics to expand to. Please let me know any opinion on this, and if you'd like something in particular to be discussed please add it to this list. 
If you wish to contribute to this, it's probably better to have different people focusing on single topics at a time. We could coordinate here. Ideas? ~qwertyoruiop
