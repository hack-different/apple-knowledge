# Factory

Generally there's a number of processes Apple refers to as "factory", most of which occur in an actual factory such as
the Foxconn facilities, but some are more akin to "not user" (aka can be done by Genius bar or certified repair).
Think of factory as the opposite of "user", where users are untrusted, and come from the internet, factory is
"trusted" (for better or worse as we see) and can do things like modify SysCfg (via blank board serializer test) for
the process of "certified refurbished" devices.  You're device in your hands interacted with factory process before it
got to you, to have the following occur:

1) Device undergoes hardware QA testing, this requires booting a non-production OS image
2) Device has core parameters (FDR factory data restore/reset and SysCfg) encoded to the device, such as the serial
   number (ECID is immutable but Serial comes from SysCfg), WiFi / BT MAC address, color, etc encoded to the
   persistent storage.
3) Has UID generated in the SEP via special boot process.  This "ensures" that UID is unique, and not known to
   Apple (presuming that their professed process is followed)
4) Has the initial operating system placed onto the disk, and it seems for devices that are not carrier locked the
   device is also paired, activated, etc.

## Creation of UID

UID is known as the user unique key and is stored in the SEP.  It's also apparent that the UID is not reset between
restores of a device as it must remain stable for the device to be able to restore its backup and have the proper
encryption keys for same device.  We _assume_ that when a device is returned to Apple UID is somehow destroyed
and refurbished units do not share a UID with the prior owner.

## Creation of `dcrt`

After the device is restored, a certificate request is sent to apple to establish `dcrt` or the device unique
identity.  This is used to uniquely identify the device and should only be stamped on devices that have an
integrity restore.  This is key to a few concepts, "Signed in From" or which Apple devices you're signed
in from.  If an attacker has `dcrt` and its respective key, it is effectively the same device.
