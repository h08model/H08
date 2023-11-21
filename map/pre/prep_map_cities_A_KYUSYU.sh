#!/bin/sh
#############################################
# Settings
#############################################
#
# KYUSYU 1 min
#
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
#
# JAPAN 1 min
#
LJP1=2138400
XYJP1="1620 1620"
L2XJP1=../../map/dat/l2x_l2y_/l2x.jp1.txt
L2YJP1=../../map/dat/l2x_l2y_/l2y.jp1.txt
LONLATJP1="122 149 24 46"
ARGJP1="$LJP1 $XYJP1 $L2XJP1 $L2YJP1 $LONLATJP1"
#############################################
# IN / OUT
#############################################
TXT=../org/JAPAN/2015_shichouson_1min.txt
MAPJP1=../dat/nat_msk_/cities_A_2015.jp1
MAPKS1=../dat/nat_msk_/cities_A_2015${SUF}
#
CPT=temp.cpt
EPS=temp.eps
PNG=../dat/nat_msk_/cities_A_2015${SUF}.png
#############################################
# JOB
#############################################
X_EDGE=`echo $LONLAT $LONLATJP1 | awk '{print (($1-$5)*60+1)}'`
Y_EDGE=`echo $LONLAT $LONLATJP1 | awk '{print (($8-$4)*60+1)}'`
#
htformat $ARGJP1 asciiu binary $TXT $MAPJP1
htextract $ARGJP1 $ARG $MAPJP1 $MAPKS1 $X_EDGE $Y_EDGE
#
gmt makecpt -T40000/47000/1000 -Z > $CPT # KYUSYU
#makecpt -T46100/46500/100 -Z > $CPT # KAGOSHIMA
htdraw $ARG $MAPKS1 $CPT $EPS
htconv $EPS $PNG rothr
