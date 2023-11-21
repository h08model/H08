#!/bin/sh
############################################################
#to   draw stress
#by   2020/06/16 hanasaki
############################################################
# Setting
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
MAP=.kyusyu
#
#L=14400                    # for Naka and Kuji river 
#XY="120 120"
#L2X=../../map/dat/l2x_l2y_/l2x.nk1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.nk1.txt
#LONLAT="139 141 36 38"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.nk1
#MAP=.NakaKuji
#
YEARMIN=2014
YEARMAX=2014
############################################################
DIROUT=../../lnd/out/wat_idx_
DIRFIG=../../lnd/fig/wat_idx_
#
#PRJRUN=AK10N_C_
#PRJRUN=AK10N_C1
#PRJRUN=AK10N_C2
PRJRUN=AK10LECD
#PRJRUN=AK10LEC2
#PRJRUN=AK10NEmD       # Simulation
#PRJRUN=AK105cm_
#PRJRUN=AK105mm_
#PRJRUN=AK105wm_
#
PRJRUNNAT=AK10LR__
#PRJRUNNAT=AK10DMLu     # Precitine simulation
YEAR=0000
#
CPTWTA=${DIRFIG}/wta.cpt
CPTCAD=${DIRFIG}/cad.cpt
OPTWITMSK=yes; MIN=30     # unit:kg/s
#OPTWITMSK=no
OPTMEAN=yes               # yes 
############################################################
# In
############################################################
WITALL=../../lnd/out/SupAIDTT/${PRJRUN}${YEAR}0000${SUF}
WITREN=../../lnd/out/SupAIDTR/${PRJRUN}${YEAR}0000${SUF}
ROFNAT=../../riv/out/riv_out_/${PRJRUNNAT}${YEAR}0000${SUF}
MSK=../../map/dat/flw_dir_/flwdir${MAP}${SUF}
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
############################################################
# Temporary
############################################################
TMP=temp${SUF}
EPS=temp.eps
############################################################
# Out
############################################################
   WTA=${DIROUT}/wta.${PRJRUN}${SUF}
PNGWTA=${DIRFIG}/wta.${PRJRUN}.png
   CAD=${DIROUT}/cad.${PRJRUN}.${OPTWITMSK}${SUF}
PNGCAD=${DIRFIG}/cad.${PRJRUN}.${OPTWITMSK}.png
#
if [ !  -d $DIROUT ]; then
  mkdir -p $DIROUT
fi
if [ !  -d $DIRFIG ]; then
  mkdir -p $DIRFIG
fi
############################################################
# Mean
############################################################
if [ $OPTMEAN = yes ]; then
  htmean $L ../../lnd/out/SupAIDTT/${PRJRUN}${SUF}YR $YEARMIN $YEARMAX 0000
  htmean $L ../../lnd/out/SupAIDTR/${PRJRUN}${SUF}YR $YEARMIN $YEARMAX 0000
fi
############################################################
# WTA
############################################################
echo Total withdrawal - all sources
htstat $ARG sum $WITALL | awk '{print $1*0.031536/1000}'
echo Total withdrawal - renewable sources
htstat $ARG sum $WITREN | awk '{print $1*0.031536/1000}'
echo Total natural runoff
htmask $ARG $ROFNAT $MSK eq 9 $TMP
htstat $ARG sum $TMP | awk '{print $1*0.031536/1000}'
############################################################
# CPT
############################################################
makecpt -T0/1/0.1 -Z > $CPTWTA
makecpt -T0/1.1/0.1 -Z > $CPTCAD
############################################################
# WTA
############################################################
htmath $L div $WITALL $ROFNAT $WTA
htdraw $ARG $WTA $CPTWTA $EPS 
htconv $EPS $PNGWTA rot
############################################################
# CAD
############################################################
htmath $L div $WITREN $WITALL $CAD
htmaskrplc $ARG $CAD $LNDMSK eq 0 1.0E20 $CAD

if [ $OPTWITMSK = yes ]; then
  htmaskrplc $ARG $CAD $WITALL lt $MIN 1.0 $CAD
fi
htdraw $ARG $CAD $CPTCAD $EPS 
htconv $EPS $PNGCAD rot
echo $PNGCAD
