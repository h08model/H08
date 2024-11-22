#!/bin/sh
############################################################
#to   prepare initial value of state variables and parameters
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
SUF=.ks1
CANSUF=.binks1
MAP=.kyusyu
#
L10=324000                             # 10 times of L
############################################################
# Input (Do not edit here basically)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
PLTRIC=../../crp/out/plt_ric_/AK10__C_00000000${SUF}
############################################################
# Output directory (Do not edit here basically)
############################################################
DIRDAMINI=../../dam/ini
DIRDAMDAT=../../dam/dat
DIRCRPOUT=../../crp/out
############################################################
# Output (Do not edit here basically)
############################################################
DAMINI=${DIRDAMINI}/uniform.0.0${SUF}
DUMMY1=${DIRDAMDAT}/uniform.0.0${SUF}
DUMMY2=${DIRDAMDAT}/uniform.0.1${SUF}
DUMMY3=${DIRDAMDAT}/uniform.0.15${SUF}
DUMMY4=${DIRDAMDAT}/uniform.0.5${SUF}
DUMMY5=${DIRDAMDAT}/uniform.1.0${SUF}
DUMMY6=${DIRDAMDAT}/uniform.0.45${SUF}
DUMMY7=${DIRCRPOUT}/uniform.0.0${SUF}
DUMMY8=${DIRCRPOUT}/uniform.8.0${SUF}
DUMMY9=${DIRCRPOUT}/uniform.12.0${SUF}
CANDAT=${DIRDAMDAT}/uniform.0.0${CANSUF}
RICDAT=../../crp/out/plt_ric_/AK10__C_00000000.30${SUF}
############################################################
# Job (prepare directory)
############################################################
if [ ! -d $DIRDAMINI ]; then mkdir -p $DIRDAMINI; fi
if [ ! -d $DIRDAMDAT ]; then mkdir -p $DIRDAMDAT; fi
############################################################
# Job (generate files)
############################################################
htcreate $L 0.0 $DAMINI 
htmask   $L $XY $L2X $L2Y $LONLAT $DAMINI $LNDMSK eq 1 $DAMINI
#
htcreate $L 0.0 $DUMMY1
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY1 $LNDMSK eq 1 $DUMMY1
htcreate $L 0.1 $DUMMY2
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY2 $LNDMSK eq 1 $DUMMY2
htcreate $L 0.15 $DUMMY3
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY3 $LNDMSK eq 1 $DUMMY3
htcreate $L 0.5 $DUMMY4
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY4 $LNDMSK eq 1 $DUMMY4
htcreate $L 1.0 $DUMMY5
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY5 $LNDMSK eq 1 $DUMMY5
htcreate $L 0.45 $DUMMY6
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY6 $LNDMSK eq 1 $DUMMY6
htcreate $L 0.0 $DUMMY7
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY7 $LNDMSK eq 1 $DUMMY7
htcreate $L 8.0 $DUMMY8
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY8 $LNDMSK eq 1 $DUMMY8
htcreate $L 12.0 $DUMMY9
htmask   $L $XY $L2X $L2Y $LONLAT $DUMMY9 $LNDMSK eq 1 $DUMMY9
#
htcreate $L10 0.0 $CANDAT 
#
htmath $L add $PLTRIC 30 $RICDAT 


