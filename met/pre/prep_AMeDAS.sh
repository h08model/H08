#!/bin/sh
###########################################################################
#
# calculate tair,wind,psurf,qair,swdown,lwdown,prcp
#
# 20210916 hayakawa
#
# marge  summary_AMeDAS.sh,
#        weather_20points.sh, weather_others.sh,
#        plus_lonlat.sh, plus_lonlat_others.sh,
#        overwrite.sh,
#        tair_AMeDAS.sh, wind_AMeDAS.sh, psur_AMeDAS.sh, qair_AMeDAS.sh,
#        swdo_AMeDAS.sh, lwdo_AMeDAS.sh, rain_AMeDAS.sh
#
############################################################################
#
# Attention
#
# The script is designed for the data format used in May 2022.
# The script may not work properly if the data format is changed.
#
###############################################################
# Settings (Edit here)
###############################################################
YEARMIN=2014
YEARMAX=2014
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
#
LV=1   # level
#LV=2
#LV=3
#LV=4
############################################################
# Geography (Edit here)
############################################################
SUF=.ks1
#SUF=.nk1    #NakaKuji
############################################################
# Input data (Edit here)
############################################################
LIST=../org/list/AMeDAS_list_KYUSYU.txt
LIST_o=../org/list/AMeDAS_list_others_KYUSYU.txt
#LIST=../org/list/list.txt             #NakaKuji
#LIST_o=../org/list/list_others.txt    #NakaKuji
############################################################
# make directry
############################################################
DIRDOW=../org/Download
DIRPTWR=../org/ptwR
DIRPTWRPR=../org/ptwRpR
if [ ! -d ${DIRDOW} ]; then mkdir -p ${DIRDOW}; fi
if [ ! -d ${DIRPTWR} ]; then mkdir -p ${DIRPTWR}; fi
if [ ! -d ${DIRPTWRPR} ]; then mkdir -p ${DIRPTWRPR}; fi
#
DIRS="Tair____ Qair____ Wind____ PSurf___ Rainf___ Snowf___ LWdown__ SWdown__ Prcp____ RH______"
for DIR in $DIRS; do
    if [ !  -d ../dat/$DIR ]; then
	mkdir -p ../dat/$DIR
    fi
done
######################################################################
# download
#
# url: daily_s1.php: major manned stations (20 points)
#      daily_a1.php: automated raingauge (97 points)
#
######################################################################
# wget
############
#<<COMENTOUT
ZY=$YEARMIN
while [ $ZY -le $YEARMAX ]; do
    for ZM in $MONS; do
	cat ${LIST} | while read POINT PN BN LON LAT
	do
	    URL="http://www.data.jma.go.jp/obd/stats/etrn/view/daily_s1.php?prec_no=${PN}&block_no=${BN}&year=${ZY}&month=${ZM}&day=&view=p1"
	    FILE1=${DIRDOW}/AMeDAS${LV}_${PN}_${BN}_${ZY}_${ZM}${SUF}.txt
	    wget $URL -O $FILE1
	done
	cat ${LIST_o} | while read POINT_o PN_o BN_o LON_o LAT_o
	do
	    URL_o="http://www.data.jma.go.jp/obd/stats/etrn/view/daily_a1.php?prec_no=${PN_o}&block_no=${BN_o}&year=${ZY}&month=${ZM}&day=&view=p1"
	    FILE1_o=${DIRDOW}/AMeDAS${LV}_${PN_o}_${BN_o}_${ZY}_${ZM}${SUF}.txt
	    wget $URL_o -O $FILE1_o
	done
    done
    ZY=`expr $ZY + 1`
done
#COMENTOUT
#########################################################################################
# extract,  make ptwRpR txt, ptwR txt 
#
# ptwRpR txt : prcp,tair,wind,RN,psurf,RH (20 points)
# ptwR   txt : prcp,tair,wind,RN (20+97 points)
#
########################################################################################
rm -r ../org/ptwRpR/AMeDAS${LV}*${SUF}.txt
rm -r ../org/ptwR/AMeDAS${LV}*${SUF}.txt

ZY=$YEARMIN
while [ $ZY -le $YEARMAX ]; do
    for ZM in $MONS; do
##############
# list ->  ptwRpR txt, ptwR txt 
##############
# 83- lines  
	cat ${LIST} | while read POINT PN BN LON LAT
	do
	    ZD=1
            ZDNUM=83
	    ZDEND=`htcal $ZY $ZM`
	    while [ $ZD -le $ZDEND ]
	    do
		ZD=`printf %02d $ZD`
		FILEPTWRPR=${DIRPTWRPR}/AMeDAS${LV}_${ZY}_${ZM}_${ZD}${SUF}.txt
		FILEPTWR=${DIRPTWR}/AMeDAS${LV}_${ZY}_${ZM}_${ZD}${SUF}.txt
#
		cat ${DIRDOW}/AMeDAS${LV}_${PN}_${BN}_${ZY}_${ZM}${SUF}.txt |
		sed -n "${ZDNUM}p" |
		sed -e "s/\"data_0_0\"><\/td/\"data_0_0\">0.0<\/td/g" -e "s/class=\"data_0_0\">//g" -e "s/..td>//g" -e "s/middle\">//g" -e "s/<td//g" -e "s/ )//g" -e "s/ ]//g" -e "s/\/\/\//0.0/g" -e "s/--/0.0/g"|
		awk '{print '$LON','$LAT',$09,$12,$17,$24,$07,$15 >> "'$FILEPTWRPR'";
print '$LON','$LAT',$09,$12,$17,$24 >> "'$FILEPTWR'" }' 
#		echo $ZY $ZM $ZD 
		ZD=`expr $ZD + 1`
		ZDNUM=`expr $ZDNUM + 1`
	    done
	done
##############
# list_others -> ptwR txt
##############
# 80- lines
# 97- lines ###### NEW 20220523
	cat ${LIST_o} | while read POINT_o PN_o BN_o LON_o LAT_o
	do
	    ZD=1
#	    ZDNUM=80
	    ZDNUM=97 ###### NEW 20220523
	    ZDEND=`htcal $ZY $ZM`
	    while [ $ZD -le $ZDEND ]
	    do
		ZD=`printf %02d $ZD`
		FILEPTWR=${DIRPTWR}/AMeDAS${LV}_${ZY}_${ZM}_${ZD}${SUF}.txt 
#
		cat ${DIRDOW}/AMeDAS${LV}_${PN_o}_${BN_o}_${ZY}_${ZM}${SUF}.txt |
		sed -n "${ZDNUM}p" | 
		sed -e 's/class=data_0_0>//g' -e 's/..td>//g' -e 's/middle">//g' -e 's/<td//g' -e 's/ )//g' -e 's/ ]//g' -e "s/\/\/\//0.0/g" -e "s/--/0.0/g" |
#		awk '{print '${LON_o}','${LAT_o}',$7,$10,$13,$22 }' >> $FILEPTWR
		awk '{print '${LON_o}','${LAT_o}',$7,$10,$15,$24 }' >> $FILEPTWR  ###### NEW 20220523
		ZD=`expr $ZD + 1`
		ZDNUM=`expr $ZDNUM + 1`
	    done
	done
########
    done
    ZY=`expr $ZY + 1`
done
######################################################################
# make bin 
######################################################################
ZY=$YEARMIN
while [ $ZY -le $YEARMAX ]; do
    for ZM in $MONS; do
	VARS="Tair____ Prcp____ Wind____ SWdown__"
	for VAR in $VARS; do
	    ZD=1
	    ZDEND=`htcal $ZY $ZM`
	    while [ $ZD -le $ZDEND ]; do
		ZD=`printf %02d $ZD`
#		echo $ZY $ZM $ZD $LV $VAR $SUF
		ptwR2bin_f $ZY $ZM $ZD $LV $VAR $SUF
#		ptwR2bin $ZY $ZM $ZD $LV $VAR $SUF
		ZD=`expr $ZD + 1`
	    done
	    echo $ZY $ZM $VAR
	done
	VARS="PSurf___ Qair____ LWdown__"
	for VAR in $VARS; do
	    ZD=1
	    ZDEND=`htcal $ZY $ZM`
	    while [ $ZD -le $ZDEND ]; do
		ZD=`printf %02d $ZD`
		ptwRpR2bin_f $ZY $ZM $ZD $LV $VAR $SUF
#		ptwRpR2bin $ZY $ZM $ZD $LV $VAR $SUF
		ZD=`expr $ZD + 1`
	    done
	    echo $ZY $ZM $VAR
	done
    done
    ZY=`expr $ZY + 1`
done
exit
