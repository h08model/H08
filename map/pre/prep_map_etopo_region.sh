#!/bin/sh
############################################################
#to
#by   nhanasaki, 2022/10/17
#
# original file: www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/bedrock/cell_registered/netcdf
############################################################
# Regional Settings (Edit here)
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
#
#L=14400
#XY="120 120"
#L2X=../../map/dat/l2x_l2y_/l2x.nk1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.nk1.txt
#LONLAT="139 141 36 38"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.nk1
###########################################################
# Global 1 min
###########################################################
LGL1=233280000
XYGL1="21600 10800"
L2XGL1=../../map/dat/l2x_l2y_/l2x.gl1.txt
L2YGL1=../../map/dat/l2x_l2y_/l2y.gl1.txt
LONLATGL1="-180 180 -90 90"
ARGGL1="$LGL1 $XYGL1 $L2XGL1 $L2YGL1 $LONLATGL1"
############################################################
# Japan 1 min
############################################################
LJP1=2138400
XYJP1="1620 1620"
L2XJP1=../../map/dat/l2x_l2y_/l2x.jp1.txt
L2YJP1=../../map/dat/l2x_l2y_/l2y.jp1.txt
LONLATJP1="122 149 24 46"
ARGJP1="$LJP1 $XYJP1 $L2XJP1 $L2YJP1 $LONLATJP1"
############################################################
# IN
############################################################
ORG=../org/ETOPO1/ETOPO1_Bed_c_gmt4.grd
############################################################
# OUT
############################################################
NC=../org/ETOPO1/ETOPO1_Bed_c_gmt4.nc
TMP=./temp.txt
DIROUT=../dat/elv_avg_
OUTGL1=${DIROUT}/ETOPO1__00000000.gl1
OUTHLF=${DIROUT}/ETOPO1__00000000.hlf
OUT=${DIROUT}/ETOPO1__00000000${SUF}
OUTJP1=${DIROUT}/ETOPO1__00000000.jp1
############################################################
# directory
############################################################
if [ !  -d $DIROUT ]; then
  mkdir -p $DIROUT
fi
############################################################
# grd --> nc (Edit here)
############################################################
gunzip ${ORG}.gz
#gmt grdconvert $ORG $NC  #gmt6
grdreformat $ORG $NC      #gmt4
############################################################
# nc --> gl1
############################################################
HEADER=`ncdump -h $NC | wc | awk '{print $1+2}'`
ncdump -vz $NC | sed -e '1,'"$HEADER"'d' | sed -e '$d' | sed -e 's/,/ /g' | sed -e 's/;/ /g' > $TMP
./prog_map_etopo $TMP $OUTGL1
############################################################
# gl1 --> ks1
############################################################
X_EDGE=`echo $LONLAT $LONLATGL1 | awk '{print(($1-$5)*60+1)}'`
Y_EDGE=`echo $LONLAT $LONLATGL1 | awk '{print(($8-$4)*60+1)}'`
#htextract $ARGGL1 $ARG $OUTGL1 $OUT 18541 3361
htextract $ARGGL1 $ARG $OUTGL1 $OUT $X_EDGE $Y_EDGE
############################################################
# gl1 --> jp1
############################################################
X_EDGEJP1=`echo $LONLATJP1 $LONLATGL1 | awk '{print(($1-$5)*60+1)}'`
Y_EDGEJP1=`echo $LONLATJP1 $LONLATGL1 | awk '{print(($8-$4)*60+1)}'`
#htextract $ARGGL1 $ARGJP1 $OUTGL1 $OUTJP1 18121 2641
htextract $ARGGL1 $ARGJP1 $OUTGL1 $OUTJP1 $X_EDGEJP1 $Y_EDGEJP1
############################################################
# gl1 --> hlf
############################################################
htuscale  30 30 720 360 $L2XGL1 $L2YGL1 $L2XHLF $L2YHLF $OUTGL1 $OUTHLF min