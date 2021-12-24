
## Flags
V = Volitale
P = Persistent


| Name            				| Type     	| Flags	| Device Types    	|  Description											|
| ----------------------------- | --------- | ----- | ----------------- | ----------------------------------------------------- |
| auto-boot       				| Boolean  	| P   	| iDevice, T2, M1 	| If the device should `fsboot` upon power on
| bootdelay       				| Integer  	| P   	| iDevice, T2, M1 	| 
| auto-boot-usb   				| 			| 		|					|
| boot-command    				| String   	|		|
| boot-args       				| String  	|		|
| boot-device     				| String	|
| boot-partition  				| Integer	|
| boot-path       				| String	|
| boot-ramdisk    				|
| boot-script    				|
| boot-stage      				|
| boot-volume     				|
| failboot-breadcrumbs 			|
| diags-path					|
| build-version    				|
| build-style                   |
| device-material             	|
| utc-offset                  	|
| SystemAudioVolumeExtension  	|
| SystemAudioVolume				|
| IDInstallerDataV2				| String	| P		| macOS				| Installer Data
| fmm-computer-name				| String	| P		| macOS, M1			|
| lts-persistance				|
| prev-lang:kbd               	| String 	| P 	| macOS				|
| prev-lang-diags:kbd 			| String 	| P 	| macOS				|
| aht-results 					| String	| P 	| macOS 			| Apple Hardware Test (diags) - PList
| filesize 						| String 	| V 	| iDevices, T2, M1 	| Hex number
| loadaddr						|
| pintoaddr						|
| debug-uarts 					| Integer 	| P 	| iDevices, T2, M1 	| Bitfield of which UARTs to enable
| debug-gg						|
| debug-soc						|
| usb-enabled					|
| is-tethered					|
| restore-outcome				|
| upgrade-boot-volume			|
| update-volume					|
| enable-upgrade-fallback		|
| force-upgrade-fail			|
| ota-updateType				|
| ota-controllerVersion			|
| ota-uuid						|
| ota-breadcrumbs				|
| core-bin-offset				|
| cpu-bin-offset				|
| soc-bin-offset				|
| ramdisk-size					|
| radio-error					|
| display-color-space			|
| display-timing				|
| display-rotation				|
| backlight-level				|
| com.apple.System.boot-nonce	|
| kaslr-off						|
| kaslr-slide					|
| ipaddr						|
| serverip						|
| rbdaddr0						|
| eth1addr						|
| ethaddr						|
| bt1addr						|
| btaddr						|
| wifi1addr						|
| wifiaddr						|
| pwr-path						|
| pmgr_gpu_override				|
| pmgr_cpu_override				|
| idle-off						|
| darkboot						|
| DClr_override					|
| adbe-tunable					|
| adbe-tunables					|
| adfe-tunables					|
| cam-use-ext-ldo				|
| e75							|
| fixed-lcm-boost				|
| pinot-panel-id				|
| summit-panel-id				|
