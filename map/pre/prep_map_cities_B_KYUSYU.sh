#!/bin/sh
############################################################
# Settings
############################################################
L=32400
XY="180 180"
LONLAT="129 132 31 34"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
############################################################
# IN / OUT
############################################################
DIRCSV=../org/JAPAN/cities_2020_KYUSYU/
FILES=${DIRCSV}*.csv
CSV=../dat/nat_msk_/cities_B_2020${SUF}.csv
#
TXT=../dat/nat_msk_/cities_B_2020${SUF}.txt
BIN=../dat/nat_msk_/cities_B_2020${SUF}
CPT=temp.cpt
EPS=temp.eps
PNG=../dat/nat_msk_/cities_B_2020${SUF}.png
############################################################
# JOB
############################################################
count=0
for file in $FILES ;do
    if [ $count == 0 ]; then
   echo $file
	cat $file > $CSV
	count=1
    else
   echo $file
	sed -e '1d' $file >> $CSV
    fi
done
#
XKS3RD=`echo $XY | awk '{print ($1*4/3)}'`      # 1 km
YKS3RD=`echo $XY | awk '{print ($2*2)}'`        # 1 km
XKS15S=`echo $XY | awk '{print ($1*4)}'`        # 15 sec
YKS15S=`echo $XY | awk '{print ($2*4)}'`        # 15 sec
#
prog_map_cities_code_KYUSYU $LONLAT $CSV $TXT
prog_map_cities_B_KYUSYU $XY $XKS3RD $YKS3RD $XKS15S $YKS15S $TXT $BIN
#
gmt makecpt -T40000/47000/1000 -Z > $CPT # KYUSYU
htdraw $ARG $BIN $CPT $EPS
htconv $EPS $PNG rothr
#display $PNG &
