#!/bin/sh
############################################################
#to   prepare desalination potential
#by   2014/04/25, hanasaki
############################################################
# options
############################################################
#
SSPS="0"
YEARS="2005"
#
SSPS="1 2 3"
YEARS="2055"
############################################################
# Parameters (critically sensitive to the results!)
############################################################
THRGPCS="0 7000 14000 24000"
THRPPETS="0.1 0.15 0.2"
THRPPETS="0.1 0.14 0.15 0.2 0.3"
THRPPETS="0.075"
#
THRGPCS="14000"
THRPPETS="0.5"
THRWWR=0.4
############################################################
# geography
############################################################
MAP=.C05.nolake
PRJ=GSW2; RUN=LR__; SUF=.one; ARG=$ARGONE
PRJ=WFD_; RUN=LR__; SUF=.hlf; ARG=$ARGHLF
############################################################
# in
############################################################
CSTLIN=../../map/dat/cst_lin_/cstlin${MAP}${SUF}
DIRGPCNAT=../../map/out/gpc_nat_
############################################################
# out
############################################################
DIRBINDESPOT=../../map/out/des_pot_
DIRFIGDESPOT=../../map/fig/des_pot_
#
if [ ! -d $DIRBINDESPOT ]; then mkdir -p $DIRBINDESPOT; fi
if [ ! -d $DIRFIGDESPOT ]; then mkdir -p $DIRFIGDESPOT; fi
############################################################
# macro
############################################################
EPS=temp.eps
CPT=temp.cpt
makecpt -T-0.5/1.5/1.0 > $CPT
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
          METPRJ=WFD_;      METRUN=LR__
        elif [ $YEAR = 2025 ]; then
          METPRJ=me${SSP}1; METRUN=LR__
        elif [ $YEAR = 2055 ]; then
          METPRJ=me${SSP}2; METRUN=LR__
        elif [ $YEAR = 2085 ]; then
          METPRJ=me${SSP}3; METRUN=LR__
        fi
        PPET=../../met/out/PPET____/${METPRJ}${METRUN}00000000${SUF}
        echo $PPET
        if   [ $PRJ = Hist ]; then
          echo Historical
          WWR=../../lnd/out/wwr_idx_/WFD_LECD00000000${SUF}
        elif [ $PRJ = SSP1 ]; then
          echo SSP1
          WWR=../../lnd/out/wwr_idx_/me12_D1100000000${SUF}
        elif [ $PRJ = SSP2 ]; then
          echo SSP2
          WWR=../../lnd/out/wwr_idx_/me22_D2100000000${SUF}
        elif [ $PRJ = SSP3 ]; then
          echo SSP3
          WWR=../../lnd/out/wwr_idx_/me32_D3100000000${SUF}
        fi
        echo $WWR
#in
        GPCNAT=${DIRGPCNAT}/${PRJ}IIA_${YEAR}0000${SUF}
#out
#        BINDESPOT=${DIRBINDESPOT}/${PRJ}____${YEAR}0000${MAP}.${THRGPC}.${THRPPET}${SUF}
#        FIGDESPOT=${DIRFIGDESPOT}/${PRJ}____${YEAR}0000${MAP}.${THRGPC}.${THRPPET}.png
        BINDESPOT=${DIRBINDESPOT}/${PRJ}____${YEAR}0000${MAP}.${THRGPC}.${THRPPET}.wwr${THRWWR}${SUF}
        FIGDESPOT=${DIRFIGDESPOT}/${PRJ}____${YEAR}0000${MAP}.${THRGPC}.${THRPPET}.wwr${THRWWR}.png
#job
        htmaskrplc $ARG $CSTLIN    $GPCNAT    eq 1.0E20   0.0 $BINDESPOT 
        htmaskrplc $ARG $BINDESPOT $GPCNAT    lt $THRGPC  0.0 $BINDESPOT 
        htmaskrplc $ARG $BINDESPOT $PPET      gt $THRPPET 0.0 $BINDESPOT
        htmaskrplc $ARG $BINDESPOT $WWR       lt $THRWWR  0.0 $BINDESPOT
        htmaskrplc $ARG $BINDESPOT $BINDESPOT eq 1.0E20   0.0 $BINDESPOT 
        htdraw $ARG     $BINDESPOT $CPT $EPS ${SSPLAB}_${YEAR}
        htconv $EPS     $FIGDESPOT rot
        echo $FIGDESPOT
      done
    done
  done
done
#
