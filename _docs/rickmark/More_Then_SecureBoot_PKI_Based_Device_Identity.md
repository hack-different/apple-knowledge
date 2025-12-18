# More Then SecureBoot - PKI Based Device Identity

# Let’s not get ahead of ourselves…

Today we have much larger problems in IoT devices such as the use of secure protocols, firmware SecureBoot and full encryption.  Those issues do in fact need to be solved, and this paper is more about what to do next.



# If You Control the Ecosystem, Create a PKI

Let’s use Alarm / Camera company ACME Alarm.  Since they know that ACME door sensors will be used with their own base stations, they should include a PUF (physically inclinable function) that provides the entropy for the private key of an EC key.  The device should then have an x509 certificate burned into ROM providing a strong device identity.   This key and certificate should be used only for the derivation of new credentials, not for the communication itself, as is required by PFS (perfect forward security).


## You Can Warn or Deny When Out of Ecosystem

The ACME security base station could then throw up a caution screen if the pairing process results in a end to end security stance that indicates the device’s origin doesn’t come from ACME Inc.  The Z-Wave initiative actually enforces that no provider can deny access to a Z-Wave network because it comes from outside the manufacturer ecosystem.  This however does not prevent ACME from warning when it’s not ACME certified hardware, or from an ACME trusted partner.



## You Can Have a Hardware Key and a Use Key

While the hardware key should be based on both confidential private key and a burned in certificate, a good implementation should use this simply to be an attestation allowing the device to derive a private key for a particular user / session, and requesting a certificate for that to be stored in mutable storage.  This prevents the general usage of hardware key for communication between nodes, while also providing a hardware based root-of-t

