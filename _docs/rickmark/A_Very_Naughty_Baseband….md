# A Very Naughty Baseband…
tl;dr - An Apple employee did the thing that they said would never happen during the San Bernardino / FBI incident, and now we can’t trust calls and text messages…


# What is a “Baseband” anyway?

Every year to much fanfare Apple announces its new A class System-on-a-Chip SoC which is the primary location all of the smart part of your smartphone runs.  This includes any UI, AppStore app, and the XNU kernel.

The Baseband is a separate chip and has been from the day one of the iPhone.  In fact the simplest way to think about it is the iPhone without the baseband was the iPod touch.  The baseband is (mostly) made by Qualcomm for Apple in these devices, and runs an entire separate OS.  It is heavily optimized for real-time communication, such as responding to the cellular network when commands or messages are received by the radio, is connects to the metal contacts of the SIM card to be able to use it in the process of communicating with the cellular network, and it connects to the main processor via way of PCIe where it is able to provide ancient simplistic “AT” commands (derivatives of the original modem protocols), all the way up to a series of network adapters that provide our traditional packet based cellular services.


# How does Baseband security work?

For Qualcomm chips, they use basically a similar process as any given secure chip, and verify the cryptographic signatures of each next stage loader.  The X50/X55 and other Qualcomm modem systems use a similar boot and verify scheme that has been around since the modem business was operated by Motorola (`.mbn` being a vestige name of Motorola Binary).  Each chip has eFuses burned in with the value of `OEM_PK_HASH` which is a cryptographic hash of the public key that will be accepted for boot (doing this instead of storing the full `OEM_PK` might in fact be less secure here as well, as you must only collide the hash, not actually solve the private key of the public key).

As the baseband boots it first loads the rough equivalent of SecureROM which in Qualcomm parlance is the PBL or primary boot loader.  The PBL is similar in that it’s tasked with the setup of high-privileged code (QSEE, QHEE) selection of the next stage (either from storage, or external source) verifying it was signed by a public key that matches the `OEM_PK_HASH` and then transferring control to that binary.

What’s important to know about the baseband is it is given its firmware via booting the `restorespl1.mbn` payload, which is used to store its image files.  The baseband power is controlled by the AP, meaning the AP can pull it through reset.  What is not known is the interaction between the AP and the Baseband to allow for non-production signed images.  Apple has previously documented the “demotion register” which is a bit that can be flipped early by DFU to make the device operate in a non-secure state (it’s OK, they have assured us that this demotion “drops” the encryption keys used for data, making it inaccessible).

# Production Firmware is Signed By Build Servers

I have in my career worked for a ton of large companies, and even some small ones.  In every case where software is “digitally signed” this process occurs on specialized servers that (when done properly) use devices known as HSMs (hardware security modules) which store the private key to perform the digital signature.  HSMs (similar to design to the TPM or the SEP) are used to ensure that using the private key does not disclose the private key.  What doesn’t happen at Apple, is some employe setting up a MacMini and signing an official firmware, or does it?

Upon having yet another SIM card fail, I decided to start tearing into the baseband firmware of the iPhone (an area that is relatively un-researched as carrier locking is not required as in the early days of the iPhone and AT&T in the US, and otherwise doesn’t provide capabilities like Jailbreaking does).  To start I had to decode the various firmware files, fortunately some amount of Qualcomm firmware research already existed. (https://github.com/openpst/libopenpst/blob/master/include/qualcomm/mbn.h)

The first item of note was the usage of a test certificate to perform the signature of the booloader:

![](https://paper-attachments.dropbox.com/s_2BB51FA788A1AF96BBDE1A217A04658CF37A71454B7D0DEE688043D8C9CFA72E_1659690892038_image.png)


That provided a basic outline of the signature format (which is only used in the Apple stack for the SPL or secondary program loader, as Apple has a competing BBTicket concept after that stage).  I built various tooling around Apple basebands (https://github.com/hack-different/apple-baseband) and used it to analyze the baseband I had pulled out of the IPSW https://github.com/rickmark/apple-malicious-baseband.  The most interesting file to me was the `bbcfg.mbn` file, as with a little Hex editor and eyeballing, it became clear that it was built on ASN.1 (yes I know its strange, but after you stare at enough x509 certificates it’s pretty easy to pick up on the ASN.1 TLV structures, I’m always watching for `0x30` for sequences).  Apple uses ASN.1 pervasively, so it was a decent guess.

To my surprise, the BBCFG first region is the build signature:

![](https://paper-attachments.dropbox.com/s_2BB51FA788A1AF96BBDE1A217A04658CF37A71454B7D0DEE688043D8C9CFA72E_1659690371278_image.png)


As documented in my toolset and https://github.com/hack-different/apple-knowledge/blob/main/docs/Baseband_Qualcomm.md, this sequence decodes as:

- Tag 0 - String: Build Type (`Mav21_Official`)
- Tag 1 - String: Build Number (Seems in Apple `\d+[A-Z]\d+` format)
- Tag 2 - String: Build Host
- Tag 3 - String: Build User
- Tag 4 - String: Build Host IP Address
- Tag 5 - String: 6 byte short commit hash?
- Tag 6 - String: Build Timestamp
- Tag 7 - String: Branch

The fully coded python decoder exists at 


# Sure, but why do you say malicious?

One of the tasks of the Baseband is to communicate with the SIM card.  I had another occurrence of spontaneous SIM card death, so I decided to attach a nifty device called a SIM interposer.  (https://osmocom.org/projects/simtrace2/wiki)


![](https://paper-attachments.dropbox.com/s_2BB51FA788A1AF96BBDE1A217A04658CF37A71454B7D0DEE688043D8C9CFA72E_1659690610496_718E3D24-5D84-41FA-8351-7BC6DD06E8C4.JPG)


With this device I was successfully able to find the Baseband making requests of the SIM card outside the range of where the data files should be (out of bounds access).  Indexes per the specification into a file (seen being written to with `UPDATE BINARY` is a int16 with a high order bit that must be zero, providing a maximal value of `0x7FFF` or `32767` in decimal, whereas the baseband clearly attempt to access a index beyond that range with `35072`


![](https://paper-attachments.dropbox.com/s_2BB51FA788A1AF96BBDE1A217A04658CF37A71454B7D0DEE688043D8C9CFA72E_1659691108959_image.png)


