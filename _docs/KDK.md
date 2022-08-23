# KDK

Apple Silicon supports kernel debugging, but there are some limitations.

<!-- Amend once limitations are investigated and solved -->
Limitations:

* No known way to switch between kernel variants (e.g. `.development`, etc.)
* Active debugging is not supported, but you can still trigger an NMI with the
  power button.

## Contents of the KDK

The KDK is a folder that contains a number of assets and is installed on macOS under `/Library/Developer/KDKs`

The KDK contains:

* `DEVELOPMENT` and `KASAN` (kernel address sanitizer) versions of the kernel
* `dSYM` bundles which contain external [DWARF](https://en.wikipedia.org/wiki/DWARF) files to symbolicate
  the kernel as well as lldb python helpers
* Extensions and their respective `dSYM` bundles
* `KernelSupport` which contains the non-open-source content of XNU on the Apple Silicon platform (Prior to the M1 XNU
  itself was truly open-source and could be compiled and run, albeit without the majority of what we call macOS.  As
  of the M1, Apple silently closed portions required to create a bootable image)

## Two-Machine Debugging Setup

This is somewhat straightforward and follows the general guidelines outlined in the
`ReadMe.pdf` file contained inside the KDK. The complications arise once you're
inside the debugger.

> Note: SIP needs to be disabled to set NVRAM boot arguments

There are multiple ways to get a connection between your host and target machine,
but the cheapest option is to purchase a "Thunderbolt 3 (USB-C) to Thunderbolt 2
Adapter" and "Thunderbolt to Gigabit Ethernet Adapter". Then connect an ethernet cable
between the target and host (can use a USB-C to ethernet adapter on the host end).
A regular ethernet to USB-C adapter on the target **will not work**.

Once both machines are connected, find the name of the networking interface in
`ifconfig` and set the `boot-args` accordingly:

```shell
sudo nvram boot-args="debug=0x44 kdp_match_name=enX wdt=-1"
```

Reboot and record the address of the target on using `ifconfig` (on the interface
used for debugging) then trigger a panic on the target machine. On the host machine, run `lldb`
and `kdp-remote` with the address of the target machine:

```shell
$ lldb
(lldb) kdp-remote 169.254.XXX.XXX
```

Once you've finished with debugging, clear the `boot-args` with

```shell
sudo nvram -d boot-args
```

### Bugs

If on any `memory read` or `x` (`x` is an alias for `memory read`) you are getting

```text
error: kdp read memory failed
```

Your `lldb` is broken. Known **broken** versions include:

* lldb-1200.0.41 (Apple Swift version 5.3.1 (swiftlang-1200.0.41 clang-1200.0.32.8))

This is due to a bug where `lldb` attempts to correct the base address to use iOS
semantics. The heap on iOS is `0xFFFFFFE0xxxxxxxx` whereas on ASi it's `0xFFFFFE0xxxxxxxx` (notice the missing `F`).

This is apparent if you open a coredump and inspect an address:

```lldb
(lldb) x/x 0xffffe00010204000
error: core file does not contain 0xffffffe010204000
```

To work around this issue on a broken `lldb`, use `p` to evaluate expressions, e.g.:

```lldb
p *(uint32_t*) 0xfffffe0010204000
```

This will not use `memory read` and will therefore work as intended. As well,
amend all scripts in the KDK distribution that use the iOS address with the ASi
one:

```diff
if name == 'VM_MIN_KERNEL_ADDRESS':
    if self.arch == 'x86_64':
        return unsigned(0xFFFFFF8000000000)
    elif self.arch.startswith('arm64'):
-        return unsigned(0xffffffe000000000)
+        return unsigned(0xfffffe000000000)
    else:
        return unsigned(0x80000000)
```

## Crash Server Setup

You can alternatively debug the system by writing coredumps to a remote server
and then inspect them afterwards. Note that coredumps are typically very large uncompressed
(e.g.: 700mb+), so ensure there's adequate space on the server before continuing.

Connect both machines using the same setup in [Two-Machine Debugging Setup](#two-machine-debugging-setup) and record
the IP address of the server running `kdumpd`.  Then, on the panicking machine, set the `boot-args` as follows:

```shell
sudo nvram boot-args="debug=0xc44 kdp_match_name=enX wdt=-1 _panicd_ip=169.254.XXX.XXX"
```

On the server, create a location for the coredumps and start `kdumpd`:

```shell
sudo mkdir /PanicDumps
sudo chown root:wheel /PanicDumps
sudo chmod 1777 /PanicDumps
```

You can either start the daemon:

```shell
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.kdumpd.plist
```

Or you can run it in the foreground:

```shell
kdumpd -w /PanicDumps
```

Once the panicking machine panics, the coredump will be written gzipped to
`/PanicDumps`. `gunzip` it and then load it in `lldb` with

```shell
lldb /System/Library/Kernels/kernel.release.t8101 --core core-xnu-XXX
```

See [bugs](#bugs) before continuing.

Once done creating crash dumps, stop the daemon or kill the foreground `kdumpd`
process and wipe the `boot-args` with `sudo nvram -d boot-args`.
