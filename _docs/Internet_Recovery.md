# Dissection of the Apple Internet Recovery protocol and Security Analysis

NOTE: The authors' machine always downgrades from 10.15.3 to 10.13.0 via
internet recovery, therefore some experiments may not be working the same
due to a network issue with an attacker at a position of privilege on the
network.

## Verification of BaseSystem.dmg and OSDInstall.dmg

See `doc/chunklist_v1.md` and <https://github.com/t8012/cnklverify>

## Request / Response of Internet Recovery image location

PAW and ruby code

`doc/Apple Internet Recovery.paw`
`lib/request_recovery.rb`

It seems that it is impossible to fake a response from the Apple Internet
recovery server, but since the forgery token isn't included with the signed
response, it opens up the case where a man-in-the-middle attack on the request
may occur.  This leads to the potential to downgrade an operating system.

This may be in part due to the age of the IR protocol and lack of stronger
PKI based crypto in older (read Lion 10.9) versions of IR.

### Request Format

A session cookie is requested from <http://osrecovery.apple.com/> then
A request is made to <http://osrecovery.apple.com/InstallationPayload/RecoveryImage>

A request is in the form of:

```text
    cid=A64F96125D28533D
    sn=C079442000SJRWLAX
    bid=Mac-7BA5B2DFE22DDD8C
    k=CF4EF754A68299485E52179B73382421FDBE38BAA06C7CE518A9A4BA91E3C96D
    os=latest
    bv=17.16.11081.0.0,0
    fg=9ECA302EC3E25279AA80C088EF82A821DAD22197B8516F2E9966CC462B524393
```

An analysis of variables comes to these assumed names

* `cid` - The T2 ECID
* `sn` - Motherboard Serial number
* `bid` - Board ID (BDID)
* `k` - Key or some form of challenge (unknown, server accepts any value)
* `os` - The requested OS
* `bv` - Version of bridgeOS
* `fg` - Anti forgery challenge (unknown, server accepts any value)

### Response Format

A response is in the form of

```text
    AP: 041-76812
    AU: http://oscdn.apple.com/content/downloads/22/29/041-76812a/2liqsakq9ocpldao5gxogpqqkg3666itc6/RecoveryImage/BaseSystem.dmg
    AH: 0DD88446D924DC180B25085F53BEA4A2B148024F69EA93E265AEC2F1102E4CB4
    AT: expires=1585251286~access=/content/downloads/22/29/041-76812a/2liqsakq9ocpldao5gxogpqqkg3666itc6/RecoveryImage/BaseSystem.dmg~md5=aade63d0bf105b660880b522ee16276f
    CU: http://oscdn.apple.com/content/downloads/22/29/041-76812a/2liqsakq9ocpldao5gxogpqqkg3666itc6/RecoveryImage/BaseSystem.chunklist
    CH: 791BD581006AD8147F988138B434A2CB792D87F4C2187BD992CC06B64234CA4A
    CT: expires=1585251286~access=/content/downloads/22/29/041-76812a/2liqsakq9ocpldao5gxogpqqkg3666itc6/RecoveryImage/BaseSystem.chunklist~md5=7b7ae5fd362c4ff1b216016121f6cb87
```

An analysis shows the following values

* AP - Apple's update ID for the package, from the software update catalog
* AU - base system URL to download from (dmg)
* AH - Some form of hash for the base system URL / content
* AT - BaseSystem URL token cookie (Passed in the next request as a cookie header)
* CU - chunklist URL (this becomes dangerous if downgrade attacked to v1)
* CH - Chunklist URL hash / content
* CT - Chunklist URL token cookie (Passed in the next request as a cookie header)

## Credit

Research by Rick Mark and moved from `rickmark/apple_net_recovery`
