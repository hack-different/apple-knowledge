# Mach & BSD

The Mach microkernel and the BSD kernel are the two major components of XNU.
<br>
Mach implements the absolute core of the operating system, while the BSD layer is built on top of Mach, and implements higher level concepts.

_Note: As I'm writing this, I'm realizing that this whole writeup on Mach/BSD will be huge, so expect this article to be divided into several sub-articles soon._

## Table of contents
+   [Mach](#mach)
    +   [Introduction](#intro)
    +   [Philosophy](#philosophy)
    +   [Implementation](#implementation)
        +   [Execution primitives](#execution_primitives)
            +   [Threads](#threads)
            +   [Tasks](#tasks)
        +   [IPC primitives](#ipc_primitives)
            +   [Messages](#messages)
                +   [Introduction](#messages_intro)
                +   [Utilizing messages](#utilizing_messages)
            +   [Ports](#ports)
                +   [Introduction](#ports_intro)
                +   [Port rights](#port_rights)
+   [BSD](#bsd)
+   [Resources](#resources)

## Mach

<a name="intro"></a>
### Introduction
Mach is a microkernel, originally designed by CMU between the 80s and the 90s. Apple chose this microkernel as the base of their new operating system, and has substantially modified it from the original version.

Mach is the absolute foundation of XNU, it deals with every crucial aspect needed for the correct functioning of the operating system. Mach does not bother with higher level concepts such as file systems or device drivers, for example. These concepts are left for other components to implement.

<a name="philosophy"></a>
### Philosophy
As stated before, Mach does not concern itself with higher level concepts, implementing just the bare-bones of the operating system. Mach is specifically designed to allow an entire operating system to be built upon it, which is exactly what Apple has done.

The core idea behind Mach its minimalism. Being a microkernel, Mach implements only the fundamental abstractions (described more in detail later).

Another key point in the Mach philosophy is how the various subsystems communicate, i.e. via a message passing facility. Interaction between components is completely implemented via IPC (inter-process communication) in Mach. This means that objects cannot directly call/invoke themselves, rather a message is sent from one object to another, that message is queued until the receiver handles it.
This may seem unconventional, and it is. But, since Mach is a microkernel, all of the subsystems are separated from one another, thus message passing is needed for communication.

Summarizing, remember that Mach is just the pure foundation of XNU, and everything else is built upon it.

<a name="implementation"></a>
### Implementation

<a name="execution_primitives"></a>
#### Execution primitives

<a name="threads"></a>
##### Threads
Mach is responsible for the basics abstractions of execution.
<br>
The most basic unit of execution is indeed a _thread_. A thread provides basics scheduling statistics and machine registers, used for execution. Remember that a thread has no links to resources (such as virtual memory), as these are implemented in _tasks_.
<br>
Also remember that exist a direct link between a Mach thread and a BSD thread.

<a name="tasks"></a>
##### Tasks
A _task_ is basically a container object. It implements resources, such as virtual memory, and its only purpose it's to contain threads, since a task has no life by its own.
<br>
It also exist a direct map between Mach tasks and BSD processes, as with threads.
<br>
The threads in a task are kept in a singly linked list.

<a name="ipc_primitives"></a>
#### IPC primitives

<a name="messages"></a>
##### Messages

<a name="messages_intro"></a>
###### Introduction
Mach messages are simply data exchanged between two endpoints, called ports. Mach messages constitutes the basic building block for IPC communication.

A message has an header (`mach_msg_header_t`), a body (`mach_msg_body_t`), and optionally a trailer (`mach_msg_trailer_t`).

The **header** contains all informations needed for the message to be sent and correctly received, such as:

-   `msgh_size`: The message size.
-   `msgh_remote_port`: The destination Mach port.
-   `msgh_local_port`: The local Mach port.
-   `msgh_id`: An unique ID. Used specifically with MIG.
-   `msgh_bits`: Optional bits.

The standard **body** contains simply a `mach_msg_size_t`. The body is the actual data of the message and can contain virtually anything.

The **trailer** contains a `mach_msg_trailer_type_t` (`unsigned int`), which specifies the trailer type, and a `mach_msg_trailer_size_t` for specifying the trailer size.

<a name="utilizing_messages"></a>
###### Utilizing messages
Any user-land process is able to create Mach messages and use them for communication.
<br>
Creating a simple message is straightforward. You are able to construct your message in any way you want, the only really needed piece is the `mach_msg_header_t`, which must **always** be located at the beginning of the message.

Let's assume we are going to use the following structure for our message:
```
/* sending */
typedef struct simple_mach_message_send {
    mach_msg_header_t header;
    uint32_t x;
} simple_mach_message_send_t;
```
This would be our message, at least for sending. The reason why we need two separate structures for sending and receiving is that the kernel implicitly adds a small trailer to our message while sending it, therefore the received message will be larger than the original, and would fail to receive.
<br>
So, our structure for receiving:
```
/* receiving */
typedef struct simple_mach_message_recv {
    mach_msg_header_t header;
    uint32_t x;
    mach_msg_trailer_t trailer; // we could also use something like `uint32_t pad[8];`
} simple_mach_message_recv_t;
```
This new structure is large enough and will contain the kernel-delivered message. Remember that your `send` struct instance's data will be sent to the receiver, while the `recv` struct instance will be created by the receiver and will receive the `send` structure data (imagine locally copying a structure's data to another structure).

The message's header must be configured properly in order for the message to be sent/received. The absolutely necessary fields to set, for sending, are:
-   `msgh_bits`: Apart from indicating if the message is complex, this field specifies important message attributes, for example how to interpret the `msgh_remote_port` field and the `msgh_local_port` field. This can easily be filled with the use of the `MACH_MSGH_BITS(remote, local)` macro, where `remote` and `local` specify the interpretation of the two ports.
-   `msgh_remote_port`: Specifies the remote Mach port, i.e. where to send our message.
-   `msgh_size`: Specifies the message size. A `sizeof()` on your message structure will suffice.

Additionally, you could specify other fields, such as `msgh_local_port` (a local Mach port, on which you hold receive rights) which could be interpreted by the receiver to send a reply message back.

Receiving requires only one necessary field to be set:
-   `msgh_size`: The message size expected to be received.

The (more common) API used to send/receive message is `mach_msg`. This API indeed gives you the ability to both send/receive messages, by passing specific parameters. Here's the definition:

```
extern mach_msg_return_t	mach_msg(
					mach_msg_header_t *msg,
					mach_msg_option_t option,
					mach_msg_size_t send_size,
					mach_msg_size_t rcv_size,
					mach_port_name_t rcv_name,
					mach_msg_timeout_t timeout,
					mach_port_name_t notify);
```

-   `mach_msg_header_t *msg`: Is the `mach_msg_header_t` of your structure instance (wether you are sending or receiving).
-   `mach_msg_option_t option`: The operation to perform. Send (`MACH_SEND_MSG`) or receive (`MACH_RCV_MSG`) are the most common.
-   `mach_msg_size_t send_size`: The size of the message you are sending. If you are receiving, pass `0` to this parameter.
-   `mach_msg_size_t rcv_size`: The size of the message you are receiving. If you are sending, this is optionally used to specify the size of the reply message. If you don't want it, pass `0` to this parameter.
-   `mach_port_name_t rcv_name`: The Mach port for receiving the message. If you are sending, this is used to specify an optional reply port. If you don't want it, pass `MACH_PORT_NULL`.
-   `mach_msg_timeout_t timeout`: Optionally specifies a timeout before giving up on sending/receiving. Pass `MACH_MSG_TIMEOUT_NONE` is you don't want a timeout.
-   `mach_port_name_t notify`: Optionally specifies a notification port, if you don't want it, pass `MACH_PORT_NULL`.

For more example and code, see the `/wiki/code/ipc/` folder, I have made a sample client/server which interact by sending/receiving a message.

Let's now discuss **complex messages**. A message is deemed _complex_ if the `MACH_MSGH_BITS_COMPLEX` flag is present in the `msgh_bits` field in its header. A complex message is structured differently: After the header, it follows a descriptor count field, followed by actual descriptors.
<br>
There are various types of descriptors, they generally serve the purpose of including special "attachments" to the message. Indeed, descriptors are specifically intended to "give hints" about what kind of out-of-line data we include in the message. Out-of-line data is simply data not directly included within the message itself, but instead allocated and kept somewhere else in memory, and only referenced (via a pointer, for example) by the message.

Here are the various descriptors defined in XNU:

-   `MACH_MSG_PORT_DESCRIPTOR`: Used to specify passing a port right along with the message.
-   `MACH_MSG_OOL_DESCRIPTOR`: Used to specify passing generic out-of-line data.
-   `MACH_MSG_OOL_PORTS_DESCRIPTOR`: Used to specify passing a port.
-   `MACH_MSG_OOL_VOLATILE_DESCRIPTOR`: Used to specify passing generic volatile (subject to frequent change) out-of-line data.

A sample structure for a complex message would be:

```
struct complex_message {
    mach_msg_header_t header;
    mach_msg_body_t body;
    mach_msg_ool_descriptor_t desc;
    mach_msg_trailer_t trailer;     /* optional, really */
};
```

In this case, the `mach_msg_body_t` is required since it specifies the descriptor count. You should set the latter to the actual number of descriptors you intend to include in your message. In our case, the `body.msgh_descriptor_count` would be `1`.

Now let's take a look to the specific fields of the `mach_msg_ool_descriptor_t`. I have chosen to use the `mach_msg_ool_descriptor_t` since it represents generic data, is the most used, and is a fundamental part of a known heap defragmentation technique (heap feng shui), used to increase the chances of a successful exploit.

-   `address`: The OOL data address.
-   `deallocate`: Should the data be deallocated after send?
-   `copy`: Copy options.
-   `type`: Descriptor type.
-   `size`: Data size.

<a name="ports"></a>
##### Ports

<a name="ports_intro"></a>
###### Introduction
Mach ports are endpoints for communication. From user-land perspective, a Mach port is nothing more than an integer, an opaque handle to a more complex object held in-kernel.

Ports implement message queues to receive and enqueue messages. A message remains in a queue until a receiver dequeues it. Messages sent are guaranteed to be delivered.

<a name="port_rights"></a>
###### Port rights
Ports may be accessed only via port rights. Those are basically permissions held by threads and tasks, needed to interact with ports. Here's a list of all the port rights:

-   `MACH_PORT_RIGHT_SEND`: Whoever holds this right for a specific port, is allowed to send (enqueue) messages to that port. More than one entity at a time are allowed to retain this right.
-   `MACH_PORT_RIGHT_RECEIVE`: Whoever holds this right for a specific port, is allowed to receive (dequeue) messages from that port. Holding this right corresponds to having ownership over the port. Only one entity at a time is allowed to retain this right.
-   `MACH_PORT_RIGHT_SEND_ONCE`: Akin to `MACH_PORT_RIGHT_SEND`, but the right is revoked after one message has been sent.
-   `MACH_PORT_RIGHT_PORT_SET`: Receive rights for multiple ports (a port set).

<a name="bsd"></a>
## BSD
BSD is primarily needed to implement what Mach leaves unimplemented. Things such as users, groups, files and others are obviously needed. BSD has also been heavily modified by Apple and differs significantly from other BSD implementations.

Although Mach builds the foundations, XNU can still be considered mostly a BSD-like system, since the POSIX APIs exposed are more complete and effectively more used than Mach's.

<a name="resources"></a>
### Resources
A list of useful external resources.

-   [A deep-dive into the many flavors of IPC available on OS X](https://vimeo.com/127859750) : A talk by Ian Beer about IPC on OS X.
