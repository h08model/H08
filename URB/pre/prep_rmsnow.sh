#!/bin/sh
YEARMIN=2019
YEARMAX=2019
MONS="00 01 02 03 04 05 06 07 08 09 10 11 12"
MONS="04 05 06 07 08 09 10 11"
PRJ=W5E5
RUN=____
SUF=.tk5
OPT=bak   # to take backup
OPT=rest  # to restore from backup
OPT=rplc  # to replace snowfall less than 0.000005 kg/m2/s to zero.
#
#
#
YEAR=${YEARMIN}
while [ $YEAR -le $YEARMAX ]; do
  for MON in $MONS; do
    DAY=0
    DAYMAX=`htcal $YEAR $MON`
    if [ $MON = "00" ]; then
      DAYMAX=0
    fi
    while [ $DAY -le $DAYMAX ]; do
      DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
      SNOWF=../../met/dat/Snowf___/$PRJ$RUN$YEAR$MON$DAY$SUF
      if   [ $OPT = "bak" ]; then 
	cp $SNOWF $SNOWF.bak
      elif [ $OPT = "rest" ]; then 
	cp $SNOWF.bak $SNOWF
	echo cp $SNOWF.bak $SNOWF
      else
	htmaskrplc $ARGTK5 $SNOWF $SNOWF lt 0.000005 0.0 $SNOWF
      fi
      DAY=`expr $DAY + 1`
    done
  done
  YEAR=`expr $YEAR + 1`
done
