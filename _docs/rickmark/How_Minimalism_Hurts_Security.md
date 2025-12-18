# How Minimalism Hurts Security



# Apple Device Boot Process

Apple has for many years valued ease of use and consumer friendliness over actual security.  This is totally clear when you consider that an Apple laptop can have its security features disabled without any clear visual indicator of this lowered security state.  (Android and Chromebooks place a large loud warning when booting in anything other then the most secure state).  


# Online Accounts

Apple does not provide historical data about your account.  This means that if an attacker gains access to your email, you are unable to create an audit trail of the events that have occurred.  An attacker can quite simply restore your backup, delete the email of the device, and then remove it from the Apple ID screen.  Microsoft has a dated but still better log of events for login to a Microsoft account, but this is still often lacking (what the account was actually logged into, or what is called the “relying party”) but still an improvement.  Clearly Microsoft provides much better visibility into the use of company owned Microsoft Accounts known as “OrgID”, but this is restricted to paying corporate customers, not consumers who, ya know, bank on outlook.com.  The best implementation of audit trail I’ve seen is GitHub.com which, although knowingly designed for a engineer class, provides a full trail of every security related event from login, to second factor modification.  Other companies, especially ones that we rely on like Google, Apple and Microsoft should provide at least that level of detail if requested. 

