# iBoot RE

## Bits and Pieces
### The Loading Address
Bootloaders in general and iBoot in particular expect to run at a specific, predefined, addresses. Such an address called the __loading address__ of a bootloader.
When loading the bootloader into IDA you need to supply the loading address, so IDA will be able to resolve data and code references properly.

Most Apple bootloaders start with a relocation code which compares the loading address with the current address and moves the bootloader if needed.
Looking at this relocation code we can extract the loading address of the particular bootloader.

So, we start by using 0 as the loading address until we'll get the real loading address.

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
The iboot starts with an exception vector.The first vector (reset) branches to the relocation code.

Other bootloader: LLB, iBEC, IBSS have the same relocation code and hence the loading address available for grabbing.

PS  
The function called before the relocation takes place is a very peculiar one.
It present on all platforms in the same place, writes some values into a non-standard system register.
Very intriguing indeed. If someone knows the meaning of this, please contact me :)




