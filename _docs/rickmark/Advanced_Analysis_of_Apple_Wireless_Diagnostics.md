# Advanced Analysis of Apple Wireless Diagnostics

# Packet Capture and the DLT Encapsulation

PCap and PCap-NG formats include the concept of a frame’s encapsulation type.  This informs Wireshark about what the next protocol expert or dissector to use is to break the protocol down into its tree structure and what the keys and values mean.  There is a series of encapsulation types known as DLT (Diagnostic Link Type - https://www.wireshark.org/docs//wsug_html_chunked/ChUserDLTsSection.html) 147 through 162 reserved for “private use”.  When capturing a Wireless Diagnostic on an Apple platform they make use of these encapsulations even thought the

