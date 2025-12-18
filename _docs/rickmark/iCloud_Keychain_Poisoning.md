# iCloud Keychain Poisoning

# tl;dr

If a malicious device is able to join your iCloud keychain (such as a jailbroken iDevice or insecure macOS device) it can pre-populate keychain items with overly permissive or insecure properties.  This can be leveraged with reset tokens, auto and continuity unlock, and other apps to allow lateral movement and access to sessions and tokens.  This is further complicated by factory process and the ability to generate attested SE tokens which are a key part of the movement of secure material such as CarKey, ApplePay etc.

# A history lesson…

The iCloud keychain is derived from various prior versions of key storage on the apple platform.  Early versions of the keychain were a flat keychain file, which had the private portions encrypted by the user’s login password.  When the user’s password was reset, often private data such as passwords and keys were lost since the key needed to decrypt them wasn’t provided.

When the iPhone shipped, it brought along the keychain concept, and expanded upon it.  iOS devices added the concept of “protection classes” labeled A-D.  These permitted control of when the data was decrypted and available, and is enforced by using a similar method of key derivation from the passcode.  Keys for the level are escrowed with the SEP (the reason you need to enter your passcode at first unlock is this key is absent).

The iPhone, and later the T2 and M series Macs inherited the SEP or secure enclave processor back from the iDevice world.  This provided these devices with new features such as non-extractable scep256k1 keys, end-to-end key attestation, and more.

# A typical secret flow (upsert)

Apple’s own documentation is illustrative of managing keychain items by means of searching for the item, and updating it should it exist, and creating it if it does not.  

![](https://paper-attachments.dropboxusercontent.com/s_3A700D1ED4D34259A09AD0E555C598962DD417CA63A6E34B287B2CA7C0D33EF2_1722877954856_8396f76a-e21a-41c8-8aa6-05d1649ccac3.png)

## Variant A - Cloud Theft

The following is taken mostly from Apple’s own example code of working with the Keychain, but includes two subtle bugs (to be fair, Apple seems to have also been bit by the same defect!)


    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: server,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    
    if status != errSecItemNotFound {
      let account = credentials.username
      let password = credentials.password.data(using: String.Encoding.utf8)!
      var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                  kSecAttrAccount as String: account,
                                  kSecAttrServer as String: server,
                                  kSecValueData as String: password,
                                  kSecAttrSynchronizable as String: false,
                                  kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly]
    
      let status = SecItemAdd(query as CFDictionary, nil)
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }  
    } else {
      guard let existingItem = item as? [String : Any]
      let updateQuery: [String: Any] = [kSecMatchSearchList as String: [item]]
    
      let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                       kSecValueData as String: password]
    
      let status = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
      guard status != errSecItemNotFound else { throw KeychainError.noPassword }
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }


Did you spot them?  The first of the two bugs is `kSecMatchLimitOne`.  Apple’s code and common usage of this are counter intuitive.  It only limits to the first result, but what if two keychain entries match?  Well with the above code you would update one of them, but in a non-deterministic way.  By Apple’s own documentation, this isn’t easy to solve without a two phase fetch:


> You can’t combine the `[kSecReturnData](https://developer.apple.com/documentation/security/ksecreturndata)` and `[kSecMatchLimitAll](https://developer.apple.com/documentation/security/ksecmatchlimitall)` options when copying password items, because copying each password item could require additional authentication. Instead, request a reference or persistent reference to the items, then request the data for only the specific passwords that you actually require.

This means to properly search for any item, you must do a `kSecMatchLimitAll`, handle duplicates, and then get the Data element.

The second bug is much worse…. The code above works great in the common case, but what if I have control of a MacBook that is syncing to your iCloud Keychain?  By inserting a keychain entry into the keychain with the server and account values I want to attack, and setting various attributes to less secure values, I can get secrets from your iDevice.  Here’s an example of attacker code running on a macOS device


    let account = victimAccount
    let server = "appleid.apple.com"
    
    var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: account,
                                kSecAttrServer as String: server,
                                kSecValueData as String: password,
                                kSecAttrSynchronizable as String: true,
                                kSecAttrAccessible as String: kSecAttrAccessibleAlways]

This will insert a matching entry into the iCloud keychain, which will happily be synced since we set `kSecAttrSynchronizable` to true, and will be available back to the macOS device due to the lowering of the protection level to `kSecAttrAccessibleAlways`.  All the attacker needs do, is wait for the victim to use their iDevice and login to the account.

## Variant B - Agressive Updates
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: server,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    
    if status != errSecItemNotFound {
      let account = credentials.username
      let password = credentials.password.data(using: String.Encoding.utf8)!
      var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                  kSecAttrAccount as String: account,
                                  kSecAttrServer as String: server,
                                  kSecValueData as String: password,
                                  kSecAttrSynchronizable as String: false,
                                  kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly]
    
      let status = SecItemAdd(query as CFDictionary, nil)
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }  
    } else {
      guard let existingItem = item as? [String : Any]
    
      guard existingItem[kSecAttrSynchronizable] == false else { throw KeychainError.noPassword }
    
      let updateQuery: [String: Any] = [kSecMatchSearchList as String: [item]]
    
      let attributes: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                       kSecAttrServer as String: server,
                                       kSecAttrAccount as String: account]
    
      let status = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
      guard status != errSecItemNotFound else { throw KeychainError.noPassword }
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    

This variant is similar but also troubling.  The problem is we have even checked for one of our attributes, yet we can still leak a credential.  Can you spot why?  Because we have only returned the first value, we have a 50/50 chance if there are two entries, one local and one iCloud.  When the search returns the local, the guard check passes, but the update operation will update both items!  Why?  Because the selection criteria applies to more than one nearly identical item.
**Potential Fix**
Apple could introduce a `kSecMatchSingleItem` that both asserts that there is a single entry (it doesn’t match more than one) but otherwise behaves the same.  This would prevent the variant B.

## Variant C - Secure Storage

This variant is focused on key origin and extractability.  Many services may assume that if the access control list is correct, and they create only token backed secrets, that all secrets read are token backed.  This also becomes a problem with SE synced material via attestation certificates.

## Variant D - Access Control

This variant is specific to Apple and the OS (as for most apps, sandbox rules apply).  This variant occurs when a malicious low privileged service creates a secret with broader access such as the access group `apple` when it should be a more tightly controlled ACL.  This can expose secrets to lower privileged services such as blastdoor and bluetooth.  This is resolved by apple asserting or validating the access group for 

# Oh continuity…

It seems even Apple can make this mistake, and in a big way.  For those with a MacBook or iPhone and Apple Watch, you’ve probably seen or use `ContinuityUnlock` which is the ability to unlock or login to these devices using the presence of the Watch.  It even flows in reverse!  The Watch can be unlocked by the Phone as well.  After being plagued with some odd security issues myself, and having dug into a ton of the iCloud Keychain model (Octagon Trust, TrustedPeer, CKKS, and the SE restore / sync method), I discovered each time I setup the devices two entries for continuity were being added (Both within the same minute, and both with the same account UUID):


![The result of adding an iPad to the circle](https://paper-attachments.dropboxusercontent.com/s_3A700D1ED4D34259A09AD0E555C598962DD417CA63A6E34B287B2CA7C0D33EF2_1722880925003_image.png)


This is exactly the form of poisoning I referred to, but wait, these continuity values are *supposed* be synced… what gives?  Well the first major issue is that for the lay person, these aren’t even visible in Keychain Access (View → Show invisible items - which still doesn’t show everything).  Second, the keychain on macOS where this is inspectable lacks substantial relevant details for the item (protection class, SEP backed, etc).

Here’s the iCloud item that was used to obtain the decryption key:

    keychain: "/Users/rickmark/Library/Keychains/iCloudBackup.keychain-db"
    version: 512
    class: "genp"
    attributes:
        0x00000007 <blob>="handoff-decryption-key-71C6FAAE-A9CD-48DA-B5B9-460B6C1B2B64"
        0x00000008 <blob>=<NULL>
        "acct"<blob>="handoff-decryption-key-71C6FAAE-A9CD-48DA-B5B9-460B6C1B2B64"
        "cdat"<timedate>=0x32303234303232353231303632375A00  "20240225210627Z\000"
        "crtr"<uint32>=<NULL>
        "cusi"<sint32>=<NULL>
        "desc"<blob>="Handoff Decryption Key"
        "gena"<blob>=<NULL>
        "icmt"<blob>=<NULL>
        "invi"<sint32>=<NULL>
        "mdat"<timedate>=0x32303234303232353231303632375A00  "20240225210627Z\000"
        "nega"<sint32>=<NULL>
        "prot"<blob>=<NULL>
        "scrp"<sint32>=<NULL>
        "svce"<blob>="com.apple.continuity.encryption"
        "type"<uint32>=<NULL>

The unfortunate extractability of the key:

![](https://paper-attachments.dropboxusercontent.com/s_3A700D1ED4D34259A09AD0E555C598962DD417CA63A6E34B287B2CA7C0D33EF2_1722882463393_image.png)


**Bonus Oh-No: iCloud + Setting Sync**



## Various Lateral Moves
- Rapport - `RPIdentity-SameAccountDevice` & `RPIdentity-FamilyDevice`
- Sleep Proxy
- `_airplay-p2p._tcp.`
- `com.apple.continuity.auto-unlock.sync` / `com.apple.continuity.unlock`
- Bluetooth `BluetoothLESync`
- Secure Element (Stockholm) Sync - `SE-PTC` & `SE-PTA`
- WiFi Passwords `AirPort` /  `com.apple.wifip2pd`
- `Backstop`
- `DevicePairing`
- `com.apple.account.idms.password-reset-token`
- `com.apple.ndoagent.baaCertificates-combined-ucrt` / `com.apple.mobileactivationd`
- `MobileBluetooth`
- `Basic Attestation User Sub CA11`
- 
![](https://paper-attachments.dropboxusercontent.com/s_3A700D1ED4D34259A09AD0E555C598962DD417CA63A6E34B287B2CA7C0D33EF2_1723071403676_image.png)


Poisoned Octogon

![](https://paper-attachments.dropboxusercontent.com/s_3A700D1ED4D34259A09AD0E555C598962DD417CA63A6E34B287B2CA7C0D33EF2_1723071637245_image.png)


Poisoned SOS

![](https://paper-attachments.dropboxusercontent.com/s_3A700D1ED4D34259A09AD0E555C598962DD417CA63A6E34B287B2CA7C0D33EF2_1723071657338_image.png)

# Secure Channel and SE Backup and Sync


## Loose notes

Discuss SecureChannel
Octagon
SOS (Secure Object Sync) != PCS (Protected Cloud Storage)
Factory SEP attestation certificates
BAA (Basic Attestation Authority) in the iCloud keychain 
Circle Formation and TLK Rotation
Octagon and TLKShares
TrustedPeers - Secure Channel vs Recovery
CKKS - Views
TPPolicy - TrustedPeer policy objects
xART Recovery Service in the SEP???
AKS vs ACS


