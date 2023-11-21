#!/bin/sh
############################################################
#to   prepare domestic water withdrawal
#by   hanasaki
############################################################
# settings
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
#
CPT=temp.cpt
#MSK=../dat/nat_msk_/prefectures.ks1
MSK=../dat/nat_msk_/prefecture_1min${SUF}
#COD=../dat/nat_cod_/prefectures.txt
COD=../dat/nat_cod_/prefecture_ID.txt
WGT=../dat/pop_tot_/population${SUF}
FACTOR=0.15  # added
############################################################
# in
############################################################
#LST=../org/KYUSYU/JWRC____20160000.txt
LST=../org/JAPAN/JWRC____20160000.txt
############################################################
# out
############################################################
BIN=../dat/wit_dom_/JWRC____20160000${SUF}
BIN2=../dat/dem_dom_/JWRC____20160000${SUF}  #added
PNG=../dat/wit_dom_/JWRC____20160000.png
############################################################
# job
############################################################
if [ ! -d ../dat/wit_dom_ ]; then mkdir -p ../dat/wit_dom_; fi
if [ ! -d ../dat/dem_dom_ ]; then mkdir -p ../dat/dem_dom_; fi # added
#
htlist2bin $L $LST $MSK $COD $BIN weight $WGT > /dev/null
#htlist2bin $L $LST $MSK $COD $BIN conserve
htmath $L div $BIN 31.536 $BIN 
makecpt -T0/1000/100 -Z > $CPT
htdraw $ARG $BIN $CPT temp.eps
htconv temp.eps $PNG rothr
echo $PNG

htmath $L mul $BIN $FACTOR $BIN2  # added