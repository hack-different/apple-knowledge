# Apple USB Target Disk Mode

# Introduction

In earlier generations of Apple MacBook computers, TDM or Target Disk Mode was a boot mode that made all internal drives appear to an external FireWire capable system to be LUNs which could be consumed by another endpoint (This usually included the internal Hard Drive and CD/DVD-ROMs).  Because of the peer-to-peer nature of FireWire and the standard SCSI command set, implementing a consumer in linux for this protocol was relatively straight forward.  Modern USB and Thunderbolt based target disk mode requires a machine that is ordinarily a USB host to become a slave.  Moreover, Apple’s security features such as encryption and effaceable storage complicate the implementation.  What follows is an analysis of the USB based target disk mode protocol, and also a revelation that the FileVault2 key may be extractable (albeit in wrapped form) from a machine without the OS booted.  This paper will be extended in the future to cover the slight differences when using Thunderbolt to replace USB mass-storage as an underlying transport.


## USB Bulk-Only-Transport by any other name…

The first layer of the TDM onion is a simple obfuscation.  When an Apple laptop is booted into TDM and a USB 3.0 cable is attached (it should be noted that the USB-C cable needs all USB3.0 pins connected, UTDM does not work with 1.0, 1.1 or 2.0 cables or controllers), it declares itself to be a Apple, `PID_1800`, implementing a Diagnostic Class (`0xDC`) device with subclass `0x02` and protocol `0x01`.

This provides two `1024` byte bulk endpoints that communicate with the device in what is called USB MSD BOT (USB mass-storage device, bulk only transport - see https://usb.org/sites/default/files/usbmassbulk_10.pdf).  This provides basic framing/length, checksum, direction, logical targets, etc.  Think of this level as TCP with a set number of pipes.  These pipes end up translating into LUNs at the next level up the stack.  Beyond this everything appears to be a superset of the standard SCSI command set.


## A little SCSI here and there…

Next up the stack is the SCSI transport.  It should be noted that this is not UASP or USB attached SCSI protocol, but instead SCSI over the mass-storage BOT.  This is a simpler protocol to implement as it doesn’t permit more eccentric things like native command queueing.  A device in UTDM has 4 addresses or in SCSI language LUNs (logical unit numbers).  SCSI sits on top of the BOT layer and provides basic commands, Apple extensions and LUN addressing.  


- The Apple proprietary  `LUN0 - CONTROL` endpoint, for managing power, device information, read/write protect and a few other things
- The Apple proprietary `LUN1 - AppleKeyStore` endpoint.  This is for accessing a T2’s AppleKeyStore service to unwrap FileVault2 keys with a password.  (see https://github.com/nabla-c0d3/iphone-dataprotection/blob/master/ramdisk_tools/AppleKeyStore.h)
- The Apple proprietary `LUN2 - AppleEffaceableStorage` endpoint.  This is to wipe the device key that is used in the wrapping process, stored in special NOR memory (the NVMe is NAND).  Wiping this key should provide protection for the entire disk, because without it the volume data cannot be decrypted.
- The “standard” `LUN3 - DISK` endpoint with a little non-standard opcode magic.  This is a generally compliant SCSI disk.


## The Control Endpoint

TODO: More analysis of how the Kext operations match up to non-standard SCSI command IDs

- Query ReadOnly/ReadWrite
- Query Device Information
- Query Battery Level
- Configure USB power distribution

Perform page 0 inquiry, length 6 - response `1F 00 05 02 E0 00` - somewhere is full length
This seems standard - see specificaiton

Perform Inquiry with “Enable Vital Product Data = true” and page code = 0

Response - uint32 length (number of page codes)

Perform Inquiry with “Enable Vital Product Data = true” and page code = 0 and length

Response - uint32 length, byte[] page_codes


## Reading the Key Bag from Effaceable Storage

Effaceable storage is a special storage region designed to be effaceable or wipeable at any time.  This is part of Apple’s wrapped key system allowing for instant device wipe.

Open Question: Can the key be read and written back with different geometry?

Keys from iOS - Likely not used on Disk Storage.  (These seem to be sequentially ordered)

| #define LOCKER_DKEY 0x446B6579 |
| ------------------------------ |
| #define LOCKER_EMF  0x454D4621 |
| #define LOCKER_BAG1 0x42414731 |
| #define LOCKER_LWVM 0x4C77564d |

Commands

| 0 : getCapacity - get full capacity of effaceable storage  |
| ---------------------------------------------------------- |
| 1 : getBytes (kernel debug)                                |
| 2 : setBytes (kernel debug)                                |
| 3 : isFormatted - if the NOR has geometry table configured |
| 4 : format - create geometry housekeeping records          |
| 5 : getLocker - get value for bag id                       |
| 6 : setLocker - get value for bag id                       |
| 7 : effaceLocker - erase operation for locker_id           |
| 8 : lockerSpace - get size of bag?                         |

Performs Apple extension SCSI command `0xF4`, data in


- Get Effaceable Geometry - Number and size of wipeable regions.  This appears to allow for different regions to be encrypted with different keys.
- Read Bytes 
    - `AppleTDMEffaceableNORDriver::DoEffaceableRead(IOMemoryDescriptor* data, unsigned int region, unsigned long long start, unsigned long long length)`
- Write Bytes
    - `AppleTDMEffaceableNORDriver::DoEffaceableWrite(IOMemoryDescriptor* data, unsigned int region, unsigned long long start, unsigned long long length)`
- Erase
    - `AppleTDMEffaceableNORDriver::DoEffaceableErase(unsigned int region, unsigned long long start, unsigned long long length)`
- ReadWriteBytes (atomic transaction)
## Unwrapping the key with AppleKeyStore

iOS / Apple ARM processor devices have a key wrapping and unwrapping service.  You may have heard of GID and UID keys burned into Apple processors, and this is in part what is being referred too.  Since the UID key can never leave the T2 processor, Apple had to expose an endpoint that allow unwrapping the disk key stored in effaceable storage to unlock the APFS `Macintosh HD - Data` volume.

Open question: Does this endpoint allow for wrapping / unwrapping of arbitrary keys other then the disk key that may be used on the T2 itself?

Send message / Get response protocol
SCSI Opcode `0xF7`

`AppleTDMAKSDriver::SendMessage(unsigned short target, unsigned long long command)`
`AppleTDMAKSDriver::DoSendMessage(void* request, unsigned long long requestBufferLength, void* response, unsigned long long responseBufferLength)`
`AppleTDMAKSDriver::GetResponse(unsigned long long target, unsigned long long*)`


| 0 : initUserClient scalarOutSize=1                                |
| ----------------------------------------------------------------- |
| 1 : unknown, possibly obsoleted                                   |
| 2 : AppleKeyStoreKeyBagCreate                                     |
| 3 : AppleKeyStoreKeyBagCopyData inscalars=id structOutSize=0x8000 |
| 4 : keybagrelease inscalars":[0]}                                 |
| 5 : AppleKeyStoreKeyBagSetSystem                                  |
| 6 : AppleKeyStoreKeyBagCreateWithData                             |
| 7 : getlockstate "inscalars":[0], "scalarOutSize":1}              |
| 8 : AppleKeyStoreLockDevice                                       |
| 9 : AppleKeyStoreUnlockDevice instruct                            |
| 10: AppleKeyStoreKeyWrap                                          |
| 11: AppleKeyStoreKeyUnwrap - used with effaceable NOR             |
| 12: AppleKeyStoreKeyBagUnlock - used to provide password          |
| 13: AppleKeyStoreKeyBagLock                                       |
| 14: AppleKeyStoreKeyBagGetSystem scalarOutSize=1                  |
| 15: AppleKeyStoreKeyBagChangeSecret                               |
| 17: AppleKeyStoreGetDeviceLockState scalarOutSize=1               |
| 18: AppleKeyStoreRecoverWithEscrowBag - recovery key?             |
| 19: AppleKeyStoreOblitClassD                                      |

## Setting up for Disk Reading

Apple Extended Request Sense Key `0x05`, response non-standard as it is 1 byte and not a full 4 bytes, which is minimum for a mode-sense response.

Responses from mode sense include, `0x0A, 0xFC`

Apple SCSI command `0x

## Reading Blocks from the Disk with AES-XTS

While it appears that raw blocks can be read off the disk using a relatively straightforward SCSI command set, if decryption of the block using the wrapped key is requested, additional SCSI commands are needed to support AES-XTS.

Reading the GPT both primary and backup seems to occur in the clear, without use of any cryptographic operation.

Apple Command `0xF6` with direction out
Apple Command `0xF2` with direction in

There are “two keys” being passed, header is `0x1F` in length, some crypto material of `0x30` in length (128 bit block and 256 bit key) and a `0x20` footer

## Unwrapping the Disk Key

Generally to access a FileVault2 encrypted volume, you need the AppleKeyStore for access to the UID key, the DKey in effaceable storage and a password for a user of the system.  By passing these two values to AKS, you are able to access the key material that protects the APFS volume.

TODO: SCSI opcode `0xF6`?  Submitted with each block read, with 104 bytes of data.  Perhaps this is AES-XTS.  (`AppleTDMType00::SendCryptoDataToTarget(unsigned char*, unsigned short, unsigned long long, unsigned long long, unsigned long long, unsigned char)`)



## Mounting the APFS volume

https://github.com/sgan81/apfs-fuse


## Potential Linux Driver


## Fuzzing Analysis on the Stack - Hackers Look Here!
- USB MSD BOT error modes
- SCSI command / length / invalid state
- Command / AKS / AES endpoints are non-standard and were likely not meant to be exposed outside the kernel

