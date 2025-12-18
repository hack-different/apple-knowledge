# AWDD Format Specification

# TLV Format

This systems uses a TLV format that is almost, yet not quite ASN1.  Unlike the normal DER rules the 3 least significant bits encode tag attributes, of if the tag is repeated, has a length prefix, etc.  The length prefixed integer type is similar to ASN1 where the high order bit indicates if there are additional octets in the integer type.  Only a value of 0 in the final octet indicates the multi-byte int is complete and the low order 7 bits may be concatenated into their final value.

## Apple Flavored Timestamps

Apple chose to use a unix epoch that is not seconds past Jan 1, 1970 but instead milliseconds.  This gives a sub second date/timestamp in a single value.

# Metadata Files
## Headers

The header is composed of the magic `AWDM` for Apple Wireless Diagnostics Metadata, followed by the number of header entries (this is sometimes `0` which seems to indicate continue reading until you reach a `uint32_t` of `0x00`), which is then followed by N region specifiers.

Files also contain a `tag` value that specify the class of tag for an extension, this is set to `0x00` on the root file. (As it contains data for multiple tag classes, all extensions will have this as a non-zero value).

A region specifier is a pair of little endian `uint16_t` values, where the first indicates the type of the region (there are cases where there are multiple of the same time, which we cover later).  The second indicates the number of `uint32_t` values that are in that region.  From the authors experience there are only two classes here, the “table” specifiers and the “flat” specifiers.  Table specifiers have a 4 `uint32_t` value size, and “flats” have a 2 `uint32_t` size.  In the experience of the author only tables are repeated, and this only seems to occur in the root metadata format object.

**Header Area Specifiers:**

- `0x02` - “Structure Table” - a compact representation of object definitions that allow the device to operate optimally when the textual display is not required.  
- `0x03` - “Display Table” - used to translate the compact representation to a form suitable to display to the user
- `0x04` - “Identity” - specifies the build identity and build timestamp of a given manifest file much like a mach-o files UUID (SHA1 based)
- `0x05` - “Root Object” - a class definition for the root object, or the base of any log file input.  This type of entry only exists in the base AWDMetadata.bin file as multiple specification is confusing and an error
- `0x06` - “Extension Points” - this encodes a dictionary that maps textual extension points of the `metricsLog` entry to the specified tag value helping connect the extension manifests.

The author believes the manifest is split across multiple files to ensure that the realtime capabilities of the logging system are not bogged down by logging systems that are not currently enabled.  When performing offline analysis there is no reason to not load the entire schemata at once as a full computer in a non-realtime context has plenty of power to do this for the sake of analysis simplicity.

# TLV Structure Types
## Identity Region 

Contains 3 tags:

- `0x01` - A SHA1 hash indicating the unique identity of this file, probably of the source file
- `0x02` - A text display name of the file
- `0x03` - A timestamp of the files generation
## Extension Region

A series of repeated tag type `0x01` where each entry is an extension point
Each entry contains two values, a string display name with index `0x01` and a integer that represents the tag at index `0x02`

## Enum Definition

A enum is defined with a string name of `0x01` with repeated `0x02` entries for each entry in compact form (its integer representation) and optionally `0x03` entries which assign a textual representation to the value

## Class Definition

A class definition is simply a single value of `0x01` which is a string name of the class and a repeated sequence of `0x02` for each property defined on that class.  The order of the definitions as well as the tag of the parent are used to compute the full class “tag” value

## Property Definition

Property definitions are the most complex schema element, consisting of:

- `0x01` the tag “index” value
- `0x02` the type of the property
- `0x03` flags on the property
- `0x04` a textual name of the property
- `0x05` if the property is a object, this is a reference to the class of the property
- `0x06` if the property is a string, this sub-specifies the string (such as a UUID)
- `0x07` if the property is a list, this is the type of the entries of the list
- `0x08` if the property is enumerated, this is the class of the enum
- `0x09` if the property is an integer, this sub-specifies, for example as a unix epoch
- `0x0A` if the property is an extension to another class that didn’t specify it, as is the case for `metricsLogs` this specifies this property is an extension, see `0x0B`
- `0x0B` the class of this property to extend.

**Currently Known Property Types**

    class PropertyType(IntEnum):
        UNKNOWN = 0x00  # Never used, for parser implementation
        DOUBLE = 0x01
        FLOAT = 0x02
        INTEGER_64 = 0x03
        INTEGER = 0x04
        UNKNOWN_5 = 0x05
        INTEGER_32 = 0x06
        INTEGER_UNSIGNED = 0x07
        UNKNOWN_8 = 0x08
        UNKNOWN_9 = 0x09
        BOOLEAN = 0x0C
        ENUM = 0x0B
        STRING = 0x0D
        BYTES = 0x0E
        PACKED_UINT_32 = 0x15
        UNKNOWN_17 = 0x11
        UNKNOWN_20 = 0x14
        OBJECT = 0x1B

**Currently Known String Formats**

    class StringFormat(IntEnum):
        UNKNOWN = 0x00  # Never used
        UUID = 0x01

**Currently Known Integer Formats**

    class IntegerFormat(IntEnum):
        UNKNOWN = 0x00  # Never used
        TIMESTAMP = 0x01
        TRIGGER_ID = 0x03
        PROFILE_ID = 0x04
        AVERAGE_TIME = 0x15
        TIME_DELTA = 0x16
        TIMEZONE_OFFSET = 0x17
        ASSOCIATED_TIME = 0x18
        PERIOD_IN_HOURS = 0x19
        TIME_OF_DAY = 0x1E
        SAMPLE_TIMESTAMP = 0x1F
# Reading Log Files

Reading a log file is a matter of parsing using the TLV format, assuming that the log is in the context of a root object, and matching the values to the tag specified for the root objet at that level.  In usage this is just a hand-full of log level properties and a sequence of `metricsLogs` entries (encoded with tag `15 / 0x0F`).  It’s the metricsLog entries that have the extended long form tags for each of the relevant events. By continuously moving up and down the metadata hierarchy with the values in the logs, each property can be matched to its schema as well as its textual representation giving raw access to the data contained within.

