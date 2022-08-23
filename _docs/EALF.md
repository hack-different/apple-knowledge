# Header

NOTE: In progress

* 0-4: "magic" = "EALF"
* 5-8: number of hash rows
* 9-12: file size in bytes
* 13: ?? Hash function, 00 = sha1, 01 = sha256
* Zeros?
* 30: UInt16 Offset to hash table
* 32: UInt16 Number of Unicode-16 characters following
* 34: - NULL = UTF-16 null terminated EFI version string

## 60 byte "rows"

* 1 byte FD region (see `fdutil`)
  * 0 = FD header / region
  * 1 = BIOS / EFI
  * 2 = Intel ME (Code + Data)
  * 3 = Gigabit Ethernet (Unused)
  * 4 = Platform Data & Bootloader
* 1 byte sub-region
* 2 byte index
* 4 byte offset
* 4 byte size
* 16 bytes GUID for section or "FF"
* 32 bytes SHA256 for section
