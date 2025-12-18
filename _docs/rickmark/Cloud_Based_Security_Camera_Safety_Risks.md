# Cloud Based Security Camera Safety Risks

# Deleting of Video Footage without an Audit Log

While it may be the case on occasion we catch something embarrassing on our home security cameras… with the rates of ATO (account take-over) and Jailbreaking / Rooting (especially over-the-air using SMS and uCells), the modern cat burger probably has access to the cloud security provider you use.  This allows them to after the fact delete video.  Any decent provider should show an audit trail of any deletions to the customer to prevent the lack of footage to the implication there was no crime.


# WiFi is Garbage, so is your ISP

Devices lack audit trail events when they have their network changed, are de-authed from WiFi or otherwise tampered with.  Most WiFi cameras also work in conjunction with security systems (using as an example here the Ring camera and the Ring alarm).  By embedding a Z-Wave controller into cameras Ring could first auto-configure WiFi for all cameras on changes, and secondary, inform the base station of interruptions to network service.  Devices should also provide an adequate amount of local non-volitale storage to record and later upload in the case of a network interruption.  This in an ideal case would be priority based keeping motion above all else, other video, then stills.  Also, higher class IoT devices are poorly designed, don’t count on your camera to be secure.  If these devices were even built to the standard of Android security (which mandates secure boot, verified boot and `dm-verity`) the world would be a better place.  I’ve often wondered if someone could use IR (infra-red) as a side channel to signal the device running a malicious firmware to stop detection of motion.  

# Lack of Secure Timestamp

Time is difficult (ask Stephen Hawking and Albert Einstein).  To this day we have a number of network time protocols but, fundamentally its difficult to establish secure time.  Part of this is that time is required to validate x509 certificates making HTTPS impossible.  Much to my chagrin, SNTP is not secure network time protocol, but simple network time protocol which simply removes complexity about ranging.  Because of this placing video “back in time” seems easily possible on many systems.  Using a monotonic increasing counter on the camera device ensures time flows unidirectionally, as well as developing a nonce’d, secure network time protocol would improve our trust in device timestamps, HTTPS and CRL/rollback attacks for connection and firmware etc.


# Lack of Login Audit Trail

I’m going to pick on Ring here… The Ring system doesn’t provide a historical view of logins to the account, support interactions, password changes, etc.  This means that an attacker can login, view, delete the “live view” event and logout without detection.  More importantly, Ring lacks strong second factors like U2F or (ick, TOTP).  They strongly prefer SMS second factor to email (which again with Google Advanced Account protection for example is stronger then SMS).  Fraud walking of emails is also a problem on many platforms.  If an attacker leaves a trail, they can often change the email of the account and create a new one with the same username and password.


# Mobile Apps Don’t Log Out

For reasons that still escape me, changing a password doesn’t log most apps out of their sessions (I’m looking at you Chase…).  

