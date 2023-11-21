#!/bin/sh
############################################################
#to   draw timeseries of all hydrological component
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Edit here (basic)
############################################################
PRJSIM=WFDE     # Project name for simulation results
RUNSIM=LR__     # Run     name for simulation results
PRJMET=wfde     # Project name for met. data
RUNMET=____     # Run     name for met. data
YEARMIN=1979
YEARMAX=1979
LON=100.25
LAT=13.75
IDX=MO          # MO for monthly, DY for daily
#
#VARS="Rainf Snowf SupAgr Tair Evap Qtot SoilMoist SWE"
VARS="Rainf Snowf Tair Evap Qtot SoilMoist SWE GW"
############################################################
# Geography (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360" 
L2X="../../map/dat/l2x_l2y_/l2x.hlf.txt"
L2Y="../../map/dat/l2x_l2y_/l2y.hlf.txt"
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.hlf
MAP=.WFDEI
############################################################
# Input (Do not change here basically)
############################################################
    DIRRAINF=../../met/dat/Rainf___
    DIRSNOWF=../../met/dat/Snowf___
     DIRTAIR=../../met/dat/Tair____
     DIREVAP=../../lnd/out/Evap____
     DIRQTOT=../../lnd/out/Qtot____
      DIRSWE=../../lnd/out/SWE_____
       DIRGW=../../lnd/out/GW______
DIRSOILMOIST=../../lnd/out/SoilMois
   DIRSUPAGR=../../lnd/out/SupAgr__
############################################################
# Map (Do not change here basically)
############################################################
     LNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}
############################################################
# Output (Do not change here basically)
############################################################
EPS=temp.eps
PNG=temp.png
TITLE="Water balance terms"
############################################################
# Macro
############################################################
MONS="01 02 03 04 05 06 07 08 09 10 11 12"

if [ $IDX = MO ]; then
  XMIN=0.5                       # minimum of x axis
  XMAX=12.5                      # maximum of x axis
  XANO=1                         # annotation interval
elif [ $IDX = DY ]; then
  XMIN=0.5                       # minimum of x axis
  XMAX=365.5                     # maximum of x axis
  XANO=30                        # annotation interval
fi

W=10                             # Width of output figure
HOFF=2                           # Height of each output figure
NOFVAR=`echo $VARS | wc | awk '{print $2}'`
H=`echo $NOFVAR $HOFF | awk '{print $1*$2+$2}'`

RFLAG0=-R0/1/0/1
JFLAG0=-JX${W}/${H}
BFLAG0=-B0

VALLNDARA=`htpoint $ARG lonlat $LNDARA $LON $LAT`
############################################################
# Draw variables
############################################################
psbasemap $RFLAG0 $BFLAG0 $JFLAG0 -K > $EPS

COUNT=1
for VAR in $VARS; do

  if [ $VAR = Rainf ]; then
    IN=$DIRRAINF/$PRJMET$RUNMET
    YMIN=0;     YMAX=10;     YANO=2
    WFLAG=
    SCALE=86400;OFFSET=0; UNIT=mm/day
  elif [ $VAR = Snowf ]; then
    IN=$DIRSNOWF/$PRJMET$RUNMET
    YMIN=0;     YMAX=10;     YANO=2
    WFLAG=
    SCALE=86400;OFFSET=0; UNIT=mm/day
  elif [ $VAR = SupAgr ]; then
    IN=$DIRSUPAGR/$PRJSIM$RUNSIM
    YMIN=0;     YMAX=10;     YANO=2
    WFLAG=
    SCALE=`echo 86400 $VALLNDARA | awk '{printf("%24.12f",$1/$2)}'`;  OFFSET=0; UNIT=mm/day
  elif [ $VAR = Tair ]; then
    IN=$DIRTAIR/$PRJMET$RUNMET
    YMIN=0;     YMAX=40;     YANO=10
    WFLAG=
    SCALE=1;    OFFSET=-273.15; UNIT=degC
  elif [ $VAR = Evap ]; then
    IN=$DIREVAP/$PRJSIM$RUNSIM
    YMIN=0;     YMAX=10;     YANO=2
    WFLAG=
    SCALE=86400;OFFSET=0; UNIT=mm/day
  elif [ $VAR = Qtot ]; then
    IN=$DIRQTOT/$PRJSIM$RUNSIM
    YMIN=0;     YMAX=10;     YANO=2
    WFLAG=
    SCALE=86400;OFFSET=0; UNIT=mm/day
  elif [ $VAR = SoilMoist ]; then
    IN=$DIRSOILMOIST/$PRJSIM$RUNSIM
    YMIN=0;     YMAX=150;     YANO=30
    WFLAG=
    SCALE=1;    OFFSET=0; UNIT=mm
  elif [ $VAR = SWE ]; then
    IN=$DIRSWE/$PRJSIM$RUNSIM
    YMIN=0;     YMAX=150;     YANO=30
    WFLAG=
    SCALE=1;    OFFSET=0; UNIT=mm
  elif [ $VAR = GW ]; then
    IN=$DIRGW/$PRJSIM$RUNSIM
    YMIN=0;     YMAX=150;     YANO=30
    WFLAG=
    SCALE=1;    OFFSET=0; UNIT=mm
  else
    $VAR not found abort.
    exit
  fi

  if [ $COUNT = 1 ]; then
    YOFF=0
    NEWS=neWS
  else
    YOFF=$HOFF
    NEWS=neWs
  fi

  RFLAG=-R${XMIN}/$XMAX/$YMIN/$YMAX
  JFLAG=-JX${W}/${HOFF}
  BFLAG=-Ba${XANO}:$XLABEL:/a${YANO}::$NEWS

  XTITLE=`echo $XMAX | awk '{print $1*0.95}'`
  YTITLE=`echo $YMAX | awk '{print $1*0.9}'`

  if [ $VAR = SoilMoist -o $VAR = SWE -o $VAR = GW ]; then
    YEARPRE=`echo $YEARMIN | awk '{print $1-1}'`
    DATPRE=`htpoint $ARG lonlat $IN${YEARPRE}1200${SUF} $LON $LAT`
    echo $YEARPRE 12 0 $DATPRE | \
    awk '{printf("%12d%12d%12d%12f\n",$1,$2,$3,$4)}' > temp.$VAR.txt
  else
    if [ -f temp.$VAR.txt ]; then
      rm temp.$VAR.txt
    fi
  fi

  if [ -f $IN${YEARMIN}1200${SUF} ]; then

    htpointts $ARG lonlat $IN$SUF$IDX $YEARMIN $YEARMAX $LON $LAT >> temp.$VAR.txt
  else
    echo $IN${YEARMIN}1200${SUF} not found

    MONMIN=0
    MONMAX=0
    YEAR=$YEARMIN
    while [ $YEAR -le $YEARMAX ];do
      for MON in 01 02 03 04 05 06 07 08 09 10 11 12; do
        if [ $IDX = MO ]; then          
          DAYMIN=00
          DAYMAX=00
        elif [ $IDX = DY ]; then          
          DAYMIN=1
          DAYMAX=`htcal $YEAR $MON`
        fi
        DAY=$DAYMIN
        while [ $DAY -le $DAYMAX ];do        
          echo $YEAR $MON $DAY 0 >> temp.$VAR.txt 
          DAY=`expr $DAY + 1`
        done
      done
      YEAR=`expr $YEAR + 1`
    done

  fi

  if [ $VAR = SoilMoist -o $VAR = SWE ]; then
#   awk '{print NR-0.5,$4*'"$SCALE"'+'"$OFFSET"'}' temp.$VAR.txt
    awk '{print NR-0.5,$4*'"$SCALE"'+'"$OFFSET"'}' temp.$VAR.txt |\
    psxy -O -Y${YOFF} $RFLAG $BFLAG $JFLAG $WFLAG -K  >> $EPS
  else
#   awk '{print NR,$4*'"$SCALE"'+'"$OFFSET"'}' temp.$VAR.txt
    awk '{print NR,$4*'"$SCALE"'+'"$OFFSET"'}' temp.$VAR.txt |\
    psxy -O -Y${YOFF} $RFLAG $BFLAG $JFLAG $WFLAG -K  >> $EPS
  fi

  pstext -O         $RFLAG $BFLAG $JFLAG     -N -K << EOF >> $EPS
  $XTITLE $YTITLE 12 0 0 7 $VAR [$UNIT]
EOF
  COUNT=`expr $COUNT + 1`

done
############################################################
# Draw water balance
############################################################
VAR=WB
if [ $VAR = WB ]; then
  IN=
  YMIN=-10;     YMAX=10;     YANO=5
  WFLAG=
  SCALE=1;OFFSET=0
fi

RFLAG=-R${XMIN}/$XMAX/$YMIN/$YMAX
JFLAG=-JX${W}/${HOFF}
BFLAG=-Ba${XANO}:$XLABEL:/a${YANO}::$NEWS

XTITLE=`echo $XMAX | awk '{print $1*0.95}'`
YTITLE=`echo $YMAX | awk '{print $1*0.9}'`

if [ -f temp.$VAR.txt ]; then
  rm temp.$VAR.txt
fi

YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  for MON in $MONS; do

    NOFDAY=`htcal $YEAR $MON`
    MONPRE=`echo $MON | awk '{print $1-1}'`
    if [ $MONPRE = 0 ]; then
      MONPRE=12
      YEARPRE=`echo $YEAR | awk '{print $1-1}'`
    else
      YEARPRE=$YEAR
    fi

    VALRAINF=`cat temp.Rainf.txt | awk '($2=='"$MON"'){print $4}'`
    VALSNOWF=`cat temp.Snowf.txt | awk '($2=='"$MON"'){print $4}'`
     VALEVAP=`cat temp.Evap.txt  | awk '($2=='"$MON"'){print $4}'`
    if [ -f temp.SupAgr.txt ]; then
      VALSUPAGR=`cat temp.SupAgr.txt| awk '($2=='"$MON"'){print $4/'"$VALLNDARA"'}'`
    else
      VALSUPAGR=0.0
    fi
    VALQTOT=`cat temp.Qtot.txt  | awk '($2=='"$MON"'){print $4}'`
    VALSOILMOISTINI=`cat temp.SoilMoist.txt | \
              awk '($1=='"$YEARPRE"'&&$2=='"$MONPRE"'){print $4}'`
    VALSOILMOISTEND=`cat temp.SoilMoist.txt | \
                                   awk '($2=='"$MON"'){print $4}' | tail -1`
    VALSWEINI=`cat temp.SWE.txt  | \
              awk '($1=='"$YEARPRE"'&&$2=='"$MONPRE"'){print $4}'`
    VALSWEEND=`cat temp.SWE.txt  | awk '($2=='"$MON"'){print $4}' | tail -1`
    VALGWINI=`cat temp.GW.txt  | \
              awk '($1=='"$YEARPRE"'&&$2=='"$MONPRE"'){print $4}'`
    VALGWEND=`cat temp.GW.txt  | awk '($2=='"$MON"'){print $4}' | tail -1`

   F=`echo $NOFDAY | awk '{print $1*86400}'`
   echo --- Mon: $MON [unit:mm for storage terms, mm/mon for fluxes ]---
   echo Rainf____: $VALRAINF  $F |   awk '{printf("%10s %8.2f\n",$1,$2*$3)}'
   echo Snowf____: $VALSNOWF  $F |   awk '{printf("%10s %8.2f\n",$1,$2*$3)}'
   echo SupAgr___: $VALSUPAGR $F |   awk '{printf("%10s %8.2f\n",$1,$2*$3)}'
   echo Evap_____: $VALEVAP   $F |   awk '{printf("%10s %8.2f\n",$1,$2*$3)}'
   echo Qtot_____: $VALQTOT   $F |   awk '{printf("%10s %8.2f\n",$1,$2*$3)}'
   echo SOILMOIST: $VALSOILMOISTINI $VALSOILMOISTEND | \
   awk '{printf("%10s %8.2f %8.2f\n",$1,$2,$3)}'
   echo SWE......: $VALSWEINI $VALSWEEND | \
   awk '{printf("%10s %8.2f %8.2f\n",$1,$2,$3)}'
   echo GW.......: $VALGWINI $VALGWEND | \
   awk '{printf("%10s %8.2f %8.2f\n",$1,$2,$3)}'
   echo $VALRAINF $VALSNOWF $VALSUPAGR $VALEVAP $VALQTOT $VALSOILMOISTINI $VALSOILMOISTEND $VALSWEINI $VALSWEEND $VALGWINI $VALGWEND $NOFDAY $YEAR $MON 0 | awk '{print $13,$14,$15,($1+$2+$3-$4-$5)*86400*$12+($6-$7+$8-$9+$10-$11),($1+$2+$3-$4-$5)*86400*$10,($6-$7+$8-$9+$10-$11)}' >> temp.$VAR.txt
  done
  YEAR=`expr $YEAR + 1`
done
echo --- water balance error ---
awk '{printf("%2d %12.4f\n",NR,$4*'"$SCALE"'+'"$OFFSET"')}' temp.$VAR.txt
echo ---------------------------
awk '{print NR,$4*'"$SCALE"'+'"$OFFSET"'}' temp.$VAR.txt |\
psxy -O -Y${YOFF} $RFLAG $BFLAG $JFLAG $WFLAG -K  >> $EPS
pstext -O         $RFLAG $BFLAG $JFLAG     -N -K << EOF >> $EPS
$XTITLE $YTITLE 16 0 0 6 $VAR
EOF

############################################################
# Put title
############################################################
YOFF=`echo $HOFF $NOFVAR | awk '{print $1*($2-1+1)*-1}'`
pstext -O -Y${YOFF} $RFLAG0 $BFLAG0 $JFLAG0 -N << EOF >> $EPS
0.5 1.02 20 0 0 6 $TITLE
EOF
htconv $EPS $PNG rot
echo $PNG