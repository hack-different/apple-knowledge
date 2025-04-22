# Loki

- Disconnect battery and all devices technician
- Disconnect antennas
- Read firmware from technician via Medusa
- Use off net loaner to read Medusa to cold storage
- Use loaner to identity and locate clean FD file
- Use loaner to identify and locate clean SMC & Updater
- Use loaner to identify and locate clean Thunderbolt & Updater (From the AV adapter update)
- Use loaner to prepare rEFInd and shell USB drive
- Write FD from loaner to Medusa
- Disconnect internal storage in technician
- Read serial number from technician machine
- Remove power technician
- Write FD from Medusa to technician
- Reset SMC using external contact switch
- Write serial number to technician
- Boot technician from reFINd
- Reset SMC using external contact switch
- Attach power
- Perform SMC update
- Perform Thunderbolt update
- Power off technician
- Verify technician via Medusa
- ASSERT: Firmware should be clean
- Attach persistent storage
- Target disk mode technician
- Read disk raw to backup
- Zero disk
- Power off technician
- Attach other devices
- Restore OS
- Verify that KDP works

Purchase:
Write-prevent USB (One of OS, one for rEFInd)
Thunderbolt -> Firewire
Sufficient size backup drive, mirror to DBX
Remaining items:
Disassemble SMCUpdater
Disassemble ThorUtil
Knowledge:
TouchBar will not be online without persistent storage
Concerns:
After EFI clean, must make sure boot-device is external with rEFInd to prevent re-infection
Assertion:
Loaner is clean out of box
Not on network (lateral movement via SSH)
Secure Enclave will be off-line
Places where persistence may occur: Thunderbolt, SMC, EFI
Questions
Can we remove keyboard and mouse from equation?
Can we disable network via nvram (previous data suggests yes)
Firmware for disk controller (NVM)
Can we prove all bits of disk accessible, write byte stream of random and generate hash, then verify. Ensure number of bytes against another machine. What about bad pages? Do they have spare area?
What if we restore to a clean external disk to verify firmware before trusting internal NVM
Is booting from optical media still supported? (Read only, and or observable change)

