#!/bin/sh
############################################################
#to   prepare groundwater fraction of water withdrawal
#by   hanasaki, 2021/11/18
############################################################
# Settings
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
############################################################
# In
############################################################
#INDTXT=../../map/org/KYUSYU/frc_gwi_MLIT.txt
INDTXT=../../map/org/JAPAN/frc_gwi_MLIT____20160000.txt
#DOMTXT=../../map/org/KYUSYU/frc_gwd_MLIT.txt
DOMTXT=../../map/org/JAPAN/frc_gwd_MLIT____20180000.txt
############################################################
# Out
############################################################
INDBIN=../../map/dat/frc_gwi_/MLIT____${SUF}
DOMBIN=../../map/dat/frc_gwd_/MLIT____${SUF}
############################################################
# Geographical
############################################################
MSK=../../map/dat/nat_msk_/prefecture_1min${SUF}
COD=../../map/dat/nat_cod_/prefecture_ID.txt
############################################################
CPT=temp.cpt
EPS=temp.eps
INDPNG=../../map/dat/frc_gwi_/MLIT____${SUF}.png
DOMPNG=../../map/dat/frc_gwd_/MLIT____${SUF}.png
############################################################
# JOB
############################################################
if [ ! -d ../dat/frc_gwi_ ]; then mkdir -p ../dat/frc_gwi_; fi
if [ ! -d ../dat/frc_gwd_ ]; then mkdir -p ../dat/frc_gwd_; fi
#
htlist2bin $LKS1 $INDTXT $MSK $COD $INDBIN perarea
htlist2bin $LKS1 $DOMTXT $MSK $COD $DOMBIN perarea
#
makecpt -T0/1/0.1 -Z > $CPT
htdraw $ARG $INDBIN $CPT $EPS
htconv $EPS $INDPNG rothr
echo $INDPNG
htdraw $ARG $DOMBIN $CPT $EPS
htconv $EPS $DOMPNG rothr
echo $DOMPNG