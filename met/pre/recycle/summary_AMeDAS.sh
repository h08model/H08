#!/bin/sh
############################################################
#
#
############################################################
# settings
############################################################
YEARMIN=2014
YEARMAX=2014
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
#
MONS="07"
LV=2   # level
############################################################
# job
############################################################
if [ ! -e url_AMeDAS_dat/ ]; then
    mkdir url_AMeDAS_dat/
fi

#
if [ ! -e data_AMeDAS/ ]; then
    mkdir data_AMeDAS/
fi
#
if [ !  -d ../org/AMeDAS ]; then
  mkdir -p ../org/AMeDAS/
fi

if [ !  -d ../dat/Tair____ ]; then
  mkdir -p ../dat/Tair____
fi
if [ !  -d ../dat/Qair____ ]; then
  mkdir -p ../dat/Qair____
fi
if [ !  -d ../dat/Wind____ ]; then
  mkdir -p ../dat/Wind____
fi
if [ !  -d ../dat/PSurf___ ]; then
  mkdir -p ../dat/PSurf___
fi
if [ !  -d ../dat/Rainf___ ]; then
  mkdir -p ../dat/Rainf___
fi
if [ !  -d ../dat/Snowf___ ]; then
  mkdir -p ../dat/Snowf___
fi
if [ !  -d ../dat/LWdown__ ]; then
  mkdir -p ../dat/LWdown__
fi
if [ !  -d ../dat/SWdown__ ]; then
  mkdir -p ../dat/SWdown__
fi
if [ !  -d ../dat/Prcp____ ]; then
  mkdir -p ../dat/Prcp____
fi

ZY=$YEARMIN
while [ $ZY -le $YEARMAX ]; do
  for ZM in $MONS; do
######################################################################
# download, move to data_AMeDAS
#
# url: daily_s1.php: major manned stations (20)
#      daily_a1.php: automated raingauge (97)
#
######################################################################
    sed -e 's/${YEAR}/'${ZY}'/g' -e 's/${MON}/'${ZM}'/g' ./url_AMeDAS/url_AMeDAS_.dat > ./url_AMeDAS/url_AMeDAS_${ZY}${ZM}.dat

    wget -i ./url_AMeDAS/url_AMeDAS_${ZY}${ZM}.dat
#    mv AMeDAS*.txt data_AMeDAS
######################################################################
# remove html tags
######################################################################
    sh weather_20points.sh ${ZY} ${ZM}    # major manned stations
    sh weather_others.sh  ${ZY} ${ZM}     # automated raingauge
######################################################################
# make AMeDAS2 files
######################################################################
    sh plus_lonlat.sh ${ZY} ${ZM}
    sh plus_lonlat_others.sh ${ZY} ${ZM}
######################################################################
# 
######################################################################
    sh overwrite.sh ${ZY} ${ZM} ${LV}
######################################################################
# 
######################################################################
    sh tair_AMeDAS.sh ${ZY} ${ZM} ${LV}
    sh wind_AMeDAS.sh ${ZY} ${ZM} ${LV}
    sh psur_AMeDAS.sh ${ZY} ${ZM} ${LV}
    sh qair_AMeDAS.sh ${ZY} ${ZM} ${LV}
    sh swdo_AMeDAS.sh ${ZY} ${ZM} ${LV}
    sh lwdo_AMeDAS.sh ${ZY} ${ZM} ${LV}
    sh rain_AMeDAS.sh ${ZY} ${ZM} ${LV}
    
    mv AMeDAS*.txt data_AMeDAS
    mv -f daily_s1.php?prec_no* url_AMeDAS_dat/
    mv -f daily_a1.php?prec_no* url_AMeDAS_dat/
    
    echo $ZY $ZM

#    find /data1/maji -type f -empty | xargs rm
  done
  ZY=`expr $ZY + 1`
done