#!/bin/sh
############################################################
#to   prepare observed operation
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Edit here (id)
############################################################
IDS="3667 5146 5140 710 712 705 702 1307 1320 411 884 338 451 307 753 597 310 297 870 148 396 355"
for ID in $IDS; do
  ID4=`echo $ID | awk '{printf("%4.4d",$1)}'`
############################################################
# Edit here (in)
############################################################
  DAYORG=../org/H06_GRanD/____day_0000${ID4}.txt
  MONORG=../org/H06_GRanD/____mon_0000${ID4}.txt
############################################################
# Edit here (out)
############################################################
DIROBSSTO=../dat/obs_sto_
DIROBSINF=../dat/obs_inf_
DIROBSRLS=../dat/obs_rls_
if [ ! -d $DIROBSSTO ];then mkdir -p $DIROBSSTO; fi
if [ ! -d $DIROBSINF ];then mkdir -p $DIROBSINF; fi
if [ ! -d $DIROBSRLS ];then mkdir -p $DIROBSRLS; fi
############################################################
# Edit here (out)
############################################################
  DAYSTO=${DIROBSSTO}/____day_0000${ID4}.txt
  DAYINF=${DIROBSINF}/____day_0000${ID4}.txt
  DAYRLS=${DIROBSRLS}/____day_0000${ID4}.txt
  MONSTO=${DIROBSSTO}/____mon_0000${ID4}.txt
  MONINF=${DIROBSINF}/____mon_0000${ID4}.txt
  MONRLS=${DIROBSRLS}/____mon_0000${ID4}.txt
 MEANSTO=${DIROBSSTO}/meanmon_0000${ID4}.txt
 MEANINF=${DIROBSINF}/meanmon_0000${ID4}.txt
 MEANRLS=${DIROBSRLS}/meanmon_0000${ID4}.txt
############################################################
# Job
############################################################
  if [ ! -f $DAYORG ]; then
    if [ ! -f $MONORG ]; then
      echo No data file for ${ID}
    else
      echo Creating monthly observation files for $ID
      awk '{print $1,$2,$3,$4*1000*1000*1000}' $MONORG > $MONSTO
      awk '{print $1,$2,$3,$5*1000}'           $MONORG > $MONINF
      awk '{print $1,$2,$3,$6*1000}'           $MONORG > $MONRLS
    fi
  else
    echo Creating daily observation files for $ID
    awk '{print $1,$2,$3,$4*1000*1000*1000}'   $DAYORG > $DAYSTO
    awk '{print $1,$2,$3,$5*1000}'             $DAYORG > $DAYINF
    awk '{print $1,$2,$3,$6*1000}'             $DAYORG > $DAYRLS
    echo Creating monthly observation files for $ID
    httimetxt ${DAYSTO}DY ${MONSTO}MO
    httimetxt ${DAYINF}DY ${MONINF}MO
    httimetxt ${DAYRLS}DY ${MONRLS}MO
  fi
  if [ -f $MONSTO ]; then
    htmeantxt ${MONSTO}MO ${MEANSTO}MO
    htmeantxt ${MONINF}MO ${MEANINF}MO
    htmeantxt ${MONRLS}MO ${MEANRLS}MO
  fi
done