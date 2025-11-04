#!/bin/sh
############################################################
#to   aggregate water withdrawal
#by   
############################################################
# Settings
############################################################
SRCS="R_ C_ M_ D_ SN GR GN"; SUM=TT    # Setting for total withdrawal
#SRCS="R_ C_ M_ D_ GR";       SUM=TR   # Setting for withdrawal from renewables
#
#PRJRUN=AK10N_C_
PRJRUN=AK10LECD
#PRJRUN=AK10N_C1
#PRJRUN=AK10N_C2
#PRJRUN=AK10LEC2
#PRJRUN=AK10NEmD
#PRJRUN=AK105cm_
#PRJRUN=AK105wm_
#PRJRUN=AK105mm_
#
L=$LKS1
SUF=.ks1
#SUF=.nk1
#
YEARMIN=2014
YEARMAX=2014
############################################################
# Sector aggregation
############################################################
for SRC in $SRCS; do
  YEAR=$YEARMIN
  while [ $YEAR -le $YEARMAX ]; do
    A=../../lnd/out/SupAgr${SRC}/${PRJRUN}${YEAR}0000${SUF}
    I=../../lnd/out/SupInd${SRC}/${PRJRUN}${YEAR}0000${SUF}
    D=../../lnd/out/SupDom${SRC}/${PRJRUN}${YEAR}0000${SUF}
  AID=../../lnd/out/SupAID${SRC}/${PRJRUN}${YEAR}0000${SUF}
    if [ !  -d ../../lnd/out/SupAID${SRC} ]; then
      mkdir -p ../../lnd/out/SupAID${SRC}
    fi
    htcreate $L 0 $AID
    htmath   $L add $AID $A $AID
    htmath   $L add $AID $I $AID
    htmath   $L add $AID $D $AID
    YEAR=`expr $YEAR + 1`
  done
done
############################################################
# Source aggregation
############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  if [ !  -d ../../lnd/out/SupAgr${SUM} ]; then
    mkdir -p ../../lnd/out/SupAgr${SUM}
  fi
  if [ !  -d ../../lnd/out/SupInd${SUM} ]; then
    mkdir -p ../../lnd/out/SupInd${SUM}
  fi
  if [ !  -d ../../lnd/out/SupDom${SUM} ]; then
    mkdir -p ../../lnd/out/SupDom${SUM}
  fi
  if [ !  -d ../../lnd/out/SupAID${SUM} ]; then
    mkdir -p ../../lnd/out/SupAID${SUM}
  fi
  ATT=../../lnd/out/SupAgr${SUM}/${PRJRUN}${YEAR}0000${SUF}
  ITT=../../lnd/out/SupInd${SUM}/${PRJRUN}${YEAR}0000${SUF}
  DTT=../../lnd/out/SupDom${SUM}/${PRJRUN}${YEAR}0000${SUF}
  TTT=../../lnd/out/SupAID${SUM}/${PRJRUN}${YEAR}0000${SUF}
  htcreate $L 0 $ATT
  htcreate $L 0 $ITT
  htcreate $L 0 $DTT
  htcreate $L 0 $TTT
  for SRC in $SRCS; do
    A=../../lnd/out/SupAgr${SRC}/${PRJRUN}${YEAR}0000${SUF}
    I=../../lnd/out/SupInd${SRC}/${PRJRUN}${YEAR}0000${SUF}
    D=../../lnd/out/SupDom${SRC}/${PRJRUN}${YEAR}0000${SUF}
    T=../../lnd/out/SupAID${SRC}/${PRJRUN}${YEAR}0000${SUF}
    htmath   $L add $ATT $A $ATT
    htmath   $L add $ITT $I $ITT
    htmath   $L add $DTT $D $DTT
    htmath   $L add $TTT $T $TTT
  done
  YEAR=`expr $YEAR + 1`
done
