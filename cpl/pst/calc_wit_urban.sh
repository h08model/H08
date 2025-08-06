#!/bin/sh
############################################################
#to   aggregate water withdrawal
#by   
############################################################
# Settings
############################################################
SRCS="R_ C_ M_ D_ SN GR GN"; SUM=TT    # Setting for total withdrawal
SRCS="R_ C_ M_ D_    GR";    SUM=TR   # Setting for withdrawal from renewables
SRCS="R_ C_ M_ D_ SN";       SUM=ST
SRCS="R_ C_ M_ D_";          SUM=SR  
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
PRJRUN=W5E5N_C_
#PRJRUN=W5E5N_C1
#PRJRUN=W5E5N_C2
#PRJRUN=W5E5N_C3
PRJRUN=W5E5N_C4
PRJRUN=W5E5N_c4
PRJRUN=W5E5N_x4
#PRJRUN=W5E5N_C5
#PRJRUN=W5E5N_C6
#PRJRUN=W5E5NDC_
#PRJRUN=W5E5NDC1
#PRJRUN=W5E5NDC2
#PRJRUN=W5E5NDC3
#
#SUF=.ks1
#SUF=.nk1
#SUF=.tk5; L=1728
#SUF=.ln5; L=1728
#SUF=.ct5; L=1296
#SUF=.cn5; L=1728
#SUF=.la5; L=2304
SUF=.rj5; L=4032
#SUF=.pr5; L=5184
#
YEARMIN=2014
YEARMAX=2014
YEARMIN=2019
YEARMAX=2019


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
   ID=../../lnd/out/SupID_${SRC}/${PRJRUN}${YEAR}0000${SUF}
    if [ !  -d ../../lnd/out/SupAID${SRC} ]; then
      mkdir -p ../../lnd/out/SupAID${SRC}
    fi
    if [ !  -d ../../lnd/out/SupID_${SRC} ]; then
      mkdir -p ../../lnd/out/SupID_${SRC}
    fi
    htcreate $L 0 $AID
    htmath   $L add $AID $A $AID
    htmath   $L add $AID $I $AID
    htmath   $L add $AID $D $AID
    htcreate $L 0 $ID
    htmath   $L add $ID $I $ID
    htmath   $L add $ID $D $ID    
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
  if [ !  -d ../../lnd/out/SupID_${SUM} ]; then
    mkdir -p ../../lnd/out/SupID_${SUM}
  fi
  ATT=../../lnd/out/SupAgr${SUM}/${PRJRUN}${YEAR}0000${SUF}
  ITT=../../lnd/out/SupInd${SUM}/${PRJRUN}${YEAR}0000${SUF}
  DTT=../../lnd/out/SupDom${SUM}/${PRJRUN}${YEAR}0000${SUF}
  TTT=../../lnd/out/SupAID${SUM}/${PRJRUN}${YEAR}0000${SUF}
  UTT=../../lnd/out/SupID_${SUM}/${PRJRUN}${YEAR}0000${SUF}
  htcreate $L 0 $ATT
  htcreate $L 0 $ITT
  htcreate $L 0 $DTT
  htcreate $L 0 $TTT
  htcreate $L 0 $UTT
  for SRC in $SRCS; do
    A=../../lnd/out/SupAgr${SRC}/${PRJRUN}${YEAR}0000${SUF}
    I=../../lnd/out/SupInd${SRC}/${PRJRUN}${YEAR}0000${SUF}
    D=../../lnd/out/SupDom${SRC}/${PRJRUN}${YEAR}0000${SUF}
    T=../../lnd/out/SupAID${SRC}/${PRJRUN}${YEAR}0000${SUF}
    U=../../lnd/out/SupID_${SRC}/${PRJRUN}${YEAR}0000${SUF}
    htmath   $L add $ATT $A $ATT
    htmath   $L add $ITT $I $ITT
    htmath   $L add $DTT $D $DTT
    htmath   $L add $TTT $T $TTT
    htmath   $L add $UTT $U $UTT
  done
  YEAR=`expr $YEAR + 1`
done
