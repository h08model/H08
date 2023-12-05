#!/bin/sh
############################################################
#to   run crop model
#by   2010/03/31, hanasaki, NIES: H08ver1.0
#
#if job scheduling and management system is installed in your environment (e.g. OpenPBS, TORQUE, etc.), please change "cat<<EOF>>$SET???" into "cat>>$SET???<<EOF".
############################################################
# Basic settings (Choose one)
############################################################
JOBS="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19"
#JOBS="2nd"
############################################################
# Basic settings (Edit here if you change settings)
############################################################
PRJ=WFDE
RUN=__C_
#PRJ=AK10
#RUN=LR__
#RUN=__C_
PRJMET=wfde           # for Global 2018
RUNMET=____           # for Global 2018
#PRJMET=AMeD          # for Kyusyu 2022
#RUNMET=AS1_          # for Kyusyu 2022
YEAR=0000
LDBG=27641            # Debugging point (L coordinate)
#LDBG=5734
############################################################
# Basic settings (Do not edit here basically)
############################################################
SECINT=86400          # Interval: Do not change!
RAMDBG=12             # Debugging crop type: No need to change! 
PROG=main             # Program: No need to change!
############################################################
# Geography (Edit here if you change spatial domain/resolution.
# Note that L (n0l) is prescribed in main.f. You also need to
# edit main.f and re-compile it.)
############################################################
L=259200
SUF=.hlf
MAP=.WFDEI

#L=11088       # for Korean peninsula 2018
#SUF=.ko5
#MAP=.SNU

#L=32400        # for Kyusyu 2022
#SUF=.ks1
#MAP=.kyusyu

############################################################
# Input (Edit here if you change settings)
#
# You can calculate PotEvap in two ways.
# 1) lnd/bin/main.sh
#
#    This is good for standard global simulations, but...
#
# 2) lnd/bin/main_fix.sh
#
#    This is better for virtual water calculation, because ...
#
############################################################
   TAIR=../../met/dat/Tair____/${PRJMET}${RUNMET}${SUF}DY
 SWDOWN=../../met/dat/SWdown__/${PRJMET}${RUNMET}${SUF}DY
POTEVAP=../../lnd/out/PotEvap_/${PRJ}LR__${SUF}DY
#POTEVAP=../../lnd/out/PotEvap_/${PRJ}NR__${SUF}DY  # see above note
   EVAP=../../lnd/out/Evap____/${PRJ}LR__${SUF}DY
############################################################
# Climate change input (Edit here if you change settings)
############################################################
   TCOR=NO
############################################################
# Climate change output directory (Edit here if you change settings)
############################################################
DIRTAIROUT=../../crp/out/Tairout_
############################################################
# Climate change output (Edit here if you change settings)
############################################################
TAIROUT=NO
############################################################
# Map (Edit here if you change settings)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
#CRPTYP2ND=../../map/out/crp_typ2/M08_____20000000${SUF} # only for JOB=2nd
#CRPTYP1ST=../../map/org/KYUSYU/crp_typ_first${SUF}
CRPTYP2ND=../../map/org/KYUSYU/crp_typ_second${SUF} # only for KYUSYU JOB=2nd   
############################################################
# Initial value (Do not edit here basically)
############################################################
if [ ! -d ../ini ]; then mkdir ../ini; fi
htcreate $L 0.0 ../ini/uniform.0.0${SUF}
BTINI=../ini/uniform.0.0${SUF}
RSDINI=../ini/uniform.0.0${SUF}
OUTBINI=../ini/uniform.0.0${SUF}
HUNAINI=../ini/uniform.0.0${SUF}
SWUINI=../ini/uniform.0.0${SUF}
SWPINI=../ini/uniform.0.0${SUF}
REGFWINI=../ini/uniform.0.0${SUF}
REGFLINI=../ini/uniform.0.0${SUF}
REGFHINI=../ini/uniform.0.0${SUF}
REGFNINI=../ini/uniform.0.0${SUF}
REGFPINI=../ini/uniform.0.0${SUF}
############################################################
# Parameter: SWIM official (Do not change here basically)
############################################################
RAM2SWIM=../../crp/org/SWIM/ram2swim.txt
RAM2NAME=../../crp/org/SWIM/ram2name.txt
SWIM2RAM=../../crp/org/SWIM/swim2ram.txt
  CRPPAR=../../crp/org/SWIM/crppar.txt
############################################################
# Parameter: H08 local (Change here if you change settings)
############################################################
DAYMAV=10
INTCRPDAYMAX=300  
REGFMIN=0.7 
TDORM=5.0 
TFRZ=-10.0 
HUNMAX=12.5 
IHUNMAT=0.95 
TSAW=10.0 
THVS=10.0
OPTTS=yes 
OPTWS=yes 
OPTNS=no
OPTPS=no 
OPTFRZ=yes 
############################################################
# Job (Preparing directory)
############################################################
if [ ! -d $DIRTAIROUT ]; then  mkdir -p $DIRTAIROUT; fi
############################################################
# Job (Making log file)
############################################################
DATE=`date +"%Y%m%d"`
DIRLOG=../log
if [ ! -d $DIRLOG ]; then
  mkdir -p $DIRLOG
fi
LOGFILE=${DIRLOG}/${PRJ}${RUN}${DATE}.log
############################################################
# Job (Making Setting file)
############################################################
DIRSET=../set
if [ ! -d $DIRSET ]; then
  mkdir -p $DIRSET
fi
SETFILE=${DIRSET}/${PRJ}${RUN}${DATE}.set
############################################################
# Job (Caution! some in/out defined here)
############################################################
for JOB in $JOBS; do
  if [ $JOB = "2nd" ]; then
#
# input
#
       CRPTYP=$CRPTYP2ND
    DOYOCUINI=../../crp/out/ocu_ini_/${PRJ}${RUN}${YEAR}0000${SUF}
    DOYOCUEND=../../crp/out/ocu_end_/${PRJ}${RUN}${YEAR}0000${SUF}
#
# output directory
#
       DIRYLDMAV=../../crp/out/mav_2nd_
       DIRYLDMAX=../../crp/out/yld_2nd_
        DIRBTMAV=../../crp/out/mab_2nd_
        DIRBTMAX=../../crp/out/bt__2nd_
    DIRPLTDOYMAX=../../crp/out/plt_2nd_
    DIRHVSDOYMAX=../../crp/out/hvs_2nd_
    DIRCRPDAYMAX=../../crp/out/crp_2nd_
        DIRREGFD=../../crp/out/reg_2nd_
    DIRCWSGRNMAX=../../crp/out/cwsg2nd_
    DIRCWSBLUMAX=../../crp/out/cwsb2nd_
  else
#
# input
#
       CRPTYP=temp.crptyp${SUF}
    DOYOCUINI=temp.doyocuini${SUF}
    DOYOCUEND=temp.doyocuend${SUF}
    htcreate $L $JOB $CRPTYP
    htcreate $L 0 $DOYOCUINI
    htcreate $L 0 $DOYOCUEND
#
# output directory
#
    CRPNAM=`awk '{print $'"$JOB"'}' $RAM2NAME`
       DIRYLDMAV=../../crp/out/mav_${CRPNAM}
       DIRYLDMAX=../../crp/out/yld_${CRPNAM}
        DIRBTMAV=../../crp/out/mab_${CRPNAM}
        DIRBTMAX=../../crp/out/bt__${CRPNAM}
    DIRPLTDOYMAX=../../crp/out/plt_${CRPNAM}
    DIRHVSDOYMAX=../../crp/out/hvs_${CRPNAM}
    DIRCRPDAYMAX=../../crp/out/crp_${CRPNAM}
        DIRREGFD=../../crp/out/reg_${CRPNAM}
    DIRCWSGRNMAX=../../crp/out/cwsg${CRPNAM}
    DIRCWSBLUMAX=../../crp/out/cwsb${CRPNAM}
  fi
#
# output
#
         YLDMAV=${DIRYLDMAV}/${PRJ}${RUN}${SUF}DY
         YLDMAX=${DIRYLDMAX}/${PRJ}${RUN}${SUF}YR
          BTMAV=${DIRBTMAV}/${PRJ}${RUN}${SUF}DY
          BTMAX=${DIRBTMAX}/${PRJ}${RUN}${SUF}YR
      PLTDOYMAX=${DIRPLTDOYMAX}/${PRJ}${RUN}${SUF}YR
      HVSDOYMAX=${DIRHVSDOYMAX}/${PRJ}${RUN}${SUF}YR
  FILECRPDAYMAX=${DIRCRPDAYMAX}/${PRJ}${RUN}${SUF}YR
       REGFDMAX=${DIRREGFD}/${PRJ}${RUN}${SUF}YR
      CWSGRNMAX=${DIRCWSGRNMAX}/${PRJ}${RUN}${SUF}YR
      CWSBLUMAX=${DIRCWSBLUMAX}/${PRJ}${RUN}${SUF}YR
#
# prepare directory
#
  if [ ! -d $DIRYLDMAV    ]; then    mkdir -p $DIRYLDMAV;    fi
  if [ ! -d $DIRYLDMAX    ]; then    mkdir -p $DIRYLDMAX;    fi
  if [ ! -d $DIRBTMAV     ]; then    mkdir -p $DIRBTMAV;     fi
  if [ ! -d $DIRBTMAX     ]; then    mkdir -p $DIRBTMAX;     fi
  if [ ! -d $DIRPLTDOYMAX ]; then    mkdir -p $DIRPLTDOYMAX; fi
  if [ ! -d $DIRHVSDOYMAX ]; then    mkdir -p $DIRHVSDOYMAX; fi
  if [ ! -d $DIRCRPDAYMAX ]; then    mkdir -p $DIRCRPDAYMAX; fi
  if [ ! -d $DIRREGFD     ]; then    mkdir -p $DIRREGFD;     fi
  if [ ! -d $DIRCWSGRNMAX ]; then    mkdir -p $DIRCWSGRNMAX; fi
  if [ ! -d $DIRCWSBLUMAX ]; then    mkdir -p $DIRCWSBLUMAX; fi
#
# setting file
#
  echo "$PROG: Making SETfile [$SETFILE]."
  if [ -f $SETFILE ]; then
    rm $SETFILE
  fi
#
  cat << EOF >> $SETFILE
&setcrp
i0year=$YEAR
i0secint=$SECINT
i0ldbg=$LDBG
i0ramdbg=$RAMDBG
i0daymav=$DAYMAV
i0crpdaymax=$INTCRPDAYMAX
r0regfmin=$REGFMIN
r0tdorm=$TDORM
r0tfrz=$TFRZ
r0hunmax=$HUNMAX
r0ihunmat=$IHUNMAT
r0tsaw=$TSAW
r0thvs=$THVS
c0optts='$OPTTS'
c0optws='$OPTWS'
c0optns='$OPTNS'
c0optps='$OPTPS'
c0optfrz='$OPTFRZ'
c0lndmsk='$LNDMSK'
c0crptyp='$CRPTYP'
c0doyocuini='$DOYOCUINI'
c0doyocuend='$DOYOCUEND'
c0ram2swim='$RAM2SWIM'
c0swim2ram='$SWIM2RAM'
c0crppar='$CRPPAR'
c0tair='$TAIR'
c0swdown='$SWDOWN'
c0potevap='$POTEVAP'
c0evap='$EVAP'
c0tcor='$TCOR'
c0tairout='$TAIROUT'
c0hunaini='$HUNAINI'
c0swuini='$SWUINI'
c0swpini='$SWPINI'
c0regfwini='$REGFWINI'
c0regflini='$REGFLINI'
c0regfhini='$REGFHINI'
c0regfnini='$REGFNINI'
c0regfpini='$REGFPINI'
c0btini='$BTINI'
c0rsdini='$RSDINI'
c0outbini='$OUTBINI'
c0yldmav='$YLDMAV'
c0yldmax='$YLDMAX'
c0btmav='$BTMAV'
c0btmax='$BTMAX'
c0regfdmax='$REGFDMAX'
c0pltdoymax='$PLTDOYMAX'
c0hvsdoymax='$HVSDOYMAX'
c0crpdaymax='$FILECRPDAYMAX'
c0cwsgrnmax='$CWSGRNMAX'
c0cwsblumax='$CWSBLUMAX'
&end
EOF
#
# run
#
  echo "$PROG $SETFILE > $LOGFILE 2>&1"
        $PROG $SETFILE > $LOGFILE 2>&1
  echo "$PROG: See [$LOGFILE] to check the execusion. For example by,"
  echo "% tail -f $LOGFILE"
done
