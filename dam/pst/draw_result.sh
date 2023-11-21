#!/bin/sh
############################################################
#to   draw timeseries graph
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Edit here (jobs)
############################################################
JOBS="Fig3a Fig3b Fig3c Fig3d Fig3e"
JOBS="Fig4a Fig4b Fig4c Fig4d Fig4e"
JOBS="Fig7a Fig7b Fig7c"
JOBS="Fig8a Fig8b Fig8c"
JOBS="Fig9a Fig9b Fig9c Fig9d"
JOBS="Fig10a Fig10b Fig10c Fig10d"
############################################################
# Edit here (basic)
############################################################
VARS="rls sto"
############################################################
# Macro
############################################################
OBSTMP=temp.obs.txt
CALTMP=temp.cal.txt
INFTMP=temp.inf.txt
FILE=temp.cat.txt
EPS=temp.eps
############################################################
# Job
############################################################
for JOB in $JOBS; do
  if [ $JOB = Fig3a -o $JOB = Fig3b -o $JOB = Fig3c -o $JOB = Fig3d -o $JOB = Fig3e ]; then
    ID=00003256; YEARMIN=1980; YEARMAX=1996
    RFLAGRLS=-R1/204/0/2500
    BFLAGRLS=-Ba12::/a500neWS
    RFLAGSTO=-R1/204/0/50000
    BFLAGSTO=-Ba24::/a5000neWS
    if   [ $JOB = Fig3a ]; then
      PRJ=JH06; RUN=3065; 
    elif [ $JOB = Fig3b ]; then
      PRJ=JH06; RUN=3075; 
    elif [ $JOB = Fig3c ]; then
      PRJ=JH06; RUN=3085; 
    elif [ $JOB = Fig3d ]; then
      PRJ=JH06; RUN=3095; 
    elif [ $JOB = Fig3e ]; then
      PRJ=JH06; RUN=3000; 
    fi
  elif [ $JOB = Fig4a -o $JOB = Fig4b -o $JOB = Fig4c -o $JOB = Fig4d -o $JOB = Fig4e ]; then
    ID=00003236; YEARMIN=1980; YEARMAX=1996
    RFLAGRLS=-R1/204/0/1000
    BFLAGRLS=-Ba12::/a500neWS
    RFLAGSTO=-R1/204/0/5000
    BFLAGSTO=-Ba24::/a1000neWS
#    ID=00003256; YEARMIN=1980; YEARMAX=1996
#    RFLAGRLS=-R1/204/0/2500
#    BFLAGRLS=-Ba12::/a500neWS
#    RFLAGSTO=-R1/204/0/50000
#    BFLAGSTO=-Ba24::/a5000neWS
    if [ $JOB = Fig4a ]; then
      PRJ=JH06; RUN=4050; 
    elif [ $JOB = Fig4b ]; then
      PRJ=JH06; RUN=4075; 
    elif [ $JOB = Fig4c ]; then
      PRJ=JH06; RUN=4100; 
    elif [ $JOB = Fig4d ]; then
      PRJ=JH06; RUN=4200; 
    elif [ $JOB = Fig4e ]; then
      PRJ=JH06; RUN=4400; 
    fi
  elif [ $JOB = Fig7a -o $JOB = Fig7b -o $JOB = Fig7c ]; then
    ID=00003256; YEARMIN=1980; YEARMAX=1996
    RFLAGRLS=-R1/204/0/2500
    BFLAGRLS=-Ba12::/a500neWS
    RFLAGSTO=-R1/204/0/50000
    BFLAGSTO=-Ba24::/a5000neWS
    if   [ $JOB = Fig7a ]; then
      PRJ=JH06; RUN=7M98;
    elif [ $JOB = Fig7b ]; then
      PRJ=JH06; RUN=7CST;
    elif [ $JOB = Fig7c ]; then
      PRJ=JH06; RUN=7H06; 
    fi
  elif [ $JOB = Fig8a -o $JOB = Fig8b -o $JOB = Fig8c ]; then
    ID=00003297; YEARMIN=1995; YEARMAX=2004
    RFLAGRLS=-R1/120/0/1000
    BFLAGRLS=-Ba12::/a200neWS
    RFLAGSTO=-R1/120/0/5000
    BFLAGSTO=-Ba24::/a1000neWS
    if   [ $JOB = Fig8a ]; then
      PRJ=JH06; RUN=8M98;
    elif [ $JOB = Fig8b ]; then
      PRJ=JH06; RUN=8CST;
    elif [ $JOB = Fig8c ]; then
      PRJ=JH06; RUN=8H06; 
    fi
  elif [ $JOB = Fig9a -o $JOB = Fig9b -o $JOB = Fig9c -o $JOB = Fig9d ]; then
    ID=00002237; YEARMIN=1987; YEARMAX=1988
    RFLAGRLS=-R1/24/0/1000
    BFLAGRLS=-Ba1::/a200neWS
    RFLAGSTO=-R1/24/0/10000
    BFLAGSTO=-Ba1::/a2000neWS
    if   [ $JOB = Fig9a ]; then
      PRJ=JH06; RUN=9M98;
    elif [ $JOB = Fig9b ]; then
      PRJ=JH06; RUN=9CST;
    elif [ $JOB = Fig9c ]; then
      PRJ=JH06; RUN=9H06; 
    elif [ $JOB = Fig9d ]; then
      PRJ=JH06; RUN=9IRG; 
    fi
  elif [ $JOB = Fig10a -o $JOB = Fig10b -o $JOB = Fig10c -o $JOB = Fig10d ]; then
#    ID=00003288; YEARMIN=1987; YEARMAX=1988
#    ID=00002237; YEARMIN=1987; YEARMAX=1988
     ID=5140; YEARMIN=1987; YEARMAX=1988
     IDS="3667 5146 5140 710 712 705 702 1307 1320 411 884 338 451 307 753 597 310 297 870 148 396 355"
  fi 

    RFLAGRLS=-R1/24/0/250
    BFLAGRLS=-Ba1::/a50neWS
#    RFLAGSTO=-R1/24/0/5000
    RFLAGSTO=-R1/24/0/8000
    BFLAGSTO=-Ba1::/a1000neWS
    if   [ $JOB = Fig10a ]; then
      PRJ=JH06; RUN=0M98;
    elif [ $JOB = Fig10b ]; then
      PRJ=JH06; RUN=0CST;
    elif [ $JOB = Fig10c ]; then
      PRJ=JH06; RUN=0H06; 
    elif [ $JOB = Fig10d ]; then
      PRJ=JH06; RUN=0IRG; 
    fi

  JFLAG=-JX21.0/10.5
##
for ID in $IDS; do
  ID4=`echo $ID | awk '{printf("%4.4d",$1)}'`
##
  for VAR in $VARS; do
    if [ $VAR = rls ]; then
      OBS=../../dam/dat/obs_rls_/____mon_0000${ID4}.txt
      CAL=../../dam/out/off_rls_/${PRJ}${RUN}0000${ID4}.txt
      INF=../../dam/dat/obs_inf_/____mon_0000${ID4}.txt
      RFLAG=$RFLAGRLS
      BFLAG=$BFLAGRLS
      FACTOR=0.001
      TITLE=Release[m3s]
      DIRFIG=../../dam/fig/off_rls_
      PNG=${DIRFIG}/${PRJ}${RUN}0000${ID4}.png
    elif [ $VAR = sto ]; then
      OBS=../../dam/dat/obs_sto_/____mon_0000${ID4}.txt
      CAL=../../dam/out/off_sto_/${PRJ}${RUN}0000${ID4}.txt
      INF=
      RFLAG=$RFLAGSTO
      BFLAG=$BFLAGSTO
      FACTOR=0.000000001
      TITLE=Storage[MCM]
      DIRFIG=../../dam/fig/off_sto_
      PNG=${DIRFIG}/${PRJ}${RUN}0000${ID4}.png
    fi
    if [ ! -d $DIRFIG ]; then
      mkdir -p $DIRFIG
    fi
############################################################
#
############################################################
#    htcat ${OBS}MO $YEARMIN $YEARMAX | \
#    awk '{print $1, $2, $3, $4*'${FACTOR}'}' > $OBSTMP
    awk '($1>="'$YEARMIN'"&&$1<="'$YEARMAX'"){print $1, $2, $3, $4*'${FACTOR}'}' ${OBS} > $OBSTMP
#    htcat ${CAL}MO $YEARMIN $YEARMAX | \
#    awk '{print $1, $2, $3, $4*'${FACTOR}'}' > $CALTMP
    awk '($1>="'$YEARMIN'"&&$1<="'$YEARMAX'"){print $1, $2, $3, $4*'${FACTOR}'}' ${CAL} > $CALTMP
#    htcat ${OBSTMP}MO ${CALTMP}MO $YEARMIN $YEARMAX > $FILE
    htcatts ${OBSTMP}MO ${CALTMP}MO > $FILE
    htdrawts $FILE $EPS $RFLAG $JFLAG $BFLAG $TITLE 2
    htconv   $EPS  $PNG  rot
    echo     $PNG
  done
done
done