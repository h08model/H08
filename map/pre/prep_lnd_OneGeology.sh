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
LNDMSK=
#
L="9331200"
XY="4320 2160"
L2X=${DIRH08}/map/dat/l2x_l2y_/l2x.gl5.txt
L2Y=${DIRH08}/map/dat/l2x_l2y_/l2y.gl5.txt
LONLAT="-180 180 -90 90"
SUF=.gl5
#
# For global 0.5 degree
#
IN=../org/OneGeology/GSC.hlf.txt
LNDMSK=../../map/dat/lnd_msk_/lndmsk.WFDEI.hlf
#
L=259200
XY="720 360"
L2X=${DIRH08}/map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=${DIRH08}/map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
#
JOBDRAWALL=no    # this is to check the original data
############################################################
# Input/Output
############################################################
# in
LST=../org/OneGeology/lst_3.txt
# out
DIROUT=../../map/dat/geo_cls_
OUT1=$DIROUT/OneGeo__00000000.original$SUF
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
ARG="$L $XY $L2X $L2Y $LONLAT"

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
htformat $ARG asciiu binary temp.txt $OUT1
############################################################
# job2 (convert binary into list)
############################################################
if [ -f $COD ]; then rm $COD; fi
NUM=1
while [ $NUM -le 255 ]; do
  echo $NUM $NUM >> $COD
  NUM=`expr $NUM + 1`
done
htbin2list $L temp$SUF $OUT1 $COD temp$SUF.txt pergrid > $LOG
############################################################
# job3 (draw)
############################################################
IDMIN=`awk '{print $1}' temp$SUF.txt | head -1`
IDMAX=`awk '{print $1}' temp$SUF.txt | tail -1`
gmt makecpt -T$IDMIN/$IDMAX/1 -Z > $CPT
htdraw $ARG $OUT1 $CPT $EPS
htconv $EPS $PNG1 rot
echo Figure completed. $PNG1
############################################################
# job4 (classify)
############################################################
htlist2bin $L $LST $OUT1 $COD $OUT2 perarea
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


