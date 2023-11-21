#!/bin/sh
############################################################
#
#
############################################################
#  Settings
############################################################
LK15=518400
XYK15="720 720"
L2XK15=../dat/l2x_l2y_/l2x.k15.txt
L2YK15=../dat/l2x_l2y_/l2y.k15.txt
LONLATK15="129 132 31 34"
ARGK15="$LK15 $XYK15 $L2XK15 $L2YK15 $LONLATK15"
SUFK15=.k15
MAPK15=.kyusyu
#
LKS1=32400
XYKS1="180 180"
L2XKS1=../dat/l2x_l2y_/l2x.ks1.txt
L2YKS1=../dat/l2x_l2y_/l2y.ks1.txt
LONLATKS1="129 132 31 34"
ARGKS1="$LKS1 $XYKS1 $L2XKS1 $L2YKS1 $LONLATKS1"
SUFKS1=.ks1
#
#PRFCMIN=1                # all area in JAPAN
#PRFCMAX=47               # all area in JAPAN
#LONLAT="122 149 24 46"   # all area in JAPAN
#
PRFCMIN=40                # regional settings
PRFCMAX=46                # regional settings
LONLAT=$LONLATK15         # regional settings
###########################################################
#INT=temp.1995.all.csv       # all area in JAPAN
INT=temp.1995${MAPK15}.csv   # regional settings
K15=temp${SUFK15}
CPT=temp.cpt
EPS=temp.eps
XYZ=temp.xyz
############################################################
# In
############################################################
IN1='../org/JAPAN/NIAES/1995B.csv'
############################################################
# Jobs
############################################################
#
# from "mesh code" (IN1) to lon-lat (INT)
#
prog_map_NIAES_KYUSYU $IN1 $INT $PRFCMIN $PRFCMAX $LONLAT
#
# loop
#
#COL=3
#COL=5
#COLMAX=7
COL=3
COLMAX=5
while [ $COL -le $COLMAX ]; do 
  awk '{print $1,$2,$'"$COL"'}' $INT > $XYZ
echo ---- $COL ----
  htformat $ARGK15 ascii3 binary $XYZ $K15
#  if   [ $COL = 3 ]; then
#    DIR=../dat/cities__; OPT=frq 
#    if [ $RGN = kyusyu ]; then
#      makecpt -T40000/50000/1000 -Z > $CPT
#    else
#      makecpt -T0/50000/10000 -Z  > $CPT
#    fi
#  elif [ $COL = 4 ]; then
#    DIR=../dat/prfc____; OPT=frq 
#    if [ $RGN = kyusyu ]; then
#      makecpt -T40/47/1 -Z > $CPT
#    else
#      makecpt -T1/47/1 -Z  > $CPT
#    fi
#  elif [ $COL = 5 ]; then
  if [ $COL = 3 ]; then
    DIR=../dat/paddy___; OPT=sum 
    gmt makecpt -T0/4000000/500000 -Z > $CPT
#  elif [ $COL = 6 ]; then
  elif [ $COL = 4 ]; then
    DIR=../dat/upland__; OPT=sum 
    gmt makecpt -T0/4000000/500000 -Z > $CPT
#  elif [ $COL = 7 ]; then
  elif [ $COL = 5 ]; then
    DIR=../dat/barwhe__; OPT=sum 
    gmt makecpt -T0/4000000/500000 -Z > $CPT
  fi
  OUT=${DIR}/NIAES___19950000${SUFKS1}
  PNG=${DIR}/NIAES___19950000${SUFKS1}.png
  if [ !  -d $DIR ]; then
    mkdir -p $DIR
  fi 
  htuscale 4 4 $XYKS1 $L2XK15 $L2YK15 $L2XKS1 $L2YKS1 $K15 $OUT $OPT
  htdraw $ARGKS1 $OUT $CPT $EPS
  htconv $EPS $PNG rot
  echo $PNG
  COL=`expr $COL + 1`
done
