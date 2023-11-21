#!/bin/sh
############################################################
#to   get dam data of MLIT
#      (Ministry of Land, Infrastructure, Transport and Tourism) 
#by   2017/12/05, fujiwara
############################################################
# Basic Settings (Edit here if you wish)
############################################################
RGN=KYSY     # region
YEARMIN=2003
YEARMAX=2016

STNIDS="01:609061289920020 02:609061289920060 04:1368091050080 05:1368090853060  07:1368091270070 14:1368090600030"

MAP=.kyusyu

MONS="01 02 03 04 05 06 07 08 09 10 11 12"

TOP="http://www1.river.go.jp/cgi-bin/DspDamData.exe"
############################################################
# Geographical Setting
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
MAP=.kyusyu
############################################################
# Directory
############################################################
OBSINF=../../dam/dat/obs_inf_
#OBSLST=../../dam/dat/obs_lst_
OBSRLS=../../dam/dat/obs_rls_
OBSSTO=../../dam/dat/obs_sto_
############################################################
# Job (Get data)
############################################################
TMP=temp.txt
for STNID in $STNIDS; do
  NO=`echo $STNID | sed -e 's/:/ /g' | awk '{print $1}'`
  STNID=`echo $STNID | sed -e 's/:/ /g' | awk '{print $2}'`

  INFALL=$OBSINF/${RGN}${NO}HR00000000.txt
  RLSALL=$OBSRLS/${RGN}${NO}HR00000000.txt
  STOALL=$OBSSTO/${RGN}${NO}HR00000000.txt

  YR=$YEARMIN
  while [ $YR -le $YEARMAX ]; do
    INFYR=$OBSINF/${RGN}${NO}HR${YR}0000.txt
    RLSYR=$OBSRLS/${RGN}${NO}HR${YR}0000.txt
    STOYR=$OBSSTO/${RGN}${NO}HR${YR}0000.txt

    for MON in $MONS; do
      INFMON=$OBSINF/${RGN}${NO}HR${YR}${MON}00.txt
      RLSMON=$OBSRLS/${RGN}${NO}HR${YR}${MON}00.txt
      STOMON=$OBSSTO/${RGN}${NO}HR${YR}${MON}00.txt

      DAYEND=`htcal $YR $MON | awk '{print $1}'`
      URL=`wget -O - ${TOP}\?KIND=1\&ID=${STNID}\&BGNDATE=${YR}${MON}01\&ENDDATE=${YR}${MON}${DAYEND}\&KAWABOU=NO | awk '(NR==24){print $2}' | sed -e 's/href=//g' -e 's/"//g'`

      wget -O - http://www1.river.go.jp${URL} | sed -e 's/\// /g' \
	  -e 's/,/ /g' -e 's/-/-9999/g' -e '1,9d' -e 's/:/ /g' -e 's/#/ /g' | \
	  awk '{print $1,$2,$3,$4,$7,$8,$9,$10,$11}'  > $TMP
      awk '{print $1,$2,$3,$4,$6}' $TMP > $INFMON
      awk '{print $1,$2,$3,$4,$7}' $TMP > $RLSMON
      awk '{print $1,$2,$3,$4,$5,$8}' $TMP > $STOMON

      if [ $MON -eq "01" ]; then
	cat $INFMON > $INFYR
	cat $RLSMON > $RLSYR
	cat $STOMON > $STOYR
      else
	cat $INFMON >> $INFYR
	cat $RLSMON >> $RLSYR
	cat $STOMON >> $STOYR
      fi
    done
    if [ $YR -eq $YEARMIN -a $MON -eq "12" ]; then
      cat $INFYR > $INFALL
      cat $RLSYR > $RLSALL
      cat $STOYR > $STOALL
    else
      cat $INFYR >> $INFALL
      cat $RLSYR >> $RLSALL
      cat $STOYR >> $STOALL
    fi
    YR=`expr $YR + 1`
  done
done