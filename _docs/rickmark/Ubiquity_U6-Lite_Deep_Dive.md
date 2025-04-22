# Ubiquity U6-Lite Deep Dive

## Overview

The Ubiquity U6-Lite (and likely its related SKUs of U6-LR and U6-Pro) are the newest in the set of the UniFi AP lineup.  They boast the first WiFi 6 (802.11ax) devices in their portfolio and are impressive devices.  The Lite uses 2x2 MIMI spacial duplexing, and provides 4, Dual-Band SSIDs at a time.  The devices are also enhanced with Bluetooth to allow for fast mesh adoption as well as proxy adoption for the UniFi SDR and NVR products.


## The Radios

The U6-Lite is powered by a total of 3 radio chipsets, providing 4 2.4GHz SSIDs on one, 4 5.7GHz ax radios as well as a “special” management radio set.  These are listed out in the FDT as follows…

- rax0, rax1, rax2, rax3 - The 802.11ax Chipset / Radios for 5.7 GHz
- ra0, ra1, ra2, ra3 - The 802.11ac Chipset / Radios for 2.4GHz
- apclix0, apcli0 - A specialized and hidden 802.11n management radio
- A Bluetooth 5 radio coexisting with the radio chipset


- MT7603E


## Accessing the UART

The device is completely sealed and only has one button for reset, and one PoE Gigabit ethernet port.  If you are willing to void a little 


## Security Analysis
- Recovery does not hold the WiFi chipset in reset and therefore could be a location of persistence
- Bringing up Bluetooth before locking down the U-Boot region could allow for a `loadx` or `loady` XModem or YModem transfer of a new boot-loader
    - Ubiquity should publish and clarify this BT protocol if it is to remain
- There is a second, 16MB SPI flash that is not assured to be restored
    - This stores the MT7915 firmware including bluetooth pairing records
- Ubiquity makes fundamental bugs in their boot-bootloader that should have been caught by QA in their final non-EA products (TFTP restore)
- 
## Referenced in FDT:

MediaTEK - MT7621AT - MIPS Dual Core SoC

- 880MHz Dual Core MIPS 1004KEc
- Ethernet Switch (5 Port)

MediaTEK MT6577 - MediaTEK Dual Core ARM Coretex-A9 SoC
MTK RT3883 - MediaTEK Ralink Dual-Band 802.11n SoC
Ralink - RT2880 - 802.11n AP/Router/iNIC SoC - MIMO
MediaTEK MT753X - Ethernet Switch
NT5CC128M16JR-EK - DRAM Chip 256MB

MediaTEK - MT7603EN - Wi-Fi N Chipset
https://www.mediatek.com/products/broadbandWifi/mt7603e

MediaTEK - MT7915AN - Wi-Fi 6 Chipset + BLE
https://www.mediatek.com/blog/mediatek-mt7915-wi-fi-6-wave-1-chipset-builds-in-a-range-of-industry-firsts

MediaTEK - MT7975AN - Wi-Fi 6 Chipset

MT3058

LM76002R


MX25L12833F - 16MB SPI Flash
https://www.macronix.com/Lists/Datasheet/Attachments/7447/MX25L12833F,%203V,%20128Mb,%20v1.0.pdf?fbclid=IwAR1GUI_Ah1096T84sqIrjw9DrSUqTvIPNjP31tPZbwagxhm_M9zKpM3NLv0

MX25L25645GMI-08G - 32 MB SPI Flash 
https://www.macronix.com/Lists/Datasheet/Attachments/7858/MX25L25645G,%203V,%20256Mb,%20v1.9.pdf

View 1 - From U-Boot (`u-boot`, `u-boot-env`, `factory` exist in view 2’s `u-boot` region)

| Name       | Offset | Size (Hex) | Size (Bytes) |
| ---------- | ------ | ---------- | ------------ |
| u-boot     | 0      | 30000      | 196,608      |
| u-boot-env | 30000  | 10000      | 65,536       |
| factory    | 40000  | 10000      | 65,536       |
| firmware   | 50000  | REMAINDER  |              |

View 2 - From the FDT

| Name       | Offset  | Size (Hex) | Size (Bytes) |
| ---------- | ------- | ---------- | ------------ |
| u-boot     | 0       | 60000      | 393,216      |
| u-boot-env | 60000   | 10000      | 65,536       |
| Factory    | 70000   | 40000      | 262,144      |
| EEPROM     | B0000   | 10000      | 65,536       |
| bs         | C0000   | 10000      | 65,536       |
| cfg        | D0000   | 100000     | 1,048,576    |
| kernel0    | 1D00000 | F10000     | 15,794,176   |
| kernel1    | 10E0000 | F10000     | 15,794,176   |




## Other Tree References 

`sdhci` SecureDigital (eMMC) Host Controller Interface - `nand2`
`rgmii1/2` - Gig Ethernet PHY
`spi` - SPI bus for JEDEC Flash - `nand1`
`pcie` - PCIe bus

PIN Mux - pinctl0
gpio, `i2c`, `uart2`, `rgmii2` and `jtag`
uart3 - `uart3`


3 USB3 PHYs

HNat - Hardware based Network Address Translation


3 UART
1 `uartlite`
2 `uartfull`



## Ethernet Related

`raeth` - Ralink ethernet
`ethsys` - 
`ethernet`


`gsw` 5 port ethernet switch (assume port 6 is the host CPU?)


## Referenced from HWNat


Only bank0 is linux accessable

Bank1/2 hidden



# Boot Sequence
## Stage 1 - Boot MT7975AE
- Perform WEN on SPI flash and check for write ready state
- The WiFi chipset SPI clocks approximately 40MHz
- Read 0x00 for interrupt vectors
- Read 0x1000 through 0x9000 for initial image
- Continue reading 0x9000 through 0x29260
- Bring up MIPS core - Single SPI Mode - initially 250kHz then 17MHz
- Continue reading at 0x29260 to 0x43DE0
- MIPS core transitions to dual fast mode SPI and clock rate increases
- MIPS reads at 0x143C, 0x1A90, 0x8B88, 0x1B0C, 0x1460, 0x73D0, 0x7430 while Radio reads at 0x043FA0
- WiFi Concludes read at 0x97F60
- MIPS reads small region at 0xB0000
- Later the 32MB SPI seems to be mastered by two deices as the clocking transitions between 10/30MHz clocking
- The 10MHz clocking is irregular indicating “bit-banging” instead of being mastered by a PLL from a crystal oscillator source (like a 24/32MHz Quartz) - Big Banging occurs at a range of 1.1MHz to 10MHz, well below the PLL


JEDEC ID: 0xC22019C22019


