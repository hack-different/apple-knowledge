# Using a EdgeRouter Lite to Act as a VPN Gateway
Introduction
So many of our devices today use a combination of protocols for restore, update or activation that can allow an attacker on the network to interfere with the security of the process.  It could be as simple as DHCP/DNS hijacking, using insecure protocols like HTTP, poor TLS implementations or any number of things.  In these situations it can be helpful to use a gateway device to ensure access is secured.  In this guide I set up the Ubiquiti EdgeRouter lite to have a WAN (even behind a double NAT), client and admin port.


