# Linux Open Network Name API

# Introduction

Today applications perform a DNS resolution, then open a socket.  This makes it difficult to express firewall policy as a DNS name and port as opposed to IP addresses.  By creating a new API that allows one to connect by name, this semantic data would be kept.  Since this is a new sys call it would need kernel design consideration.  How the kernel perform the resolution of the name is another concern with the design.


