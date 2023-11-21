

VARS="LWdown__ Prcp____ PSurf___ Qair____ Rainf___ Snowf___ SWdown__ Tair____ Wind____"
YEAR=1979
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
#MONS="00"
PRJ=wfde
RUN=____
SUF=.hlf

L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt


for VAR in $VARS; do
for MON in $MONS; do
    DAYMAX=`htcal $YEAR $MON`
    DAY=00
    while [ $DAY -le $DAYMAX ]; do
	DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
	FILE=../../met/dat/$VAR/$PRJ$RUN$YEAR$MON$DAY$SUF
	echo $FILE
	htarray $L $XY $L2X $L2Y upsidedown $FILE $FILE
	DAY=`expr $DAY + 1 | awk '{printf("%2.2d",$1)}'`
    done
done
done
