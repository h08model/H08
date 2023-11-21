#!/bin/sh
############################################################
#to   calculate precipitation
#by   2010/01/31, hanasaki, NIES: 
############################################################
# Settings (change below)
############################################################
PRJ=mesc; RUN=hs1_; YEARMIN=1979; YEARMAX=1979
#PRJ=mesc; RUN=851_; YEARMIN=2079; YEARMAX=2079
#
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.hlf
############################################################
# macro (do not change)
############################################################
MONS="00 01 02 03 04 05 06 07 08 09 10 11 12"
TMP=temp${SUF}
############################################################
# job
############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  for MON in $MONS; do
    DAY=0
    if [ $MON = 00 ]; then
      DAYMAX=0
    else
      DAYMAX=`htcal $YEAR $MON`
    fi
    while [ $DAY -le $DAYMAX ]; do
      DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
      RAINF=../../met/dat/Rainf___/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
      SNOWF=../../met/dat/Snowf___/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
      PRCP=../../met/dat/Prcp____/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
      htmath $L sub $PRCP $SNOWF $RAINF           # may include negative value
      htmaskrplc $ARG $RAINF $RAINF gt 0 0 $TMP   # mask
      htmath $L add $SNOWF $TMP $SNOWF            # correct snowf
      htmath $L sub $RAINF $TMP $RAINF            # correct rainf
      htmaskrplc $ARG $SNOWF $SNOWF lt 0 0 $SNOWF # mask
      DAY=`expr $DAY + 1`
    done
  done
  YEAR=`expr $YEAR + 1`
done