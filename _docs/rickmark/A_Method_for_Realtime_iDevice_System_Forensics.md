# A Method for Realtime iDevice System Forensics

# License

Creative Commons - Share Alike - Attribution

# Constraints

Apple places heavy sandboxing on Apps shipped in the AppStore.  This largely is to the benefit of the user, preventing malicious Apps from being system level privileged, but leaves a massive gap between 3rd party Apps and 1st party system Apps.  Because of this gap, there exists no API or method to pull system level logging or metrics.  This means that all detection and response capabilities be baked into the operating system and be performed by Apple.  This is clearly a single point of failure and monopoly on the data without a clear plurality of the talent in the field.  This method’s constraints are based on the idea of a non-jailbroken device (which weakens overall security stance in almost all cases) running stock iOS.  Moreover the method should be durable over time.


# Method
- Create a pairing record with `usbmuxd` on a linux workstation, enable Wi-Fi sync
    - Possibly via browser if web app via: https://github.com/webmuxd
- Install multiple System Diagnostic profiles for the domains of interest
- Create an always-on VPN to the network segment that hosts usbmuxd
- Ensure avahi / mDNS / DNS-SD advertises the Wi-Fi sync protocol
- Periodically use `libimobiledevice` to pull logs from device
- Perform crash analysis of crash, panic, spinwait, etc (ZecOps for example does this)
- Perform binary to convert awdd logs to textual form for analysis
- Perform backups to analyze with `isafety` or the MVT (mobile verification toolkit)

