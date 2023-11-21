#!/bin/sh

###################################################
# Geography (Edit here if you change spatial domain/resolution)
###################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
MAP=.kyusyu
#
#L=14400
#XY="120 120"
#L2X=../../map/dat/l2x_l2y_/l2x.nk1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.nk1.txt
#LONLAT="139 141 36 38"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.nk1
#MAP=.NakaKuji
###################################################
# Input txt (Edit here if you change spatial domain/resolution)
###################################################
FLWDIRASC=../../map/org/KYUSYU/flwdir${MAP}${SUF}.txt
###################################################
# Input map
###################################################
GRDARA=../../map/dat/grd_ara_/grdara${SUF}
###################################################
# Output
###################################################
DIRFLWDIR=../../map/dat/flw_dir_
DIRLNDMSK=../../map/dat/lnd_msk_
DIRLNDARA=../../map/dat/lnd_ara_

FLWDIR=${DIRFLWDIR}/flwdir${MAP}${SUF}
LNDMSK=${DIRLNDMSK}/lndmsk${MAP}${SUF}
LNDARA=${DIRLNDARA}/lndara${MAP}${SUF}
###################################################
# Job (Prepare directory)
###################################################
if [ ! -d $DIRFLWDIR ]; then mkdir -p $DIRFLWDIR;fi
if [ ! -d $DIRLNDMSK ]; then mkdir -p $DIRLNDMSK;fi
if [ ! -d $DIRLNDARA ]; then mkdir -p $DIRLNDARA;fi
###################################################
# Job (generate flow direction and land mask)
###################################################
htformat $ARG asciiu binary $FLWDIRASC $FLWDIR
htmaskrplc $ARG $FLWDIR $FLWDIR gt 0 1 $LNDMSK
htmask $ARG $GRDARA $LNDMSK eq 1 $LNDARA

echo $FLWDIR
echo $LNDMSK
echo $LNDARA