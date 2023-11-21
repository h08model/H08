#!/bin/sh
############################################################
#to   prepare WFDEI geographical data
#by   2010/03/31, hanasaki, NIES
############################################################
# Geography (Do not edit here: 0.5 deg global only)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
LNDMSKTXT=../../map/org/WFDEI/lndmsk.WFDEI.hlf.txt
LNDARATXT=../../map/org/WFDEI/lndara.WFDEI.hlf.txt
NATMSKTXT=../../map/org/WFDEI/C05_____20000000.WFDEI.hlf.txt
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIRLNDMSK=../../map/dat/lnd_msk_
DIRLNDARA=../../map/dat/lnd_ara_
DIRNATMSK=../../map/dat/nat_msk_
#
LNDMSK=${DIRLNDMSK}/lndmsk.WFDEI.hlf
LNDARA=${DIRLNDARA}/lndara.WFDEI.hlf
NATMSK=${DIRNATMSK}/C05_____20000000.WFDEI.hlf
############################################################
# Job (prepare directory)
############################################################
if [ !  -d ${DIRLNDMSK} ]; then  mkdir -p ${DIRLNDMSK}; fi
if [ !  -d ${DIRLNDARA} ]; then  mkdir -p ${DIRLNDARA}; fi
if [ !  -d ${DIRNATMSK} ]; then  mkdir -p ${DIRNATMSK}; fi
############################################################
# Job (create files)
############################################################
htformat $L $XY $L2X $L2Y $LONLAT asciiu binary ${LNDMSKTXT} $LNDMSK
htformat $L $XY $L2X $L2Y $LONLAT asciiu binary ${LNDARATXT} $LNDARA
htformat $L $XY $L2X $L2Y $LONLAT asciiu binary ${NATMSKTXT} $NATMSK
