# Taking Apart an Android

# Apriori
- https://alephsecurity.com/2018/01/22/qualcomm-edl-1/
- http://bits-please.blogspot.com/2015/08/exploring-qualcomms-trustzone.html
- https://www.qualcomm.com/media/documents/files/secure-boot-and-image-authentication-technical-overview-v2-0.pdf
- https://www.qualcomm.com/media/documents/files/secure-boot-and-image-authentication-technical-overview-v1-0.pdf
- https://blog.quarkslab.com/analysis-of-qualcomm-secure-boot-chains.html
- http://bits-please.blogspot.com/2016/04/exploring-qualcomms-secure-execution.html
- http://elfparser.com/download.html
# Tools Required
-  A bunch of standard dev tooling:
    `sudo apt install file lzma binwalk xz-tools device-tree-compiler python3.9 apt-get install git gitk git-gui curl xz-utils python3-pkg-resources python3-virtualenv python3-oauth2client binutils-aarch64-linux-gnu g++-aarch64-linux-gnu cpp-aarch64-linux-gnu`
- http://newandroidbook.com/tools/imjtool.html - Once again the amazing Jonathan Levin takes apart things so you (and I) don’t have too…
# Aquire Image (Read About DMCA Section 1202)
- Go to Google and download.  Remember that just because it’s not enforceable doesn’t mean that Google will not try and scare you off with a “do not disassemble” warning on the site.  The DMCA was not intended to prevent users from (WARNING - NON LAWYER UNDERSTANDING)
    - verifying manufacturer claims about security
    - reverse engineering malware
    - allowing a user to run alternate operating systems or code
    - BEWARE: once you start getting into DRM territory you are at the edge of the DMCA unless you can show the DRM technology is being used to hide malicious code
    - you are safest when using “fair use” to understand the security of a device running code you write, distribution of circumvention increases risk
    - Your analysis isn’t intended to circumvent any patients held - Many of which exist for LTE/Cellular technology.  By sticking to well known boot-loader / secure boot topics and away from the actual IP governing the radio this should be fine
    - Nothing being done in this paper is novel: we are using standard tools to split apart and analyze files in the payload
- https://www.eff.org/issues/coders/reverse-engineering-faq
# Extract ZIPs


# Boot / Bootloader / DBTO / Radio

These are best handled by recursive `binwalk` - DBTO should contain multiple DTB (device tree blob) objects that are selected by the bootloader and overlayed over 


    $ binwalk -e -M boot.img
    $ binwalk -e -M bootloader-*.img
    $ binwalk -e -M radio-*.img
    $ binwalk -e -m dtbo.img
## Convert DTBs to Source
    $ file *
    [Look for entries that say Device Tree]
    $ dtc -I dtb -O dts -o [filename].dts [filename]
## Extracting Qualcomm Signed Binaries


## Extracting XBL - the eXtenable Bootloader
- xbl will be a Qualcomm signed ELF
- Inside XBL is a UEFI flash volume
    - this will contain a number of DXEs
    - 
# System / System Extended / Vendor / Product

These images are “Android Sparse Images” and can be converted to ext4 images for loopback mount via the tool: https://github.com/anestisb/android-simg2im


    $ simg2img system.img system.raw.img
    $ simg2img system_other.img system_other.raw.img
    $ simg2img system_ext.imge system_ext.raw.img
    $ simg2img product.img product.raw.img
    $ simg2img vendor.img vendor.raw.img


- The `system` partition is not very interesting - it should only contain AOSP code
- The `system_ext` is essentially an overlay of non-standard extensions to the ASOP base image, executes identically to those items found in `system`
- `system_other` is usually for A/B updates but often contains pre-optimized ART bianaries
- `vendor` is usually extended APEX files to extend the system with the proper APIs for the hardware, Qualcomm stuff mostly lives here…
- `product` is specific to the product, and often is where Google Play gets layered in.  Think of a device without product as lacking “Google Play Experience”

**T**he Titan-M Firmware

- Two files exist under the `vendor.img` file
    - `/vendor/firmware/citadel/ec.bin` - this is the true image for the Titan-M firmware (A_RO, A_RW, B_RO, B_RW)
    - `/vendor/firmware/citadel/ec.rec` - this is the rescue firmware for `fastboot oem citadel rescue`
    - The flash layout of the citadel is defined by : https://android.googlesource.com/platform/external/nos/host/generic/+/refs/heads/android10-c2f2-release/nugget/include/flash_layout.h
    #!/usr/bin/env python3
    from enum import Enum
    
    
    class ChipType(Enum):
        TYPE_HAVEN = -1
        TYPE_CITADEL = -2
        TYPE_DAUNTLESS = -3
    
    
    CHIP_SIZE = {
        ChipType.TYPE_CITADEL: 512 * 1024,
        ChipType.TYPE_DAUNTLESS: 1024 * 1024
    }
    
    CHIP_RO_SIZE = {
        ChipType.TYPE_CITADEL: 0x4000,
        ChipType.TYPE_DAUNTLESS: 0x4000
    }
    
    
    class GoogleSecurityChipFirmware():
        def __init__(self, path):
    
    
    
    # Usage: split_titan_ec [path_to_header] ec.bin
    # We assume a citadel layout from : https://android.googlesource.com/platform/external/nos/host/generic/+/refs/heads/android10-c2f2-release/nugget/include/flash_layout.h
    
    # Google Git
    # Sign in
    # android / platform / external / nos / host / generic / refs/heads/master / . / nugget / include / flash_layout.h
    # blob: 13c00ef5d1c6e643dc830c9276508754796c14f3 \[file\] [log] [blame]
    # /* Copyright 2014 The Chromium OS Authors. All rights reserved.
    #  * Use of this source code is governed by a BSD-style license that can be
    #  * found in the LICENSE file.
    #  */
    # #ifndef __CROS_EC_FLASH_LAYOUT_H
    # #define __CROS_EC_FLASH_LAYOUT_H
    # /*
    #  * The flash memory is implemented in two halves. The SoC bootrom will look for
    #  * a first-stage bootloader (aka "RO firmware") at the beginning of each of the
    #  * two halves and prefer the newer one if both are valid. The chosen bootloader
    #  * also looks in each half of the flash for a valid application image (("RW
    #  * firmware"), so we have two possible RW images as well. The RO and RW images
    #  * are not tightly coupled, so either RO image can choose to boot either RW
    #  * image. RO images are provided by the SoC team, and can be updated separately
    #  * from the RW images.
    #  */
    # #define CITADEL_FLASH_BASE     0x40000
    # #define CITADEL_FLASH_SIZE     (512 * 1024)
    # #define CITADEL_FLASH_HALF     (CITADEL_FLASH_SIZE >> 1)
    # #define CITADEL_RO_SIZE        0x4000
    # #define CITADEL_RO_A_MEM_OFF   0
    # #define CITADEL_RO_B_MEM_OFF   CITADEL_FLASH_HALF
    # #define CITADEL_RW_A_MEM_OFF   CITADEL_RO_SIZE
    # #define CITADEL_RW_B_MEM_OFF   (CITADEL_FLASH_HALF + CITADEL_RW_A_MEM_OFF)
    # #define DAUNTLESS_FLASH_BASE   0x80000
    # #define DAUNTLESS_FLASH_SIZE   (1024 * 1024)
    # #define DAUNTLESS_FLASH_HALF   (DAUNTLESS_FLASH_SIZE >> 1)
    # #define DAUNTLESS_RO_SIZE      0x4000
    # #define DAUNTLESS_RO_A_MEM_OFF 0
    # #define DAUNTLESS_RO_B_MEM_OFF DAUNTLESS_FLASH_HALF
    # #define DAUNTLESS_RW_A_MEM_OFF DAUNTLESS_RO_SIZE
    # #define DAUNTLESS_RW_B_MEM_OFF (DAUNTLESS_FLASH_HALF + DAUNTLESS_RW_A_MEM_OFF)
    # #endif   /* __CROS_EC_FLASH_LAYOUT_H */
    # Powered by Gitiles| Privacy
    # txt
    # json
    
    # /* Copyright 2015 The Chromium OS Authors. All rights reserved.
    #  * Use of this source code is governed by a BSD-style license that can be
    #  * found in the LICENSE file.
    #  */
    # #ifndef __EC_UTIL_SIGNER_COMMON_SIGNED_HEADER_H
    # #define __EC_UTIL_SIGNER_COMMON_SIGNED_HEADER_H
    # #ifdef __cplusplus
    # #include <endian.h>
    # #include <stdio.h>
    # #include <time.h>
    # #endif
    # #include <assert.h>
    # #include <inttypes.h>
    # #include <string.h>
    # #define FUSE_MAX 128
    # #define INFO_MAX 128
    # #define FUSE_PADDING 0x55555555
    # // B chips
    # #define FUSE_IGNORE_B 0xa3badaac  // baked in rom!
    # #define INFO_IGNORE_B 0xaa3c55c3  // baked in rom!
    # // Citadel chips
    # #define FUSE_IGNORE_C 0x3aabadac  // baked in rom!
    # #define INFO_IGNORE_C 0xa5c35a3c  // baked in rom!
    # // Dauntless chips
    # #define FUSE_IGNORE_D 0xdaa3baca  // baked in rom!
    # #define INFO_IGNORE_D 0x5a3ca5c3  // baked in rom!
    # #if defined(CHIP_D)
    # #define FUSE_IGNORE FUSE_IGNORE_D
    # #define INFO_IGNORE INFO_IGNORE_D
    # #elif defined(CHIP_C)
    # #define FUSE_IGNORE FUSE_IGNORE_C
    # #define INFO_IGNORE INFO_IGNORE_C
    # #else
    # #define FUSE_IGNORE FUSE_IGNORE_B
    # #define INFO_IGNORE INFO_IGNORE_B
    # #endif
    # #define SIGNED_HEADER_MAGIC_HAVEN (-1u)
    # #define SIGNED_HEADER_MAGIC_CITADEL (-2u)
    # #define SIGNED_HEADER_MAGIC_DAUNTLESS (-3u)
    # /* Default value for _pad[] words */
    # #define SIGNED_HEADER_PADDING 0x33333333
    # typedef struct SignedHeader {
    # #ifdef __cplusplus
    #   SignedHeader()
    #       : magic(SIGNED_HEADER_MAGIC_HAVEN),
    #         image_size(0),
    #         epoch_(0x1337),
    #         major_(0),
    #         minor_(0xbabe),
    #         p4cl_(0),
    #         applysec_(0),
    #         config1_(0),
    #         err_response_(0),
    #         expect_response_(0),
    #         swap_mark({0, 0}),
    #         dev_id0_(0),
    #         dev_id1_(0) {
    #     memset(signature, 'S', sizeof(signature));
    #     memset(tag, 'T', sizeof(tag));
    #     memset(fusemap, 0, sizeof(fusemap));
    #     memset(infomap, 0, sizeof(infomap));
    #     memset(&_pad, SIGNED_HEADER_PADDING, sizeof(_pad));
    #     // Below all evolved out of _pad, thus must also be initialized to '3'
    #     // for backward compatibility.
    #     memset(&rw_product_family_, SIGNED_HEADER_PADDING,
    #            sizeof(rw_product_family_));
    #     memset(&u, SIGNED_HEADER_PADDING, sizeof(u));
    #     memset(&board_id_, SIGNED_HEADER_PADDING, sizeof(board_id_));
    #   }
    #   void markFuse(uint32_t n) {
    #     assert(n < FUSE_MAX);
    #     fusemap[n / 32] |= 1 << (n & 31);
    #   }
    #   void markInfo(uint32_t n) {
    #     assert(n < INFO_MAX);
    #     infomap[n / 32] |= 1 << (n & 31);
    #   }
    #   static uint32_t fuseIgnore(bool c, bool d) {
    #     return d ? FUSE_IGNORE_D : c ? FUSE_IGNORE_C : FUSE_IGNORE_B;
    #   }
    #   static uint32_t infoIgnore(bool c, bool d) {
    #     return d ? INFO_IGNORE_D : c ? INFO_IGNORE_C : INFO_IGNORE_B;
    #   }
    #   bool plausible() const {
    #     switch (magic) {
    #       case SIGNED_HEADER_MAGIC_HAVEN:
    #       case SIGNED_HEADER_MAGIC_CITADEL:
    #       case SIGNED_HEADER_MAGIC_DAUNTLESS:
    #         break;
    #       default:
    #         return false;
    #     }
    #     if (keyid == -1u) return false;
    #     if (ro_base >= ro_max) return false;
    #     if (rx_base >= rx_max) return false;
    #     if (_pad[0] != SIGNED_HEADER_PADDING) return false;
    #     return true;
    #   }
    #   void print() const {
    #     printf("hdr.magic          : %08x (", magic);
    #     switch (magic) {
    #       case SIGNED_HEADER_MAGIC_HAVEN:
    #         printf("Haven B");
    #         break;
    #       case SIGNED_HEADER_MAGIC_CITADEL:
    #         printf("Citadel");
    #         break;
    #       case SIGNED_HEADER_MAGIC_DAUNTLESS:
    #         printf("Dauntless");
    #         break;
    #       default:
    #         printf("?");
    #         break;
    #     }
    #     printf(")\n");
    #     printf("hdr.ro_base        : %08x\n", ro_base);
    #     printf("hdr.keyid          : %08x\n", keyid);
    #     printf("hdr.tag            : ");
    #     const uint8_t* p = reinterpret_cast<const uint8_t*>(&tag);
    #     for (size_t i = 0; i < sizeof(tag); ++i) {
    #       printf("%02x", p[i] & 255);
    #     }
    #     printf("\n");
    #     printf("hdr.epoch          : %08x\n", epoch_);
    #     printf("hdr.major          : %08x\n", major_);
    #     printf("hdr.minor          : %08x\n", minor_);
    #     printf("hdr.timestamp      : %016" PRIx64 ", %s", timestamp_,
    #            asctime(localtime(reinterpret_cast<const time_t*>(&timestamp_))));
    #     printf("hdr.img_size       : %08x\n", image_size);
    #     printf("hdr.img_chk        : %08x\n", be32toh(img_chk_));
    #     printf("hdr.fuses_chk      : %08x\n", be32toh(fuses_chk_));
    #     printf("hdr.info_chk       : %08x\n", be32toh(info_chk_));
    #     printf("hdr.applysec       : %08x\n", applysec_);
    #     printf("hdr.config1        : %08x\n", config1_);
    #     printf("hdr.err_response   : %08x\n", err_response_);
    #     printf("hdr.expect_response: %08x\n", expect_response_);
    #     if (dev_id0_)
    #       printf("hdr.dev_id0        : %08x (%d)\n", dev_id0_, dev_id0_);
    #     if (dev_id1_)
    #       printf("hdr.dev_id1        : %08x (%d)\n", dev_id1_, dev_id1_);
    #     printf("hdr.fusemap        : ");
    #     for (size_t i = 0; i < sizeof(fusemap) / sizeof(fusemap[0]); ++i) {
    #       printf("%08X", fusemap[i]);
    #     }
    #     printf("\n");
    #     printf("hdr.infomap        : ");
    #     for (size_t i = 0; i < sizeof(infomap) / sizeof(infomap[0]); ++i) {
    #       printf("%08X", infomap[i]);
    #     }
    #     printf("\n");
    #     printf("hdr.board_id       : %08x %08x %08x\n",
    #            SIGNED_HEADER_PADDING ^ board_id_.type,
    #            SIGNED_HEADER_PADDING ^ board_id_.type_mask,
    #            SIGNED_HEADER_PADDING ^ board_id_.flags);
    #   }
    # #endif  // __cplusplus
    #   uint32_t magic;  // -1 (thanks, boot_sys!)
    #   uint32_t signature[96];
    #   uint32_t img_chk_;  // top 32 bit of expected img_hash
    #   // --------------------- everything below is part of img_hash
    #   uint32_t tag[7];   // words 0-6 of RWR/FWR
    #   uint32_t keyid;    // word 7 of RWR
    #   uint32_t key[96];  // public key to verify signature with
    #   uint32_t image_size;
    #   uint32_t ro_base;  // readonly region
    #   uint32_t ro_max;
    #   uint32_t rx_base;  // executable region
    #   uint32_t rx_max;
    #   uint32_t fusemap[FUSE_MAX / (8 * sizeof(uint32_t))];
    #   uint32_t infomap[INFO_MAX / (8 * sizeof(uint32_t))];
    #   uint32_t epoch_;  // word 7 of FWR
    #   uint32_t major_;  // keyladder count
    #   uint32_t minor_;
    #   uint64_t timestamp_;  // time of signing
    #   uint32_t p4cl_;
    #   uint32_t applysec_;      // bits to and with FUSE_FW_DEFINED_BROM_APPLYSEC
    #   uint32_t config1_;       // bits to mesh with FUSE_FW_DEFINED_BROM_CONFIG1
    #   uint32_t err_response_;  // bits to or with FUSE_FW_DEFINED_BROM_ERR_RESPONSE
    #   uint32_t expect_response_;  // action to take when expectation is violated
    #   union {
    #     // 2nd FIPS signature (cr51/cr52 RW)
    #     struct {
    #       uint32_t keyid;
    #       uint32_t r[8];
    #       uint32_t s[8];
    #     } ext_sig;
    #   } u;
    #   // Spare space
    #   uint32_t _pad[5];
    #   struct {
    #     unsigned size : 12;
    #     unsigned offset : 20;
    #   } swap_mark;
    #   uint32_t rw_product_family_;  // 0 == PRODUCT_FAMILY_ANY
    #                                 // Stored as (^SIGNED_HEADER_PADDING)
    #                                 // TODO(ntaha): add reference to product family
    #                                 // enum when available.
    #   struct {
    #     // CR50 board class locking
    #     uint32_t type;       // Board type
    #     uint32_t type_mask;  // Mask of board type bits to use.
    #     uint32_t flags;      // Flags
    #   } board_id_;
    #   uint32_t dev_id0_;  // node id, if locked
    #   uint32_t dev_id1_;
    #   uint32_t fuses_chk_;  // top 32 bit of expected fuses hash
    #   uint32_t info_chk_;   // top 32 bit of expected info hash
    # } SignedHeader;
    # #ifdef __cplusplus
    # static_assert(sizeof(SignedHeader) == 1024,
    #               "SignedHeader should be 1024 bytes");
    # #ifndef GOOGLE3
    # static_assert(offsetof(SignedHeader, info_chk_) == 1020,
    #               "SignedHeader should be 1024 bytes");
    # #endif  // GOOGLE3
    # #else
    # _Static_assert(sizeof(SignedHeader) == 1024,
    #               "SignedHeader should be 1024 bytes");
    # #endif  // __cplusplus
    # #endif  // __EC_UTIL_SIGNER_COMMON_SIGNED_HEADER_H
    
    #  * The flash memory is implemented in two halves. The SoC bootrom will look for
    #  * a first-stage bootloader (aka "RO firmware") at the beginning of each of the
    #  * two halves and prefer the newer one if both are valid. The chosen bootloader
    #  * also looks in each half of the flash for a valid application image (("RW
    #  * firmware"), so we have two possible RW images as well. The RO and RW images
    #  * are not tightly coupled, so either RO image can choose to boot either RW
    #  * image. RO images are provided by the SoC team, and can be updated separately
    #  * from the RW images.
    #  */
    # /* Flash is directly addressable - BUG: here lays a flaw, it will boot from either half but
    # the RW_A/RW_B selection governs what half of the flash is expsoed at this stage.  */
    # #if defined(CHIP_H1D1)
    # #define CHIP_FLASH_BASE              0x80000
    # #define CHIP_FLASH_SIZE              (1024 * 1024)
    # #else
    # #define CHIP_FLASH_BASE              0x40000
    # #define CHIP_FLASH_SIZE              (512 * 1024)
    # #endif
    # #define CHIP_FLASH_HALF              (CHIP_FLASH_SIZE >> 1)
    # /* Each half has to leave room for the image's signed header */
    # #define CHIP_SIG_HEADER_SIZE      1024
    # /* This isn't optional, since the bootrom will always look for both */
    # #define CHIP_HAS_RO_B
    # /* The RO images start at the very beginning of each flash half */
    # #define CHIP_RO_A_MEM_OFF 0
    # #define CHIP_RO_B_MEM_OFF CHIP_FLASH_HALF
    # /* Size reserved for each RO image */
    # #define CHIP_RO_SIZE 0x4000
    # /*
    #  * RW images start right after the reserved-for-RO areas in each half, but only
    #  * because that's where the RO images look for them. It's not a HW constraint.
    #  */
    # #define CHIP_RW_A_MEM_OFF CHIP_RO_SIZE
    # #define CHIP_RW_B_MEM_OFF (CHIP_FLASH_HALF + CHIP_RW_A_MEM_OFF)
    # /*
    #  * Any reserved flash storage is placed after the RW image. It makes A/B
    #  * updates MUCH simpler if both RW images are the same size, so we reserve the
    #  * same amount in each half.
    #  */
    # #define CHIP_RW_SIZE                   \
    #  (CHIP_FLASH_HALF - CHIP_RW_A_MEM_OFF - CONFIG_FLASH_TOP_SIZE)
    # /* Reserved flash offset starts here. */
    # #define CHIP_FLASH_TOP_A_OFF (CHIP_FLASH_HALF - CONFIG_FLASH_TOP_SIZE)
    # #define CHIP_FLASH_TOP_B_OFF (CHIP_FLASH_SIZE - CONFIG_FLASH_TOP_SIZE)
    # /* Internal flash specifics */
    # #define CHIP_FLASH_BANK_SIZE         0x800   /* protect bank size */
    # #define CHIP_FLASH_ERASE_SIZE        0x800   /* erase bank size */
    # /* This flash can only be written as 4-byte words (aligned properly, too). */
    # #define CHIP_FLASH_ERASED_VALUE32    0xffffffff
    # #define CHIP_FLASH_WRITE_SIZE        4   /* min write size (bytes) */
    # /* But we have a 32-word buffer for writing multiple adjacent cells */
    # #define CHIP_FLASH_WRITE_IDEAL_SIZE  128 /* best write size (bytes) */
    # /* The flash controller prevents bulk writes that cross row boundaries */
    # #define CHIP_FLASH_ROW_SIZE          256 /* row size */
    # /* Manufacturing related data. */
    # /* Certs in the RO region are written as 4-kB + 3-kB blocks to the A &
    #  * B banks respectively.
    #  */
    # #define RO_CERTS_A_OFF                     (CHIP_RO_A_MEM_OFF + 0x2800)
    # #define RO_CERTS_B_OFF                     (CHIP_RO_B_MEM_OFF + 0x2800)
    # #define RO_CERTS_A_SIZE                     0x01000
    # #define RO_CERTS_B_SIZE                     0x00c00
    # /*
    #  * Flash erases must be multiples of CHIP_FLASH_ERASE_SIZE, so in
    #  * order to rewrite CERTS_B, we need wipe RO_CERTS_ERASE_SIZE rather
    #  * than CERTS_B_SIZE.
    #  */
    # #define RO_CERTS_ERASE_SIZE                 0x01000
    # /* We have an unused 3-kB region in the B bank, for future proofing. */
    # #define RO_CERTS_PAD_B_SIZE                 0x00c00
    # /* Factory provision data is written as a 2-kB block to the A bank. */
    # #define RO_PROVISION_DATA_A_OFF             0x3800
    # #define RO_PROVISION_DATA_A_SIZE            0x0800
    # #endif   /* __CROS_EC_FLASH_LAYOUT_H */


## Loop Mounting Images
    $ sudo mkdir -p /mnt/android/[image_name]
    $ sudo mount -t ext4 -o ro,loop ./[image_name].raw.img /mnt/android/[image_name]


