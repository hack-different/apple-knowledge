
## Flags
V = Volitale
P = Persistent
S = System
C = Common


| Name                                      | Type      | Flags | Device Types      |  Description                                          |
| ----------------------------------------- | --------- | ----- | ----------------- | ----------------------------------------------------- |
| _csegbufsz_experiment                     |
| _libmalloc_experiment                     |
| AAPL,ignore                               |
| aapl,pci                                  |
| aapl,panic-info                           |
| adbe-tunable                              |
| adbe-tunables	                            |
| acc-cm-override-charger-count             |
| acc-cm-override-count                     |
| acc-mb-ld-lifetime                        |
| adfe-tunables                             |
| aht-results                               | String    | P     | macOS 			| Apple Hardware Test (diags) - PList
| allow-root-hash-mismatch                  |
| ane-type                                  |
| aud-early-boot-critical                   |
| auto-boot                                 | Boolean   | P     | iDevice, T2, M1 	| If the device should `fsboot` upon power on
| auto-boot?                                | Boolean
| auto-boot-halt-stage                      |
| auto-boot-usb                             |           |       |                   |
| auto-boot-x86-once                        |
| backlight-level                           |
| backlight-nits                            |
| base-system-path                          |
| BaseSystemAccessabiliityFeatures          | 
| battary-health                            |
| bluetoothHostControllerSwitchBehaviour    |
| BluetoothInfo                             |
| BluetoothUHEDevices                       |
| board-id                                  |
| bootdelay                                 | Integer   | P     | iDevice, T2, M1   | 
| boot-args                                 | String    |       |
| boot-breadcrumbs                          |
| boot-command                              | String   	|       |
| boot-device                               | String    |
| boot-file                                 |
| boot-image                                |
| boot-partition                            | Integer   |
| boot-path                                 | String    |
| boot-ramdisk                              |
| boot-script                               |
| boot-stage                                |
| boot-volume                               |
| BOSCatalogURL                             |
| build-version                             |
| build-style                               |
| bt1addr                                   |
| btaddr                                    |
| cam-use-ext-ldo                           |
| com.apple.System.boot-nonce	            |
| com.apple.System.fp-state                 |
| com.apple.System.sep.art                  |
| com.apple.System.tz0-size                 |
| console-screen                            |
| core-bin-offset                           |
| cpu-bin-offset                            |
| csr-data                                  |
| current-network                           |
| darkboot                                  |
| DClr_override                             |
| debug-gg                                  |
| debug-soc                                 |
| debug-uarts                               | Integer   | P     | iDevices, T2, M1 	| Bitfield of which UARTs to enable
| DebugBluetoothHIDShim                     |
| default-client-ip                         |
| default-gateway-ip                        |
| default-mac-address?                      | Boolean   |
| default-router-ip                         |
| default-server-ip                         | String    |
| default-subnet-mask                       | String    |
| DefaultBackgroundColor                    |
| device-material                           |
| diag-device                               | String    |
| diag-file                                 | String    |
| diag-switch?                              | Boolean   |
| diags-path                                |
| disable_screensavers                      |
| display-carveout-inhibitcache             |
| display-color-space                       |
| display-timing                            |
| display-rotation                          |
| e75                                       |
| emu                                       |
| enable-remap-mode                         |
| enter-tdm-mode                            | Boolean   |       | x86               | Enter USB Target Disk Mode
| eth1addr                                  |
| ethaddr                                   |
| failboot-breadcrumbs                      |
| fcode-debug?                              | Boolean   |
| filesize                                  | String    | V     | iDevices, T2, M1 	| Hex number
| fixed-lcm-boost                           |
| fmm-computer-name                         | String    | P	    | macOS, M1         |
| fmm-mobileme-token-FMM                    |
| fmm-mobileme-token-FMM-BridgeHasAccount   |
| fmm-mobileme-foken-FMM-WipePending        |
| force-upgrade-fail                        |
| HardwareModel                             |
| idle-off                                  |
| IASCurrentInstallPhase                    |
| IASInstallPhaseList                       |
| IASUCatalogURL                            |
| IDInstallerDataV2	                        | String    | P	    | macOS	            | Installer Data
| input-device                              |
| input-device-1                            |
| IOBusyInterest                            |
| IODeviceMemory                            |
| IOPlatformActiveAction                    |
| IOPlatformHaltRestartAction               |
| IOPlatformPanicAction                     |
| IOPlatformQuiensceAction                  |
| IOPlatformSleepAction                     |
| IOPlatformWakeAction                      |
| IORematchPersonality                      |
| ipaddr                                    |
| is-tethered                               |
| kaslr-off	                                |
| kaslr-slide                               |
| little-endian?                            | Boolean   |
| load-base                                 |
| loadaddr                                  |
| LocationServicesEnabled                   |
| lts-persistance                           |
| mca-info0                                 |
| mouse-device                              |
| net-boot                                  |
| non-coherent                              |
| nonce-seeds                               |
| nvramrc                                   |
| obliteration                              |
| oblit-begins                              |
| oblit-inprogress                          |
| oem-banner                                |
| oem-banner?                               | Boolean   |
| oem-logo                                  | 
| oem-logo?                                 | Boolean   |
| output-device                             |
| output-device-1                           |
| one-time-boot-command                     |
| ota-anomalies                             |
| ota-brain-version                         |
| ota-breadcrumbs                           |
| ota-child-failures                        |
| ota-context                               |
| ota-controllerVersion	                    |
| ota-conv-panic-indicator                  |
| ota-failure-reason                        |
| ota-forced-reset-uptime                   |
| OTA-fsck-metrics                          |
| ota-initial-breadcrumbs                   |
| ota-initial-result                        |
| ota-internal-failure-reason               |
| ota-internal-forced-reset-uptime          |
| ota-install-tonight                       |
| ota-os-version                            |
| ota-original-os-version                   |
| ota-outcome                               |
| ota-perform-shutdown                      |
| OTA-post-conversion                       |
| OTA-pre-conversion                        |
| ota-reboot-retry-enabled                  |
| ota-reboot-retry-zone                     |
| ota-result                                |
| ota-retry-battery-level                   |
| ota-retry-breadcrumbs                     |
| ota-retry-codes                           |
| ota-retry-domains                         |
| ota-retry-enabled                         |
| ota-retry-external-power                  |
| ota-retry-failure-reason                  |
| ota-retry-ids                             |
| ota-retry-monitor                         |
| ota-retry-names                           |
| ota-retry-error                           |
| ota-retry-result                          |
| ota-retry-results                         |
| ota-retry-uptime                          |
| ota-retry-user-progress                   |
| ota-retry-warnings                        |
| OTA-sealvolume-metrics                    |
| ota-step-battery-level                    |
| ota-step-codes                            |
| ota-step-domains                          |
| ota-step-error                            |
| ota-step-external-power                   |
| ota-step-ids                              |
| ota-step-monitor                          |
| ota-step-names                            |
| ota-step-results                          |
| ota-step-user-progress                    |
| ota-step-uptime                           |
| ots-step-warnings                         |
| ota-snapshot-update                       |
| ota-submission-url                        |
| ota-updateType                            |
| ota-uuid                                  |
| panicmedic                                |
| pci-probe-list                            |
| pci-probe-mask                            |
| pinot-panel-id                            |
| pintoaddr	                                |
| policy-nonce-digests                      |
| pmgr_gpu_override                         |
| pmgr_cpu_override	                        |
| pre-recovery-ota-failure-uuid             |
| preferred-count                           |
| prev-lang:kbd                             | String    | P     | macOS	            |
| prev-lang-diags:kbd                       | String    | P     | macOS	            |
| prevent-restores                          |
| pwr-path                                  |
| radio-error                               |
| rbdaddr0                                  |
| ramdisk-size                              |
| ramrod-nvram-shadow-path                  |
| ramrod-nvram-sequence                     |
| ramrod-nvram-session                      |
| recovery-boot-setting                     |
| recovery-boot-mode                        |
| recoveryos-inited-update                  |
| recoveryos-passcode-blob                  |
| real-base                                 | Number    |
| real-mode?                                | Boolean   |
| real-size                                 | Number    |
| restore-child-failures                    |
| restore-retry-coes                        |
| restore-retry-domains                     |
| restore-retry-ids                         |
| restore-outcome                           |
| restore-perform-shutdown                  |
| restore-reboot-retry-enabled              |
| restore-reboot-retry-zone                 |
| restore-retry-error                       |
| restore-retry-monitor                     |
| restore-retry-names                       |
| restore-retry-results                     |
| restore-step-codes                        |
| restore-step-domains                      |
| restore-step-error                        |
| restore-step-ids                          |
| restore-step-names                        |
| restore-step-monitor                      |
| restore-step-warnings                     |
| restore-step-results                      |
| root-live-fs                              |
| screen-#columns                           | Number    |
| screen-#rows                              | Number    |
| security-mode                             | String    |
| security-password                         | String    |
| selftest-#megs                            | Number    |
| serverip                                  |
| SleepWakeFailurePanic                     |
| SleepWakeFailureString                    |
| soc-bin-offset                            |
| StartupMute                               |
| stress-rack                               |
| summit-panel-id                           |
| system-passcode-lock-blob                 |
| SystemAudioVolume	                        |
| SystemAudioVolumeExtension                |
| SystemAudioVolumeSaved                    |
| target-uuid                               |
| tbt-options                               |
| upgrade-fallback-boot-command             |
| upgrade-boot-volume                       |
| update-volume	                            |
| usb-enabled                               |
| use-generic?                              | Boolean   |
| use-nvramrc?                              | Boolean   |
| utc-offset                                |
| virt-base                                 | Number    |
| virt-size                                 | Number    |
| wifi-fw-path                              |
| wifi-nvram-path                           |
| wifi1addr                                 |
| wifiaddr                                  |
| zhuge_debug                               |