#!/bin/sh

export TARGET="$1"
export BOARD=$(basename $(dirname $TARGET))
export COMMON_DIR=$(dirname $0)
export BOARD_DIR=$COMMON_DIR/../$BOARD
export BOOT_DIR=$TARGET/../images/boot/
export IMG_DIR=$TARGET/../images

mkdir -p $BOOT_DIR

test -x $BOARD_DIR/postscript.sh && $BOARD_DIR/postscript.sh

# transform /var contents into symlinks
rm -rf $TARGET/var/cache
rm -rf $TARGET/var/lib
rm -rf $TARGET/var/lock
rm -rf $TARGET/var/log
rm -rf $TARGET/var/run
rm -rf $TARGET/var/spool
rm -rf $TARGET/var/tmp

ln -s /tmp $TARGET/var/cache
ln -s /tmp $TARGET/var/lib
ln -s /tmp $TARGET/var/lock
ln -s /data/log $TARGET/var/log
ln -s /tmp $TARGET/var/run
ln -s /tmp $TARGET/var/spool
ln -s /tmp $TARGET/var/tmp

# wireless
cp $COMMON_DIR/wpa_supplicant.conf $BOOT_DIR
ln -s $BOOT_DIR/wpa_supplicant.conf $TARGET/data/etc
cp $COMMON_DIR/static_ip.conf $BOOT_DIR
ln -s $BOOT_DIR/static_ip.conf $TARGET/data/etc

$COMMON_DIR/cleanups.sh
test -x $BOARD_DIR/cleanups.sh && test -x $BOARD_DIR/cleanups.sh || true