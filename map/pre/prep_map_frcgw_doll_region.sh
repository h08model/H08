#!/bin/sh
############################################################
#to   estimate the fraction of groundwater use
#by   2018/09/13,hanasaki
#
#     method inspired by Doell et al (2014, WRR)
#
############################################################
# geography
############################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
MAP=.SNU
SUF=.ko5

MAPHLF=.WFDEI
############################################################
# input
############################################################
 AGRGW=../../map/dat/SupAgrGT/IGRAC___19950000.txt # in km3/yr
 INDGW=../../map/dat/SupIndGT/IGRAC___19950000.txt # in km3/yr
 DOMGW=../../map/dat/SupDomGT/IGRAC___19950000.txt # in km3/yr
AGRTOT=../../map/dat/wit_agr_/AQUASTAT20000000.lst # in km3/yr
INDTOT=../../map/dat/wit_ind_/AQUASTAT20000000.lst
DOMTOT=../../map/dat/wit_dom_/AQUASTAT20000000.lst
#
MSK=../../map/dat/nat_msk_/C05_____20000000${MAPHLF}.hlf
COD=../../map/dat/nat_cod_/C05_____20000000.txt
RGN=../../map/org/IGRAC/FAO_____00000000.txt
############################################################
# output
############################################################
DIROUTAGR=../../map/dat/frc_gwa_
DIROUTIND=../../map/dat/frc_gwi_
DIROUTDOM=../../map/dat/frc_gwd_
AGRRATASC=${DIROUTAGR}/D12.txt
INDRATASC=${DIROUTIND}/D12.txt
DOMRATASC=${DIROUTDOM}/D12.txt
AGRRATBIN=${DIROUTAGR}/D12${MAPHLF}.hlf
INDRATBIN=${DIROUTIND}/D12${MAPHLF}.hlf
DOMRATBIN=${DIROUTDOM}/D12${MAPHLF}.hlf
#
AGRRATBIN2=${DIROUTAGR}/D12${MAP}${SUF}
INDRATBIN2=${DIROUTIND}/D12${MAP}${SUF}
DOMRATBIN2=${DIROUTDOM}/D12${MAP}${SUF}
#
AGRRATFIG=${DIROUTAGR}/D12${MAP}.png
INDRATFIG=${DIROUTIND}/D12${MAP}.png
DOMRATFIG=${DIROUTDOM}/D12${MAP}.png
#
LOG=temp.log
############################################################
# macro
############################################################
EPS=temp.eps
CPT=temp.cpt
#
RECDBG=231
############################################################
# job
############################################################
if [  ! -d $DIROUTAGR ]; then
  mkdir -p $DIROUTAGR
fi
if [  ! -d $DIROUTIND ]; then
  mkdir -p $DIROUTIND
fi
if [  ! -d $DIROUTDOM ]; then
  mkdir -p $DIROUTDOM
fi
prog_frcgw $COD $RGN $AGRGW $INDGW $DOMGW $AGRTOT $INDTOT $DOMTOT $AGRRATASC $INDRATASC $DOMRATASC $RECDBG > $LOG
############################################################
# post process
############################################################
htlist2bin $LHLF $AGRRATASC $MSK $COD $AGRRATBIN perarea >> $LOG
htlinear $ARGHLF $ARG $AGRRATBIN $AGRRATBIN2 >> $LOG 
htlist2bin $LHLF $INDRATASC $MSK $COD $INDRATBIN perarea >> $LOG
htlinear $ARGHLF $ARG $INDRATBIN $INDRATBIN2 >> $LOG 
htlist2bin $LHLF $DOMRATASC $MSK $COD $DOMRATBIN perarea >> $LOG
htlinear $ARGHLF $ARG $DOMRATBIN $DOMRATBIN2 
#

htdraw $ARG $AGRRATBIN2 $CPT $EPS
htconv $EPS $AGRRATFIG rot
htdraw $ARG $INDRATBIN2 $CPT $EPS
htconv $EPS $INDRATFIG rot
htdraw $ARG $DOMRATBIN2 $CPT $EPS
htconv $EPS $DOMRATFIG rot
echo Fig: $DOMRATFIG
echo Log: $LOG



