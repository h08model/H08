#!/bin/sh
############################################################
#to   prepare permafrost distribution map of NSIDC
#by   2015/12/14, hanasaki
############################################################
# in/out/temporary
############################################################
 IN=../org/NSIDC/llipa.txt
TMP=temp.txt
#
OUTDIR=../../map/dat/prm_msk_
OUT=${OUTDIR}/prmmsk.merkator.hlf
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
htformat $ARGHLF asciiu binary $TMP $OUT
echo $OUT created. > $LOG
#
gmt makecpt -T1/25/1 > $CPT
htdraw  $ARGHLF $OUT $CPT $EPS
htconv  $EPS   $PNG rot
echo $PNG created. >> $LOG
echo Log: $LOG
