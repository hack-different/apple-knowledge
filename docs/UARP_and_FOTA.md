# Accessory Firmware Updates

WARNING: This is a lot of guessing and raw notes, please validate and extend but do not assume it is correct.  It
is a starting point for those who wish to continue this area of work.

## UARP - Universal Accessory Restore Protocol

Guesswork structs from work on MagSafe Charger and Beats Studio Buds.

Versions appear to follow the format `major.minor.release.build`. An example of a build version is
`100.7916.1052884864.1` or `247.0.0.0`.

```c
typedef enum {
    kPayloadFOTA = 'FOTA', // Firmware Over the Air
    kPayloadP1FW = 'P1FW', // PROTO1?
    kPayloadP2FW = 'P2FW', // PROTO2?
    kPayloadEVTF = 'EVTF', // Engineering Validation Test
    kPayloadPVTF = 'PVTF', // Production Validation Test
    kPayloadMPFW = 'MPFW', // Mainline Production Firmware
    kPayloadSTFW = 'STFW', // Storage Firmware?
    kPayloadDTTX = 'DTTX', // Data? Transmit
    kPayloadDTRX = 'DTRX', // Data? Receive
    kPayloadDMTP = 'DMTP', // Test Point?
    kPayloadPDFW = 'PDFW', // USB-C Power Delivery
    kPayloadULPD = 'ULPD', // Upload? Possibly the updater
    kPayloadCHDR = 'CHDR', // Charge Direction?
} t_payoad_type;

typedef struct {
    uint32_t version; // BE, == 2
    uint32_t size; // Version 2 header size == 0x2C
    uint32_t binary_size; // Length of the binary. Metadata plist follows immediately after.
    uint32_t major_version; // 100 in '100.7916.1052884864.1'.
    uint32_t minor_version; // 7916 in '100.7916.1052884864.1'.
    uint32_t release_version; // 1052884864 in '100.7916.1052884864.1'.
    uint32_t build_version; // 1 in '100.7916.1052884864.1'.
    uint32_t metadata_offset; // Typically present after the full header.
    uint32_t metadata_length; // Note that metadata can be 0 in length.
    uint32_t row_offset = 0x2c; // Immediately follows UARP header.
    uint32_t row_length; // Divide by row size (0x28) to determine. 0xC8 defines five.
} uarp_header;

typedef struct {
    uint32_t row_size = 0x28;
    t_payload_type payload_type;  // For example 'FOTA';
    uint32_t major_version; // All versions within rows appear to match the binary header.
    uint32_t minor_version;
    uint32_t release_version;
    uint32_t build_version;
    uint32_t metadata_offset; // Both offset/length typically match the UARP header.
    uint32_t metadata_length;
    uint32_t payload_offset; // Offset within file.
    uint32_t payload_length; // Should never exceed binary size.
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
