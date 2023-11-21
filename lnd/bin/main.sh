#!/bin/sh
############################################################
#to   run the land surface model
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Basic Settings (edit here if you wish)
############################################################
PRJ=WFDE		# Project name
RUN=LR__               # Run name
YEARMIN=1979		# start year
YEARMAX=1979           # end year
#PRJ=AK10              # for Kyusyu (.ks1) 
#RUN=LR__
#YEARMIN=2014
#YEARMAX=2014

SECINT=86400            # interval
LDBG=43420             # debugging point
#LDBG=5734
PRJMET=wfde
RUNMET=____
#PRJMET=AMeD
#RUNMET=AS1_
############################################################
# Expert Settings (Do not edit here unless you are an expert)
############################################################
SPNFLG=0                # spinup completion flag (1 for skip spinup)
SPNERR=0.05             # spinup error torrelance
SPNRAT=0.95             # spinup threshold
ENGBALC=1.0             # energy inbalance tolerance
WATBALC=0.1             # water inbalance tolerance
CNTC=1000               # maximum iteration
PROG=./main
############################################################
# Geographical Settings (edit here if you change spatial domain/resolution.
# Note that L (n0l) is prescribed in main.f. You also need to 
# edit main.f and re-compile it.)
############################################################
SUF=.hlf                # Suffix
MAP=.WFDEI              # Map

#SUF=.ko5                # for Korean peninsula (.ko5)
#MAP=.SNU

#SUF=.ks1                # for Kyusyu (.ks1)
#MAP=.kyusyu
############################################################
# Meteorological input (Edit here if you wish)
############################################################
    WIND=../../met/dat/Wind____/${PRJMET}${RUNMET}${SUF}DY
   RAINF=../../met/dat/Rainf___/${PRJMET}${RUNMET}${SUF}DY
   SNOWF=../../met/dat/Snowf___/${PRJMET}${RUNMET}${SUF}DY
    TAIR=../../met/dat/Tair____/${PRJMET}${RUNMET}${SUF}DY
    QAIR=../../met/dat/Qair____/${PRJMET}${RUNMET}${SUF}DY
      RH=NO
#    QAIR=NO
#      RH=../../met/dat/RH______/${PRJMET}${RUNMET}${SUF}DY
   PSURF=../../met/dat/PSurf___/${PRJMET}${RUNMET}${SUF}DY
  SWDOWN=../../met/dat/SWdown__/${PRJMET}${RUNMET}${SUF}DY
  LWDOWN=../../met/dat/LWdown__/${PRJMET}${RUNMET}${SUF}DY
############################################################
# Climate Change Input (Outdated. Do not edit here)
############################################################
    TCOR=NO
    PCOR=NO
    LCOR=NO
############################################################
# Climate Change Output Directory (Outdated. Do not edit here)
############################################################
 DIRTAIROUT=../../lnd/out/Tairout_
DIRRAINFOUT=../../lnd/out/Rainfout
DIRSNOWFOUT=../../lnd/out/Snowfout
DIRLWDOWNOUT=../../lnd/out/LWdownou
############################################################
# Climate Change Output (Outdated. Do not edit here)
############################################################
#
 TAIROUT=${DIRTAIROUT}/${PRJ}${RUN}${SUF}MO
RAINFOUT=${DIRRAINFOUT}/${PRJ}${RUN}${SUF}MO
SNOWFOUT=${DIRSNOWFOUT}/${PRJ}${RUN}${SUF}MO
LWDOWNOUT=${DIRLWDOWNOUT}/${PRJ}${RUN}${SUF}MO
#
TAIROUT=NO
RAINFOUT=NO
SNOWFOUT=NO
LWDOWNOUT=NO
############################################################
# Input Map (Edit here if you wish)
############################################################
   LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
  BALBEDO=../../map/dat/Albedo__/GSW2____${SUF}MM
############################################################
# Parameter (Edit here if you wish)
############################################################
SOILDEPTH=../../lnd/dat/uniform.1.00${SUF}
 FIELDCAP=../../lnd/dat/uniform.0.30${SUF}
     WILT=../../lnd/dat/uniform.0.15${SUF}
       CG=../../lnd/dat/uniform.13000.00${SUF}
       CD=../../lnd/dat/uniform.0.003${SUF}
    GAMMA=../../lnd/dat/gamma___/${PRJMET}${RUNMET}00000000${SUF}
      TAU=../../lnd/dat/tau_____/${PRJMET}${RUNMET}00000000${SUF}
  GWDEPTH=../../lnd/dat/uniform.1.00${SUF}
  GWYIELD=../../lnd/dat/uniform.0.30${SUF}
  GWGAMMA=../../lnd/dat/uniform.2.00${SUF}
    GWTAU=../../lnd/dat/uniform.100.00${SUF}
    GWRCF=../../lnd/dat/gwr_____/fg${SUF}
  GWRCMAX=../../lnd/dat/gwr_____/rgmax${SUF}
############################################################
# Initial Value (Edit here if you wish)
############################################################
SOILMOISTINI=../../lnd/ini/uniform.150.0${SUF}
 SOILTEMPINI=../../lnd/ini/uniform.283.15${SUF}
      SWEINI=../../lnd/ini/uniform.0.0${SUF}
 AVGSURFTINI=../../lnd/ini/uniform.283.15${SUF}
       GWINI=../../lnd/ini/uniform.0.0${SUF}
#
#SOILMOISTINI=../../lnd/out/SoilMois/${PRJ}${RUN}19851231${SUF}
# SOILTEMPINI=../../lnd/out/SoilTemp/${PRJ}${RUN}19851231${SUF}
# AVGSURFTINI=../../lnd/out/AvgSurfT/${PRJ}${RUN}19851231${SUF}
#      SWEINI=../../lnd/out/SWE_____/${PRJ}${RUN}19851231${SUF}
#       GWINI=../../lnd/out/GW______/${PRJ}${RUN}19851231${SUF}
############################################################
# Output Directory (Do not edit here unless you are an expert)
############################################################
    DIRSWNET=../../lnd/out/SWnet___
    DIRLWNET=../../lnd/out/LWnet___
       DIRQH=../../lnd/out/Qh______
      DIRQLE=../../lnd/out/Qle_____
       DIRQG=../../lnd/out/Qg______
       DIRQF=../../lnd/out/Qf______
       DIRQV=../../lnd/out/Qv______
     DIREVAP=../../lnd/out/Evap____
  DIRPOTEVAP=../../lnd/out/PotEvap_
       DIRQS=../../lnd/out/Qs______
      DIRQSB=../../lnd/out/Qsb_____
     DIRQTOT=../../lnd/out/Qtot____
DIRSOILMOIST=../../lnd/out/SoilMois
 DIRSOILTEMP=../../lnd/out/SoilTemp
      DIRSWE=../../lnd/out/SWE_____
 DIRAVGSURFT=../../lnd/out/AvgSurfT
  DIRSUBSNOW=../../lnd/out/SubSnow_
  DIRSALBEDO=../../lnd/out/SAlbedo_
       DIRGW=../../lnd/out/GW______
      DIRQBF=../../lnd/out/Qbf_____
      DIRQRC=../../lnd/out/Qrc_____
############################################################
# Output (Edit here if you wish)
############################################################
    SWNET=NO
    LWNET=NO
       QH=NO
      QLE=NO
       QG=NO
     EVAP=NO
  POTEVAP=NO
       QS=NO
      QSB=NO
     QTOT=NO
SOILMOIST=NO
 SOILTEMP=NO
      SWE=NO
 AVGSURFT=NO
  SUBSNOW=NO
  SALBEDO=NO
       GW=NO
      QBF=NO
      QRC=NO
#
    SWNET=${DIRSWNET}/${PRJ}${RUN}${SUF}MO
    LWNET=${DIRLWNET}/${PRJ}${RUN}${SUF}MO
       QH=${DIRQH}/${PRJ}${RUN}${SUF}MO
      QLE=${DIRQLE}/${PRJ}${RUN}${SUF}MO
       QG=${DIRQG}/${PRJ}${RUN}${SUF}MO
       QF=${DIRQF}/${PRJ}${RUN}${SUF}MO
       QV=${DIRQV}/${PRJ}${RUN}${SUF}MO
     EVAP=${DIREVAP}/${PRJ}${RUN}${SUF}DY
  POTEVAP=${DIRPOTEVAP}/${PRJ}${RUN}${SUF}DY
       QS=${DIRQS}/${PRJ}${RUN}${SUF}MO
      QSB=${DIRQSB}/${PRJ}${RUN}${SUF}MO
     QTOT=${DIRQTOT}/${PRJ}${RUN}${SUF}DY
SOILMOIST=${DIRSOILMOIST}/${PRJ}${RUN}${SUF}MO
 SOILTEMP=${DIRSOILTEMP}/${PRJ}${RUN}${SUF}MO
      SWE=${DIRSWE}/${PRJ}${RUN}${SUF}MO
 AVGSURFT=${DIRAVGSURFT}/${PRJ}${RUN}${SUF}MO
  SUBSNOW=${DIRSUBSNOW}/${PRJ}${RUN}${SUF}MO
  SALBEDO=${DIRSALBEDO}/${PRJ}${RUN}${SUF}MO
       GW=${DIRGW}/${PRJ}${RUN}${SUF}MO
      QBF=${DIRQBF}/${PRJ}${RUN}${SUF}MO
      QRC=${DIRQRC}/${PRJ}${RUN}${SUF}MO
############################################################
# Job (prepare directory)
############################################################
if [ ! -d ../../lnd/out ]; then mkdir ../../lnd/out; fi
if [ ! -d $DIRSWNET     ]; then mkdir $DIRSWNET;     fi
if [ ! -d $DIRLWNET     ]; then mkdir $DIRLWNET;     fi
if [ ! -d $DIRQH        ]; then mkdir $DIRQH;        fi
if [ ! -d $DIRQLE       ]; then mkdir $DIRQLE;       fi
if [ ! -d $DIRQG        ]; then mkdir $DIRQG;        fi
if [ ! -d $DIRQF        ]; then mkdir $DIRQF;        fi
if [ ! -d $DIRQV        ]; then mkdir $DIRQV;        fi
if [ ! -d $DIREVAP      ]; then mkdir $DIREVAP;      fi
if [ ! -d $DIRPOTEVAP   ]; then mkdir $DIRPOTEVAP;   fi
if [ ! -d $DIRQS        ]; then mkdir $DIRQS;        fi
if [ ! -d $DIRQSB       ]; then mkdir $DIRQSB;       fi
if [ ! -d $DIRQTOT      ]; then mkdir $DIRQTOT;      fi
if [ ! -d $DIRSOILMOIST ]; then mkdir $DIRSOILMOIST; fi
if [ ! -d $DIRSOILTEMP  ]; then mkdir $DIRSOILTEMP;  fi
if [ ! -d $DIRSWE       ]; then mkdir $DIRSWE;       fi
if [ ! -d $DIRAVGSURFT  ]; then mkdir $DIRAVGSURFT;  fi
if [ ! -d $DIRSUBSNOW   ]; then mkdir $DIRSUBSNOW;   fi
if [ ! -d $DIRSALBEDO   ]; then mkdir $DIRSALBEDO;   fi
if [ ! -d $DIRGW        ]; then mkdir $DIRGW;        fi
if [ ! -d $DIRQBF       ]; then mkdir $DIRQBF;       fi
if [ ! -d $DIRQRC       ]; then mkdir $DIRQRC;       fi
############################################################
# Job (prepare directory)
############################################################
if [ ! -d $DIRTAIROUT   ]; then  mkdir -p  $DIRTAIROUT;   fi
if [ ! -d $DIRRAINFOUT  ]; then  mkdir -p  $DIRRAINFOUT;  fi
if [ ! -d $DIRSNOWFOUT  ]; then  mkdir -p  $DIRSNOWFOUT;  fi
if [ ! -d $DIRLWDOWNOUT ]; then  mkdir -p  $DIRLWDOWNOUT; fi
############################################################
# Job (Making Log file)
############################################################
DATE=`date +"%Y%m%d"`
DIRLOG=../../lnd/log
if [ ! -d $DIRLOG ]; then
  mkdir $DIRLOG
fi
LOGFILE=${DIRLOG}/${PRJ}${RUN}${DATE}.log
############################################################
# Job (Making Setting file)
############################################################
DIRSET=../../lnd/set
if [ ! -d $DIRSET ]; then
  mkdir $DIRSET
fi
SETFILE=${DIRSET}/${PRJ}${RUN}${DATE}.set
#
if [ -f $SETFILE ]; then
  rm $SETFILE
fi
#
cat <<EOF>> $SETFILE
&setlnd
i0yearmin=$YEARMIN
i0yearmax=$YEARMAX
i0secint=$SECINT
i0ldbg=$LDBG
i0cntc=$CNTC

i0spnflg=$SPNFLG
r0spnerr=$SPNERR
r0spnrat=$SPNRAT
r0engbalc=$ENGBALC
r0watbalc=$WATBALC

c0lndmsk='$LNDMSK'
c0soildepth='$SOILDEPTH'
c0w_fieldcap='$FIELDCAP'
c0w_wilt='$WILT'
c0cg='$CG'
c0cd='$CD'
c0gamma='$GAMMA'
c0tau='$TAU'
c0balbedo='$BALBEDO'
c0gwdepth='$GWDEPTH'
c0w_gwyield='$GWYIELD'
c0gwgamma='$GWGAMMA'
c0gwtau='$GWTAU'
c0gwrcf='$GWRCF'
c0gwrcmax='$GWRCMAX'

c0wind='$WIND'
c0rainf='$RAINF'
c0snowf='$SNOWF'
c0tair='$TAIR'
c0qair='$QAIR'
c0rh='$RH'
c0psurf='$PSURF'
c0swdown='$SWDOWN'
c0lwdown='$LWDOWN'

c0soilmoist='$SOILMOIST'
c0soiltemp='$SOILTEMP'
c0avgsurft='$AVGSURFT'
c0swe='$SWE'

c0swnet='$SWNET'
c0lwnet='$LWNET'
c0qh='$QH'
c0qle='$QLE'
c0qg='$QG'
c0qf='$QF'
c0qv='$QV'

c0evap='$EVAP'
c0qs='$QS'
c0qsb='$QSB'
c0qtot='$QTOT'
c0potevap='$POTEVAP'

c0soilmoistini='$SOILMOISTINI'
c0soiltempini='$SOILTEMPINI'
c0avgsurftini='$AVGSURFTINI'
c0sweini='$SWEINI'
c0gwini='$GWINI'

c0subsnow='$SUBSNOW'
c0salbedo='$SALBEDO'

c0qrc='$QRC'
c0qbf='$QBF'
c0gw='$GW'

c0tcor='$TCOR'
c0pcor='$PCOR'
c0lcor='$LCOR'
c0tairout='$TAIROUT'
c0rainfout='$RAINFOUT'
c0snowfout='$SNOWFOUT'
c0lwdownout='$LWDOWNOUT'

&end
EOF
############################################################
# Job (Start program)
############################################################
echo "$PROG $SETFILE > $LOGFILE 2>&1 &"
      $PROG $SETFILE > $LOGFILE 2>&1 &
echo "$PROG: See [$LOGFILE] to check the execusion. For example by,"
echo "% tail -f $LOGFILE"
