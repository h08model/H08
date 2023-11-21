#!/bin/sh
############################################################
#to   calculate environmental flow
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Basic settings (Edit here if you change settings)
############################################################
PRJ=WFDE
RUN=LR__
#PRJ=AK10
#RUN=LR__
YEARMIN=0000
YEARMAX=0000
LDBG=27641
#LDBG=5734
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
MAP=.WFDEI

#L=11088           # for Korean peninsula 2018
#XY="84 132"
#LONLAT="124 131 33 44"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#SUF=.ko5
#MAP=.SNU

#L=32400            # for Kyusyu 2022
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#SUF=.ks1
#MAP=.kyusyu

############################################################
# Input (Do not edit here basically)
############################################################
LNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}
FLWDIR=../../map/dat/flw_dir_/flwdir${MAP}${SUF}
RIVARA=../../map/out/riv_ara_/rivara${MAP}${SUF}
############################################################
# Input (Do not edit here basically)
############################################################
DIRRIVOUT=../../riv/out/riv_out_
RIVOUT=${DIRRIVOUT}/${PRJ}${RUN}${SUF}MO
############################################################
# Output directory (Do not edit here basically)
############################################################
DIRENVTYP=../../riv/out/env_typ_
DIRENVFLG=../../riv/out/env_flg_
DIRENVOUT=../../riv/out/env_out_
############################################################
# Output (Do not edit here basically)
############################################################
ENVTYP=${DIRENVTYP}/${PRJ}${RUN}${SUF}YR
ENVFLG=${DIRENVFLG}/${PRJ}${RUN}${SUF}MO
ENVOUT=${DIRENVOUT}/${PRJ}${RUN}${SUF}MO
ENVOUTYEAR=${DIRENVOUT}/${PRJ}${RUN}${SUF}YR
############################################################
# Job (Prepare output directory)
############################################################
if [ ! -d $DIRENVTYP ]; then mkdir $DIRENVTYP; fi
if [ ! -d $DIRENVOUT ]; then mkdir $DIRENVOUT; fi
if [ ! -d $DIRENVFLG ]; then mkdir $DIRENVFLG; fi
############################################################
# Job
############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  prog_envout $L $YEAR $LDBG $RIVARA $RIVOUT $ENVTYP $ENVOUT $ENVFLG
  YEAR=`expr $YEAR + 1`
done

httime $L $ENVOUT     $YEARMIN $YEARMAX $ENVOUTYEAR
htmean $L $ENVOUT     $YEARMIN $YEARMAX 0000 
htmean $L $ENVOUTYEAR $YEARMIN $YEARMAX 0000 

htmask $L $XY $L2X $L2Y $LONLAT ${DIRRIVOUT}/${PRJ}${RUN}${YEARMIN}0000${SUF} $FLWDIR eq 9 temp${SUF}
htmask $L $XY $L2X $L2Y $LONLAT ${DIRENVOUT}/${PRJ}${RUN}${YEARMIN}0000${SUF} $FLWDIR eq 9 temp${SUF}
############################################################
# Job (Draw)
############################################################
CPT=../../cpt/envtyp.cpt
EPS=temp.envtyp.eps
PNG=temp.envtyp.png

htdraw $L $XY $L2X $L2Y $LONLAT ${DIRENVTYP}/$PRJ${RUN}${YEARMIN}0000${SUF} $CPT $EPS
htconv $EPS $PNG rot
echo $PNG 

CPT=../../cpt/Diskgs.cpt
EPS=temp.envout.eps
PNG=temp.envout.png

htdraw $L $XY $L2X $L2Y $LONLAT ${DIRENVOUT}/$PRJ${RUN}${YEARMIN}0000${SUF} $CPT $EPS
htconv $EPS $PNG rot
echo $PNG 
