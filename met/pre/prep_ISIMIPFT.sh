#!/bin/sh
############################################################
#to   prepare ISIMIP Fast Track climate scenarios
#by   2018/09/25, hanasaki
############################################################

#YEARMIN=1979; YEARMAX=1979; PID1=20405; PID2=8274; SUF=.hlf; PRJRUN=meschs1_
YEARMIN=2079; YEARMAX=2079; PID1=20405; PID2=27708; SUF=.hlf; PRJRUN=mesc851_
VARS="rlds ps rh rsds prsn tas wind pr"
#
L=$LHLF
############################################################
#
############################################################
DIRORG=../../met/org/ISIMIPFT
############################################################
# Download
############################################################
DIRPWD=`pwd`
#
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  for VAR in $VARS; do
#
# wget
#
    OPT="--http-user=cmip5 --http-passwd=CMIP5"
    URL="http://h08.nies.go.jp/~ddc/tmp/ddc_data/${PID1}/"
    FILE="${PID2}${VAR}${YEAR}.tar.gz"
    wget $OPT ${URL}${FILE}
#
# put tarball into met/org
#
    if [ ! -d $DIRORG/$VAR ]; then 
      mkdir -p $DIRORG/$VAR
    fi
    mv $FILE ${DIRORG}/${VAR}/
#
# directory
#
    if   [ $VAR = rlds ]; then
      DIRVAR=../../../../met/dat/LWdown__
    elif [ $VAR = ps   ]; then
      DIRVAR=../../../../met/dat/PSurf___
    elif [ $VAR = rh   ]; then
      DIRVAR=../../../../met/dat/RH______
    elif [ $VAR = rsds ]; then
      DIRVAR=../../../../met/dat/SWdown__
    elif [ $VAR = prsn ]; then
      DIRVAR=../../../../met/dat/Snowf___
    elif [ $VAR = tas  ]; then
      DIRVAR=../../../../met/dat/Tair____
    elif [ $VAR = wind ]; then
      DIRVAR=../../../../met/dat/Wind____
    elif [ $VAR = pr   ]; then
      DIRVAR=../../../../met/dat/Prcp____
    fi
#
# extract files and put into met/dat
#
    cd $DIRORG/${VAR}
    if [ !  -d $DIRVAR ]; then
      mkdir -p $DIRVAR
    fi
    tar zxf $FILE
    mv ./*${SUF} ${DIRVAR}/
#
    httime $L ${DIRVAR}/${PRJRUN}${SUF}DY $YEAR $YEAR ${DIRVAR}/${PRJRUN}${SUF}MO
#
    cd $DIRPWD
#
  done
  YEAR=`expr $YEAR + 1`

done

