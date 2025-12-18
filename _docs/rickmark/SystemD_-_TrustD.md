# SystemD - TrustD

# Introduction

A classic problem of Linux based systems is the agreement and configuration of Certificate Authorities.  Different SSL libraries have different approaches to handling this.  


# Proposed Solution
- A new `systemd` service called `systemd-trustd` that executes as a local Unix socket that can perform trust evaluations for clients.
- Helper scripts that synchronize disk areas like openssl’s CAs with the root CAs.
- Authorized clients can add additional CAs and manage policies
- By being a active responder, it can get more context about a trust decision and execute policy based approval / denial of trust
    - E.G. during TLS negotiation it can send the IP/dns name of the server allowing CA’s to have policies such as only being trusted for domain trees (e.g. Chinese CAs only being valid for .zh domains)
- Can become the beginning of a user mode code signing architecture for linux
- SSL libraries can use `trustd` if available or legacy methods if not
- TrustD can perform caching that can optimize decisions across the system
- It can interact with `ssh-agent` to provide hardware or software backed credentials (reusing the same policy scheme as for trust evaluation)
- It can interact with the GPG keychain providing an API to a system keyring besides keys on disk
- Using a Linux Security Module it can be hardened against tampering even by the root user

