# Introduction

When emulating SEP, it is particularly useful to know its physical memory layout (i.e. MMIO address). Inside the decoded
64bit SEP Firmware (>=A11), there are some constant arrays of structure which have the following format:

```c
struct phys_range {
    uint32_t ctx;
    uint32_t name;
    uint64_t start;
    uint32_t size;
    uint32_t unk;
};
static_assert(sizeof(struct phys_range) == 0x18, "");
```

This array contains the physical location of many SEP's peripherals.
The `ctx` and `name` fields are in reversed ASCII.

## Methodology

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

## Examples

For your convenience, A11 and A12's memmap are put here.

### A11 physical ranges

| ctx  | name | start       | size     | unk |
|------|------|-------------|----------|-----|
| dram | nubg | 0x235000000 | 0x4000   | 0x6 |
| dram | nubs | 0x235f00000 | 0x10000  | 0x6 |
| dram | mpst | 0x2352c0000 | 0x4000   | 0x6 |
| dram | amcc | 0x200000000 | 0x4000   | 0x6 |
| XPRT | PMSC | 0x2352d0000 | 0x4000   | 0x6 |
| XPRT | FUSE | 0x2352bc000 | 0x10000  | 0x6 |
| XPRT | MISC | 0x2352e8000 | 0x3c4000 | 0x6 |
| PMGR | BASE | 0x240200000 | 0x10000  | 0x6 |
| TRNG | REGS | 0x240500000 | 0x10000  | 0x6 |
| KEY  | BASE | 0x240680000 | 0x10000  | 0x6 |
| KEY  | FKEY | 0x240e40000 | 0x4000   | 0x6 |
| KEY  | FCFG | 0x240e50000 | 0x10000  | 0x6 |
| AKF  | MBOX | 0x243000000 | 0x8000   | 0x6 |
| AESS | BASE | 0x240300000 | 0x10000  | 0x6 |
| PKA  | BASE | 0x240600000 | 0x10000  | 0x6 |
| GPIO | BASE | 0x240f00000 | 0x10000  | 0x6 |
| I2C  | BASE | 0x240700000 | 0x10000  | 0x6 |

### A12 physical ranges

| ctx  | name | start       | size     | unk  |
|------|------|-------------|----------|------|
| XPRT | PMSC | 0x23d2d0000 | 0x4000   | 0x6  |
| XPRT | FUSE | 0x23d2bc000 | 0x10000  | 0x6  |
| XPRT | MISC | 0x23d2e8000 | 0x3c4000 | 0x6  |
| PMGR | BASE | 0x241000000 | 0x10000  | 0x6  |
| AKF  | MBOX | 0x242404000 | 0x10000  | 0x6  |
| TRNG | REGS | 0x241100000 | 0x10000  | 0x6  |
| KEY  | BASE | 0x241180000 | 0x10000  | 0x6  |
| KEY  | FCFG | 0x241400000 | 0x18000  | 0x6  |
| MONI | BASE | 0x241380000 | 0x40000  | 0x6  |
| MONI | THRM | 0x2413c0000 | 0x10000  | 0x6  |
| GPIO | BASE | 0x241480000 | 0x10000  | 0x6  |
| I2C  | BASE | 0x241440000 | 0x10000  | 0x6  |
| EISP | HMAC | 0x240a60000 | 0x4000   | 0x16 |
| EISP | BASE | 0x240800000 | 0x240000 | 0x16 |
| AESS | BASE | 0x241040000 | 0x10000  | 0x6  |
| PKA  | BASE | 0x241140000 | 0x10000  | 0x6  |

## Character codes

Here are some that are known:

| 4CC  | Meaning                      |
|------|------------------------------|
| XPRT | Expert device                |
| PMGR | Power Manager                |
| AKF  | Apple KingFisher             |
| MONI | Monitor                      |
| TRNG | True Random Number Generator |

## SEP's peripherals

Many SEP's peripherals have a similar MMIO format compared to AP. This includes the I2C master, interrupt dispatcher,
and mailbox.

### AKF

The AKF block generally contains both the interrupt dispatcher (intr) and the AP mailbox. Although A11 and A12 store
different addresses for this, we are certain that the mailbox address ends with 0x4000, because it sits right after
0x4000 bytes of intr's MMIO.

In the above dump, A11's SEP stores intr's address, A12's SEP stores mailbox's address.

#### Interrupt dispatcher

SEP's interrupt dispatcher (intr) has some similarity with Apple Interrupt Controller (AIC) that AP uses.

The intr outputs to the core's IRQ line, it dispatches IRQ from peripherals and the physical timer.

Most of the registers are unknown; however, the SEP's IRQ handler reads from the offset (+0x81C) to find the
asserting interrupt.  This register has a similar format to AIC's IACK.

- External Interrupt: `0x10000 | (v & 0x1ff)`
- Timer Interrupt: `0x70000 | 1`

The timer interrupt seems to be acknowledged by writing `2` to offset (+0xc18)

#### Mailbox

SEP's mailbox MMIO is also very similar compared to AP's side:

```c
#define REG_IOP_I2A_CTRL                    (0x10C)
#define     REG_IOP_I2A_CTRL_ENABLE         (1 << 0)
#define     REG_IOP_I2A_CTRL_FULL           (1 << 16)
#define     REG_IOP_I2A_CTRL_EMPTY          (1 << 17)
#define     REG_IOP_I2A_CTRL_OVFL           (1 << 18)
#define     REG_IOP_I2A_CTRL_UDFL           (1 << 19)
#define REG_IOP_I2A_MSG0                    (0x820)
#define REG_IOP_I2A_MSG1                    (0x824)
#define REG_IOP_I2A_MSG2                    (0x828)
#define REG_IOP_I2A_MSG3                    (0x82C)

#define REG_IOP_A2I_CTRL                    (0x108)
#define REG_IOP_A2I_MSG0                    (0x810)
#define REG_IOP_A2I_MSG1                    (0x814)
#define REG_IOP_A2I_MSG2                    (0x818)
#define REG_IOP_A2I_MSG3                    (0x81C)
```
