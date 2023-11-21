#!/bin/sh
############################################################
#to   prepare industrial water data
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
MSK=../dat/nat_msk_/cities_2015${SUF}
#MSK=../dat/nat_msk_/cities_A_2015${SUF}   # A
#MSK=../dat/nat_msk_/cities_B_2015${SUF}   # B
COD=../org/JAPAN/cities_id_2015.txt
WGT=../dat/pop_tot_/population${SUF}
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
#
BIN1=../dat/wit_ind_/METIm___20150000${SUF}
BIN2=../dat/wit_ind_/METIms__20150000${SUF}
#
BIN3=../dat/dem_ind_/METIm___20150000${SUF}
BIN4=../dat/dem_ind_/METIms__20150000${SUF}
#
PNG1=../dat/wit_ind_/METIm___20150000.png
PNG2=../dat/wit_ind_/METIms__20150000.png
############################################################
# Job
############################################################
if [ ! -d ../dat/wit_ind_ ]; then mkdir -p ../dat/wit_ind_; fi
if [ ! -d ../dat/dem_ind_ ]; then mkdir -p ../dat/dem_ind_; fi   #added
#
prog_map_ind_KYUSYU $DAT $LST1 $LST2
#
htlist2bin $L $LST1 $MSK $COD $BIN1 weight $WGT
htlist2bin $L $LST2 $MSK $COD $BIN2 weight $WGT
############################################################
# Draw
############################################################
makecpt -T0/1000/100 -Z > $CPT
htdraw $ARG $BIN1 $CPT temp.eps
htconv temp.eps $PNG1 rothr
echo $PNG1

htdraw $ARG $BIN2 $CPT temp.eps
htconv temp.eps $PNG2 rothr
echo $PNG2

htmath $L mul $BIN1 $FACTOR $BIN3  #added
htmath $L mul $BIN2 $FACTOR $BIN4  #added