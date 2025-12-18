# Abusing EFI Variables and the AMT
**SUPERCEDED: This appears to be downstream of the Dark Symbiote CS/ME** 
[+WIP: Intel Goa’uld (Dark Symbiote)](https://paper.dropbox.com/doc/WIP-Intel-Goauld-Dark-Symbiote-W2zOTnalFBinwmosi4ghG) 

## Speculation on How EFI was Modified:

By simply having Ring 0 (kernel mode) one can place EFI variables into NVRAM via EFI runtime services.  If one of these variables is scanned as a valid FFV, that gives execute at level of Ring -1, from there modifying the SPI contents of the flash chip to re-write the Intel ME / Intel Gigabit Ethernet is possible.  By flashing an old version of the Intel ME (or better the Intel AMT) one can take advantage of known CVEs in the Intel ME giving Ring -3.  From here one can inject any SMBios of their choosing and maintain Ring -2 every boot.  This allows for a evil actor to run their own stack during any OS load or reinstall.  By using AMT ramdisks, EFI drivers, and modifying the ACPI tables they can then live in Ring 0 cooperatively with any OS that is installed.

# Booting Into a Decent Shell

After some working around various issues I finally got into a decent EFI v2.2 shell.  The first five entries in the handle table were what are known as “FFV” or flash-firmware-volume entries.  This implies that the lion share of this is happening one of two ways: the flash chip has been somehow updated to a version of EFI that it should not contain, or two that something is persisting to disk and performing a restore in a way that it is not possible to reset with only pulling the power cable out of the device.  It is clearly running vPro and the AMT stack, and has created an entry of a ramdisk entry (shows in the table) as well as loading a number of drivers and Dxe’s that are to say the least, unexpected.

From a running linux view the following EFI vars were observed, not matching in any way what was pulled from the shell: https://gist.githubusercontent.com/rickmark/21059379ab65c11bfcb2f3b339bdbea1/raw/7a0d2a60f38cdc1bf7887df1e7e461474dced25c/refi_var_list.txt


- `PlatformLangCodes` = `en-US;x-UQI`
- `ItkModifiedSetup` = 0 
- `MeInfoSetup`
- `SIO_DEV_STATUS_VAR`
- `VV_SIO_LD0`
- `DriverHlthEnable`
- `TpmServFlatgs`
- `OptaneState`
- `FPDT_Volatile`
- `NBPlatformData`
- `E770BB69-BCB4-4D09-9E97-23FF9456FEAC:SystemAccess` = 0
- `BootDebugPolicyApplied`
- `CurrentPolicy`
- `CurrentActivePolicy`
- `1C697A091199_IAIDPXE`
- `Ip6Config:16697A091199`
- `IPv4Config2:1C697A091199`
- `SetupCpuFetures`




- StandardGUID `8BE4DF61-93CA-11D2-AA0D-00E098032B9C`
    - `ACA9F304-21E1-4852-9875-7FF488AD67A5`
        - `PCI_COMMON`
    - `7B59104A-C00D-4158-87FF-F03D6396A915`
        - `S`ecureBootSetup
    - `EC87D643-EBA4-4BB5-A1E5-3F3E36B20DA9`
        - `SdioDevConfiguration`
    - `64192DCA-D034-49D2-A6DE-65A829EB4C74`
        - `IccAdvancedSetupDataVar
    - `5432122D-D034-29D2-A6DE-65A829EB4C74`
        - `MeSetupStorage`
    - `90D93E09-4E91-4B3D-8C77-C82FF10E3C81`
        - `CpuSmm`
    - `05A798EA-39EE-40FC-92C5-622582FA634B`


Asking the device for the listing of devices shows

| Seg:Bus:Dev:Func | Ven:Dev   | Description                                       |
| ---------------- | --------- | ------------------------------------------------- |
| 00:00:00:00      | 8086:3ED0 | Bridge Device - Host/PCI bridge                   |
| 00:00:02:00      | 8086:3EA5 | Display Controller - VGA/8514                     |
| 00:00:08:00      | 8086:1911 | Other System Peripheral (Gaussian Mixture Model?) |
| 00:00:12:00      | 8086:9DF9 | Other DAQ & SP controllers                        |
| 00:00:14:00      | 8086:9DED | USB Controller                                    |
| 00:00:14:02      | 8086:9DED | RAM Memory Controller (Interface 30)              |
| 00:00:16:00      | 8086:9DE0 | Simple Communications Controller                  |
| 00:00:17:00      | 8086:9DD3 | Mass Storage SATA (interface 1)                   |
| 00:00:1D:00      | 8086:9DB0 | Bridge Device PCI/PCI                             |
| 00:00:1F:00      | 8086:9D84 | Bridge Device PCI/ISA bridge                      |
| 00:00:1F:04      | 8086:9DA3 | SMBus Controller                                  |
| 00:00:1F:05      | 8086:9DA4 | Serial Bus Controllers                            |
| 00:00:1F:06      | 8086:15BE | Network Controller                                |
| 00:01:00:00      | 144D:A808 | Mass Storage Controller - NV memory subsystem     |


The following does skip some entries as there’s no good way to copy and paste this, and UDIDs are hard…

- LoadedImage `DxeCore`
- `5CB5C776-`
- Decompress
- FirmwareVolume2 `-B9A42172CE53`
- FirmwareVolume2 `-EC40C23C5916`
- FirmwareVolume2 `-DC1671C10F36`
- FirmwareVolume2 `-E48809A7ACE3`
- FirmwareVolume2 `-2A4FF6CA6FE5`
- `EE4E5898-`
- LoadedImage `StatusCodeDxe`
- `36232936-`
- SmartCardReader RscHandler
- LoadedImage `PcdDxe`
- GetPcdInfo GetPcdInfoProtocol Pcd Pcd
- LoadedImage `CpuIo2Dxe`
- CpuIo2
- LoadedImage `FlashDriver`
- `755B6596-`
- LoadedImage `NvramDxe`
- VariableWriteArch VariableArch
- MonotonicCounterArch
- LoadedImage `CrbDxe`
- LoadedImage `FastBootRuntime`
- LoadedImage `DxeBoardConfigInit`
- LoadedImage `WdtDxe`
- LoadedImage `CmosDxe`
- `9851740C-`
- LoadedImage `RomLayoutDxe`
- HiiPackageList LoadedImage `Bds`
- BdsArch
- LoadedImage `DataHubDxe`
- `AE80D021-`
- LoadedImage `DevicePathDxe`
- DevicePathFromText DevicePathToText DevicePathUtilities
- DebugSupport EBCInterpreter LoadedImage `EbcDxe`
- LoadedImage `HiiDatabase`
- HIIImage ConfigKeywordHandler HIIConfigRouting HIIDatabase HIIString HIIFont
- LoadedImage `SecurityStubDxe`
- SecurityArch Security2Arch
- LoadedImage `TimestampDxe`
- Timestamp
- LoadedImage `CpuDxe`
- LoadedImage `CpuIoDxe`
- `B0732526-`
- LoadedImage `AmiCpuFeaturesDxe`
- LoadedImage `AmiPciPlatform`
- PciPlatform
- DebugPort LoadedImage `GopDebugDxe`
- LoadedImage `WdtAppDxe`
- LoadedImage `PlatformInfoDxe`
- LoadedImage `PolicyInitDxe`
- LoadedImage `AmiSyncSetupData`
- LoadedImage `CpuInitDxe`
- `E223CF65-`
- LoadedImage `SmmAccess`
- SmmAccess2
- LoadedImage `LegacyInterrupt`
- `31CE593d-`
- LoadedImage `PchSmbusDxe`
- SmbusHc
- LoadedImage `FspWrapperNotifyDxe`
- LoadedImage `Aint31`
- LoadedImage `Acoustic`
- `10E9D800-`
- LoadedImage `S3SaveStateDxe`
- S3SaveState
- LoadedImage `SioDxeInit`
- `9D36F7EF-`
- LoadedImage `IdeBusBoard`
- LoadedImage `PciDxeInit`
- `EC63428D-`
- LoadedImage `RdspPlus`
- ComponentName2 DriverBinding LoadedImage `Uhcd`
- `2AD8E2D2-`
- ComponentName2 DriverBinding
- ComponentName2 DriverBinding
- LoadedImage `DpcDxe`
- `480F8AE9-`
- LoadedImage `AmiBoardInfo2`
- `4FC0733F-`
- LoadedImage `FanDxe`
- LoadedImage `HddSecurity`
- `CE6F86BB-`
- LoadedImage `EsrtDxe`
- `A340C064-`
- LoadedImage `OpalSecurity`
- `59AF16B0-`
- LoadedImage `RngDxe`
- Rng
- LoadedImage `AmiRedFishApi`
- `B5E7C7AF-`
- LoadedImage `AmiDeviceGuardApi`
- `DAEEAFC8-`
- LoadedImage `TpmSmbiosDxe`
- LoadedImage `TpmNvmeSupport`
- LoadedImage `TcgStorageSecurity`
- `734AA01D-`
- LoadedImage `UpdateDriverProtocol`
- LoadedImage `CpuDxe`
- CpuArch
- MpService
- LoadedImage `DxeSignBiosAuthenticate`
- `24400798-`
- LoadedImage `EventLog`
- `DAED23EC-`
- LoadedImage `IntelVBios2`
- HIIFormBrowser2
- `49374A18-`
- HIIFormBrowser2
- `1F73B18D-`
- `348C4D62-`
- `BEBF428C-`
- LoadedImage `FsDxe`
- LoadedImage `DnsrDxe`
- ComponentName2 DriverBinding LoadedImage `NTFS`
- LoadedImage `CapsuleRuntimeDxe`
- CapsuleArch
- LoadedImage `RuntimeDxe`
- RuntimeArch
- MetronomeArch LoadedImage `SbRun`
- RealTimeClockArch
- SmmControl2 LoadedImage `SmmControl`
- LoadedImage `MePlatformReset`
- ResetArch
- LoadedImage `CryptoDXE`
- ComponentName2 DriverBinding LoadedImage `NTFS`
- DriverBinding LoadedImage `MouseDriver`
- LoadedImage `StdDefaultsUpdate`
- LoadedImage `Achi`
- 83: CompnentName2 DriverBinding
- LoadedImage `HttpUtilitiesDxe`
- HttpUtilities
- LoadedImage `Nvme`
- ComponentName2 DriverBinding
- LoadedImage `SecureBootDXE`
- LoadedImage `TcgPlatformSetupPolicy`
- LoadedImage `ITK50`
- LoadedImage `CISDWdtDxe`
- LoadedImage `OCDxe`
- LoadedImage `OemGop`
- LoadedImage `NbDxe`
- LoadedImage `AmiTxtDxe`
- LoadedImage `HstiIhvDxe`
- LoadedImage `TxtDxe`
- LoadedImage `PciHostBridgeDxe`
- PciHostBridgeResourceAllocation
- PCIRootBridgeIO DevicePath(PciRoot(0x0))
- LoadedImage `AmiUpdateCspResources`
- `27CFAC87-`
- LoadedImage `PchSpiRuntime`
- `00C7D289-`
- LoadedImage `SiInitDxe`
- IncompatiblePciDeviceSupport
- LoadedImage `HpetTimerDxe`
- TimerArch
- HiiPackageList LoadedImage `AmiHsti`
- AdapterInfo(AdapterInfo)
- LoadedImage `ACPI`
- AcpiSdt AcpiTable
- `01FA319E-`
- LoadedImage `AcpiS3SaveDxe`
- HiiPackageList LoadedImage `PciOutOfResourcesSetupPage`
- LoadedImage `UsbRtDxe`
- HiiPackageList LoadedImage `HddSmart`
- `9401BD4F-`
- HiiPackageList LoadedImage `PauseKey`
- LoadedImage `SmbiosBoard`
- HiiPackageList LoadedImage `Tpm20PlatformDxe`
- LoadedImage `CpuS3DataDxe`
- LoadedImage `PlatformConfigDxe`
- `C298B206-`
- `23F2D944-`
- HiiPackageList `ICBDTSEPopupMenu`
- HiiPackageList LoadedImage `HkUpdate`
- `E2E6CF23-`
- HiiPackageList LoadedImage `PlatformIdPage`
- HIIConfigAccess
- LoadedImage `OemBoardDxe`
- `BA8D58AB-`
- LoadedImage `PiSmmIpl`
- LoadedImage `PiSmmCore`
- SmmCommunication SmmBase2
- LoadedImage `Tcg2Dxe`
- LoadedImage `StatusCodeDxe`
- LoadedImage `FlashDriverSmm`
- `ECB867AB-`
- LoadedImage `CpuIo2Smm`
- LoadedImage `SmmLockBox`
- `BD445d79-`
- LoadedImage `PchSmbusSmm`
- LoadedImage `SraSmmStub`
- LoadedImage `AhciSmm`
- LoadedImage `CryptoCMM`
- `91ABC830-`
- LoadedImage `SmmS3SaveState`
- LoadedImage `RuntimeSmm`
- `395C33FE-`
- LoadedImage `PiSmmCpuDxeSmm`
- SmmConfig
- LoadedImage `NvramSmm`
- `CD3D0A05-`
- LoadedImage `PchSpiSmm`
- LoadedImage `SmmPcieSataController`
- LoadedImage `SbDxe`
- WatchdogTimerArch
- `17706D27-`
- PciHotPlugInit
- `377E6D6B-`
- LoadedImage `CnvUefiVariables`
- `C77AE557-`
- LoadedImage `Dptf`
- LoadedImage `HstiResultDxe`
- LoadedImage `TbtDxe`
- `4D6A54D1-`
- LoadedImage `PlatoformVTdSampleDxe`
- `3D17E448-`
- LoadedImage `PlatformSetup`
- `D5E1268B-` `D4D2F201-`
- LoadedImage `PowerMgmtDxe`
- `D71DB106-`
- LoadedImage `BdatAccessHandler`
- LoadedImage `PchInitDxe`
- LoadedImage `SraDxe`
- `7AE12E27-`
- LoadedImage `HeciInit`
- `EC7BC880-`
- `1498D127-`
- LoadedImage `BootScriptExecutorDxe`
- LoadedImage `HardwareSignatureEntry`
- `43169678-`
- ComponentName DriverBinding LoadedImage `RtkSdCardDxe`
- LoadedImage `Smbios`
- LoadedImage `OEMActivation`
- LoadedImage `OemUsbPort`
- LoadedImage `OemEventDxe`
- LoadedImage `SaInitDxe`
- LegacyRegion2
- `9E67AECF-`
- `603DF7CA-`
- LoadedImage `AcpiPlatform`
- `C77AE556-`
- LoadedImage `AcpiDebugDxe`
- LoadedImage `RamDiskDxe`
- HIIConfigAccess DevicePath `-BB1A4F94081E`
- HIIConfigAccess DevicePath `-2B769AAA30C5`
- F7: `28A03FF4-` RamDisk
- LoadedImage `ItkSmmVarsDxe`
- LoadedImage `ItkSmmVarsDxe`
- LoadedImage `PchSmiDispatcher`
- LoadedImage `CpuSpSMI`
- LoadedImage `NbSmi`
- LoadedImage `PowerButton`
- LoadedImage `SbRunSmm`
- LoadedImage `SleepSmi`
- FF: LoadedImage `PeriodicSmiControl`
- LoadedImage `TcoSmi`
- LoadedImage `AcpiModeEnable`
- LoadedImage `PepBccdSmm`
- LoadedImage `TbtSmm`
- LoadedImage `OverClockSmiHandler`
- LoadedImage `PowerMgmtSmm`
- LoadedImage `SaLateInitSmm`
- `0D66A1CF-` LoadedImage `PchInitSmm`
- LoadedImage `UsbRtSmm`
- LoadedImage `CmosSmm`
- LoadedImage `SmmHddSecurity`
- LoadedImage `NvmeSmm`
- LoadedImage `SdioSmm`
- LoadedImage `TpmClearOnRollbackSmm`
- LoadedImage `SmmTcgStorageSec`
- LoadedImage `CrbSmi`
- LoadedImage `PiSmmCommunicationSmm`
- LoadedImage `RtcWakeup`
- LoadedImage `ItkSmmVars`
- LoadedImage `OemBoardSmi`
- LoadedImage `SmmPlatoform`
- ImageDevicePath `-AB74D2C1A600` LoadedImage `EnglishDxe`
- UnicodeCollation2 UnicodeCollation
- LoadedImage `SmbiosUpdateData`
- LoadedImage `AmiMemoryInfoConfig`
- LoadedImage `MeSmbiosDxe`
- ComponentName2 ComponentName DriverBinding ImageDevicePath `-CD92CFB7D362` LoadedImage `SataController`
- LoadedImage `PlatofrmInitDxe`
- LoadedImage `VtioDxe`
- LoadedImage `DxeOverClock`
- LoadedImage `MeFwDowngrade`
- `3EA824D1-`
- LoadedImage `ConSplitter`
- ComponentName2 DriverBinding
- ComponentName2 DriverBinding
- AbsolutePointer SimplePointer SimpleTextInEx SimpleTextIn SimpleTextOut
- LoadedImage `GraphicsConsole`
- ComponentName2 DriverBinding
- ComponentName2 ComponentName DriverBinding LoadedImage `DiskIoDxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `PartitionDxe`
- LoadedImage `RstOneClickEnable`
- LoadedImage `RstuefiDriverSupport`
- `5B10CDC8-`
- SupportedEfiSpecVersion(`0x0002001E`) ComponentName2 ComponentnName DriverBinding LoadedImage `IntegratedTouch`
- LoadedImage `GenericSio`
- `7576CC89-` ComponentName2 DriverBinding
- LoadedImage `IdeBusSrc`
- 132: ComponentName2 DriverBinding
- LoadedImage `PciBus`
- ComponentName2 DriverBinding
- LoadedImage `Ps2Main`
- ComponentName2 DriverBindding
- ComponentName2 ComponentName DriverBinding LoadedImage `SnpDxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `MnpDxe` 
- ComponentName2 ComponentName DriverBinding LoadedImage `ArpDxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `IpSecDxe`
- IpSec2 IpSecConfig
- ComponentName2 ComponentName DriverBinding
- ComponentName2 ComponentName DriverBinding LoadedImage `TcpDxe`
- ComponentName2 ComponentName DriverBinding
- 13F: 
- ComponentName2 ComponentName DriverBinding LoadedImage `UefiPxeBcDxe`
- ComponentName2 ComponentName DriverBinding
- ComponentName2 ComponentName DriverBinding LoadedImage `DnsDxe`
- ComponentName2 ComponentName DriverBinding
- LoadedImage `TlsDxe`
- TlsServiceBinding
- ComponentName2 ComponentName DriverBinding LoadedImage `Dhcp4Dxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `Ip4Dxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `Mtftp4Dxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `Udp4Dxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `Ip6Dxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `Udp6Dxe`
- ComponentName2 ComponentName DriverBinding LoadedImage `Mtftp6Dxe`
- LoadedImage `AtaPassThru`
- `C6734411-`
- LoadedImage `AudioPlayback`
- ComponentName2 ComponentName DriverBinding LoadedImage `Fat`
- AuthenticationInfo iSCSIInitiatorName ComponentName2 ComponentName DriverBinding LoadedImage `IScsiDxe`
- ComponentName2 ComponentName DriverBinding
- HIIConfigAccess DevicePath(`-CCAD2E0F4CF9`)
- ComponentName2 ComponentName DriverBinding LoadedImage `ScsiBus`
- ComponentName2 ComponentName DriverBinding LoadedImage `ScsiDisk`
- LoadedImage `PcieSataController`
- ComponentName2 DriverBinding
- ComponentName2 DriverBinding
- ComponentName2 DriverBinding LoadedImage `SdioDriver`
- LoadedImage `AcpiPlatformFeatures`
- LoadedImage `CustomSMBIOS`
- HiiPackageList LoadedImage `AMITSE`
- HiiPopup 
- 160: LoadedImage `SmmGenericSio`
- LoadedImage `UpdateMemoryRecord`
- EDIDOverride
- PciEnumerationComplete
- `30249499-` `C7D4703B-`
- `651B7EBD-` `DBCB2FCD-` ComponentName2 DriverBinding ImageDevicePath((`0x3`,`0x75F5A018`,`0x75F6BA98`)) LoadedImage MemoryMapped
- `3279A703-`
- `AD77AE29-` `1FD29BE6-` AtaPassThru
- `1FD29BE6-` `AD77AE29`
- `FA20568B-`
- `6DE538E4-`
- `A33319B5-`
- `A33319B5-`
- DevicePath LoadFile
- ImageDevicePath LoadedImage `SmbiosMisc`
- ImageDevicePath LoadedImage `FileExplorerLite`
- `088C3203-`
- HiiPackageList ImageDevicePath LoadedImage `DpsdSetup`
- HIIConfigAccess DevicePtah
- BootManagerPolicy
- `A68D1FDE-`
- `4622F942-`
- HIIConfigAccess DevicePath
- `3A3300AB-`
- `F8DD3A9D-`
- `F31FCBB5-`
- `348C4D62-`
- 18F: `348C4D62-`
- `348C4D62-`
- AdapterInfo(AdapterInfo)
- `0F500BE6-`
- `8D9B3387-`
- Shell ShellParameters SimpleTextOut ImageDevicePath LoadedImage()
- PciEnumerationComplete `F42A009D-`
- USBHostController2 USBHostController `3279A703-` DevicePath(PciRoot(0x0)/Pci(0x14,0x0)) PCIIO
- `0ADFB62D-` SimpleTextInEx SimpleTextIn `1FEDE521-` DevicePath(..)/Pci(0x14,0x0)/USB(0x0,0x0)) USBIO
- 198: SimplePointer `1FEDE521-` DevicePath(..)/Pci(0x14,0x0)/USB(0x0,0x1)) USBIO
- DevicePath(..)/Pci(0x014,0x0)/USB(0x0,0x2)) USBIO
- `30249499-` `C7D3703B-` LoadFile2 BusSpecificDriverOverride DevicePath(PciRoot(0x0)/Pci(0x2,0x0)) PCIIO
- `E1E4A857-` SimpleTextOut EDIDActive(EDIDActive GraphicsOutput(GraphicsOutput) EDIDDiscovered(EDIDDiscovered) `39487C79-` DevicePath(..0x2,0x0)/AcpiAdr(0x80013310))
- DevicePath(PciRoot(0x0)/Pci(0x0,0x0)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x8,0x0)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x12,0x0)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x14,0x0)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x16,0x0)) PCIIO
- `FDB29BE6-` `AD77AE29-` AtaPassThru `B2FA4764-` IdeControllerInit DevicePath(PciRoot(0x0)/Pci(0x17,0x0)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x1D,0x0)) PCIIO
- `4B235191-` `1FD29BE6-` `AD77AE29-` `F4F63529-` NvmExpressPassThru `AFA4CF3F-` DevicePath(..)/Pci(0x1D,0x0)/Pci(0x0,0x0)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x1F,0x0)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x1F,0x4)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x1F,0x5)) PCIIO
- DevicePath(PciRoot(0x0)/Pci(0x1F,0x6)) PCIIO
- DiskIO `F4F63529-` BlockIO DickInfo DevicePath(..17,0x0)/Sata(0x2,0xFFFF,0x0))
- 1A1: DickIO `E6D6D379-` PartitionInfo BlockIO DevicePath(..49E6173E12,0x800,0x7470658F))
- DiskIO BlockIO DiskInfo DevicePath(..0x1,8D-73-B0-91-55-38-26-00)) StorageSecurityCommand
- SimpleFileSystem DiskIO EFISystemPartition PartitionInfo BlockIO DevicePath(..-FFC0339F3A57,0x800,0xEE000))
- DiskIO `0FC63DAF-` PartitionInfo BlockIO DevicePath(..78C7D5369,0xEE800,0x12A0800))
- 1A7: DiskIO `E6D6D379-` PartitionInfo BlockIo DevicePath(.. 18EF8D,0x138F000,0x38FF6800))
# Open Questions:
- How does the EFI Runtime Services pointer get passed from EFI boot-loaders to the kernel?  Or does it re-scan ACPI to pick it up?
- Why does the kernel have an option for performing an ACPI SSDT overlay from an EFI variable?
- Will a EFI variable containing a EFI FFV (flash firmware volume) or FFS (flash file system) be picked up as part of the EFI payload?  Would this allow for early injection of additional DXE’s into the runtime environment before exiting EFI to the boot-loader?  
- For what possible reason did someone think it was a good idea to have an NVMe over TCP and other fabric protocol?  This seems to be in use as the device also showed up with a `wwn` or “World Wide Name” ala iSCSI.
- What is required to enable AMT on a device that was not intended for it?
- For what reason would a firewire and cdrom kernel module get injected into initrd?
- Why would there be a script in initrd that creates systemd units that are later deleted?
- Why would a network controller be brought up 3 times with the name WMI identity when virtualization of the adapter is not in use
- Why would network address families be brought up so early in the process if not to access the root filesystem across a synthetic network fabric?
- Why would seccomp be creating eBPF LSM executables without any other audit record?
- Why would one override the ACPI tables for Intel WiFi compliance if not to use frequency bands from other countries in the US to evade detection?
- Why would a bluetooth based braile TTY attempt to come up if not a side channel for access to the machine?
- Why would kernel objects on a clean Arch install (`*.zko`) files be signed with an ephemeral key if not tampered with?
- Why is there a “bluetooth meshing” driver
- Why is the EC able to perform interrupt pausing and resumption - during normal operation of the Intel ME it doesn’t interfere with normal OS operations in this way.
- Why would there be two tpm objects if not a root and a synthetic device?  Or perhaps a dTPM while the system has also enabled a fTPM (both occur at path ACPI `LNXSYSTM:00-LNXSYBUS:00-MSFT0101:00` which makes reference to the Microsoft ACPI table
- Can `dleyna` be used as a form of remote desktop?
- What is `slsh`?
- Why does the SATA device occur at ata3-host2-target2 - and why is ata1/2 “DUMMY”
- Why does the network device occur at address PCI `0000:00-0000:00:1f.6` and not `.0`?  Are these IO-SRV virtual functions?
- Why are the TTYs `platform-serial8250` which is a hardware backed device rather then a psudo terminal
- Why did a `/var/lib/machines` mount come up and later die?
- Why is there a `binfmt_misc` that gets brought up with the system
- Why are there kernel trace file system mounts?
- What is `systemd-ask-password-console.path` and `systemd-ask-password-wall.path`
- Why would there be an on shutdown service `mkinitcpio-generate-shutdown-ramfs.service` as this should only happen upon kernel updates via pacman.  It runs with `TMPDIR=/run` and `/usr/bin/mkinitcpio -A sd-shutdown -k none -c /dev/null -d /run/initramfs`
- What is `shaddow.service` and why does it have to run to change or verify `passwd` and `shaddow` - both of which have clearly been edited as they contain a vi trailing “-” pair.  Seems to execute `/usr/binpwck -r || r=1; /usr/bin/grpck -r`
- What `systemd-boot-system-token.service` do?
- What are the `getty-pre.target` doing?
- Why is `remote-fs.target` a thing, it also includes `verity` and `cryptsetup`
- Somehow “RealtimeKit” is a name collision on linux and apple ecosystems?  Also what happened to `remoteproc` for the Intel EC
- Why is `udisks2` being used as a fuse helper for most things
- Why does my initrd have a `/usr` mount (`initrd-usr-fs.target`) - clearly this is being loaded across some other busbecause I have no `/usr` but do have a `/usr/local` in my `fstab`
- What is `request-key.conf` and why does it have to many defined values for debug and dns_resolver, it also seems to make special consideration o `debug:loop:*`
- What is “Rygel Remote UI Server”
    - Secure TTY config makes reference to `hvc0` - probably some hypervisor based channel
    - it also allows the tty[1-6], ttyS0 and console
    - 
# Useful non-Network Control Channels

Using accessibility systems like `brltty` over bluetooth can give terminal access without need of a reliable network (WiFi or ethernet).


# Early Injection using Firewire Serial



# Messing with the ACPI Tables

People often forget that operating systems will happily collect data from ACPI including AML code.  This is usually executed during power events like suspend and resume and has been abused in the past in the form of “dark wake” attacks.


# Hiding from Root Using the Linux BFP LSM

One of the more recent advancements in the Linux tree is reusing eBPF (yes of note because it has been used for network firewalls for many years) to become a policy agent.  eBPF was selected because it is a Turing complete language that we already compile and execute in-kernel by way of `ip_tables`/`x_tables` and the like.

When auditing is enabled, loading and unloading of these BPF programs will become part of the kernel debug output so they can be observed.  You can actually “mount” this to see the BPF entries by executing `mount bpffs /mnt/bpffs/ -t bpf` which will provide `maps.debug` and `progs.debug`.  Another useful tool to get more information about this is `bpftool prog show`

# Xen Para-virtualization is Still a Thing

Even without using Intel’s VT, it is still very possible for an attacker to `kexec` into a Xen based kernel providing themselves a way to control non-virtual ring-0 even while still letting an arbitrary linux guest OS execute thinking it is the kernel of the system.  Even without `kexec` one can do about exactly the same thing using `kgdb` after transferring an image to memory.



## Tampering During Compile
- `sync_regs()`
- `mce_setup()`
- `do_machine_check()`
- `rcu_nmi_enter()`

