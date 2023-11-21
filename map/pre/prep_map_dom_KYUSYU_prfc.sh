#!/bin/sh
############################################################
#to   prepare domestic water withdrawal
#by   hanasaki
############################################################
# settings
############################################################
LNK1=14400
XYNK1="120 120"
L2XNK1=../../map/dat/l2x_l2y_/l2x.nk1.txt
L2YNK1=../../map/dat/l2x_l2y_/l2y.nk1.txt
LONLATNK1="139 141 36 38"
ARGNK1="$LNK1 $XYNK1 $L2XNK1 $L2YNK1 $LONLATNK1"
SUFNK1=.nk1
#
LTI1=57600
XYTI1="240 240"
L2XTI1=../../map/dat/l2x_l2y_/l2x.ti1.txt
L2YTI1=../../map/dat/l2x_l2y_/l2y.ti1.txt
LONLATTI1="138 142 35 39"
ARGTI1="$LTI1 $XYTI1 $L2XTI1 $L2YTI1 $LONLATTI1"
SUFTI1=.ti1
#
CPT=temp.cpt
#MSK=../dat/nat_msk_/prefectures.ks1
MSK=../dat/nat_msk_/prefecture_1min${SUFTI1}
#COD=../dat/nat_cod_/prefectures.txt
COD=../dat/nat_cod_/prefecture_ID.txt
WGT=../dat/pop_tot_/population${SUFTI1}
FACTOR=0.15  # added
############################################################
# in
############################################################
#LST=../org/KYUSYU/JWRC____20160000.txt
LST=../org/JAPAN/JWRC____20160000.txt
############################################################
# out
############################################################
BINTI1=../dat/wit_dom_/JWRC____20160000${SUFTI1}
BIN2TI1=../dat/dem_dom_/JWRC____20160000${SUFTI1}  #added
BINNK1=../dat/wit_dom_/JWRC____20160000${SUFNK1}
BIN2NK1=../dat/dem_dom_/JWRC____20160000${SUFNK1}  #added
PNGTI1=../dat/wit_dom_/JWRC____20160000${SUFTI1}.png
PNGNK1=../dat/wit_dom_/JWRC____20160000${SUFNK1}.png
############################################################
# job
############################################################
if [ ! -d ../dat/wit_dom_ ]; then mkdir -p ../dat/wit_dom_; fi
if [ ! -d ../dat/dem_dom_ ]; then mkdir -p ../dat/dem_dom_; fi # added
#
htlist2bin $LTI1 $LST $MSK $COD $BINTI1 weight $WGT > /dev/null
#htlist2bin $L $LST $MSK $COD $BIN conserve
htmath $LTI1 div $BINTI1 31.536 $BINTI1 
makecpt -T0/1000/100 -Z > $CPT
htdraw $ARGTI1 $BINTI1 $CPT temp.eps
htconv temp.eps $PNGTI1 rothr
echo $PNGTI1
#display $PNGTI1 &
htmath $LTI1 mul $BINTI1 $FACTOR $BIN2TI1  # added
#################################################
X_EDGE=`echo $LONLATNK1 $LONLATTI1 | awk '{print(($1-$5)*60+1)}'`
Y_EDGE=`echo $LONLATNK1 $LONLATTI1 | awk '{print(($8-$4)*60+1)}'`
htextract $ARGTI1 $ARGNK1 $BINTI1 $BINNK1 $X_EDGE $Y_EDGE
htextract $ARGTI1 $ARGNK1 $BIN2TI1 $BIN2NK1 $X_EDGE $Y_EDGE
htdraw $ARGNK1 $BINNK1 $CPT temp.eps
htconv temp.eps $PNGNK1 rothr
#display $PNGNK1 &