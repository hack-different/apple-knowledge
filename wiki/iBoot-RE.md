# iBoot RE (64 bits)

We focus on 64 bit iBoot cause we should:)

## In the beginning

### The Loading Address

Bootloaders in general and iBoot in particular expect to run at a specific, predefined, addresses.
Such an address called the __loading address__ (reset vector) of a bootloader.
When loading the bootloader into IDA you need to supply the loading address, so IDA will be able to resolve data and code references properly.

Most Apple bootloaders start with a relocation code which compares the loading address with the current address and moves the bootloader if needed.
Looking at this relocation code we can extract the loading address of the particular bootloader.

So, we start by using 0 as the loading address until we know better.

Here is an iBoot 64 bit example loaded at 0:
~~~ data
ROM:000 loc_0                            
ROM:000                                 
ROM:000          ADRP     X0, #loc_0@PAGE
ROM:004          ADD      X0, X0, #loc_0@PAGEOFF <=== X0 has the current page address
ROM:008          LDR      X1, =0x83D37B000       <=== this is the loading address
ROM:00C          BL       sub_17634              
ROM:010          CMP      X1, X0                 <=== are we running at loading address
ROM:014          B.EQ     loc_44                 <=== if yes: continue booting normally
ROM:018          MOV      X30, X1                <=== else: set LR to loading address
ROM:01C          LDR      X2, =0x83D413440
ROM:020          LDR      X3, =0x83D37B000
ROM:024          SUB      X2, X2, X3            <=== calculate len
ROM:028
ROM:028 loc_28                                  <=== copy loop
ROM:028          LDP      X3, X4, [X0]
ROM:02C          STP      X3, X4, [X1]
ROM:030          ADD      X0, X0, #0x10
ROM:034          ADD      X1, X1, #0x10
ROM:038          SUBS     X2, X2, #0x10
ROM:03C          B.NE     loc_28
ROM:040          RET                            <=== done copying -> return to loading address (LR)
ROM:044 ; -------------------------------------------------------------
ROM:044
ROM:044 loc_44                                  <=== rest of the iboot
ROM:044          MSR      #6, #0xF ; MSR DAIFSET, #0XF  
ROM:048          ADRP     X30, #loc_AC8@PAGE
ROM:04C          ADD      X30, X30, #loc_AC8@PAGEOFF
ROM:050          ADRP     X10, #loc_1F000@PAGE
ROM:054          ADD      X10, X10, #loc_1F000@PAGEOFF
ROM:058          MSR      #6, c12, c0, #0, X10 ; MSR VBAR_EL3, X10
~~~

So, the __loading address__ in this example is: __0x83D37B000__.
With this knowledge we can load the iboot to IDA with a proper loading address.

For 32 bits iboot the relocation code works the same, but it's not the first code. 
The iboot starts with an exception vector.The first vector (reset) branches to the relocation code and it's the same from there.

Other bootloader: LLB, iBEC, IBSS have the same relocation code and hence the loading address available for grabbing.


### Beyond the loading address

After relocation of the iBoot to the proper running place, the boot continues.
Setting SP pointers, exception tables, etc.
Below is the rest of the first function that runs on boot.
Between the comments and the labels you should have no troubles following the code flow.


~~~ data
.........   [        relocation code as shown above        ]
ROM:83D07B044   
ROM:83D07B044   ; mask exceptions
ROM:83D07B044                 MSR             #6, #0xF ; MSR DAIFSET, #0XF
ROM:83D07B048   ; set the next function to be executed on return
ROM:83D07B048                 ADRP            X30, #_start@PAGE
ROM:83D07B04C                 ADD             X30, X30, #_start@PAGEOFF
ROM:83D07B050   ; setup exceptions table base address
ROM:83D07B050                 ADRP            X10, #exception_table@PAGE
ROM:83D07B054                 ADD             X10, X10, #exception_table@PAGEOFF
ROM:83D07B058                 MSR             #6, c12, c0, #0, X10 ; MSR VBAR_EL3, X10
ROM:83D07B05C   ; clear 512K of memory
ROM:83D07B05C                 LDR             X10, =base_addr_for_stack_and_stuff
ROM:83D07B060                 LDR             X11, =0x80000 ; 512K
ROM:83D07B064                 ADD             X11, X11, X10
ROM:83D07B068                 MOV             X12, #0
ROM:83D07B06C loop__clear_512K
ROM:83D07B06C                 STP             X12, X12, [X10]
ROM:83D07B070                 ADD             X10, X10, #0x10
ROM:83D07B074                 CMP             X10, X11
ROM:83D07B078                 B.NE            loop__clear_512K
ROM:83D07B07C   ; set base address for stack and stuff
ROM:83D07B07C                 LDR             X10, =base_addr_for_stack_and_stuff
ROM:83D07B080                 ADD             X10, X10, #1,LSL#12 ; (base + 4K)
ROM:83D07B084   ; set EL3 SP to (base + 4K)
ROM:83D07B084                 MOV             SP, X10
ROM:83D07B088                 MSR             #5, #0  ; MSR SPSEL, #0
ROM:83D07B08C                 ADD             X10, X10, #2,LSL#12 ; ((base + 4K) + 8K)
ROM:83D07B090   ; set EL0 SP to (base + 12K)
ROM:83D07B090                 MOV             SP, X10
ROM:83D07B094                 ADD             X20, X10, #2,LSL#12 ; (((base + 4K) + 8K) + 8K)
ROM:83D07B098   ; zero additional space
ROM:83D07B098                 LDR             X10, =_iboot_end ; from this addr
ROM:83D07B09C                 LDR             X11, =fb_mbe ; to this addr
ROM:83D07B0A0                 MOV             X12, #0xF
ROM:83D07B0A4                 BIC             X12, X11, X12 ; end addr aligned to 16
ROM:83D07B0A8                 MOV             X13, #0
ROM:83D07B0AC   ; clear more space, aligned 16
ROM:83D07B0AC loop__clear_more__aligned
ROM:83D07B0AC                 STP             X13, X13, [X10],#0x10
ROM:83D07B0B0                 CMP             X10, X12
ROM:83D07B0B4                 B.NE            loop__clear_more__aligned
ROM:83D07B0B8                 CMP             X11, X12
ROM:83D07B0BC                 B.EQ            loc_83D07B0CC
ROM:83D07B0C0  ; clear more space, the rest (unaligned)
ROM:83D07B0C0 loop__clear_more__unaligned
ROM:83D07B0C0                 STR             W13, [X10],#4
ROM:83D07B0C4                 CMP             X10, X11
ROM:83D07B0C8                 B.NE            loop__clear_more__unaligned
ROM:83D07B0CC
ROM:83D07B0CC loc_83D07B0CC
ROM:83D07B0CC  ; set Exception handlers SP to (base + 20K)
ROM:83D07B0CC                 ADRP            X11, #sp_for_exception_handlers@PAGE
ROM:83D07B0D0                 ADD             X11, X11, #sp_for_exception_handlers@PAGEOFF
ROM:83D07B0D4                 STR             X20, [X11]
ROM:83D07B0D8                 RET
~~~


Notes:
- MSR DAIFSET, #0XF (mask all exceptions)
  This is very early stage and we don't want to be interrupted before we can handle exceptions properly.
- _start
  We are running a kind of a 'reset vector' code now and this is the next
  function we execute by setting its address in the LR register and running with the RET instruction.
- exception_table
  The address that goes into the VBAR_EL3 register is the beginning of the EL3 exception table.  
  ARMv8 is very different from ARMv7 in how the exception table looks and works.
  Some of the differences are:
  - Instead of vector of dwords it has 0x80 bytes of code for each exception
  - There are multiple entries for the same exception depending on the circumstances of where the exception is taken from



