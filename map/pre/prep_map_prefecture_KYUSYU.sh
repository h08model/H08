#!/bin/sh
############################################################
#to   prepare prefecture map
#by   hanasaki, 2021/11/18
############################################################
# Settings
############################################################
#
# Kyushu 1min 
#
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
#
# Japan 1min
#
LJP1=2138400
XYJP1="1620 1320"
L2XJP1=../../map/dat/l2x_l2y_/l2x.jp1.txt
L2YJP1=../../map/dat/l2x_l2y_/l2y.jp1.txt
LONLATJP1="122 149 24 46"
ARGJP1="$LJP1 $XYJP1 $L2XJP1 $L2YJP1 $LONLATJP1"
############################################################
# In
############################################################
MAPTXT=../../map/org/JAPAN/GIS/prefecture_Japan_1min.txt
CODJP1=../../map/org/JAPAN/GIS/prefecture_ID.txt
############################################################
# OUT
############################################################
MAPJP1=../../map/dat/nat_msk_/prefecture_1min.jp1
MAPKS1=../../map/dat/nat_msk_/prefecture_1min${SUF}
CODKS1=../../map/dat/nat_cod_/prefecture_ID.txt
############################################################
# Job
############################################################
if [ ! -d ../dat/nat_msk_ ]; then mkdir -p ../dat/nat_msk_; fi
if [ ! -d ../dat/nat_cod_ ]; then mkdir -p ../dat/nat_cod_; fi
#
X_EDGE=`echo $LONLAT $LONLATJP1 | awk '{print (($1-$5)*60+1)}'`
Y_EDGE=`echo $LONLAT $LONLATJP1 | awk '{print (($8-$4)*60+1)}'`
#
htformat $ARGJP1 asciiu binary $MAPTXT $MAPJP1
htextract $ARGJP1 $ARG $MAPJP1 $MAPKS1 $X_EDGE $Y_EDGE
cp $CODJP1 $CODKS1