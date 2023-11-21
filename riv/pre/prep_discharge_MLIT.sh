#!/bin/sh
############################################################
#to   get discharge data of MLIT
#      (Ministry of Land, Infrastructure, Transport and Tourism) 
#by   2017/05/17, fujiwara
############################################################
# Before excute this program, make station list file(stnlst.${MAP}.txt)
#  at "riv/dat/stn_lst_" and write ID and Name and River.
# After excute this program, check station list file,
#  then write information about H08 by checking points.
############################################################
# Basic Settings (Edit here if you wish)
############################################################
RGN=KYSY  #Kyusyu
#RGN=NKKJ     # NakaKuji
YEARMIN=2014
YEARMAX=2014
VER=____

STNS="Senoshita(Chikugo)309061289901190 Takaoka(Oyodo)309141289916060 Yokoishi(Kuma)309111289909070 Miwa(Gokase)309161289917020 Shiratakibashi(Oono)309181289913030 Jonan(Midori)309101289908030 Hinodebashi(Onga)309011289902050 Tamana(Kikuchi)309081289911080 Sendai(Sendai)309121289918160 Kuranobashi(Sendai)309121289918130" #Kyusyu
#STNS="Noguchi(Naka)303021283322040 Koubori(Naka)303021283322050 Koguchi(Naka)303021283322060 Kurobane(Naka)303021283322070 Yamagata(Kuji)303011283322010 Tomioka(Kuji)303011283322020 Nukada(Kuji)303011283322030 Sakakibashi(Kuji)303011283322050" #NakaKuji

MAP=.kyusyu
#MAP=.NakaKuji

TOP="http://www1.river.go.jp/cgi-bin"
#DIROBS=../../riv/dat/riv_disD
#DIRLST=../../riv/dat/stn_lst_
DIROBSD=../../riv/dat/riv_disD
DIROBSM=../../riv/dat/riv_disM
DIRLST=../../riv/dat/stn_lst_
STNLST=$DIRLST/stnlst${MAP}.txt
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
#
# Setting for Naka and Kuji river
#L=14400
#XY="120 120"
#L2X=../../map/dat/l2x_l2y_/l2x.nk1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.nk1.txt
#LONLAT="139 141 36 38"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.nk1
#MAP=.NakaKuji
############################################################
# Input
############################################################
GRDARA=../../map/dat/grd_ara_/grdara${SUF}
FLWDIR=../../map/dat/flw_dir_/flwdir${MAP}${SUF}
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}
RIVNUM=../../map/out/riv_num_/rivnum${MAP}${SUF}
############################################################
# Job (Prepare directory and delete station file)
############################################################
if [ ! -d $DIROBSD ]; then mkdir -p $DIROBSD; fi
if [ ! -d $DIROBSM ]; then mkdir -p $DIROBSM; fi
if [ ! -d $DIRLST  ]; then mkdir -p $DIRLST ; fi
############################################################
# Job (Get data)
############################################################
echo "ID Name RIV LON(OBS) LAT(OBS) AREA(OBS) LON(H08) LAT(H08) AREA(H08) MLIT_ID" > $STNLST
TMP=temp.txt
TMP2=temp2.txt
TEMP=temp${SUF}
NUM=1
for STN in $STNS; do
  echo $STN > $TMP
  STNNAME=`sed -e "s/(/ /g" $TMP | sed -e "s/)/ /g" | awk '{print $1}'`
  RIVNAME=`sed -e "s/(/ /g" $TMP | sed -e "s/)/ /g" | awk '{print $2}'`
    STNID=`sed -e "s/(/ /g" $TMP | sed -e "s/)/ /g" | awk '{print $3}'`

  NUM=`printf "%02d\n" $NUM`
#
  rm $TMP
  OBSTXT=${RGN}${VER}000000${NUM}.txt
  OBS=$DIROBSD/$OBSTXT
#  OBS=$DIROBS/${STNID}a.txt
#
  if [ -f $OBS ]; then rm $OBS; fi
#
  YR=$YEARMIN

  while [ $YR -le $YEARMAX ]; do
    FEB=`htcal $YR 2`
    LN=73
    MON=1
    DAY=1
    if [ $FEB -eq 29 ]; then
	FEBEND=135
	FEBPLS=5
    else
	FEBEND=134
	FEBPLS=6
    fi
    rm $TMP
    rm $TMP2
    wget -O - ${TOP}/DspWaterData.exe\?KIND=7\&ID=${STNID}\&BGNDATE=${YR}0131\&ENDDATE=${YR}1231\&KAWABOU=NO >> $TMP


      sed -e 's/<TD align="right" bgcolor="#e6e6e7" nowrap><FONT size="-1">//g' \
	  -e 's/<TD align="right" nowrap><FONT size="-1">//g' \
	  -e 's/<\/FONT><\/TD>//g' -e '/<TD align="center"/c -9999' $TMP >> $TMP2
#      sed -e '/<TD align="center"/c -9999' $TMP2 >> $TMP2
#
    while [ $LN -le 477 ]; do   # 477 is the last line
      DAT=`sed -n ${LN}p $TMP2`
#
      echo $YR $MON $DAY $DAT >> $OBS
      if [ $LN -eq 103 -o $LN -eq 171 -o $LN -eq 239 \
	  -o $LN -eq 307 -o $LN -eq 341 -o $LN -eq 409 ]; then
	  LN=`expr $LN + 3`
	  MON=`expr $MON + 1`
	  DAY=1
      elif [ $LN -eq 204  -o $LN -eq 272 -o $LN -eq 374 -o $LN -eq 442 ]; then
	  LN=`expr $LN + 4`
	  MON=`expr $MON + 1`
	  DAY=1
      elif [ $LN -eq $FEBEND ]; then
	  LN=`expr $LN + $FEBPLS`
	  MON=`expr $MON + 1`
	  DAY=1
      else
	  DAY=`expr $DAY + 1`
      fi

      LN=`expr $LN + 1`
#      DAY=`expr $DAY + 1`
    done
    YR=`expr $YR + 1`
  done

# get lonlat and catchment area

  wget -O - ${TOP}/SiteInfoDetail.exe\?ID=${STNID} > $TMP

  DEG=`awk '(NR==60){print $4}' $TMP | cut -c1,2 `      # degree
  MIN=`awk '(NR==60){print $4}' $TMP | cut -c5,6 | \
      awk '{printf("%12.4f",$1/60)}'`                   # minute
  SEC=`awk '(NR==60){print $4}' $TMP | cut -c8,9 | \
      awk '{printf("%12.4f",$1/3600)}'`                 # second
  LATOBS=`echo $DEG $MIN $SEC | awk '{printf("%12.4f",$1+$2+$3)}'`

  DEG=`awk '(NR==60){print $6}' $TMP | cut -c1,2,3 `
  MIN=`awk '(NR==60){print $6}' $TMP | cut -c6,7 | \
      awk '{printf("%12.4f",$1/60)}'` 
  SEC=`awk '(NR==60){print $6}' $TMP | cut -c9,10 | \
      awk '{printf("%12.4f",$1/3600)}'`
  LONOBS=`echo $DEG $MIN $SEC | awk '{printf("%12.4f",$1+$2+$3)}'`

  L=`htid $ARG lonlat $LONOBS $LATOBS | awk '{print $3}'`
  LONH08=`htid $ARG l $L | awk '{print $1}'`
  LATH08=`htid $ARG l $L | awk '{print $2}'`

  AREAOBS=`grep "km2" $TMP | awk '{print $2}' | cut -c13- | \
      sed -e "s/km2<\/TD>/E+06/g" | sed -e "s/,//g"`
  
  htcatchment $ARG lonlat $FLWDIR $RIVSEQ $RIVNUM $TEMP $LONH08 $LATH08 > /dev/null
#  htcatchment $ARG $LONH08 $LATH08 $FLWDIR $RIVSEQ $RIVNUM $TEMP
  htmask $ARG $GRDARA $TEMP eq 1 $TEMP
  AREAH08=`htstat $ARG sum $TEMP | awk '{print $1}'`

  echo $STNNAME $RIVNAME $STNID
  echo $LONOBS $LATOBS $AREAOBS
#  NUM=`printf "%02d\n" $NUM`
#  NUM=`printf "%02d" $NUM`
  echo $NUM $STNNAME $RIVNAME $LONOBS $LATOBS $AREAOBS \
      $LONH08 $LATH08 $AREAH08 $STNID >> $STNLST

  httimetxt ${OBS}DY ${DIROBSM}/${OBSTXT}MO > /dev/null
  NUM=`expr $NUM + 1`
done
#   sed -e 's/<TD align="right" bgcolor="#e6e6e7" nowrap><FONT size="-1">//g' -e 's/<TD align="right" nowrap><FONT size="-1">//g' -e 's/<\/FONT><\/TD>//g' MLIT_2${ZY}.txt > MLIT_${ZY}.txt
#ZM1=`awk '{sum+=$1}END{print sum/NR}' MLIT_${ZY}.txt`
#rm MLIT_2${ZY}.txt   

# wget  -O - http://www1.river.go.jp/cgi-bin/DspWaterData.exe\?KIND=7\&ID=309061289901190\&BGNDATE=20080131\&ENDDATE=20081231\&KAWABOU=NO 

# put decimal point
#  LON=`awk '(NR==60){print $6}' $TMP | cut -c1,2,3,6,7,9,10 | \
#      sed -e 's/^\(.\{3\}\)/\1./'`
