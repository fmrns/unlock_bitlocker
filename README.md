# unlock_bitlocker

Unlock BitLocker'd partition with interactive passphrase.
For automatic mount, see https://github.com/Aorimn/dislocker#a-note-on-fstab

Search the UUID of the partition with blkid, then set it as PARTUUID.
Set BASED, and MOUNTP, then $BASED/$MOUNTP is the target mount point.

## mount
> sudo sh unlock.sh

## unmount
> sudo umount $BASED/$MOUNTP
> sudo umount $BASED/.$MOUNTP

<!-- end of file -->
