#!/bin/sh
############################################################
#to   cleanup output directory
#by   2010/06/30, hanasaki, NIES: H08ver0.5
############################################################
# You must edit here (basic)
############################################################
PRJ=temp
RUN=
SUF=.one
YEARMIN=0000
YEARMAX=0000
############################################################
# You can edit here (directories to clean up)
############################################################
DIR1STS="lnd riv crp dam cpl"
DIR2NDS="out"
############################################################
# Macro
############################################################
DIRPWD=`pwd`
############################################################
# Job
############################################################
for DIR1ST in $DIR1STS; do
  for DIR2ND in $DIR2NDS; do
    DIR3RDS=`find ../${DIR1ST}/${DIR2ND} -maxdepth 1 -type d`
    for DIR3RD in $DIR3RDS; do
      echo ${DIR3RD}
      YEAR=$YEARMIN
      while [ $YEAR -le $YEARMAX ]; do
        rm ${DIR3RD}/${PRJ}${RUN}*${YEAR}*${SUF}
        YEAR=`expr $YEAR + 1`
      done
    done
  done
done
