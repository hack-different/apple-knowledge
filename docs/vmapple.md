# Apple Silicon Virtualization.framework Notes

* arm64e only
* `AVPBooter.bin` serves as SecureROM

## Root of Trust

```text
 Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            21:4b:32:1a:4d:ac:3a:de:36:e8:37:e3:09:f1:52:33:fe:7c:8f:51
    Signature Algorithm: sha384WithRSAEncryption
        Issuer: CN=Apple DDI Secure Boot Root CA - G1, O=Apple Inc., C=US
        Validity
            Not Before: Nov 18 19:33:06 2020 GMT
            Not After : Nov 15 00:00:00 2045 GMT
        Subject: CN=Apple DDI Secure Boot Root CA - G1, O=Apple Inc., C=US
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Modulus:
                    00:bc:77:b0:80:9d:49:87:be:42:7f:ac:1d:b3:d5:
                    22:e0:fd:fa:20:23:da:b0:f3:27:e5:ff:85:67:a1:
                    a4:42:5a:99:d6:9b:10:c3:b3:1d:1b:53:e2:8a:37:
                    b8:c6:85:ee:64:c2:c2:c0:13:d4:c4:aa:02:32:c9:
                    74:29:b6:b4:50:18:98:10:6e:d1:3d:0f:14:33:e6:
                    8b:ab:fb:41:91:cb:bd:d9:99:3c:43:27:37:53:c6:
                    0d:48:e9:fc:70:6c:05:72:04:69:23:82:15:cf:60:
                    54:e6:01:43:a5:7c:fd:c3:78:b1:55:32:5a:05:73:
                    da:1f:a6:9b:93:7c:1d:40:66:c1:06:cd:7a:30:bb:
                    4a:1f:99:77:f6:49:0e:b1:29:3a:2d:4d:cb:8c:e2:
                    d4:e7:f3:64:14:47:2d:27:02:c3:ff:e9:bc:c8:a9:
                    5f:62:33:59:01:d9:00:6a:de:b6:15:7b:dd:4e:1c:
                    31:4a:85:39:9c:84:fc:2c:38:4f:88:fe:27:89:a5:
                    6a:65:65:bc:f6:63:00:78:ed:d8:04:c1:86:37:f3:
                    25:f0:f8:3d:59:62:a5:d8:92:f5:0e:4a:ae:2b:73:
                    8b:ff:1a:85:af:f8:0a:ee:43:bc:90:9f:fa:c6:dd:
                    42:47:c6:6d:cc:db:c7:02:e0:2d:9d:b2:74:c2:46:
                    a8:e1:00:b9:26:ab:ed:0a:88:1f:6b:9a:95:ae:1a:
                    60:8f:76:92:b4:36:5d:bd:9a:e0:9e:f4:32:ab:93:
                    19:2b:73:07:c4:4a:cd:27:50:fe:f1:3f:a9:ad:78:
                    29:25:80:aa:30:a7:e8:c5:5a:56:d5:e8:58:74:bc:
                    a1:32:88:56:15:be:ca:62:12:b8:05:08:6e:92:a8:
                    35:03:ba:5d:cf:e8:38:a1:7b:f9:0d:2a:ad:04:11:
                    f3:3e:13:d6:b0:a8:9e:19:67:de:56:74:67:08:11:
                    9f:2a:20:24:ef:61:70:74:38:8d:35:43:48:64:89:
                    be:87:57:2d:b8:da:2d:ba:51:56:7e:1a:e4:76:0f:
                    e5:9b:6b:7e:1e:57:6d:d6:dc:2b:81:36:40:6c:6d:
                    f5:a4:16:13:ee:fb:17:c6:a2:60:53:07:7c:ad:83:
                    73:e0:36:68:65:ff:62:5a:c3:3a:07:ad:a2:57:0b:
                    08:cb:c9:87:cf:f1:22:9d:1e:bc:fc:e8:b2:3f:80:
                    12:3e:6f:2b:87:33:ae:8f:18:70:e3:76:95:af:9b:
                    3f:19:d6:97:37:58:e8:2d:cc:90:75:f3:f2:63:d0:
                    6f:10:e9:72:c6:4b:17:e0:46:8c:14:ef:fa:72:0f:
                    e8:89:8d:da:c2:c7:46:46:c2:05:de:cb:76:b5:8e:
                    f2:ee:f9
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier:
                6B:C2:5E:01:C3:2C:B1:BA:70:8C:BC:C4:03:27:00:DD:51:7F:12:17
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
    Signature Algorithm: sha384WithRSAEncryption
         04:26:aa:30:52:7f:c5:09:cf:d9:0e:46:7e:bb:66:1f:62:1e:
         db:c6:77:c3:c9:62:21:1c:29:1b:a8:85:99:eb:b4:5b:44:e7:
         71:dc:13:0a:12:e9:4b:5e:b5:33:e7:81:f7:16:55:85:54:51:
         14:66:9c:24:67:76:37:08:34:28:32:a7:c2:e2:4b:30:31:22:
         06:31:5d:57:7e:2e:d5:ad:0a:b3:d2:47:5e:1f:57:ab:65:b6:
         1b:56:11:e9:99:0b:6d:2a:35:5d:6a:35:f1:f5:77:83:a2:88:
         b4:63:66:7e:09:b3:0a:9d:da:72:f7:e2:e1:a5:27:d8:73:0c:
         02:6e:b9:39:65:48:b4:0f:9d:dd:03:5f:1b:fa:ce:02:27:90:
         96:4c:ee:e0:da:4b:1f:3c:97:09:98:21:3f:4b:e4:eb:70:6c:
         77:46:74:dc:60:3d:fd:ec:40:d5:ad:c9:c8:83:ab:dd:b6:92:
         f3:c3:dc:5a:d2:dd:89:d5:a2:d6:b7:8f:d7:b2:ba:40:fe:b6:
         3a:62:8c:49:b5:39:2e:45:a0:c7:a6:0a:41:5c:56:7d:b7:57:
         40:0d:c0:55:fe:e5:56:5b:49:82:bf:e0:77:36:da:97:f2:45:
         1b:68:a0:7a:26:f1:a2:65:62:6a:e7:78:75:5c:37:5d:dd:db:
         eb:3a:a8:c5:c0:a5:21:92:4d:da:8d:14:41:72:a9:8c:b2:1f:
         18:96:e9:54:80:76:02:5c:32:6f:8d:a6:8c:66:ce:f8:03:20:
         51:33:ba:fc:cc:76:f5:7c:64:c8:af:c1:4a:87:e7:6e:3a:8f:
         b0:ba:ff:46:6a:91:54:0a:de:ba:2d:d0:26:8e:c7:49:c2:d7:
         59:9c:4f:28:9f:24:74:51:7e:ce:81:e7:86:b6:e7:30:b3:f5:
         43:d7:f6:b8:65:a2:07:8c:ae:84:55:fa:67:fd:df:8e:ca:5b:
         9c:24:0a:ab:48:9f:07:18:7d:6c:20:00:9c:b9:1b:b8:cc:dd:
         84:42:55:b7:96:f8:b0:bd:ed:08:77:d3:d0:7b:e1:cd:3d:71:
         1b:bc:08:0a:75:34:62:a9:d6:30:3b:ec:64:65:4b:eb:5d:b2:
         64:97:5f:c4:1c:b3:df:69:d5:0f:01:ce:e1:47:ff:db:6f:46:
         0f:0b:cc:0b:84:77:65:b7:0c:24:55:1c:dc:8f:c8:d4:58:ce:
         1d:56:20:b4:7d:13:f4:93:b3:72:e9:b8:40:8a:dd:67:cf:21:
         6b:af:ed:1b:af:dc:b0:28:8e:fc:4c:4e:47:1e:94:b6:6f:fc:
         73:ec:d8:0f:6b:ed:15:98:86:0c:41:10:ec:18:e1:03:82:72:
         dc:4f:a4:35:b6:e6:d4:1d
```

## Hypercalls

Because the SysCfg / NVRAM / Firmware is largely "synthetic", iBoot uses "hypercalls" or para-virtualization to
access these services.  They are bound into the device tree by the `AVPBooter` and `iBoot` from the `utils` node
of the device tree.

### Services Provided

SysCfg Entries (generated):

* EMac
* EMc2
* WMac
* BMac

SysCfg Entries (pass-through):

* SrNm
* Mod#
* Regn

## Firmwares

* ibec
* ibot
* cfel
* hmmr
* pert
* phlt
* rbmt

## Graphical Images

* chg0
* chg1
* batF
* bat0
* bat1
* glyP
* liqd
* logo
* lpw0
* lpw1
* recm
* rlg1
* rlg2
* rlgo

## `vmapple2` FTAB

* virt_firmware
* nvram
* virt_syscfg
* control_bits
* paniclog
* virt_ean