#Mach-O
##This is a simple description to Mach-O File Format
###You can choose the otool inside Xcode Command Line Tools For Certain Operations.But I Recommand JTOOL
###jtool[Download](http://newosxbook.com/tools/jtool.html)

###Following Defines Can Be Found In mach-o/fat.h
>>Mach-O is the executable file format used by all kinds of stuff inside Apple Eco-System(Mac OS X/iOS/Watch OS) It has two versions: thin & fat.

>>Fat Mach-O can be built/extracted using lipo. Check *man lipo* for details.

>>>Fat Mach-O

>>>>Fat's Mach-O Header is Fat Heade. Usually is 2bytes long. The first byte is FAT_MAGIC(Big Endian)或FAT_CIGAM(*MAGIC* Reversed, For Little Endian)
>>>>2nd byte(Starting At 0x4)is the number **n** of contained archs of this Fat Mach-O.Followed by **n** info structs of related thin machos. Each struct is a fat_arch struct. Which contains (in order) CPU-Type(Ex:CPU_TYPE_ARM),CPU-Sub-Type(e.g:CPU_SUBTYPE_ARM_V7),Thin Mach-O Offset , Size ,Segment Alignment Info
>>>>Then it's the data blobs of corresponding Mach-Os. Please note that they are usually sorted in the same order as the headers

>>>Thin Mach-O
To be continued