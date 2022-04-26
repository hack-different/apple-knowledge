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