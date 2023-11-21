#!/bin/sh

###################################################
# Geography
###################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ko5
MAP=.SNU
###################################################
# Input
###################################################
FLWDIRASC=../../map/org/KOR/flwdir${MAP}${SUF}.txt
LNDMSKASC=../../map/org/KOR/lndmsk${MAP}${SUF}.txt
###################################################
# Output
###################################################
DIRFLWDIR=../../map/dat/flw_dir_
DIRLNDMSK=../../map/dat/lnd_msk_

FLWDIR=${DIRFLWDIR}/flwdir${MAP}${SUF}
LNDMSK=${DIRLNDMSK}/lndmsk${MAP}${SUF}
###################################################
# Job (Prepare directory)
###################################################
if [ ! -d $DIRFLWDIR ]; then mkdir -p $DIRFLWDIR;fi
if [ ! -d $DIRLNDMSK ]; then mkdir -p $DIRLNDMSK;fi
###################################################
# Job (generate flow direction and land mask)
###################################################
htformat $ARG asciiu binary $FLWDIRASC $FLWDIR
htformat $ARG asciiu binary $LNDMSKASC $LNDMSK
echo $FLWDIR
echo $LNDMSK