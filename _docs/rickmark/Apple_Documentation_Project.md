# Apple Documentation Project

# Apple Formats for Documentation
## File Formats

**Archives**

- `bom`
- `pbzx`
- `dmg`
- `pkg`

**Mach-O Binary**

- dyld cache
- AOT rostetta 2
- sandbox policy binary format

**Signature Formats**

- img4
- chunklist
- trustcache
- iBoot BAA signing (`lpol`)
- APFS SSV signing related formats (`mtree`, `root_hash`)
- `CodeSignature` + Mach-O signatures (including requirements language)
- xART `.gl`

**User Data**

- iPhone Backups
- FileVault

**Other**

- DeviceTree
## Wireless Protocols
- iTunes Wifi Sync / Wireless USBMUXD
- AWDL
- Bluetooth Bonjour
- Apple Watch pairing
- `com.apple.terminusd`
## Wired Protocols
- USBMUXD
- iBoot Recovery Mode (`libirecovery`)
- `com.apple.recoveryd`
- everything covered by `libimobiledevice`
- USB-PD VDMs
- Lightning and any special messages such as `RESET` and `FORCE_DFU`
## Data Transports
- XPC serialization
- SEP protocol (since they do not use a TPM)
- AGX Apple Graphics API
- RTBuddy
## Debug Protocols
- MojoSerial
- XHC20 USB capture
- Lifeboat
## Web Services
- Xcode profile creation
- Update services (OTA, and IPSW)
- iCloud Backup Restore
- iCloud Generally
- iMessage (may not be able to interact without Lynx / Ocelot but still needs to be documented for fuzzing)

