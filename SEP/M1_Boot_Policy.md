# Introduction

The M1 introduced us to a new 'boot policy' scheme for allowing booting older versions of macOS as well as other non-Apple operating systems (see Ashai linux).  This scheme is based on the idea of a `img4` file in the `iSCPreboot` (iBoot System Container?) portion of the disk.  In order to ensure that the policy file is modified only in approved ways, the system must be first booted to 1TR (one true recoveryOS) to allow the SEP to sign a new policy file.  Furthermore the SEP must be authenticated to by an administrator to approve the change.  Because the SEP has limited storage (see Lynx, next generation Ocelot) the policy is stored on disk and only the apporate hashes are stored in SEP local storage / EEPROM.

## Methodology

By using `bputil -l` the commands sent to the SEP are plainly visible.  This is a documentation of those commands.

Aside:
I do find it unusual that there is both a SEP command to retreve the policy nonces as well as a system `policy-nonce-digests` nvram variable as this seems
redundant

## Storage of Policy

The `img4` policy itself is stored in the `iSCPreboot` volume and grouped by the APFS volume group ID.  It uses the path structure:

Local Policy:      `<iSCPreboot_MOUNT_POINT>/<VOLUME_GROUP_ID>/LocalPolicy/<LOCAL_POLICY_HASH_HEX>.img4`
RecoveryOS Policy: `<iSCPreboot_MOUNT_POINT>/<VOLUME_GROUP_ID>/LocalPolicy/<LOCAL_POLICY_HASH_HEX>.recovery.img4`

It appears there is a volume group for the regular APFS macOS install as well as the second `Apple_APFS_Recovery` volume group.

## Boot Policy / BAA Commands

Note: all commands specify that the SEP must respond to API level v7
Note: "hashes" are 48 bytes long, which coresponds to SHA2-384

| SEP Ordinal | Command                                                     | Description                                                       |
| ----------- | ----------------------------------------------------------- | ----------------------------------------------------------------- |
| 2           | begin_update_policy                                         | TBD                                                               |
| 3           | end_update_policy                                           | TBD                                                               |
| 11          | bootpolicy_get_proposed_local_policy_nonce_digest           | TBD                                                               |
| 12          | bootpolicy_get_proposed_remote_policy_nonce_digest          | TBD                                                               |
| 13          | bootpolicy_get_proposed_recoveryos_policy_nonce_digest      | TBD                                                               |
| 14          | bootpolicy_get_blessed_local_policy_nonce_digest            | Input "Volume Group ID", Returns "Local Policy Nonce Hash" (lpnh) | 
| 15          | bootpolicy_get_blessed_remote_policy_nonce_digest           | TBD                                                               |
| 16          | bootpolicy_get_blessed_recoveryos_policy_nonce_digest       | TBD                                                               |
| 19          | update_local_policy_for_new_local_nonce                     | TBD                                                               |
| 43          | create_sidp_measurement                                     | TBD                                                               |
| 45          | bootpolicy_get_linked_manifest_tag_list                     | TBD                                                               |
| 62          | bootpolicy_get_current_os_type                              | Returns macOS, one true recoveryOS, ordinary recoveryOS           |
| 63          | bootpolicy_get_current_os_type_restrictions_override_status | TBD                                                               |
| 67          | bootpolicy_get_local_policy_pairing_status                  | TBD                                                               |
| 68          | bootpolicy_verify_local_policy_pairing                      | TBD                                                               |
