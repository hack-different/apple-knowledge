# Qualcomm Baseband

## `bbfw`

Zip package containing:

* `sbl1.mbn` - Secondary Bootloader (after ROM PBL)
* `Info.plist`
* `Options.plist` - Zero?
* `qdsp6sw.mbn` - Qualcomm Hexagon Digital Signal Processor
* `tz.mbn` - Qualcomm TrustZone Implementation - QSEE
* `hyp.mbn` - Qualcomm Hypervisor Execution Environment - QHEE - EL2
* `xbl_cfg.mbn` - For XBL (eXtensible Boot Loader) or EFI based SPL signed static data
* `restoresbl1.mbn` - Secondary program loader (bootloader) for baseband recovery
* `acdb.mbn` - Accessory Calibration Database (seems to be initial)

## MBN Signature Format

Contains a C struct styled header, followed by hashes, a signature and a certificate chain.

MBNs are ill-designed because the ELF header contains the offset to the signature region, which signs the ELF header
creating a circular dependency.

### Header Region

```c
// Likely depends on hash type - samples found stated PK algorithm scep384r1 having a signature size of 384 - deterministic noncing?
// does this lead to a potential leak of private key with double nonce values?
typedef struct {
  char* hash[HASH_TYPE_SIZE]; // Unfortuantly they used all zeros to encode an empty region instead of hash of zeros...
                              // This seems to always be true of the signature area (b01) but also of other regions?
} mbn_hash_row_t;

typedef enum {
  kSHA2_384 = 0x06;
} mbn_hash_type_t;

typedef struct {
  uint32_t hash_rows;         // Number of hash rows - samples with 0 have hashes but no signature... and 0xFFFFFFFF for
                              // pk_hash.  It also has hash rows, perhaps its a problem via multiple verification paths?
  mbn_hash_type_t hash_type;  // 6 - SHA2-384?
  uint32_t = 0
  uint32_t = 0
  uint32_t hash_and_signature_size; // Little endian - data following header and extra
  uint32_t hash_size; // size in bytes of hash type row size * rows - signature follows
  uint32_t pk_hash_one? = 0xFFFFFFFF / 0xA803708F
  uint32_t signature_size; // Size of ASN.1 signature following hash list
  uint32_t pk_hash_two? = 0xFFFFFFFF / 0xA803708F // Usually matches pk_hash_one
  uint32_t some_size;  // Some header item size or possibly align value?
  uint32_t = 0;
  uint32_t extra_size; // Seems to be 0x78 bytes long... 64bit extension?
  char* extra[extra_size];
  mbn_hash_row_t hashes[hash_rows];
} mbn_header_t;

typedef struct {

```

#### Examples of headers

```text
restoresbl1.b01
00000000 06000000 00000000 00000000 A8120000 40020000 FFFFFFFF 68000000 FFFFFFFF 00100000 00000000 78000000
00000000 00000000 00000000 E1401400 00000000 00000000 00000000 04000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 B7EB6FD8 00000000 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
```

```text
qdsp06sw.b01
0C000000 06000000 00000000 00000000 40050000 40050000 A803708F 00000000 A803708F 00000000 00000000 00000000
```

```text
multi_image.b01
00000000 06000000 00000000 00000000 F8100000 90000000 FFFFFFFF 68000000 FFFFFFFF 00100000 00000000 78000000
00000000 00000000 22000000 E1401400 00000000 00000000 00000000 04000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 B7EB6FD8 00000000 00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
```

```text
hyp.b01
00000000 06000000 00000000 00000000 C0000000 C0000000 FFFFFFFF 00000000 FFFFFFFF 00000000 00000000 00000000
```

```text
devcfg.b01
00000000 06000000 00000000 00000000 C0000000 C0000000 FFFFFFFF 00000000 FFFFFFFF 00000000 00000000 00000000
```

```text
apps.b01
04000000 06000000 00000000 00000000 70020000 70020000 C821F980 00000000 C821F980 00000000 00000000 00000000
```

```text
aop.b01
00000000 06000000 00000000 00000000 F0000000 F0000000 C880E08F 00000000 C880E08F 00000000 00000000 00000000
```

### ASN.1 Encoded Signature

#### ECDSA scep384r1

```text
9062 // ASN1 string header

// SHA2-384 of the data to sign
BCD8BE0C F9D0C2FD 4B19F174 CCEB6387 C3B05F17 1BAFA3D1 3DD12AC1 067E2B17 4424C5B4 9DC318C5 5E45C5F9 9E703066

02 // Type?
31 // Length
00 // Compression of point? (possible non-standard 0/1 instead of 03/04)
C0BA9832 B6F45BA2 AB8D411E E1C719F6 42342B86 2D4D3623 C7252D13 507339D7 C7EDAF53 5C84C3FA 1D14ABE4 BA1048A4

02 // Type?
31 // Length
00 // Compression of point?
8A8598AD B921E977 1276DACC 6FCEAA7A DEA4E971 EABAFEEB 61FF5F55 11AAB378 48C91884 8C6CE7E4 BABC4907 05F1E36F
```

### ASN.1 Encoded Certificate Chain

```text
SEQUENCE (3 elem)
  SEQUENCE (8 elem)
    [0] (1 elem)
      INTEGER 2
    INTEGER (63 bit) 5102134721289033247
    SEQUENCE (1 elem)
      OBJECT IDENTIFIER 1.2.840.10045.4.3.3 ecdsaWithSHA384 (ANSI X9.62 ECDSA algorithm with SHA384)
    SEQUENCE (3 elem)
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.3 commonName (X.520 DN component)
          UTF8String Test Eureka SOC Root CA 35
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.10 organizationName (X.520 DN component)
          UTF8String Apple Inc.
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.8 stateOrProvinceName (X.520 DN component)
          UTF8String California
    SEQUENCE (2 elem)
      UTCTime 2018-05-15 22:12:28 UTC
      UTCTime 2018-05-16 22:12:28 UTC
    SEQUENCE (2 elem)
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.3 commonName (X.520 DN component)
          UTF8String Test Eureka SOC Root CA 35 Leaf
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.10 organizationName (X.520 DN component)
          UTF8String Apple Inc.
    SEQUENCE (2 elem)
      SEQUENCE (2 elem)
        OBJECT IDENTIFIER 1.2.840.10045.2.1 ecPublicKey (ANSI X9.62 public key type)
        OBJECT IDENTIFIER 1.3.132.0.34 secp384r1 (SECG (Certicom) named elliptic curve)
      BIT STRING (776 bit) 0000010011101011000011110010001100011110100010100110000000100001100000…
    [3] (1 elem)
      SEQUENCE (4 elem)
        SEQUENCE (3 elem)
          OBJECT IDENTIFIER 2.5.29.19 basicConstraints (X.509 extension)
          BOOLEAN true
          OCTET STRING (2 byte) 3000
            SEQUENCE (0 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.29.35 authorityKeyIdentifier (X.509 extension)
          OCTET STRING (24 byte) 301680140C64EDABDEA076FCCBB4F49FBDB75D46F597AF32
            SEQUENCE (1 elem)
              [0] (20 byte) 0C64EDABDEA076FCCBB4F49FBDB75D46F597AF32
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.29.14 subjectKeyIdentifier (X.509 extension)
          OCTET STRING (22 byte) 0414DD5C0F80952FB597AB60DD9282EA70B80EEA0E7A
            OCTET STRING (20 byte) DD5C0F80952FB597AB60DD9282EA70B80EEA0E7A
        SEQUENCE (3 elem)
          OBJECT IDENTIFIER 2.5.29.15 keyUsage (X.509 extension)
          BOOLEAN true
          OCTET STRING (4 byte) 03020780
            BIT STRING (1 bit) 1
  SEQUENCE (1 elem)
    OBJECT IDENTIFIER 1.2.840.10045.4.3.3 ecdsaWithSHA384 (ANSI X9.62 ECDSA algorithm with SHA384)
  BIT STRING (816 bit) 0011000001100100000000100011000000110100111101101000100011111010111100…
    SEQUENCE (2 elem)
      INTEGER (382 bit) 8151756030331056487823161874997707277988121415666908648513990112722474…
      INTEGER (383 bit) 1281400542485460847206440091939968328867920960916542938903846231152859…
```

```text
SEQUENCE (3 elem)
  SEQUENCE (8 elem)
    [0] (1 elem)
      INTEGER 2
    INTEGER (61 bit) 1625249655888498160
    SEQUENCE (1 elem)
      OBJECT IDENTIFIER 1.2.840.10045.4.3.3 ecdsaWithSHA384 (ANSI X9.62 ECDSA algorithm with SHA384)
    SEQUENCE (3 elem)
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.3 commonName (X.520 DN component)
          UTF8String Test Eureka SOC Root CA 35
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.10 organizationName (X.520 DN component)
          UTF8String Apple Inc.
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.8 stateOrProvinceName (X.520 DN component)
          UTF8String California
    SEQUENCE (2 elem)
      UTCTime 2018-05-15 21:55:08 UTC
      UTCTime 2038-05-10 21:55:08 UTC
    SEQUENCE (3 elem)
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.3 commonName (X.520 DN component)
          UTF8String Test Eureka SOC Root CA 35
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.10 organizationName (X.520 DN component)
          UTF8String Apple Inc.
      SET (1 elem)
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.4.8 stateOrProvinceName (X.520 DN component)
          UTF8String California
    SEQUENCE (2 elem)
      SEQUENCE (2 elem)
        OBJECT IDENTIFIER 1.2.840.10045.2.1 ecPublicKey (ANSI X9.62 public key type)
        OBJECT IDENTIFIER 1.3.132.0.34 secp384r1 (SECG (Certicom) named elliptic curve)
      BIT STRING (776 bit) 0000010001111010111101000100010110101111010000000101100101000010110101…
    [3] (1 elem)
      SEQUENCE (3 elem)
        SEQUENCE (3 elem)
          OBJECT IDENTIFIER 2.5.29.19 basicConstraints (X.509 extension)
          BOOLEAN true
          OCTET STRING (8 byte) 30060101FF020100
            SEQUENCE (2 elem)
              BOOLEAN true
              INTEGER 0
        SEQUENCE (2 elem)
          OBJECT IDENTIFIER 2.5.29.14 subjectKeyIdentifier (X.509 extension)
          OCTET STRING (22 byte) 04140C64EDABDEA076FCCBB4F49FBDB75D46F597AF32
            OCTET STRING (20 byte) 0C64EDABDEA076FCCBB4F49FBDB75D46F597AF32
        SEQUENCE (3 elem)
          OBJECT IDENTIFIER 2.5.29.15 keyUsage (X.509 extension)
          BOOLEAN true
          OCTET STRING (4 byte) 03020204
            BIT STRING (6 bit) 000001
  SEQUENCE (1 elem)
    OBJECT IDENTIFIER 1.2.840.10045.4.3.3 ecdsaWithSHA384 (ANSI X9.62 ECDSA algorithm with SHA384)
  BIT STRING (832 bit) 0011000001100110000000100011000100000000111101001001010000001111111011…
    SEQUENCE (2 elem)
      INTEGER (384 bit) 3764405614543861553181393903194413274471521338802557327047703229534942…
      INTEGER (384 bit) 2942036852031372040337745727030783615133201264286154596397242159682249…
```

## Sahara Protocol

Based on a public gitlab copy of msm8974 headers

```c

/* Sahara command IDs */
enum boot_sahara_cmd_id
{
  SAHARA_NO_CMD_ID          = 0x00,
  SAHARA_HELLO_ID           = 0x01, /* sent from target to host */
  SAHARA_HELLO_RESP_ID      = 0x02, /* sent from host to target */
  SAHARA_READ_DATA_ID       = 0x03, /* sent from target to host */
  SAHARA_END_IMAGE_TX_ID    = 0x04, /* sent from target to host */
  SAHARA_DONE_ID            = 0x05, /* sent from host to target */
  SAHARA_DONE_RESP_ID       = 0x06, /* sent from target to host */
  SAHARA_RESET_ID           = 0x07, /* sent from host to target */
  SAHARA_RESET_RESP_ID      = 0x08, /* sent from target to host */
  SAHARA_MEMORY_DEBUG_ID    = 0x09, /* sent from target to host */
  SAHARA_MEMORY_READ_ID     = 0x0A, /* sent from host to target */
  SAHARA_CMD_READY_ID       = 0x0B, /* sent from target to host */
  SAHARA_CMD_SWITCH_MODE_ID = 0x0C, /* sent from host to target */
  SAHARA_CMD_EXEC_ID        = 0x0D, /* sent from host to target */
  SAHARA_CMD_EXEC_RESP_ID   = 0x0E, /* sent from target to host */
  SAHARA_CMD_EXEC_DATA_ID   = 0x0F, /* sent from host to target */

  /* place all new commands above this */
  SAHARA_LAST_CMD_ID,
  SAHARA_MAX_CMD_ID             = 0x7FFFFFFF /* To ensure 32-bits wide */
};
```

## Baseband Config

`bbcfg` files are a 48 byte header:

```c
typedef struct {
    uint32_t magic = '\0GFC'; // LE 'CFG\0'
    uint32_t header_size = 3; // Offset to next magic?
    uint32_t = 0
    uint32_t = 0
} bbcfg_header_t;

typdef struct {
    uint64_t magic = 0xDAEF3003DAEF3003; // Magic
    uint64_t = 0; // Guess: offset following header?
    uint64_t = 0; // Guess: size, 0 being to EoF
    uint8_t[8] name; // 'BBCFGMBN'
} bbcfg_mbn_header_t;
```

The remaining data is ASN1 - DER encoded:

* Tag 0 - String: Build Type (`Mav21_Official`)
* Tag 1 - String: Build Number (Seems in Apple `\d+[A-Z]\d+` format)
* Tag 2 - String: Build Host
* Tag 3 - String: Build User
* Tag 4 - String: Build Host IP Address
* Tag 5 - String: 6 byte short commit hash?
* Tag 6 - String: Build Timestamp
* Tag 7 - String: Branch
* Tag 8 - Sequence of Tag 16:
  * Tag 200 -
  * Tag 201
  * Tag 202
  * Tag 203
  * Tag 204
* Tag 9 - Sequence, Patch Files?
  * Tag 100 - String: SHA1 Hash
  * Tag 101 - String: Binary Data

## Blobs

### ASN Coded Files

* Sequence containing nodes
  * Tag `600` - A series of patches into non-volatile
    * Tag `400` - Offset
    * Tag `401` - Unknown (Usually 0, guess - pad char?)
    * Tag `402` - Unknown (guess - length?)
    * Tag `403` - Content
    * Tag `404`
  * Tag `601` - A sequence of files
    * Tag `500` - File Name
    * Tag `501` - Guess: Permission? Offset?
    * Tag `502` - Content
    * Tag `503`
    * Tag `504`

### STX2VG

### MAVZ

A compressed stream with the following header followed by `zlib` compressed data

```c
typedef struct {
  uint32_t magic = 'MAVZ'; // Magic
  uint16_t unknown1; // DE76
  uint16_t unknown2; // 0000
} mavz_file_heaeder_t
```

## xbl_cfg

Signed ELF (MBN) file with a CFGL header and payloads for each entry.

Example files from manifest:

* /6013_0100_0_dcb.bin
* /6013_0100_1_dcb.bin
* /6013_0200_1_dcb.bin

Each of which appear to be machine code as evidenced by the constant string areas:

File contains a number of unicode (wide char) 8 byte full caps magic values:

* `0000`
* `DEFG`
* `ABVW`
* `HIJK`

### CFGL

```c
typedef struct {
  uint32_t magic = 'CFGL';
  uint32_t
  uint32_t size;
} cfgl_header_t;

typedef struct {
  uint32_t unknown1; // 0
  uint32_t file_offset;
  uint32_t unknown2; // 04340000
  uint32_t file_name_length; // In examples 0x14
  char[file_name_length] = "/6013_0100_0_dcb.bin";
  uint32_t unknown3;
} cfgl_row_t;
```

## QHEE

### Devices in `hyp.mbn`

Suspicion - `$` are serviced by the TrustZone

* `IORT`
* `QCOM`
* `2KDEMOCQ`
* `MOCQ`
* `$AOSS`
* `$BLSP`
* `$CRYPTO`
* `$DAP`
* `$DCC`
* `$ECATS_TEST`
* `$IPA`
* `$LPASS`
* `$PCIE0`
* `$QPIC`
* `$SDC2`
* `$SPDM`
* `$SPMI`
* `$TIC`
* `$USB0`
