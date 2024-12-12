#!/bin/sh
############################################################
#to   display the L coordinate of the main stream in urban area 
#by   2024/04/25, hanasaki
############################################################
# Settings
############################################################
source ~/.bashrc
#
#LORG=661; SUF=.tk5   #Tokyo,Tone
#LORG=808; SUF=.tk5   #Tokyo,Ara
#LORG=951; SUF=.tk5   #Tokyo,Tama
#LORG=1023; SUF=.tk5  #Tokyo,Sagami
LORG=500; SUF=.ln5; ID=00000038    #London,Thames 945-903
#
PRJ=W5E5
RUN=LR__
MAP=.CAMA
############################################################
# in (basically, do not edit)
############################################################
RIVNXL=../../map/out/riv_nxl_/rivnxl${MAP}${SUF}
RIVARA=../../map/out/riv_ara_/rivara${MAP}${SUF}
RIVDIS=../../riv/out/riv_out_/${PRJ}${RUN}00000000${SUF}
CTYMSK=../org/KKT/cty_msk_${SUF}
CTYMSK=../../map/dat/cty_msk_/city_${ID}${SUF}
############################################################
# Job
############################################################
#
# initialize
#
echo CNT L Area Dis CityMask
L=$LORG
FLGCNT=1
CNT=1
while [ $FLGCNT -eq 1 ]; do
  ARA=`pointtk5 l $RIVARA $L | awk '{printf("%f",$1/1000/1000)}'`
  DIS=`pointtk5 l $RIVDIS $L | awk '{printf("%f",$1/1000)}'`
  CTY=`pointtk5 l $CTYMSK $L | awk '{printf("%d",$1)}'`
  echo $CNT $L $ARA $DIS $CTY
#
# downstream grid cell
#
  NXL=`pointtk5 l $RIVNXL $L | awk '{printf("%i",$1)}'`
  if [ $NXL -eq $L ]; then
    FLGCNT=0
  fi
#
# renew
#
  L=$NXL
  CNT=`expr $CNT + 1`
done
