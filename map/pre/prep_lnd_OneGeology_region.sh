#!/bin/sh
############################################################
#
#
#
#     Original data availabe at www.OneGeology.org
#     World CGMW 1:50M Geological Units Onshore
#     PNG graphical map was converted into raster data
#
############################################################
# Settings
############################################################
#
# For global 5min
#
IN=../org/OneGeology/GSC.gl5.txt
#
LGL5="9331200"
XYGL5="4320 2160"
L2XGL5=${DIRH08}/map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=${DIRH08}/map/dat/l2x_l2y_/l2y.gl5.txt
LONLATGL5="-180 180 -90 90"
SUFGL5=.gl5
#
# For global 0.5 degree
#
#IN=../org/OneGeology/GSC.hlf.txt

LHLF=259200
XYHLF="720 360"
L2XHLF=${DIRH08}/map/dat/l2x_l2y_/l2x.hlf.txt
L2YHLF=${DIRH08}/map/dat/l2x_l2y_/l2y.hlf.txt
LONLATHLF="-180 180 -90 90"
SUFHLF=.hlf
#
JOBDRAWALL=no    # this is to check the original data
#
# regional settings
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
# Input/Output
############################################################
# in
LST=../org/OneGeology/lst_3.txt
# out
DIROUT=../../map/dat/geo_cls_
OUT1=$DIROUT/OneGeo__00000000.original$SUFGL5
OUT_R=$DIROUT/OneGeo__00000000.original$SUF
PNG1=$DIROUT/OneGeo__00000000.original.png
OUT2=$DIROUT/OneGeo__00000000.3cls$SUF
PNG2=$DIROUT/OneGeo__00000000.3cls.png
# dir
if [ !  -d $DIROUT ]; then
  mkdir -p $DIROUT
fi
############################################################
# Macro
############################################################
ARGGL5="$LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5"

COD=temp.cod
CPT=temp.cpt
EPS=temp.eps

LOG=temp.log
if [ -f $LOG ]; then
  rm $LOG
fi
############################################################
# job1 (convert ascii into binary)
############################################################
sed -e '1,6d' $IN > temp.txt
htformat $ARGGL5 asciiu binary temp.txt $OUT1
htlinear $ARGGL5 $ARG $OUT1 $OUT_R
############################################################
# job2 (convert binary into list)
############################################################
if [ -f $COD ]; then rm $COD; fi
NUM=1
while [ $NUM -le 255 ]; do
  echo $NUM $NUM >> $COD
  NUM=`expr $NUM + 1`
done
htbin2list $L temp$SUF $OUT_R $COD temp$SUF.txt pergrid > $LOG
############################################################
# job3 (draw)
############################################################
IDMIN=`awk '{print $1}' temp$SUF.txt | head -1`
IDMAX=`awk '{print $1}' temp$SUF.txt | tail -1`
gmt makecpt -T$IDMIN/$IDMAX/1 -Z > $CPT
htdraw $ARG $OUT_R $CPT $EPS
htconv $EPS $PNG1 rot
echo Figure completed. $PNG1
############################################################
# job4 (classify)
############################################################
htlist2bin $LGL5 $LST $OUT1 $COD $OUT2 perarea
htlinear $ARGGL5 $ARG $OUT2 $OUT2
gmt makecpt -T1/4/1 -Z > $CPT
htdraw $ARG $OUT2 $CPT $EPS
htconv $EPS $PNG2  rot
echo Figure completed. $PNG2
############################################################
# jobx (convert binary to figure)
############################################################
if [ "$JOBDRAWALL" = yes ]; then
  IDS=`awk '{print $1}' temp$SUF.txt`
  for ID in $IDS; do
    htmaskrplc $ARG temp$SUF temp$SUF eq $ID 1 temp2$SUF >> $LOG
    gmt makecpt -T0.5/1.5/1 > temp.cpt
    htdraw $ARG temp2$SUF temp.cpt temp.eps
    htconv temp.eps temp$SUF.$ID.png rot
  done
fi
echo Log: $LOG


