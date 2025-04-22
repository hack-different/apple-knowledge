# Titan

Internal Storage - GPT


/mmcblk0s1 - ESP - EFI System Partition
/mmcblk0s2 - ext4 - /boot
/mmcblk0s3 - lvm2 PVS - only member of “system”

vgcreate - system
lvcreate root - /dev/system/system-root = /
/dev/system/system-root - XFS
lvcreate swap /dev/system/system-swap

/dev/sda
/dev/sdb
/dev/md0 - raid0 of sda/sdb

lvm volume group /de/md0 - data

vgcreate data /dev/md0

lvcreate /dev/data/data-srv



# Map
- / - XFS on LVM on sytem
- /boot - ext4 
- /boot/esp - fat
- /mnt/data - root btrfs on data on mutable
- /home - subvol /home on /mnt/data
- /srv - subvol /srv on /mnt/data
- /var - subvol /var on /mnt/data
- /opt - xfs on data on runtime
- /usr/local - xfs on data on runtime


# Mkinitcpio
- `lvm2’
- `udev_mdadm`
- `xfs`
- `btrfs`
# Packages


- `btrfs-progs`
- `grub`
- `zsh`
- `base`
- `base-devel`
- `vim`
- `efibootmgr`
- 

