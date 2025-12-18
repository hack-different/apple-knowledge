# QEMU Gadget Device USB Stack
This is a collaborative document, all helpful edits (or comments) are welcome (might require Dropbox to be signed in)

# Problem / Goals

Traditionally USB virtualization has been about exposing physical or virtual devices to a synthetic USB controller on the virtualized guest OS.  This has been useful for traditional scenarios such as exposing printers or Webcams to macOS or Linux in a VM.  As ARM is a platform that predominately today is used with “gadget mode” devices (those who traditionally had USB-B connectors) we lack a well defined method of using / testing these gadgets.  We need to build up an effective means for connecting these resources, either to their hosting OS (pretending to be a physical device to the kernel), to processes on the hosting OS such as `usbmuxd`, or even still to other virtualized operating systems local or remote.

## The problems with todays solutions

**USB over TCP/IP abstracts low level parts of the USB stack**
USB over TCP/IP was not intended to be used for low level testing such as device enumeration, protocol errors or to give precise control of `SETUP` or endpoints / stalls / enumeration etc.  While support for USB over TCP/IP has value (it of course has an existing install base, compatible hardware and software, and is broadly useful for *numerous* scenarios where precise frame control is not required and better performance / lower latency is optimal.  It’s likely that any “lower level” implementation could in effect also present a higher level USB over TCP/IP functionality as well to enable dual use cases.
**A USB bus lifetime should not be owned by the device, or the host**
To enable a more flexible set of use cases we should consider cases where the device would be pulled through reset.  If the socket / connection is owned by `qemu` itself, when the system goes down or restarts the owned socket / device would also disappear, requiring the other end of the bus to re-establish a link.  By using a separate process that represents a “virtual USB controller”, a `usbd` of sorts, we can allow both the host and the guest to vary independently and to isolate their lifetimes from each-other.
**The protocol should be OS independent since both ends will most likely be different operating systems**
The protocol should not make any assumptions that limit to particular operating systems.  This is the reason that simpler options like `usbfs` aren’t feasible as they are Linux specific.  

## Goals

**Maintain compatibility with tooling**

- `pcapng` USB support (Darwin and Linux are specified) which provides Wireshark viewing of packet flow
- `libusb` backend allowing use by unprivileged users, such as CI environments 
- Support USB over TCP for both sources (gadgets) and sinks (virtual controllers)

**Support local connectivity securely**

- No use of TCP by default, not even localhost
- No client uses it “by default”.  `libusb` would have to “opt in” to support for this facility.  If “system wide” access is desired it can be done by configuring the kernel mode component to present the bus system wide.
- Capability model that uses separate sockets for “gadget” end and “host” end (so they can have separate user/group rights)
- Ability to specify restrictions on which USB PID/VID and Classes

**Async support first, sync supported by the client end as kernel transports are async**
USB conceptually allows the submission and completion to occur as two async messages.  For example a device might “disconnect” after a control request is sent, but before the non-existent reply fails to arrive causing a timeout.  Synchronous semantics should be simulated by the client in user mode using timeouts, and mutex/semaphores.
**Support for multiple instances**
This allows multiple users or multiple VMs/test runners to share a system
**Support for low level and malformed frames**
Allow for full control of the oppose end of the transaction, including frames that are non-sensical to support fuzzing.  In order to accomplish this we should allow for the endpoints to submit `RAW` frames or the traditional Control/Bulk/etc types.  

# Presenting the device natively to the OS
## macOS

**Strategy 1: Use DriverKit in user mode**
https://developer.apple.com/documentation/usbdriverkit
https://developer.apple.com/documentation/iousbhost

**Strategy 2: Use classic Kernel Extensions and a virtual USBHostController**
Build essentially a virtual host controller, making the devices indistinguishable in user mode from devices physically attached.  Not a great strategy for Apple Silicon as those devices are not capable of using Kexts without turning off like, all of security

**Strategy 3: Utilize** `**Virtualization.framework**`
More RE / analysis needed

## Linux

**Strategy 1: It’s all a file anyway**
Present the devices as sockets on the filesystem, possibly like the suggestion below for `libusb`.  Not know is `ioctl` on the devices
**Strategy 2: Something, something, kernel patch/reuse**
I’m sure KVM would do *something* here
**Strategy 3: UDev? USBFS?**

# Creating a Virtual Device backend for `libusb`
## Unix sockets

The simple answer is to support a socket interface between `qemu-system` and `libusb` as a new backend.  This would probably work by `libusb` reading an environment variable like `LIBUSB_VIRTUAL_SOCKETS` which would be the location on disk of a folder monitored for create/delete events where each file is a POSIX socket that represents a single device on the bus.

