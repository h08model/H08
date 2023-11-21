#!/bin/sh
############################################################
#to   prepare industrial water data
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
##########################
CPT=temp.cpt
#MSK=../dat/nat_msk_/cities_2015${SUFTI1}
MSK=../dat/nat_msk_/cities_A_2015${SUFTI1}   # A
#MSK=../dat/nat_msk_/cities_B_2015${SUFTI1}   # B
COD=../org/JAPAN/cities_id_2015.txt
WGT=../dat/pop_tot_/population${SUFTI1}
FACTOR=0.1                       #added
############################################################
# in 
############################################################
DAT=../org/JAPAN/METI____20150000.txt    # Excel
############################################################
# out
############################################################
LST1=../dat/wit_ind_/METIm___20150000.txt    # METI municipal/total
LST2=../dat/wit_ind_/METIms__20150000.txt    # METI municipal/sector-wise
#####
BIN1TI1=../dat/wit_ind_/METIm___20150000${SUFTI1}
BIN2TI1=../dat/wit_ind_/METIms__20150000${SUFTI1}
BIN3TI1=../dat/dem_ind_/METIm___20150000${SUFTI1}
BIN4TI1=../dat/dem_ind_/METIms__20150000${SUFTI1}
PNG1TI1=../dat/wit_ind_/METIm___20150000${TI1}.png
PNG2TI1=../dat/wit_ind_/METIms__20150000${TI1}.png
######
BIN1NK1=../dat/wit_ind_/METIm___20150000${SUFNK1}
BIN2NK1=../dat/wit_ind_/METIms__20150000${SUFNK1}
BIN3NK1=../dat/dem_ind_/METIm___20150000${SUFNK1}
BIN4NK1=../dat/dem_ind_/METIms__20150000${SUFNK1}
PNG1NK1=../dat/wit_ind_/METIm___20150000${NK1}.png
PNG2NK1=../dat/wit_ind_/METIms__20150000${NK1}.png
############################################################
# Job
############################################################
if [ ! -d ../dat/wit_ind_ ]; then mkdir -p ../dat/wit_ind_; fi
if [ ! -d ../dat/dem_ind_ ]; then mkdir -p ../dat/dem_ind_; fi   #added
#
prog_map_ind_KYUSYU $DAT $LST1 $LST2
#
htlist2bin $LTI1 $LST1 $MSK $COD $BIN1TI1 weight $WGT
htlist2bin $LTI1 $LST2 $MSK $COD $BIN2TI1 weight $WGT
############################################################
# Draw
############################################################
makecpt -T0/1000/100 -Z > $CPT
htdraw $ARGTI1 $BIN1TI1 $CPT temp.eps
htconv temp.eps $PNG1TI1 rothr
echo $PNG1TI1
######
htdraw $ARGTI1 $BIN2TI1 $CPT temp.eps
htconv temp.eps $PNG2TI1 rothr
echo $PNG2TI1
######
htmath $LTI1 mul $BIN1TI1 $FACTOR $BIN3TI1  #added
htmath $LTI1 mul $BIN2TI1 $FACTOR $BIN4TI1  #added
#############################################################
# .ti1 --> .nk1
#############################################################
X_EDGE=`echo $LONLATNK1 $LONLATTI1 | awk '{print(($1-$5))*60+1}'`
Y_EDGE=`echo $LONLATNK1 $LONLATTI1 | awk '{print(($8-$4))*60+1}'`
htextract $ARGTI1 $ARGNK1 $BIN1TI1 $BIN1NK1 $X_EDGE $Y_EDGE
htextract $ARGTI1 $ARGNK1 $BIN2TI1 $BIN2NK1 $X_EDGE $Y_EDGE
htextract $ARGTI1 $ARGNK1 $BIN3TI1 $BIN3NK1 $X_EDGE $Y_EDGE
htextract $ARGTI1 $ARGNK1 $BIN4TI1 $BIN4NK1 $X_EDGE $Y_EDGE
####
htdraw $ARGNK1 $BIN1NK1 $CPT temp.eps
htconv temp.eps $PNG1NK1 rothr
display $PNG1NK1 &
#
htdraw $ARGNK1 $BIN2NK1 $CPT temp.eps
htconv temp.eps $PNG2NK1 rothr
display $PNG2NK1 &
