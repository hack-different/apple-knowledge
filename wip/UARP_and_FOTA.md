# Accessory Firmware Updates

WARNING: This is a lot of guessing and raw notes, please validate and extend but do not assume it is correct.  It
is a starting point for those who wish to continue this area of work.

## UARP - Universal Accessory Restore Protocol

Guesswork Structs - Beats Update

```c
typedef struct {
    uint32_t version; // BE, == 2
    uint32_t size; // Version 2 header size == 0x2C
    uint32_t file_size; // Length of the file
    uint32_t alignment; // Unsure, 64
    uint32_t checksum; // Unsure, CRC32? Adler32?
    uint32_t flash_size; // Little endian (likely device endian)
    uint32_t images; // 1, number of "rows" that follow
    uint32_t total_header_size; // 54 (equal to size + images * row_size)
    uint32_t reserved; // 0
    uint32_t header_size; // Also 0x2C
    uint32_t row_size = 0x28;
} uarp_header;

typedef struct {
    uint32_t size = 0x28;
    uint32_t magic = 'FOTA';
    uint32_t alignment = 64;
    uint32_t checksum;
    uint32_t flash_size; // BE CAB8B9
    uint32_t unk1; // index or flags?
    uint32_t next_entry = 0x54;
    uint32_t reserved;
    uint32_t file_offset;
    uint32_t file_size; // Less then the size of the region 1A14B3
} uarp_row;
```

## FOTA - Firmware over the Air

```c
typedef struct {
    uint16_t nand_offset;
    uint16_t file_offset;
} chunk_checksum;

typedef struct {
    uint32_t // pad_before?
    uint32_t // distance_from_end
    uint32_t // pad_after?
    uint32_t chunks = 0x1C4
    uint32_t = 0 // pad_before?
    uint32_t = 0 // distance_from_end
    uint32_t = 0 // pad_after?
    uint32_t plist_length = 0xC97
} fota_footer;
```

## SuperBinary

### Metadata

A `NSKeyedArchiver` for a bunch of `NSDictionary` objects - because just serializing the dictionary made no sense...

An example taken from the Beats Headphone Update:

```json
{
    "SuperBinary Format Version": 2,
    "SuperBinary Firmware Version":  "100.232833204.3401103616.1",
    "SuperBinary payloads": [
        {
            "Payload Version": "100.232833204.3401103616.1",
            "Payload Filepath": "/Library/Caches/com.apple.xbs/Binaries/TideUserFirmware/install/TempContent/Root/TideUserFirmware/b507/download/b507_fota_package-prod.bin",
            "Payload 4CC": "FOTA",
            "Payload Long Name": "Beats Studio Buds Firmware"
        }
    ],
    "MetaData plist": {
        "MetaData Format Version": 2,
        "MetaData Values": [
            {"Value": 0, "Name": "Payload Filepath"},
            {"Value": 1, "Name": "Payload Long Name"},
            {"Value": 2, "Name": "Minimum Required Version"},
            {"Value": 3, "Name": "Ignore Version"},
            {"Value": 4, "Name": "Urgent Update"},
            {"Value": 5, "Name": "Payload Certificate", "Filepath": true},
            {"Value": 6, "Name": "Payload Signature", "Filepath": true},
            {"Value": 7, "Name": "Payload Hash", "Filepath": true},
            {"Value": 8, "Name": "Personalization Required"},
            {"Value": 9, "Name": "Personalization Payload Tag"},
            {"Value": 10, "Name": "Personalization SuperBinary AssetID"},
            {"Value": 11, "Name": "Personalization Manifest Prefix"},
            {"Value": 12, "Name": "Payload Digest"},
            {"Value": 13, "Name": "HeySiri Model Type"},
            {"Value": 14, "Name": "HeySiri Model Locale"},
            {"Value": 15, "Name": "HeySiri Model Hash"},
            {"Value": 16, "Name": "HeySiri Model"},
            {"Value": 17, "Name": "Minimum Battery Level"},
            {"Value": 18, "Name": "Trigger Battery Level"},
            {"Value": 19, "Name": "HeySiri Fallback Model"},
            {"Value": 20, "Name": "HeySiri Model Digest"},
            {"Value": 21, "Name": "HeySiri Model Signature"},
            {"Value": 22, "Name": "HeySiri Model Certificate"},
            {"Value": -16777216, "Name": "Host Minimum Battery Level"},
            {"Value": -16777215, "Name": "Host Inactive To Stage Asset"},
            {"Value": -16777214, "Name": "Host Inactive To Apply Asset"},
            {"Value": -16777213, "Name": "Host Network Delay"},
            {"Value": -16777212, "Name": "Host Reconnect After Apply"},
            {"Value": -16777211, "Name": "Minimum iOS Version"},
            {"Value": -16777210, "Name": "Minimum macOS Version"},
            {"Value": -16777209, "Name": "Minimum tvOS Version"},
            {"Value": -16777208, "Name": "Minimum watchOS Version"},
            {"Value": -16777207, "Name": "Host Trigger Battery Level"}
        ]
    }
}
```
