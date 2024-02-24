# Secure Enclave Processor

See also [SEP processor memory layout](SEP)

## SEP Firmware Images

Modern SEP firmware images are a flat binary that performs basic ARM8-M 64bit setup by including an image executed at
Virtual Address `0x00000000`.  This will jump to the loader loop, which will first setup hard-coded page tables, other
machine state registers, and then call the `lzvn_decompress` function to decompress the each of the regions of the
firmware image.  Each of these can be seen as the function sets up a ARDP (address relative to PC page aligned) value
in `x0` where the source of the block is, a length of the block in `x1` and the address to decompress to at `x2`.
From a basic look, it seems that the LZVN decompression does include zero pad runs between the sections allowing for
the entire image to be decompressed in a single pass.  While iw would have been helpful to contain this value as an
encoded struct, clearly the intent wasn't to make static analysis of the image simple.

## Extracting a SEP Image

First, we have to decrypt the sep-firmware. This can be done using [xerub's img4lib](https://github.com/xerub/img4lib).
You'll also need the decryption keys.

For A11 SEPOS especially, you might have to do lzvn decode after decrypting img4 since it is an unpacker.

```shell
dd if=sepfw-raw of=sepfw.lzvn bs=0x20000 skip=1
lzvn -d sepfw.lzvn sepfw
```

[LZVN](https://github.com/xerub/lzvn)
(Credit goes to [@s1guza](https://twitter.com/s1guza))

To find these arrays, we can do a `/ EASB` or `/x 0000010006` on the sep-firmware image. Then go back to the farthest
chunk of 8 ASCII characters (`ctx` and `name` fields).

Here is the python code to dump these fields on A12 sep-firmware:

```python
import struct

f = struct.Struct("<4s4sQII")
assert f.size == 0x18
def dump_map(buffer):
 for x in f.iter_unpack(buffer):
  print(*[x[0][::-1].decode('utf-8'), x[1][::-1].decode('utf-8'), hex(x[2]), hex(x[3]), hex(x[4])])

with open("sepos", "rb") as fd:
 fd.seek(0x2cb180)
 buffer = fd.read(0x18*14)
 dump_map(buffer)

 fd.seek(0x2d6080)
 buffer = fd.read(0x18*2)
 dump_map(buffer)
```

## Splitting out the SEP Images

Thanks to the wonderful `sepsplit-rs` [`usttryingthingsout/sepsplit-rs`](https://github.com/justtryingthingsout/sepsplit-rs)
tool we can then split out the SEP image into its modules.
