#!/bin/sh
############################################################
#to   prepare WATCH Forcing data of future projection
#by   2011/12/25 hanasaki
############################################################
# Settings (Change below)
############################################################
GCM=echam; SCEN=A2;    PRJ=WEC_; RUN=A2__; IDX=DY; YEARMIN=2002; YEARMAX=2100
GCM=cncm3; SCEN=A2;    PRJ=WCN_; RUN=A2__; IDX=DY; YEARMIN=2002; YEARMAX=2100
GCM=ipsl;  SCEN=A2;    PRJ=WIP_; RUN=A2__; IDX=DY; YEARMIN=2002; YEARMAX=2100
GCM=echam; SCEN=20C3M; PRJ=WEC_; RUN=20__; IDX=DY; YEARMIN=1961; YEARMAX=2000
GCM=cncm3; SCEN=20C3M; PRJ=WCN_; RUN=20__; IDX=DY; YEARMIN=1961; YEARMAX=2000
GCM=ipsl;  SCEN=20C3M; PRJ=WIP_; RUN=20__; IDX=DY; YEARMIN=1961; YEARMAX=2000

GCM=echam; SCEN=20C3M; PRJ=WEC_; RUN=20__; IDX=DY; YEARMIN=1961; YEARMAX=1961
############################################################
# Macro (Do not change here)
############################################################
VARS="Tair Prcp Snowf SWdown LWdown Qair PSurf Wind"
L=259200
SUF=.hlf
DIRIN=../org/WFD_Future
DIROUT=../../met/dat
LNDMSK=../../map/dat/lnd_msk_/lndmsk.WATCH.hlf
############################################################
# Job
############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  for VAR in $VARS; do
    VAR8=`echo ${VAR}________ | awk '{print substr($1,1,8)}'`

# file name

    NOFDAY=`htcal $YEAR 0`
    if   [ $GCM = echam -o $GCM = ipsl ]; then
      if [ $VAR = Tair -o $VAR = Prcp -o $VAR = Snowf ]; then
        if [ $VAR = Tair ]; then
          VARFILE=T
          VARNAME=temp2
        elif [ $VAR = Prcp ]; then
          VARFILE=pr
          VARNAME=precip
        elif [ $VAR = Snowf ]; then
          if [ $GCM = echam ]; then
            VARFILE=pr_PRSN
          elif  [ $GCM = ipsl ]; then
            VARFILE=pr_SNOWF
          fi
          VARNAME=snow
        fi
        if [ $SCEN = A2 -a $GCM = echam ]; then
          SCENFILE=A2_
        else
          SCENFILE=
        fi
        FILE=${DIRIN}/${SCENFILE}${VARFILE}_BCed_1960_1999_${YEAR}.nc
      else
        if [ $VAR = Qair ]; then
          VARFILE=huss
          if [ $GCM = echam ]; then
            VARNAME=var168
          elif [ $GCM = ipsl ]; then
            VARNAME=huss
          fi
        elif [ $VAR = PSurf ]; then
          VARFILE=ps
          VARNAME=ps
        elif [ $VAR = LWdown ]; then
          if [ $GCM = echam ]; then
            VARFILE=rlds
            VARNAME=rlds
          elif [ $GCM = ipsl ]; then
            VARFILE=solldown
            VARNAME=solldown
          fi
        elif [ $VAR = SWdown ]; then
          VARFILE=rsds
          VARNAME=rsds
        elif [ $VAR = Wind ]; then
          VARFILE=wss
          VARNAME=wss
        fi
        if [ $SCEN = A2 ]; then
          SCENFILE=SRA2
        elif [ $SCEN = 20C3M ]; then
          SCENFILE=20C3M
        fi
        if [ $GCM = echam ]; then
        FILE=${DIRIN}/MPEH5_${SCENFILE}_3_DM_${VARFILE}_${YEAR}_0.5deg_land.nc
        elif [ $GCM = ipsl ]; then
        FILE=${DIRIN}/IPCM4_${SCENFILE}_1_DM_${VARFILE}_${YEAR}_0.5deg_land.nc
        fi
      fi
    elif [ $GCM = cncm3 ]; then
      if [ $VAR = Tair ]; then
        VARFILE=tair
        VARNAME=Tair
      elif [ $VAR = Prcp ]; then
        VARFILE=precip
        VARNAME=Precip
      elif [ $VAR = Snowf ]; then
        VARFILE=snowf
        VARNAME=Snowf
      fi
      if [ $VAR = Qair ]; then
        VARFILE=qair
        VARNAME=Qair
      elif [ $VAR = PSurf ]; then
        VARFILE=psurf
        VARNAME=PSurf
      elif [ $VAR = LWdown ]; then
        VARFILE=lwdown
        VARNAME=LWdown
      elif [ $VAR = SWdown ]; then
        VARFILE=swdown
        VARNAME=SWdown
      elif [ $VAR = Wind ]; then
        VARFILE=wind
        VARNAME=Wind
      fi
      if [ $SCEN = A2 ]; then
        SCENFILE=sresa2
      elif [ $SCEN = 20C3M ]; then
        SCENFILE=20c3m
      fi
      FILE=${DIRIN}/cncm3_${VARFILE}_${SCENFILE}_${YEAR}.nc
    elif [ $GCM = echam ]; then
      if [ $VAR = Tair -o $VAR = Prcp -o $VAR = Snowf ]; then
        if [ $VAR = Tair ]; then
          VARFILE=T
          VARNAME=temp2
        elif [ $VAR = Prcp ]; then
          VARFILE=pr
          VARNAME=precip
        elif [ $VAR = Snowf ]; then
          VARFILE=pr_SNOWF
          VARNAME=snow
        fi
        if [ $SCEN = A2 ]; then
          SCENFILE=A2_
        elif [ $SCEN = 20C3M ]; then
          SCENFILE=
        fi
        FILE=${DIRIN}/${SCENFILE}${VARFILE}_BCed_1960_1999_${YEAR}.nc
      else
        if [ $VAR = Qair ]; then
          VARFILE=huss
          VARNAME=huss
        elif [ $VAR = PSurf ]; then
          VARFILE=ps
          VARNAME=ps
        elif [ $VAR = LWdown ]; then
          VARFILE=rlds
          VARNAME=rlds
        elif [ $VAR = SWdown ]; then
          VARFILE=rsds
          VARNAME=rsds
        elif [ $VAR = Wind ]; then
          VARFILE=wss
          VARNAME=wss
        fi
        if [ $SCEN = A2 ]; then
          SCENFILE=SRA2
        elif [ $SCEN = 20C3M ]; then
          SCENFILE=20C3M
        fi
        FILE=${DIRIN}/MPEH5_${SCENFILE}_3_DM_${VARFILE}_${YEAR}_0.5deg_land.nc
      fi
    fi

# file check

    if [ ! -f $FILE ]; then
      if [ -f ${FILE}.gz ]; then
        gunzip ${FILE}.gz
      else
        echo $FILE not found
        exit
      fi
    fi
    echo working on $FILE ...

# generate ascii data 

    HEADER=`ncdump -h $FILE | wc | awk '{print $1+2}'`
    if [ ! -f $FILE ]; then
      echo $FILE not found
    else
      ncdump -v$VARNAME $FILE | \
      sed -e '1,'"$HEADER"'d' | sed -e '$d' | \
      sed -e 's/,/ /g'        | sed -e 's/;/ /g'   |\
      sed -e 's/_/1.0e20/g'   > temp.txt
    fi

# convert into binary data

    if [ ! -d $DIROUT/$VAR8 ]; then
      mkdir   $DIROUT/$VAR8
    fi
    OUT=$DIROUT/$VAR8/${PRJ}${RUN}${SUF}${IDX}
    prog_WDD $L $NOFDAY temp.txt $OUT $YEAR $LNDMSK
  done
  YEAR=`expr $YEAR + 1`
done
