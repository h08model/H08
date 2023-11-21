#!/bin/sh
############################################################
#to   draw agricultural withdrawal
#by   2010/06/05, hanasaki: H08ver1.0
############################################################
# in
############################################################
L=64800
SUF=.one
PRJ=GSW2
RUN=L_C_
YEAR=1990
############################################################
# in
############################################################
DIROBS=../../map/dat/wit_agr_

DIRSIM=../../lnd/out/DemAgr__
OBS=${DIROBS}/AQUASTAT20000000.lst
SIM=${DIRSIM}/${PRJ}${RUN}${YEAR}0000${SUF}
NATMSK=../../map/dat/nat_msk_/C05_____20000000${SUF}
NATLST=../../map/dat/nat_cod_/C05_____20000000.txt
IRGEFF=../../map/dat/irg_eff_/irgeff.DS02${SUF}
#
#RFLAG=-R0/800/0/800
#JFLAG=-JX10.5/10.5
#BFLAG=-Ba100:AQUASTAT:/a100:Simulation:neWS
RFLAG=-R0/100/0/100
JFLAG=-JX10.5/10.5
BFLAG=-Ba10:AQUASTAT:/a10:Simulation:neWS
SFLAG=-Sa0.1
TITLE=Annual_Irrigation_Withdrawal
############################################################
# out
############################################################
PNG=temp.png
############################################################
# local
############################################################
TMP1=temp.sim.txt
TMP2=temp.cat.txt
TMP0=temp${SUF}
EPS=temp.eps
############################################################
# job
############################################################
htmath $L div $SIM $IRGEFF $TMP0
htmath $L mul $TMP0 0.031536000 $TMP0
htmath $L mul $TMP0 0.001 $TMP0
htbin2list $L $TMP0 $NATMSK $NATLST $TMP1 sum
htcat $OBS $TMP1 $NATLST > $TMP2
htplot $TMP2 $EPS $RFLAG $JFLAG $BFLAG $SFLAG $TITLE
htconv $EPS $PNG rot
