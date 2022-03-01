# iDevice USB Modes

## Modes as a function of SDOM

SDOM is a two bit (2^2) value.  The value is a bitflag of SEC and PRO (CXXX and EXXX).

CXXX (being CSEC and CRPO) are the in-burned chip security and "promotion" value.

EXXX (being ESEC and EPRO) are the effective security and promotion values.

the SEC bit is the lower (ones place)

the PRO bit is if the device is promoted (twos place)

This means a "SDOM" of 03 is secure, promoted which matches the CPFM of retail devices (the default value for SDOM)

"Demotion" occurs by changing the SDOM value from it's CPFM mode by running a CPFM:03 diags payload.  Because this is
signed with the CPFM:03 values, it can run on retail.  It then is able to modify EPRO to 0 bringing a device to
SDOM = 01 (secure, development), the use of ESEC _implies_ that an Apple payload could turn any device into SDOM:00
or making it an insecure development device.  (CSEC = 1, CPRO = 1, ESEC = 0, EPRO = 0 from CPFM = 03 to SDOM = 00).

Each "mode" has a base USB product ID (compiled into the binary) as given in the following:
WTF Mode (classic iPods) = 0x1222
DFU Mode (shared between iPod and iDevice) = 0x1226
...
unknown, other apple products?  other iBoot modes (likely defunct as 1280 can respond with its mode)?
...
iBoot Mode = 0x1280

The low order bits are set to the value of SDOM, meaning that the Product ID presented to macOS differs based on the
SDOM value.  This is no doubt useful to Apple employees who do not want iTunes / Finder popping up excpet on "retail"
devices fighting over the USB interface.  (They likely only respond to SDOM=3)

This means a "production" device should present as 0x1229 in DFU and 0x1283 in recovery.