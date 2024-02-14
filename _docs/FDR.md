# Factory Data Restore

## Valid Values in libFDR

* SrNm - Serial Number
* MLB# - Main Logic Board Number
* WMac - Wireless MAC Address
* MBac - Bluetooth MAC Address
* seid - Secure Element ID
* sei2
* tsid
* imei - International Mobile Equipment Identifier (Main)
* ime2 - International Mobile Equipment Identifier (Secondary)
* meid - Mobile Equipment Identifier
* nuid - Apple NAND Storage / NVMe Unique ID
* mlb# - Main Logic Board Serial
* prd# - Product Number
* arc#
* wsku - Wireless Product SKU
* srvn - Server Nonce
* time
* clid
* ksku
* PrCL
* Mod# - Model Number
* Regn - Region
* SWKU
* BORD - Board ID
* SDOM - Security Domain
* acid
* eeid - ESIM EID
* bat# - Battery Serial Number
* rpcp
* sdak
* bdak
* mdak
* spub
* bpub
* mpub
* meta
* SrvP
* SrvT
* CLHS
* sei3
* supm
* Coor - Country of origin

## Sealed Values (A17)

* seal - Format looks like CHIP-ECID
* AlsH
* scrt - Format looks like CHIP - ECID
* lcrt
* dCfg
* fCfg
* bCfg
* CmCl
* IfCl
* HmCl
* GpC2
* pspc
* vcrt
* JpCl - has "SucCC"
* bbpc - Baseband related - looks to be half UUID (int64) common to qualcomm baseband UUIDS
* bbcl - See bbpc
* bbpv - see bbpc
* ShMC
* ShSC
* rcrt - CHIP-ECID format
* rSCl - CHIP-ECID format
* pcrt - CHIP-ECID format
* appv - CHIP-ECID format
* FCCl
* ycrt
* PlCl - PCI express? Has "SubCC" (pbas, pcic, pcii, pdcl, pmpc, psnv, pwcl, PxCl)
* sePK - Secure Element Public Key? ( Looks to be compressed ECC point )
* prf1
* psd2 - see prf1
* tcrt -
* mcrt -
* rMC2 - CHIP-ECID format but not for AP, chip ID 0x2024, SubCCList (rMUB, rMNB)

## Verified Properties (A17)

* SrNm - Serial Number
* BMac - Bluetooth MAC
* drp# - Raw Panel Serial Number
* seid - Secure Element ID
* SDOM - Security Domain
* mlb# - Main Logic Board Serial
* WMac - Wireless MAC address
* BORD - Board Identifier
* imei - International Mobile Equipment Identifier
* arc# -
* nuid - ANS (Apple NAND Storage) - Serial Number
* eeid - ESIM EID
* ime2 - International Mobile Equipment Identifier 2 (IMEI)
