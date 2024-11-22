#!/bin/sh
############################################################
#to   prepare initial value of state variables and parameters
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
CANSUF=.binhlf      # suffix for canal (.bin+SUF)
MAP=.WFDEI

#L=11088
#XY="84 132"
#LONLAT="124 131 33 44"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#SUF=.ko5
#CANSUF=.binko5
#MAP=.SNU

#
L10=2592000                             # 10 times of L
#L10=110880
############################################################
# Input (Do not edit here basically)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
############################################################
# Output directory (Do not edit here basically)
############################################################
DIRDAMINI=../../dam/ini
DIRDAMDAT=../../dam/dat
############################################################
# Output (Do not edit here basically)
############################################################
DAMINI=${DIRDAMINI}/uniform.0.0${SUF}
DUMMY1=${DIRDAMDAT}/uniform.0.0${SUF}
DUMMY2=${DIRDAMDAT}/uniform.0.1${SUF}
DUMMY3=${DIRDAMDAT}/uniform.0.15${SUF}
DUMMY4=${DIRDAMDAT}/uniform.0.5${SUF}
DUMMY5=${DIRDAMDAT}/uniform.1.0${SUF}
CANDAT=${DIRDAMDAT}/uniform.0.0${CANSUF}
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
#
htcreate $L10 0.0 $CANDAT 


