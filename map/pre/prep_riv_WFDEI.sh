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
FLWDIRTXT=../../map/org/WFDEI/flwdir.WFDEI.hlf.txt
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIRFLWDIR=../../map/dat/flw_dir_
#
FLWDIR=${DIRFLWDIR}/flwdir.WFDEI.hlf
#
LOG=temp.log
############################################################
# Job (prepare directory)
############################################################
if [ !  -d ${DIRFLWDIR} ]; then  mkdir -p ${DIRFLWDIR}; fi
############################################################
# Job (create files)
############################################################
if [ -f $LOG ]; then
  /bin/rm $LOG
fi
#
htformat $L $XY $L2X $L2Y $LONLAT asciiu binary ${FLWDIRTXT} $FLWDIR
echo Log: $LOG