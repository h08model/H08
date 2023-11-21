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
L=$LHLF
ARG=$ARGHLF
MAP=.WFDEI
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
MSK=../../map/dat/nat_msk_/C05_____20000000${MAP}.hlf
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
AGRRATBIN=${DIROUTAGR}/D12${MAP}.hlf
INDRATBIN=${DIROUTIND}/D12${MAP}.hlf
DOMRATBIN=${DIROUTDOM}/D12${MAP}.hlf
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
htlist2bin $L $AGRRATASC $MSK $COD $AGRRATBIN perarea >> $LOG
htlist2bin $L $INDRATASC $MSK $COD $INDRATBIN perarea >> $LOG
htlist2bin $L $DOMRATASC $MSK $COD $DOMRATBIN perarea >> $LOG
#
htdraw $ARG $AGRRATBIN $CPT $EPS
htconv $EPS $AGRRATFIG rot
htdraw $ARG $INDRATBIN $CPT $EPS
htconv $EPS $INDRATFIG rot
htdraw $ARG $DOMRATBIN $CPT $EPS
htconv $EPS $DOMRATFIG rot
echo Fig: $DOMRATFIG
echo Log: $LOG



