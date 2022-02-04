# IOKit RE (may the 64 bits be with you)

IOKit is a bunch of classes, a C++ framework for writing code and drivers in XNU kernel.
It is implemented on top of the libkern library in a subset of C++.

It is true that the generic parts of the IOKit are available in source.
Here and there you might even find an outdated sources for some of the driver families kexts.
However, most of the kexts present in the kernelcache on the iOS are binary and need to be REd.

One of the challenges REing these kexts is the dynamic nature of the C++.
Fortunately, libkern provides a sort of RTTI (Runtime Type Information) for safe dynamic casting and
whatnot, which gives us information about the classes and the hierarchy.

## Meta
> We only collect meta data ...

Seriously though, there is a meta class for each and every class in libkern/IOKit.
It provides the basis for runtime information about the classes and helps us a lot.

### Registration
During the initialization of the kernel/kext, new classes are registered
into the RTTI system by calling the OSMetaClass::OSMetaClass() function.  
This "register" function takes the following arguments:
  - pointer to instance of the meta class for the class we register
  - name of the class we register
  - pointer to instance of parent's meta class
  - size of an instance of the class we register

These register calls are made from the init functions located in the __mod_init_func sections of the kernel and the kexts.  
Lets take the AMFI kext for example. It has 2 init functions in the mod_init_func section.  
Bellow is the content of the first one:
~~~ data
AppleMobileFileIntegrity:__text:FFFFFF801FE19C8C ADR       X0, off_FFFFFF801FE3F228
AppleMobileFileIntegrity:__text:FFFFFF801FE19C90 NOP
AppleMobileFileIntegrity:__text:FFFFFF801FE19C94 ADR       X1, aApplemobilefil ; "AppleMobileFileIntegrityUserClient"
AppleMobileFileIntegrity:__text:FFFFFF801FE19C98 NOP
AppleMobileFileIntegrity:__text:FFFFFF801FE19C9C NOP
AppleMobileFileIntegrity:__text:FFFFFF801FE19CA0 LDR       X2, =off_FFFFFF801FD36DC8
AppleMobileFileIntegrity:__text:FFFFFF801FE19CA4 MOV       W3, #0xE8
AppleMobileFileIntegrity:__text:FFFFFF801FE19CA8 BL        sub_FFFFFF801FE1E270
AppleMobileFileIntegrity:__text:FFFFFF801FE19CAC ADRP      X8, #off_FFFFFF801FE3F228@PAGE
AppleMobileFileIntegrity:__text:FFFFFF801FE19CB0 ADR       X9, off_FFFFFF801FE3E8E0
AppleMobileFileIntegrity:__text:FFFFFF801FE19CB4 NOP
AppleMobileFileIntegrity:__text:FFFFFF801FE19CB8 ADD       X9, X9, #0x10
AppleMobileFileIntegrity:__text:FFFFFF801FE19CBC STR       X9, [X8,#off_FFFFFF801FE3F228@PAGEOFF]
~~~
Observe the following details (you will need your own kernelcache for this):
- X0 is a pointer to a data structure residing in this kext's data section, specifically in the
  section named "__common" (on 64 bits).
- X1 is a pointer to a string that looks like it could be a name of a class
- X2 is another pointer to a "__common" data section, but this time not necessarily in the same kext.
- W3 is a small immediate
- BL is a stub function in the same kext. With the stub (through the symbol) leading to a function in the kernel.

__Congratulations!__ You have found a meta class register call to OSMetaClass::OSMetaClass().  
Just as you've guessed it:
- X0 is the meta class
- X1 is the name
- X2 is the parent
- W3 is the size
- The function in the kernel is the OSMetaClass::OSMetaClass() function.

There is a bit more though ...  
After the call to the register stub, it writes some pointer+0x10 into the mata class object.  
The first pointer in the object is usually the vtable. And indeed, this is the vtable for the meta
class.

#### Beautification
Let's apply the knowledge we've gathered. Let's rename the objects and the vtable by the following
patterns (python):
~~~python
meta_object = "__ZN%d%s10gMetaClassE" % (len(class_name), class_name)
meta_vtable = "__ZTVN%d%s9metaClassE" % (len(class_name), class_name)
~~~

Notes:  
* Parent meta class:  
  The _parent_meta_object_ gets renamed when we find where the parent is registered and rename the
  _meta_object_ there. It is a pointer to the same place.
* Renaming a stub:  
  You can't really add the "stub" and be done with it, because you have such a stub in every kext.
  So, you need to be a bit creative here.

##### Results
Now, IDA can demangle the names and will show us the following:
~~~ data
AppleMobileFileIntegrity:__text:FFFFFF801FE19C8C  ADR      X0, AppleMobileFileIntegrityUserClient::gMetaClass
AppleMobileFileIntegrity:__text:FFFFFF801FE19C90  NOP
AppleMobileFileIntegrity:__text:FFFFFF801FE19C94  ADR      X1, aApplemobilefil ; "AppleMobileFileIntegrityUserClient"
AppleMobileFileIntegrity:__text:FFFFFF801FE19C98  NOP
AppleMobileFileIntegrity:__text:FFFFFF801FE19C9C  NOP
AppleMobileFileIntegrity:__text:FFFFFF801FE19CA0  LDR      X2, =IOUserClient::gMetaClass
AppleMobileFileIntegrity:__text:FFFFFF801FE19CA4  MOV      W3, #0xE8
AppleMobileFileIntegrity:__text:FFFFFF801FE19CA8  BL       OSMetaClass::OSMetaClass::[stub_at_0xFFFFFF801FE1E270](char const*,OSMetaClass const*,uint)
AppleMobileFileIntegrity:__text:FFFFFF801FE19CAC  ADRP     X8, #AppleMobileFileIntegrityUserClient::gMetaClass@PAGE
AppleMobileFileIntegrity:__text:FFFFFF801FE19CB0  ADR      X9, vtable for'AppleMobileFileIntegrityUserClient_::metaClass
AppleMobileFileIntegrity:__text:FFFFFF801FE19CB4  NOP
AppleMobileFileIntegrity:__text:FFFFFF801FE19CB8  ADD      X9, X9, #0x10
AppleMobileFileIntegrity:__text:FFFFFF801FE19CBC  STR      X9, [X8,#AppleMobileFileIntegrityUserClient::gMetaClass@PAGEOFF]
~~~

# TODO
* __such wow!__
* __much to-do!__
* vtables (class  and meta class)
* structs
* OSMetaClassBase vtable quirk
* moar RE


# Notes
## 64 vs 32 bits
Sometimes the difference are minor, like R0 instead of X0.  
I believe the grand scheme is the same and it would be relatively easy to apply.  
And why would you be looking at 32 bits anyway, shoo, shoo!

