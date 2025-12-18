# Hidden Gems of APFS
In 2017 Apple introduced the successor to the long standard barer filesystem of the Mac, named `APFS` for Apple Filesystem (https://en.wikipedia.org/wiki/Apple_File_System), it replaced the impressively long lived `HFS+` or Hierarchical File System Plus/Extended, so named because early macOS and Apple IIs lacked folders (`MFS` or Macintosh File System is what HFS and HFS+ replaced)

APFS brought with it a full re-imaging of the low level filesystem.   It took inspiration from ZFS which rumor has it almost became the standard filesystem.  New features included:

- Better support for Flash and 4k page sizes
- Logical Volume Grouping, replacing `CoreStorage`
- Snapshotting including copy-on-write, leveraged in Time Machine and later macOS updates (the system volume becomes an atomic, signed snapshot)
- Volume Roles - such as System, Data, Preboot, Update etc. better supporting read-only system
- After Initial Release: Signed System Volumes


## How Signed System Volumes Work

For newer iOS / macOS versions a “signed system volume” is used unless disabled by SIP policy.  What is a signed system volume?  Apple chose to implement their scheme by using what’s called a `Merkle tree` (https://en.wikipedia.org/wiki/Merkle_tree) representation of the filesystem metadata (broadly equivalent to linux `inode`s).  This gets deployed in a pair of files, known as `mtree`, a representation of the Merkle tree in its entirety, and `root_hash`, clearly the final hash used at runtime to verify the system.


## For System Volumes, the Mount-Point Changed

Because of the privileged role of various other partitions, Apple changed the long standing scheme of using `/Volumes` as their mount point to avoid confusion with user supplied drives with the same name (imagine what would break loose if a user disk was named `Preboot` or `Recovery`).  System privileged volumes are now mounted at `/System/Volumes` which are folders under the System volume SSV.  


## The OS Verifies the Disk at Runtime


