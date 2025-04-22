# Security Critical Kernel Object Confidentiality and Integrity

# License

This work is licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).


## From the Author

Furthermore I make no intellectual property claims, other then attribution of work.  Therefore, from myself it can be used for both research as well as commercial works.  This paper draws on the ARM public reference documentation, and to the best of my knowledge does not contain any rights protected patents or any other protected materials.  This does not act as a guarantee of non-infringement as I have not made the effort to ensure non-infringement myself.  I urge commercial implementer to verify non-infringement prior to implementing, with simple credit to myself as an author.

# Primer (Work In Linux Kernel Protection)

https://www.kernel.org/doc/html/latest/security/self-protection.html

# Introduction

Today many advanced operating systems have mitigation around the kinds of security bugs that they were susceptible to just years ago.  No execute brought about an era where data in RAM could not hold executable machine code that could be modified, stack canaries sought to prevent stack smashing.  Some of the most advanced techniques such as iOS’s KTRR (Kernel Text Read-only Region) use higher privileged processor levels to prevent the kernel from disabling these protections.  All of these in total have narrowed attackers to very few possible routes whereby gaining control of the system can occur.  Broadly there are a few paths left:


1. From the bottom up by using EoP from un-trusted user mode bug to some modification of the kernel state that allows for privileged execution.
    1. For example, changing a process effective UID to 0
    2. Inserting libraries into other processes to provide “rootkit like” abilities
2. From the top down by re-writing some part of the secure boot chain, allowing the attacker to control the operating system before it loads
    1. a defect in secure boot
    2. overwriting “Boot ROM” (shockingly usually not ROM but locked flash regions)
    3. blue pill like virtualization, where a malicious hyper-visor can control a guest OS that does not know it’s not running on bare metal
3. From the side using other system elements such as the baseband processor in cell phones to modify regions of data
    1. can allow for an “over the air” attack from a LTE or WiFi chip
    2. can be used by a low privilege segment of code to modify regions of memory that would gain access to high privilege levels of the main processing element.

In cases of #1 and #3, code that is in fact valid and booted using a secure boot chain has been modified into executing down code paths that are not as expected by the designers of the kernel.
The common pattern in #1 and #3 compromises is that they take advantage of the fact that the kernel trusts its own mutable data structures.  Since data structures in the kernel are used to make security decisions, they are fundamentally required.  The problem in all of these situations described is that they assume that the data is valid and as was last written by the kernel.  As there are numerous ways to affect the values from outside the expected and legitimate paths, this may not be true.  Mutations can occur by use of a Read/Write gadget that allows for arbitrary read and write to kernel space.  It can also occur when DMA allows other processing elements to directly modify kernel memory. 

In these cases, the code reading and making a security decision is generally undisturbed and is operating properly, albeit with incorrect data.  The failure was code that was not intended to mutate the kernel state in such a way having been executed prior to the read.  I therefore propose a new technique known as security critical kernel object confidentiality and integrity.

Errors of the #2 category are explicitly out of scope as modification of the secure boot chain would prevent sign and validate operations to occur, and can best be accomplished by other means, although hardening of the running kernel may provide some protection for the update mechanism preventing some #2 type attacks.
+
The basis is simple, mutations to kernel state should come only from known code paths, and therefore can create a cryptographic signature at time of mutation that can prove it was modified by an approved method.  Other parts of the kernel can then validate this hash to prove that no unauthorized modifications of state have occurred.  For the purposes of this example I base a theoretical implementation on iOS with KTRR on ARM hardware supporting TrustZone and ARMv8.3 pointer signing.

KTRR executes in the ARM TrustZone (EL3 - the secure monitor) and gives us good assurance that any code executed in the processing element at kernel privilege is part of the kernel text region, and that MMU protections have not been modified or disabled.  This also means we have some “secure world” OS we can extend.

The kernel would compile a new data structure that includes the types of kernel objects that have security properties (like the XNU process, known as a `task`).  It would also include a series of valid functions in the kernel which can “sign” such objects.  For the sake of simplicity let’s ignore non-secure mutations of such objects, and assume the kernel could split task into the signed object and the non-security related mutable state.

On startup the secure world creates random tweak values for each object type to ensure one signing gadget cannot be used for different types, and stores it in secure memory.  It also generates a root key per boot stored in secure memory.  Think of this as a form of object ASLR.

Upon entering a function in the kernel such as `task_create`, a call to the “secure world” notifying that it is entering a task mutation function.  The secure world uses the read only structures to verify this entry point is a valid location to begin a task sign operation.  The secure world notes this state for the processor that is handling this operation, adds in validation data such as a random nonce, the stack pointer, and returns a cookie.  The function continues and either enters a commit or an abort phase.  Commit calls the secure world back with the address of the new struct and the cookie.  If the cookie is valid and we haven’t unwound the kernel stack past when the cookie was created, we use a tweaked per object type and random key in the secure world to sign the task.  If abort is called, we verify that we are in a valid sign state, and then clean up the sign operation state.  If we are invalid somehow, we panic.

We use this enter and commit/fail method to ensure that a kernel which an attacker has control of  the instruction pointer does not jump to some point within the `task_create` function turning it into a signing gadget.  Also, to prevent race conditions, the struct should exist in processor local memory until signed.

To ensure that the kernel maintains integrity, upon every user / kernel mode transition we tensure that the signing state does not exist and panic if it does, as it should always be committed or aborted in a single kernel operation.  Since the cookie can exist outside of the secure memory, this should not require a transition across the TrustZone barrier.

Later when the kernel needs to read the kernel object, it calls a secure world operation with the address of the kernel object.  The secure world verifies the signature and if valid copies into processor local storage.  The processor is then free to read the object and make security decisions.  The processor local cache must be reset on every kernel mode transition.


## This scheme can be further enhanced in the following ways:

**Confidentiality**: Encryption can be added to these operations to prevent reading sensitive values from non-approved code paths.
**List and tree operations**: The secure world can provide append and remove operations for lists allowing an entire list of items to be validated.
**Tweak values passed to children**:  A thread value may be able to use a tweak value from the task that it is part of to ensure that it is not moved between tasks.  Provides Merkle tree like function.
**Rollback prevention**: By using a central monotonically increasing counter rollbacks to prior valid signed states can be avoided.
**Hardware acceleration**:  With the ARM extension process, hardware support to increase the speed and security of this scheme can be developed.


## Hardware Mitigations - The Secure Von Neumann Architecture



# Reference Implementation
## ARM and The Cryptographic Extensions

Because the signer and the validation key are both protected inside of the ARM TrustZone SMEM, there is no need for public / private cryptographic signing in this scene.  Further the ARMv8.2 cryptographic extensions provide hardware based acceleration of the SHA256 algorithm, which to our benefit also allows for hashing of a non-contiguous region.  This in sum total means that the HMAC Sign / Verify operations are hardware optimized and much like ARMv8.3 pointer signing may not lead to an odious burden on the operating system to sign and verify.

## OP-TEE and Linaro

OP-TEE () is an open source trusted execution environment which has mainline support in the linux kernel, and can be run in a QEMU AArch32/AArch64 emulated environment.  This provides the required substrate to implement a reference implementation.  In this solution we will be building an early load OP-TEE TA (trusted application) that will run inside the TrustZone of an ARM processor.  

Technical Implementation

- Kernel jumps to EL3 and call site is retained in ELR_EL3

Experimental Tree Manifest:

https://github.com/rickmark/manifest/blob/master/qemu_v8.xml

## Interface
- Initialize
    - Creates per-object tweak values and stores configuration
    - While for the purposes of this example we will take a dynamic configuration from the REE kernel, this would not be done in practice as it would allow reconfiguration or disabling the protections set out here.  This configuration would likely be compiled directly into the TA, and immutable as the TA and the kernel are paired.
        - The cookie could be a tweaked, random prefixed copy of the stack pointer to ensure we have returned to the same stack where the cookie was issued.
- Enter
    - This notifies the TEE that a client function has been entered.  The TA verifies the instruction pointer of the processor before the secure call, and creates a cookie to mark the beginning of the transaction.
- Protect
    - Pass enter cookie, sign object with object type tweak value and return signed blob, possibly encrypted
- Abort
    - Clear a signing cookie state, called when a function has a gracefully handled error.
- Clear
    - Called during entry to kernel mode transitions to ensure that no cookie state was leaked.  Can cause a panic if state is found.  This depends on the CPU time required for this check.
- Verify
    - Verifies signature and copies to processor local cache

