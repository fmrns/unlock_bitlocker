#!/bin/sh
#
# Copyright 2021 Abacus Technologies, Inc.
# Copyright 2021 Fumiyuki Shimizu
# https://opensource.org/licenses/mit-license
#
# apt install dislocker

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin
rc=1

#SUDO_UID=1000
[ -z "$SUDO_UID"  ] && { echo "\$SUDO_UID is empty."; exit $rc; }

# set your PARTUUID. you can search by: blkid | fgrep 'TYPE="BitLocker"'
#PARTUUID=$(blkid | sed -n -E -e 's/^.*TYPE="BitLocker".*PARTUUID="([^"]+)".*$/\1/p' | head -n 1)
PARTUUID=83676fca-01

# set base directory to set the mode to 0500.
HM=$(getent passwd "$SUDO_UID" | cut -d: -f 6)
BASED="$HM/.bitlocker"

# set your directory to mount, relative to $BASED.
MOUNTP=usb1



INTP="$BASED/.$MOUNTP"
INTF="$INTP/dislocker-file"
MOUNTP="$BASED/$MOUNTP"

[ -d "$BASED" ] || { mkdir -p "$BASED"; chown "$SUDO_UID" "$BASED"; }
chmod go= "$BASED"

[ -d "$INTP" ] || { mkdir -p "$INTP"; chown "$SUDO_UID" "$INTP"; }
[ -f "$INTF" ] && { echo "$INTF exists."; exit $rc; }

[ -d "$MOUNTP" ] || { mkdir -p "$MOUNTP"; chown "$SUDO_UID" "$MOUNTP"; }

echo "Trying to mount BitLocker'ed partition [$PARTUUID] to [$MOUNTP] via [$INTF]."

[ -n "$PARTUUID" ] || { echo 'empty PARTUUID.'; exit $rc; }
dislocker --volume /dev/disk/by-partuuid/"$PARTUUID" -u -- "$INTP"
[ -r "$INTF" ] || { echo "cannot unlock $PARTUUID."; exit $rc; }

mount -o loop "$INTF" "$MOUNTP"
echo "to unmount: umount $MOUNTP && umount $INTP"

rc=0
exit $rc

# end of file
