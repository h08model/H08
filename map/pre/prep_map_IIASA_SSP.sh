#!/bin/sh
############################################################
#to   prepare IIASA-SSP
#by   2014/06/16, hanasaki
#
#  Source: SSP Database - Version 1.1
#  http://tntcat.iiasa.ac.at/SspDb
#
############################################################
# settings
#   Job=1: GDP per capita historical
#   Job=2: GDP per capita future
#   Job=3: GDP historical
#   Job=4: GDP future
############################################################
JOBS="1 2 3 4"
############################################################
# geography
############################################################
SUF=.hlf; L=259200; MAP=.WFDEI
MSK=../../map/dat/nat_msk_/C05_____20000000${MAP}${SUF}
COD=../../map/dat/nat_cod_/C05_____20000000.txt
LOG=temp.log
############################################################
# in/out
############################################################
if [ -f   $LOG ]; then
  /bin/rm $LOG
fi
#
for JOB in $JOBS; do
  if   [ $JOB = 1 ]; then
    ORG=../../map/org/IIASA_SSP/GPC_historical.txt
    SSPS="Hist"
    YEARMIN=1980
    YEARMAX=2005
    DIROUT=../../map/out/gpc_nat_
    OPT=perarea
  elif [ $JOB = 2 ]; then
    ORG=../../map/org/IIASA_SSP/GPC.txt
    SSPS="SSP1 SSP2 SSP3 SSP4 SSP5"
    YEARMIN=2010
    YEARMAX=2100
    DIROUT=../../map/out/gpc_nat_
    OPT=perarea
  elif [ $JOB = 3 ]; then
    ORG=../../map/org/IIASA_SSP/GDP_historical.txt
    SSPS="Hist"
    YEARMIN=1980
    YEARMAX=2005
    DIROUT=../../map/out/gdp_nat_
    POP=../../map/dat/pop_tot_/C05_a___20000000.hlf
    OPT="weight $POP"
  elif [ $JOB = 4 ]; then
    ORG=../../map/org/IIASA_SSP/GDP.txt
    SSPS="SSP1 SSP2 SSP3 SSP4 SSP5"
    YEARMIN=2010
    YEARMAX=2100
    DIROUT=../../map/out/gdp_nat_
    POP=../../map/dat/pop_tot_/C05_a___20000000.hlf
    OPT="weight $POP"
  fi
############################################################
# job
############################################################
  if [ !  -d $DIROUT ]; then
    mkdir -p $DIROUT
  fi
  for SSP in $SSPS; do
    YEAR=$YEARMIN
    while [ $YEAR -le $YEARMAX ]; do
      ASC=${DIROUT}/${SSP}IIA_${YEAR}0000.txt
      BIN=${DIROUT}/${SSP}IIA_${YEAR}0000${SUF}
      COL=`echo $YEAR $YEARMIN | awk '{print ($1-$2)/5+3}'`
      awk '($1=="'$SSP'"){print $2,$'$COL'}' $ORG | sed '1d' > $ASC
      htlist2bin $L $ASC $MSK $COD $BIN $OPT >> $LOG
      echo $ASC $COL >> $LOG
      YEAR=`expr $YEAR + 5`
    done
  done
done
#
echo Log: $LOG

