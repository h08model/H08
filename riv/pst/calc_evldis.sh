#!/bin/sh
############################################################
#to   evaluate discharge simulation
#by   2015/10/07, hanasaki
#
#     before using this script,
#     prepare river discharge observation
#    (../../riv/dat/riv_disM or ../../riv/dat/riv_disDd )
#
############################################################
# settings (edit below)
############################################################
SDS="A B C"        # options for SD (must be consistent with lnd/dat/par_lst_/) 
CDS="A B C"        # options for CD (ibid)
GAMMAS="A B C"     # options for Gamma (ibid)
TAUS="A B C"       # options for Tau (ibid)
#
PRJ=GSW2           # Project name (must be 4 char.)
YEARMIN=1986       # year to start calibration
YEARMAX=1986       # year to end validation
TRESO=MO           # MO for monthly, DY for daily
#
#PRJ=AK10            # for .ks1 2022
#YEARMIN=2014
#YEARMAX=2014
#TRESO=MO
#
#DIROBS=../../riv/dat/riv_disD
DIROBS=../../riv/dat/riv_disM       # directory where observed data stored
PRJRUNOBS=SNU_v1__
PRJRUNOBS=SNU_v2__                  # for .ko5 2018
#PRJRUNOBS=KYSY____
  
OPTMET=nse; DIRMET=../../riv/out/nse_____ # nse for Nash-Sutcliffe Efficiency
OPTEVAL=max                    # max (greater is better) or min (less is better)
#
#IDS="1 2 3 4 5 6 7 8 9 10"    # for .ko5 2018
IDS="01 02 03 04 05 06 07 08 09 10" # for .ks1 2022
############################################################
# geography
############################################################
SUF=.ko5
MAP=.SNU
L=11088
XY="84 132"
LONLAT="124 131 33 44"
L2X=../../map/dat/l2x_l2y_/l2x${SUF}.txt 
L2Y=../../map/dat/l2x_l2y_/l2y${SUF}.txt 
ARG="$L $XY $L2X $L2Y $LONLAT"

# for .ks1 2022
#SUF=.ks1
#MAP=.kyusyu
#L=32400
#XY="180 180"
#LONLAT="129 132 31 34"
#L2X=../../map/dat/l2x_l2y_/l2x${SUF}.txt 
#L2Y=../../map/dat/l2x_l2y_/l2y${SUF}.txt 
#ARG="$L $XY $L2X $L2Y $LONLAT"

############################################################
# in (do not edit below unless you are an expert of H08)
############################################################
DIRSIMBIN=../../riv/out/riv_out_    # directory where simulated data stored
STNLST=../../riv/dat/stn_lst_/stnlst${MAP}.txt  # station list
############################################################
# out (do not edit below unless you are an expert of H08)
############################################################
DIRSIMASC=../../riv/out/riv_dis_    # directory for simulated discharge
DIRPARCMB=../../riv/out/par_cmb_
#
if [ ! -d $DIRSIMASC ]; then mkdir $DIRSIMASC; fi
if [ ! -d $DIRPARCMB ]; then mkdir $DIRPARCMB; fi
if [ ! -d $DIRMET    ]; then mkdir $DIRMET;    fi
############################################################
# Job 1 (initialize)
############################################################
PARCMB=${DIRPARCMB}/${PRJ}.txt
if [   -f $PARCMB ]; then rm    $PARCMB; fi
############################################################
# Job 2 (Extract data and calculate metrix)
############################################################
for ID in $IDS; do
  ID8=`echo $ID | awk '{printf("%8.8d",$1)}'`
  LON=`awk '($1=="'$ID'"){print $7}' $STNLST`       # need check
  LAT=`awk '($1=="'$ID'"){print $8}' $STNLST`       # need check
  NAME=`awk '($1=="'$ID'"){print $2}' $STNLST`      # need check
  echo --------
  echo ID: $ID8
  echo LON: $LON
  echo LAT: $LAT
  echo Name: $NAME
#
  MET=${DIRMET}/${PRJ}____${ID8}.txt
  if [ -f $MET ]; then /bin/rm $MET; fi
#
  for SD in $SDS; do
    for CD in $CDS; do
      for GAMMA in $GAMMAS; do
        for TAU in $TAUS; do
          IN=../../riv/out/riv_out_/${PRJ}${SD}${CD}${GAMMA}${TAU}
          INCHECK=${IN}${YEARMIN}0100${SUF}
          if [ -f $INCHECK ]; then
            SIM=${DIRSIMASC}/${PRJ}${SD}${CD}${GAMMA}${TAU}${ID8}.txt
            htpointts $ARG lonlat ${IN}${SUF}${TRESO} $YEARMIN $YEARMAX $LON $LAT | awk '{print $1,$2,$3,$4/1000}' > $SIM
            SIMS=`echo $SIMS $SIM${TRESO}`
            OBS=${DIROBS}/${PRJRUNOBS}${ID8}.txt
            if [ -f $OBS ]; then
              METRIX="`htmettxt ${OPTMET} ${SIM}${TRESO} ${OBS}${TRESO} $YEARMIN $YEARMAX | awk '{print $1}'`"
              echo ${SD}${CD}${GAMMA}${TAU} $METRIX >> $MET
            else
              echo $OBS not exist
            fi
          else
            echo $IN not exist
          fi
        done
      done
    done
  done
  OPTIMAL=`htstatlst $OPTEVAL $MET`
  echo Metrix: $OPTIMAL
  echo $ID $OPTIMAL >> $PARCMB
done
#
echo The combinations of optimal parameters are written to: 
echo $PARCMB



