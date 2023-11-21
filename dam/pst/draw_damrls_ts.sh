#!/bin/sh
############################################################
#to   draw river discharge hydrograph
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Edit here (geography)
############################################################
L=64800
XY="360 180"
L2X=../../map/dat/l2x_l2y_/l2x.one.txt
L2Y=../../map/dat/l2x_l2y_/l2y.one.txt
LONLAT="-180 180 -90 90"
SUF=.one
ARG="$L $XY $L2X $L2Y $LONLAT"
############################################################
# Edit here (in)
############################################################
DAMLST=../../map/org/H06/damlst.GSWP2${SUF}.area.txt
OBSLST=../../dam/dat/obs_lst_/obsdat.txt
PRJ1=GSW2
RUN1=LECD
DAMRLS1=../../riv/out/riv_out_/${PRJ1}${RUN1}${SUF}MO
DAMRLS2=
DAMSTO1=../../dam/out/dam_sto_/${PRJ1}${RUN1}${SUF}MO
DAMSTO2=
YEARMIN=1986
YEARMAX=1995
############################################################
# Edit here (option)
############################################################
SLEGTIT1=$PRJ1
SLEGTIT2=
SLEGTIT0=Observation
OPTVERBOSE=yes
############################################################
# Edit here (out)
############################################################
DIRFIG=../../dam/fig/sim_ope_
if [ ! -d $DIRFIG ]; then mkdir -p $DIRFIG; fi
############################################################
# Job
############################################################
IDS=`awk '{print $1}' $OBSLST`
for ID in $IDS; do
#
# Output
#
  EPS=temp.eps
  PNG=${DIRFIG}/${PRJ1}${RUN1}0000${ID}.png
#
# Basic info
#
  LON=`awk '($3=='"$ID"'){print $1}' $DAMLST`
  LAT=`awk '($3=='"$ID"'){print $2}' $DAMLST`
  NAME=`awk '($3=='"$ID"'){print $5}' $DAMLST`
  DAMRLSOBS=../../dam/dat/obs_rls_/____mon_0000${ID}.txt
  DAMSTOOBS=../../dam/dat/obs_sto_/____mon_0000${ID}.txt
  if [ "$OPTVERBOSE" = "yes" ]; then
    echo draw_hydrog.sh: ID: $ID
    echo draw_hydrog.sh: LON LAT: $LON $LAT
    echo draw_hydrog.sh: DAMRLSOBS: $DAMRLSOBS
    echo draw_hydrog.sh: DAMSTOOBS: $DAMSTOOBS
  fi
#
# Horizontal
#
  RXMAX=`echo $YEARMAX $YEARMIN | awk '{print ($1-$2+1)*12}'`
  if [ $RXMAX -le 24 ]; then
    BXANO=1
  else
    BXANO=12
  fi
#
# Vertical
#
  DAMRLSMAX=`htstattxt max ${DAMRLSOBS}MO | awk '{printf("%d",$1/1000)}'`
  if   [ $DAMRLSMAX -le 100 ]; then
    RYMAX=100;   BYANO=20; 
  elif [ $DAMRLSMAX -le 1000 ]; then
    RYMAX=1000;  BYANO=200
  elif [ $DAMRLSMAX -le 10000 ]; then
    RYMAX=10000; BYANO=2000
  else
    RYMAX=10000; BYANO=2000
  fi
  if [ "$OPTVERBOSE" = "yes" ]; then
    echo draw_hydrog.sh: DAMRLSMAX: $DAMRLSMAX
  fi
#
  DAMSTOMAX=`htstattxt max ${DAMSTOOBS}MO | awk '{printf("%d",$1/1000/1000/1000)}'`
  if   [ $DAMSTOMAX -le 10000 ]; then
    RYMAX2=10000;   BYANO2=2000; 
  elif [ $DAMSTOMAX -le 50000 ]; then
    RYMAX2=50000;  BYANO2=10000
  elif [ $DAMSTOMAX -le 100000 ]; then
    RYMAX2=100000;  BYANO2=20000
  elif [ $DAMSTOMAX -le 500000 ]; then
    RYMAX2=500000; BYANO2=100000
  elif [ $DAMSTOMAX -le 1000000 ]; then
    RYMAX2=1000000; BYANO2=200000
  else
    RYMAX2=1000000; BYANO2=200000
  fi
  if [ "$OPTVERBOSE" = "yes" ]; then
    echo draw_hydrog.sh: DAMRLSMAX: $DAMSTOMAX
  fi
#
# Legend
#
  LEGXORG=`echo $RXMAX | awk '{print $1*0.2}'`
  LEGXDES=`echo $RXMAX | awk '{print $1*0.3}'`
  LEGXTIT=`echo $RXMAX | awk '{print $1*0.35}'`
  LEGYTOP=`echo $RYMAX | awk '{print $1*0.9}'`
  LEGYMID=`echo $RYMAX | awk '{print $1*0.8}'`
  LEGYBOT=`echo $RYMAX | awk '{print $1*0.7}'`
#
# Title
#
  XTIT=`echo $RXMAX | awk '{print $1*0.5}'`
  YTIT=`echo $RYMAX2 | awk '{print $1*1.1}'`
  STIT=${NAME}_${YEARMIN}-${YEARMAX}      # title
#
#
#
  RFLAGDAMRLS=-R1/${RXMAX}/0/${RYMAX}
  BFLAGDAMRLS=-Ba${BXANO}:Month:/a${BYANO}:Discharge[m@+3@+s@+-1@+]:neWS
  JFLAGDAMRLS=-JX21.0/5.0
  RFLAGDAMSTO=-R1/${RXMAX}/0/${RYMAX2}
  BFLAGDAMSTO=-Ba${BXANO}::/a${BYANO2}:Storage[10@+6@+m@+3@+]:neWs
  JFLAGDAMSTO=-JX21.0/5.0
#
#
#
  XLEGORG1=$LEGXORG; YLEGORG1=$LEGYTOP 
  XLEGDES1=$LEGXDES; YLEGDES1=$LEGYTOP                     # legend line
  XLEGTIT1=$LEGXTIT; YLEGTIT1=$LEGYTOP                     # legend title
  XLEGORG2=$LEGXORG; YLEGORG2=$LEGYMID 
  XLEGDES2=$LEGXDES; YLEGDES2=$LEGYMID                     # legend line
  XLEGTIT2=$LEGXTIT; YLEGTIT2=$LEGYMID                     # legend title
  XLEGORG0=$LEGXORG; YLEGORG0=$LEGYBOT 
  XLEGDES0=$LEGXDES; YLEGDES0=$LEGYBOT                     # legend line
  XLEGTIT0=$LEGXTIT; YLEGTIT0=$LEGYBOT                     # legend title
#
#
#
  COL0=10/255/0/0
  COL1=5/0/0/255
  COL2=5/0/255/0
############################################################
# Draw
############################################################
  gmtset ANOT_FONT_SIZE 12
  gmtset LABEL_FONT_SIZE 12
#
# draw basemap
#
  psbasemap $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -K > $EPS
#
# simulation (1)
#
  if [ "$OPTVERBOSE" = "yes" ]; then
    echo draw_hydrog.sh: simulation 1
    htpointts $ARG lonlat $DAMRLS1 $YEARMIN $YEARMIN $LON $LAT | \
    awk '{print $1, $2, $3, $4/1000}' | \
    awk '{print NR, $4}'
  fi
  htpointts $ARG lonlat $DAMRLS1 $YEARMIN $YEARMAX $LON $LAT | \
  awk '{print $1, $2, $3, $4/1000}' | \
  awk '{print NR, $4}' | \
  psxy   -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -W$COL1 -K >> $EPS
  echo $XLEGORG1 $YLEGORG1 $XLEGDES1 $YLEGDES1 | \
  awk '{printf("%f %f\n%f %f",$1,$2,$3,$4)}' | \
  psxy   -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -W$COL1 -K >> $EPS
  pstext -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -K     <<EOF >> $EPS
  $XLEGTIT1 $YLEGTIT1 20 0 0 5 $SLEGTIT1
EOF
#
# simulation (2)
#
  if [ "$DAMRLS2" != "" ]; then
    if [ "$OPTVERBOSE" = "yes" ]; then
      echo draw_hydrog.sh: simulation 2
      htpointts $ARG lonlat $DAMRLS2 $YEARMIN $YEARMIN $LON $LAT |\
      awk '{print $1, $2, $3, $4/1000}' | \
      awk '{print NR, $4}'
    fi
    htpointts $ARG lonlat $DAMRLS2 $YEARMIN $YEARMAX $LON $LAT | \
    awk '{print $1, $2, $3, $4/1000}' | \
    awk '{print NR, $4}' | \
    psxy   -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -W$COL2 -K >> $EPS
    echo $XLEGORG2 $YLEGORG2 $XLEGDES2 $YLEGDES2 | \
    awk '{printf("%f %f\n%f %f",$1,$2,$3,$4)}' | \
    psxy   -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -W$COL2 -K >> $EPS
    pstext -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -K     <<EOF >> $EPS
    $XLEGTIT2 $YLEGTIT2 20 0 0 5 $SLEGTIT2
EOF
  fi
#
# observation
#
  if [ "$DAMRLSOBS" != "" ]; then
    if [ "$OPTVERBOSE" = "yes" ]; then
      echo draw_hydrog.sh: observation
      htcatts ${DAMRLSOBS}MO $YEARMIN $YEARMIN | \
      awk '{print NR, $4/1000}'
    fi
    htcatts ${DAMRLSOBS}MO $YEARMIN $YEARMAX | \
    awk '{print NR, $4/1000}' | \
    psxy   -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -W$COL0 -K >> $EPS
    echo $XLEGORG0 $YLEGORG0 $XLEGDES0 $YLEGDES0 | \
    awk '{printf("%f %f\n%f %f",$1,$2,$3,$4)}' | \
    psxy   -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -W$COL0 -K >> $EPS
    pstext -O $RFLAGDAMRLS $BFLAGDAMRLS $JFLAGDAMRLS -K     <<EOF >> $EPS
    $XLEGTIT0 $YLEGTIT0 20 0 0 5 $SLEGTIT0
EOF
  fi
#
# simulation (1)
#
  if [ "$OPTVERBOSE" = "yes" ]; then
    echo draw_hydrog.sh: simulation 1
    htpointts $ARG lonlat $DAMSTO1 $YEARMIN $YEARMIN $LON $LAT |\
    awk '{print $1, $2, $3, $4/1000/1000/1000}' | \
    awk '{print NR, $4}'
  fi
  htpointts $ARG lonlat $DAMSTO1 $YEARMIN $YEARMAX $LON $LAT | \
  awk '{print $1, $2, $3, $4/1000/1000/1000}' | \
  awk '{print NR, $4}' | \
  psxy   -O -Y5 $RFLAGDAMSTO $BFLAGDAMSTO $JFLAGDAMSTO -W$COL1 -K >> $EPS
#
# simulation (2)
#
  if [ "$DAMSTO2" != "" ]; then
    if [ "$OPTVERBOSE" = "yes" ]; then
      echo draw_hydrog.sh: simulation 2
      htpointts $ARG lonlat $DAMSTO2 $YEARMIN $YEARMIN $LON $LAT |\
      awk '{print $1, $2, $3, $4/1000/1000/1000}' | \
      awk '{print NR, $4}'
    fi
    htpointts $ARG lonlat $DAMSTO2 $YEARMIN $YEARMAX $LON $LAT | \
    awk '{print $1, $2, $3, $4/1000/1000/1000}' | \
    awk '{print NR, $4}' | \
    psxy   -O $RFLAGDAMSTO $BFLAGDAMSTO $JFLAGDAMSTO -W$COL2 -K >> $EPS
  fi
#
# observation
#
  if [ "$DAMSTOOBS" != "" ]; then
    if [ "$OPTVERBOSE" = "yes" ]; then
      echo draw_hydrog.sh: observation
      htcatts ${DAMSTOOBS}MO $YEARMIN $YEARMAX | \
      awk '{print NR, $4/1000/1000/1000}'
    fi
    htcatts ${DAMSTOOBS}MO $YEARMIN $YEARMAX | \
    awk '{print NR, $4/1000/1000/1000}' | \
    psxy   -O $RFLAGDAMSTO $BFLAGDAMSTO $JFLAGDAMSTO -W$COL0 -K >> $EPS
  fi
#
# put title
#
  pstext -O $RFLAGDAMSTO $BFLAGDAMSTO $JFLAGDAMSTO -N       <<EOF >> $EPS
  $XTIT $YTIT 20 0 0 6 $STIT
EOF
#
# convert
#
  htconv $EPS $PNG rot
  echo $PNG
done