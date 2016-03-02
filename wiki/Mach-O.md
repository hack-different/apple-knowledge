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
Each architecture is defined as a section of the fat file itself, and is specific for a particular cpu(sub)type. 


__ TODO __
# mach_header(_64)

# Load Commands and struct load_command

# Segments

# Symbols

# Lazy Linking

# Position Indipendent Executables

# Special Segments

# LC_MAIN, LC_UNIXTHREAD

# Malformed Mach-O

# Two Level Namespace

# The Mach-O Address Space in xnu/dyld based OSes

# Dyld Shared Cache

# References
__ add apple docs here maybe? __

# Talk
