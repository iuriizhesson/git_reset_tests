#!/bin/sh

#
# Post build script for Factory Tools
# Created by Bruno Diraison (ST-Microelectronics - 2014)
#

TARGETDIR=$1
BOARD_DIR="$(dirname $0)"

# Extract addons to rootfs
tar xvf $BOARD_DIR/addons_factory_tools.tar.bz2 -C $TARGETDIR/



#
# End of post build script
#
