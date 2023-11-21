#!/bin/sh
############################################################
#to   separate Prcp into Rainf and Snowf
#by   2011/12/26 hanasaki
############################################################
# Settings (Change below)
############################################################
PRJ=WEC_; RUN=20__; YEARMIN=1960; YEARMAX=2000
PRJ=WEC_; RUN=A2__; YEARMIN=2001; YEARMAX=2100
PRJ=WCN_; RUN=20__; YEARMIN=1960; YEARMAX=2000
PRJ=WCN_; RUN=A2__; YEARMIN=2001; YEARMAX=2100
PRJ=WIP_; RUN=20__; YEARMIN=1960; YEARMAX=2000
PRJ=WIP_; RUN=A2__; YEARMIN=2001; YEARMAX=2100
############################################################
# Geography (Do not change here)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
############################################################
# Macro (Do not change here)
############################################################
MONS="00 01 02 03 04 05 06 07 08 09 10 11 12"
############################################################
# Prepare directory
############################################################
if [ ! -d ../../met/dat/Rainf___ ]; then
  mkdir   ../../met/dat/Rainf___
fi
if [ ! -d ../../met/dat/Snowf___ ]; then
  mkdir   ../../met/dat/Snowf___
fi
############################################################
# Job
############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  for MON in $MONS; do
    if [ $MON = 00 ]; then
      DAY=0
      DAYMAX=0
    else
      DAY=0
      DAYMAX=`htcal $YEAR $MON`
    fi
    while [ $DAY -le $DAYMAX ]; do
      DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
       PRCP=../../met/dat/Prcp____/$PRJ$RUN${YEAR}${MON}${DAY}$SUF
      SNOWF=../../met/dat/Snowf___/$PRJ$RUN${YEAR}${MON}${DAY}$SUF
      RAINF=../../met/dat/Rainf___/$PRJ$RUN${YEAR}${MON}${DAY}$SUF
      htmath $L sub $PRCP $SNOWF $RAINF
      htmaskrplc $L $XY $L2X $L2Y $LONLAT $RAINF $RAINF lt 0.0 0.0 $RAINF
      DAY=`expr $DAY + 1`
    done
  done
  YEAR=`expr $YEAR + 1`
done
