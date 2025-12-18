# How To: Bypass T-Mobile SIM block, steal all their money, and leave no trace…

# Disclaimer

This is a tutorial to do something illegal to demonstrate how bad the vendor is, despite multiple complaints from me.  If you do this, you will likely be caught and go to prison.  I do not condone these actions and the experiments that prove their validity took place against my own accounts and did not require criminal behavior.

# The T-Mobile SIM Lock

By asking T-Mobile nicely they can put up additional barriers to having the SIM card replaced.  This means that retail locations and the phone services have to go through additional hoops to swap your SIM card.

## Trivial Bypass

Buy a new iPhone linked to the phone number / carrier.  Upon receipt of the device you will be asked for the last four of the SSN, and the billing zip code.  Upon entry of these, even though the account holder is set to SIM lock, the new device will activate and receive calls and messages.  In my experience in about 15-20 minutes the SIM reverts to the previous value leaving the new device inactive.  Most importantly, there is no record at customer service that the new device was activated or that it was reverted (though these records do exist in back end systems, the customer would require escalation to retrieve them)

# What’s wrong here…
## That the SIM lock doesn’t do it’s job…

Apple’s back end activation services were able to bypass the SIM lock, and that begs the question if the SIM lock is a “front end” customer service block, how many other back end systems can directly modify the AUC (Authentication Center) and HLR (Home Location Register).  Metro by T-Mobile and all the MVNOs that target T-Mobile as the PLMN registrar are potential vectors.  Because it didn’t block Apple’s modification, it almost surely doesn’t block others…

## There was no audit record of the change…

Because the SIM was modified outside the T-Mobile customer care system, there was no obvious record of the change that I the customer was able to retrieve at a corporate store.  Every change to the SIM regardless of the back end system of origin should be customer visible.  Also they tell you to reach out to fraud when this happens, but again - with what phone or compromised email?  A catch-22 of security.

## Bonus Awful: SIM lock emails your the IMSI…

When you do have the SIM lock feature enabled, and it eventually does go through, it breaks rule one of cellular, do not reveal the IMSI (international mobile subscriber identifier).  This is why there’s the entire concept of the TMSI (temporary mobile subscriber identifier) exists.  The IMSI is considered confidential and there is NO REASON to email it to the customer where it could be exposed to an attacker.  Careless…

## Bonus Awful 2: TOTP uses a fixed secret…

T-Mobile’s “Google Authenticator” which means TOTP has an absolutely awful implementation.  By removing authenticator and re-adding it the “secret” value doesn’t change.  Which means that once an attacker gets the TOTP they have it for the length of the account.  This is a simple fix of making sure the secret rotates between enrollments. 

