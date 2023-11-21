#!/bin/sh
############################################################
#to   prepare permafrost distribution map of NSIDC
#by   2015/12/14, hanasaki
############################################################
# Geographical Setting (Output)
############################################################
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
# in/out/temporary
############################################################
 IN=../org/NSIDC/llipa.txt
TMP=temp.txt
#
OUTDIR=../../map/dat/prm_msk_
OUTHLF=${OUTDIR}/prmmsk.merkator.hlf
OUT=${OUTDIR}/prmmsk.merkator${SUF}
PNG=${OUTDIR}/prmmsk.merkator.png
############################################################
# macro
############################################################
EPS=temp.eps
CPT=temp.cpt
LOG=temp.log
############################################################
# job
############################################################
if [ ! -d $OUTDIR ]; then mkdir -p $OUTDIR; fi
#
sed -e '1,6d' $IN > $TMP
htformat $ARGHLF asciiu binary $TMP $OUTHLF
    htlinear $ARGHLF $ARG $OUTHLF $OUT
echo $OUT created. > $LOG
#
gmt makecpt -T1/25/1 > $CPT
htdraw  $ARGHLF $OUTHLF $CPT $EPS
htconv  $EPS   $PNG rot
echo $PNG created. >> $LOG
echo Log: $LOG
