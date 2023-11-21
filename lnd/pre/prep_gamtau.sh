#!/bin/sh
############################################################
#to   prepare gamma and tau
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Edit here (in)
############################################################
NL=259200
NX=720
NY=360
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf

# Regional setting (.ko5)
#NL=11088
#NX=84
#NY=132
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#LONLAT="124 131 33 44"
#SUF=.ko5

# Regional setting (.ks1)
#NL=32400
#NX=180
#NY=180
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#SUF=.ks1

############################################################
# Edit here (in)
############################################################
PRJ=wfde
RUN=____

#PRJ=AMeD
#RUN=AS1_
KOPPEN=../../met/out/Koppen__/${PRJ}${RUN}00000000${SUF}
############################################################
# Edit here (out)
############################################################
DIRTAU=../../lnd/dat/tau_____
DIRGAM=../../lnd/dat/gamma___
if [ ! -d $DIRTAU ]; then mkdir -p $DIRTAU; fi
if [ ! -d $DIRGAM ]; then mkdir -p $DIRGAM; fi
   TAU=$DIRTAU/${PRJ}${RUN}00000000${SUF}
 GAMMA=$DIRGAM/${PRJ}${RUN}00000000${SUF}
############################################################
# Assumptions (See Hanasaki et al., 2008)
# tau=100, gamma=2.0 for tropical forests (Af)
# tau=300, gamma=2.0 for tropical monsoon (Am), savanna (Aw), and dry (B)
# tau=200, gamma=2.0 for temperate (C) and continental [warmer] climates
# tau=50,  gamma=1.0 for continental [cooler] and polar (E) climates
# --> modified to 100 and 2.0 in Hanasaki et al. (2017)
############################################################
htcreate $NL 0 $TAU
htcreate $NL 0 $GAMMA
#
for JOB in 1 2 3 4; do
  if   [ $JOB = 1 ]; then
    THR=11;  VALTAU=100.0; VALGAMMA=2.0
  elif [ $JOB = 2 ]; then
    THR=12; VALTAU=300.0; VALGAMMA=2.0
  elif [ $JOB = 3 ]; then
    THR=31; VALTAU=200.0; VALGAMMA=2.0
  elif [ $JOB = 4 ]; then
#    THR=43; VALTAU=50.0;  VALGAMMA=1.0
    THR=43; VALTAU=100.0;  VALGAMMA=2.0
  fi
  htmaskrplc $NL $NX $NY $L2X $L2Y $LONLAT $TAU   $KOPPEN ge $THR $VALTAU   $TAU
  htmaskrplc $NL $NX $NY $L2X $L2Y $LONLAT $GAMMA $KOPPEN ge $THR $VALGAMMA $GAMMA
done
