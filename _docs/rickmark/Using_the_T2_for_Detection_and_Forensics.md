# Using the T2 for Detection and Forensics

## Todays Need

With the advent of modern security hardware, it has become near impossible to perform comprehensive security auditing of devices used in the field.  This has allowed malware to run at layers of the stack not accessible to traditional endpoint security.  Recent un-patchable hardware vulnerabilities that may have served as vectors for infection can be re-purposed for DFIR purposes, allowing us to mitigate their malicious impact.

## New Solutions

With the recent discoveries of `checkm8`, `blackbird` and the subsequent work of `checkra1n`, we are finally able to directly interact with non-mutable storage on Apple Macs, and some models of iPhone.  This provides a unique opportunity for the following:


- Reading raw data from non-volatile storage, allowing full capture in cases of legal or forensics cases
- Interacting with the SEP to potentially pull otherwise encrypted data by brute forcing the password (a working PoC is yet required)
- Comparing the contents of the system to known good baselines for implant detection and surveillance.  (see github.com/rickmark/efivalidate)
- Using the debug functionality of the T2 and Intel DCI to capture volatile memory for malware analysis
- Placing “tripwires” into the T2 to detect if the device is restarted without authorization


## Solution Categories:

**Law Enforcement/Intelligence: Direct Sale**

1. Forensics: Full physical forensic disk recovery with or without a password or filefault key.
2. Forensics: Password Retreival - Brute Force
3. Tamper Detection: DTrace / Hash Run / Store 
4. Lawful Warrant: Implement Limited Warrant / Access to Device / Audio Tap
5. Lawful Wire: Implement undetectable Screen, camera, Audio Tap for UCEs and Informants.
6. Triggered Interdiction or National Security Intervention: End point triggered shutdown / disconnect to prevent communication or computation that might result in immediate harm to  people, infrastructure, etc.
7. Hidden Terminal and Desktop and/or novel encryption and communication scheme that evades normal procedures to place malware and or extract information from laptops.
8. Self-Destruct: Implementation of triggered secure erase of devices bases on specific triggers or the absence of specific triggers.
9. Audio and Video Surveillance of via camera mic and bluetooth or wifi connection.

**Enterprise:**

1. Implementation of Remote or Local Full Wipe.
2. Implementation of Netboot or Network File System
3. Backup / Reset to Known State
4. Virus, Malware, Tamper Scanning and Protection
5. VPN / Proxy
6. Enterprise APP and Default Build Distribution and Implementation
7. Custom Recovery Environments
8. KVM

**Consumer / Advocacy:**

1. Detect and Remove DEP
2. Detect and Remove Geo Restrictions
3. App Store Alternative: Mounted 
4. Disable Camera, Mic, Speaker & Sensor
5. Hidden Disk Partition
6. Ability to Reflash and Lock Device in Specific Config ie Media Server, VPN / Cache, Simple Terminal Server, etc.
7. Tamper Detection, Recording, and Alert
8. Wifi / BT Mac Randomization
9. Mounting and Booting from Network Drives and/or Locally Stored DMGs
10. Low Level Wifi / Bluetooth / Networking Firewall and VPN that persists during Recovery etc.


## Demo - Using Chrome WebUSB to Deliver This Technology
![](https://paper-attachments.dropbox.com/s_E45BFBDCB9E23EE642EF6346F4FE25A02EC16FCEEE5E5471FDDEF207CE13C831_1602995662061_image.png)


