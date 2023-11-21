#!/bin/sh
############################################################
#
#
############################################################
# Settings
############################################################
#
# Kyushu 1 min
#
XY="180 180"
LONLAT="129 132 31 34"
SUF=.ks1
#
# Japan 1 min
#
XYJP1="1620 1320"
LONLATJP1="122 149 24 46"
############################################################
# In/Out
############################################################
NC=../org/JAPAN/S8/S8-2-1_population_total_all_age_mid_base_2010.nc
OUT=../dat/pop_tot_/population${SUF}
############################################################
# Job (prepare output directory)
############################################################
if [ ! -d ../dat/pop_tot_ ]; then mkdir -p ../dat/pop_tot_; fi
############################################################
# Convert 1min into 1km(3rd)
############################################################
XJP3RD=`echo $XYJP1 | awk '{print ($1*4/3)}'`   # Japan in 1 km
YJP3RD=`echo $XYJP1 | awk '{print ($2*2)}'`     # Japan in 1 km
XKS3RD=`echo $XY | awk '{print ($1*4/3)}'`      # Kyushu in 1 km
YKS3RD=`echo $XY | awk '{print ($2*2)}'`        # Kyushu in 1 km
XKS15S=`echo $XY | awk '{print ($1*4)}'`        # Kyushu in 15 sec
YKS15S=`echo $XY | awk '{print ($2*4)}'`        # Kyushu in 15 sec
X_EDGE=`echo $LONLAT $LONLATJP1 | awk '{print (($1-$5)*80)}'`        # Top-left edge of kyushu
Y_EDGE=`echo $LONLAT $LONLATJP1 | awk '{print (($8-$4)*120)}'`        # Top-left edge of kyushu
#echo $XJP3RD $YJP3RD $XKS3RD $YKS3RD $XKS15S $YKS15S $X_EDGE $Y_EDGE
############################################################
# convert netcdf into ascii
############################################################
NCHEAD=`ncdump -h $NC | wc | awk '{print $1 + 2}'`
ncdump -vpop1 $NC | sed '1,'${NCHEAD}'d' | sed -e '$d' |\
sed -e 's/;//' | sed -e 's/,//g' | sed -e 's/_/1.0E20/g' > temp.txt
############################################################
# convert ascii into binary
############################################################
prog_map_pop_KYUSYU $XJP3RD $YJP3RD $XY $XKS3RD $YKS3RD $XKS15S $YKS15S $X_EDGE $Y_EDGE temp.txt $OUT


