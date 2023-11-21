#!/bin/sh
############################################################
#to   get data from Database of Dam
#by   2018/08/31, fujiwara, NIES: 
############################################################
RGN=KYSY
VER=v2__
############################################################
# dam IDs
############################################################
IDS="02 04 05 07 14 19 22 23" # kyusyu
############################################################
# Directory
############################################################
DIRORG=../../dam/org/KYUSYU
DIROBSLVLD=../../dam/dat/obs_lvlD
DIROBSSTOD=../../dam/dat/obs_stoD
DIROBSRLSD=../../dam/dat/obs_rlsD
DIROBSINFD=../../dam/dat/obs_infD
DIROBSLVLM=../../dam/dat/obs_lvlM
DIROBSSTOM=../../dam/dat/obs_stoM
DIROBSRLSM=../../dam/dat/obs_rlsM
DIROBSINFM=../../dam/dat/obs_infM
############################################################
# Jobs
############################################################
if [ ! -e $DIROBSLVLD ]; then mkdir $DIROBSLVLD; fi
if [ ! -e $DIROBSSTOD ]; then mkdir $DIROBSSTOD; fi
if [ ! -e $DIROBSRLSD ]; then mkdir $DIROBSRLSD; fi
if [ ! -e $DIROBSINFD ]; then mkdir $DIROBSINFD; fi
if [ ! -e $DIROBSLVLM ]; then mkdir $DIROBSLVLM; fi
if [ ! -e $DIROBSSTOM ]; then mkdir $DIROBSSTOM; fi
if [ ! -e $DIROBSRLSM ]; then mkdir $DIROBSRLSM; fi
if [ ! -e $DIROBSINFM ]; then mkdir $DIROBSINFM; fi
#
#
TMP=temp.txt
#
for ID in $IDS; do
  ID=`printf "%02d\n" $ID`
  echo "dam_ID: " $ID
#
  OBSDAT=$DIRORG/${ID}_day_storage_inflow_discharge.csv
  sed -e '1,2d' -e 's/\// /g' -e 's/,,,/,-9999,-9999,/g' \
      -e 's/,,/,-9999,/g' -e "s/,\$/,-9999/g" \
      -e 's/,0,/,-9999,/g' -e 's/,/ /g' $OBSDAT > $TMP
#
  OBSLVLD=$DIROBSLVLD/${RGN}${VER}000000${ID}.txt
  OBSSTOD=$DIROBSSTOD/${RGN}${VER}000000${ID}.txt
  OBSRLSD=$DIROBSRLSD/${RGN}${VER}000000${ID}.txt
  OBSINFD=$DIROBSINFD/${RGN}${VER}000000${ID}.txt
#  
  OBSLVLM=$DIROBSLVLM/${RGN}${VER}000000${ID}.txt
  OBSSTOM=$DIROBSSTOM/${RGN}${VER}000000${ID}.txt
  OBSRLSM=$DIROBSRLSM/${RGN}${VER}000000${ID}.txt
  OBSINFM=$DIROBSINFM/${RGN}${VER}000000${ID}.txt
#
  awk '{print $1,$2,$3,$4}' $TMP > $OBSLVLD
  awk '{print $1,$2,$3,$6}' $TMP > $OBSRLSD
  awk '{print $1,$2,$3,$5}' $TMP > $OBSINFD
#
  httimetxt ${OBSLVLD}DY ${OBSLVLM}MO
  httimetxt ${OBSRLSD}DY ${OBSRLSM}MO
  httimetxt ${OBSINFD}DY ${OBSINFM}MO
#
  if [ $ID -eq "02" ]; then
    awk '{print $1,$2,$3,(10.423*$4^2-5398.9*$4+695546)/1000}' $OBSLVLD \
	> $OBSSTOD
  elif [ $ID -eq "04" ]; then
    awk '{print $1,$2,$3,(11.932*$4^2-2833.2*$4+166189)/1000}' $OBSLVLD \
	> $OBSSTOD
  elif [ $ID -eq "05" ]; then
    awk '{print $1,$2,$3,(9.825*$4^2-4227*$4+454497)/1000}' $OBSLVLD \
	> $OBSSTOD
  elif [ $ID -eq "07" ]; then
    awk '{print $1,$2,$3,(9.7729*$4^2-970.07*$4+24483)/1000}' $OBSLVLD \
	> $OBSSTOD
  elif [ $ID -eq "14" ]; then
    awk '{print $1,$2,$3,(4.7543*$4^2-656.64*$4+21532)/1000}' $OBSLVLD \
	> $OBSSTOD
  elif [ $ID -eq "19" ]; then
    awk '{print $1,$2,$3,(12.59*$4^2-5618.7*$4+624086)/1000}' $OBSLVLD \
	> $OBSSTOD
  elif [ $ID -eq "22" ]; then
    awk '{print $1,$2,$3,(10.737*$4^2-2124.1*$4+101310)/1000}' $OBSLVLD \
	> $OBSSTOD
  elif [ $ID -eq "23" ]; then
    awk '{print $1,$2,$3,(5.9756*$4^2-2829.7*$4+333848)/1000}' $OBSLVLD \
	> $OBSSTOD
  fi
  httimetxt ${OBSSTOD}DY ${OBSSTOM}MO
done