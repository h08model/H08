#!/bin/sh
############################################################
#to   prepare desalination potential
#by   2014/04/25, hanasaki
############################################################
# options
############################################################
#
# for future runs
#
SSPS="1 2 3"
YEARS="2025 2055 2085"
THRGPCS="14000"
THRPPETS="0.08"
MAP=.C05.nolake
MAP=.WFDEI
#
# for historical run
#
SSPS="0"
YEARS="2005"
THRGPCS="14000"
THRPPETS="0.08"
MAP=.C05.nolake
MAP=.WFDEI
############################################################
# geography
############################################################
L=259200
XY="720 360"
L2X=${DIRH08}/map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=${DIRH08}/map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
ARG="$L $XY $L2X $L2Y $LONLAT"
############################################################
# in
############################################################
   CSTLIN=../../map/dat/cst_lin_/cstlin${MAP}${SUF}
DIRGPCNAT=../../map/out/gpc_nat_
  DIRPRCP=../../met/dat/Prcp____
  DIRPOTE=../../lnd/out/PotEvap_
############################################################
# out
############################################################
DIRBINDESPOT=../../map/out/des_pot_     # area utilizing seawater desal
DIRFIGDESPOT=../../map/fig/des_pot_
     DIRPPET=../../met/out/PPET____     # Prcp / PotEvap
#
if [ ! -d $DIRBINDESPOT ]; then mkdir -p $DIRBINDESPOT; fi
if [ ! -d $DIRFIGDESPOT ]; then mkdir -p $DIRFIGDESPOT; fi
if [ ! -d $DIRPPET      ]; then mkdir -p $DIRPPET; fi
############################################################
# macro
############################################################
EPS=temp.eps
CPT=temp.cpt
gmt makecpt -T-0.5/1.5/1.0 > $CPT
############################################################
# job
############################################################
for THRGPC in $THRGPCS; do
  for THRPPET in $THRPPETS; do
    for SSP in $SSPS; do
      if [ $SSP = 0 ]; then
        PRJ=Hist
        SSPLAB=Historical
      else
        PRJ=SSP${SSP}
        SSPLAB=SSP${SSP}
      fi
      for YEAR in $YEARS; do
        if   [ $YEAR = 2005 ]; then
          PRJMET=wfde;      RUNMET=____
          PRJSIM=WFDE;      RUNSIM=LR__
        elif [ $YEAR = 2025 ]; then
          PRJMET=me${SSP}1; RUNMET=LR__
        elif [ $YEAR = 2055 ]; then
          PRJMET=me${SSP}2; RUNMET=LR__
        elif [ $YEAR = 2085 ]; then
          PRJMET=me${SSP}3; RUNMET=LR__
        fi
#in
        PRCP=${DIRPRCP}/${PRJMET}${RUNMET}00000000${SUF}
        POTE=${DIRPOTE}/${PRJSIM}${RUNSIM}00000000${SUF}
        GPCNAT=${DIRGPCNAT}/${PRJ}IIA_${YEAR}0000${SUF}
#out
        PPET=${DIRPPET}/${PRJMET}${RUNMET}00000000${SUF}
        BINDESPOT=${DIRBINDESPOT}/${PRJ}____${YEAR}0000${MAP}.${THRGPC}.${THRPPET}${SUF}
        FIGDESPOT=${DIRFIGDESPOT}/${PRJ}____${YEAR}0000${MAP}.${THRGPC}.${THRPPET}.png
# job (ppet)
        htmath $L div $PRCP $POTE $PPET
# job 
        htmaskrplc $ARG $CSTLIN    $GPCNAT    eq 1.0E20   0.0 $BINDESPOT 
        htmaskrplc $ARG $BINDESPOT $GPCNAT    lt $THRGPC  0.0 $BINDESPOT 
        htmaskrplc $ARG $BINDESPOT $PPET      gt $THRPPET 0.0 $BINDESPOT
        htmaskrplc $ARG $BINDESPOT $BINDESPOT eq 1.0E20   0.0 $BINDESPOT 
        htdraw $ARG     $BINDESPOT $CPT $EPS ${SSPLAB}_${YEAR}
        htconv $EPS     $FIGDESPOT rot
        echo $FIGDESPOT
      done
    done
  done
done
#
