#!/bin/sh
############################################################
#to   prepare global slope data
#by   2015/10/07, hanasaki
#
#     Original Data:
#     FAO Harmonized World Soil Database v1.2
#     Data available at IIASA's web site.
#
############################################################
# settings (Do not edit)
############################################################
CLSS="1 2 3 4 5 6 7 8"
############################################################
# output (Do not edit)
############################################################
DIR=../../map/dat/slp_cls_
############################################################
# geography (Do not edit)
############################################################
LGL5=9331200
XYGL5="4320 2160"
L2XGL5=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=../../map/dat/l2x_l2y_/l2y.gl5.txt
LONLATGL5="-180 180 -90 90"
ARGGL5="$LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5"
#
LHLF=259200
XYHLF="720 360"
L2XHLF=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2YHLF=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLATHLF="-180 180 -90 90"
ARGHLF="$LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF"
#
# region
#
#5min x 5min for Korean peninsula (.ko5)
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ko5
MAP=.SNU

#1min x 1min for Kyusyu (.ks1)
#L=32400
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.ks1
#MAP=.kyusyu

############################################################
# macro
############################################################
if [ ! -d $DIR ];then mkdir $DIR; fi
TMPASC=temp.txt
TMPHLF=temp.hlf
TMPKO5=temp${SUF}
SUMHLF=${DIR}/FAO2009_00000000.sum.hlf
SUMKO5=${DIR}/FAO2009_00000000.sum${SUF}
############################################################
# job
############################################################
LOG=temp.log
if [ -f $LOG ]; then
  /bin/rm $LOG
fi
#
htcreate $L 0 $SUMKO5

for CLS in $CLSS; do
#
# in
#
  ASC=../../map/org/FAO2009_Slope/GloSlopesCl${CLS}_5min.asc
#
# out
#
  GL5=${DIR}/FAO2009_00000000.Cl${CLS}.gl5
  KO5=${DIR}/FAO2009_00000000.Cl${CLS}${SUF}
#
  sed -e '1,6d' $ASC > $TMPASC
#
  htformat $ARGGL5 asciiu binary $TMPASC $GL5
  htlinear $ARGGL5 $ARG $GL5 $KO5
#

  htmaskrplc $ARG $KO5 $KO5 eq 1.0E20 0.0 $TMPKO5 >> $LOG
  htmath $L add $TMPKO5 $SUMKO5 $SUMKO5
done
echo Log: $LOG

