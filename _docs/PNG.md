# PNG images

The standard PNG format is documented in the
[PNG specification](http://www.libpng.org/pub/png/spec/1.2/PNG-Contents.html).
It consists of a series of "chunks" which contain:

* length (4 bytes big-endian, only counts length of data, may be 0)
* chunk type (4 bytes)
* data (variable length, may be empty)
* CRC (4 bytes)

Apple uses PNG images extensively,
but they also extended them with proprietary chunks.

## CgBI chunk

Ever since the first iPhoneOS,
PNG images included in the operating system (such as application icons)
have a custom chunk called `CgBI`.
These images are not supported by standard PNG viewers since the `CgBI` chunk is marked "critical".
Standard decoders reject the whole file.
In theory, the purpose is to optimize the image decoding
on the slow CPUs of early iPhones.
For example, red and blue channels are flipped (BGR instead of RGB)
to match the iPhone framebuffer format.

There is some public information about this format:

* [Apple's patent](https://patents.google.com/patent/US20080177769A1/en)
* [The iPhone Wiki](https://www.theiphonewiki.com/wiki/PNG_Images)
* [iPhone dev wiki](https://iphonedev.wiki/index.php/CgBI_file_format)
* [pngdefry website](http://www.jongware.com/pngdefry.html)
* [Archiveteam file format wiki](http://fileformats.archiveteam.org/wiki/CgBI)

There are also many tools to create (flip color channels, add CgBI chunk)
and decode (convert to standard PNG image) these PNG files:

* [pincrush](https://github.com/DHowett/pincrush) (Python encoder)
* [ipin.py](https://axelbrz.com/?mod=iphone-png-images-normalizer) (Python decoder)
* [pngdefry](http://www.jongware.com/pngdefry.html) (C decoder)
* [PNGNormalizer](https://github.com/briancollins/PNGNormalizer) (ObjC decoder)
* [cgbi-to-png](https://github.com/jakubknejzlik/cgbi-to-png) (Javascript decoder)

However, many tools are incomplete (eg. they swap BGR to RGB
but don't fix the pre-multipled alpha channel),
and none of the public information seems to have actually figured out
what the *content* of the `CgBI` chunk is about.

By the specification:

* The `IHDR` chunk must appear first.
* The image data, if true-color, must have color components in RGB order.
* "The color values stored for a pixel are not affected
  by the alpha value assigned to the pixel.
  This rule is sometimes called 'unassociated' or 'non-premultiplied' alpha.
  PNG does *not* use pre-multiplied alpha".
* Image data is compressed with 'deflate'
  and the compressed data stream is stored in the "zlib" format
  (compression method + flags + data + Adler-32 checksum).

iPhone-optimized PNG images with a `CgBI` chunk break all these items.

The `CgBI` chunk appears even before the `IHDR`.
It contains 4 bytes with flags.

The image data is (sometimes?) byte-swapped such that the colors are in BGR order instead of RGB.
The alpha channel is also (sometimes?) in pre-multiplied format.
This *may* depend on other flags in `CgBI`, but I haven't figured it out exactly yet.

If bit 0x1 is set in the first byte of the `CgBI` chunk,
then the compressed stream is in raw format,
and doesn't have the zlib header or Adler checksum.
(Note that most tools will use the raw zlib format
if the CgBI chunk is merely present, and don't check for this bit being set).

Bit 0x2 in the first byte sets an internal flag `APPLE_FILTER_SUB_ONLY` in the decoder
but the meaning is not yet understood.

## iDOT chunk

Another proprietary PNG chunk added by Apple is `iDOT`.
It even appears on screenshots taken on iOS.

This chunk has information that allows decoding the PNG image using multiple threads.

More information is available on <https://www.hackerfactor.com/blog/index.php?/archives/895-Connecting-the-iDOTs.html>

## apPD chunk

The ImageIO framework has code that looks for an `apPD` chunk.
Probably means "app data".

The format seems to be:

* Offset 0, length 4: unknown
* Offset 4, length 4: subtype? Only `pKit` is supported
* Offset 8, length 4: big-endian number, payload length
* Offset 12, var length: payload

The ImageIO decoder checks that the subtype is equal to `pKit`,
and checks that the chunk length is equal to the "payload length" field + 12,
If both checks pass, the rest of the chunk data (the "payload" above) is stored as a `CFData`.
Later this data is added to a `dictionary["PencilKitPrivateData"]`.

The purpose of this data is unknown (probably need to dig into the PencilKit framework),
and I haven't yet seen any sample of an image file containing `apPD`.
