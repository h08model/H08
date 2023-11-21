#!/bin/sh
############################################################
#to   run river model
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Basic Settings (Edit here if you wish)
############################################################
PRJ=WFDE
RUN=LR__
#PRJ=AK10
#RUN=LR__
#PRJ=mesc
YEARMIN=1979
YEARMAX=1979
#YEARMIN=2014
#YEARMAX=2014
SECINT=86400
LDBG=27641
#LDBG=5734  # must be smaller than L. (regional)
############################################################
# Expert Settings (Do not edit here unless you are an expert)
############################################################
SPNFLG=0
SPNERR=0.05
SPNRAT=0.95
PROG=./main
############################################################
# Geography (Edit here if you change spatial domain/resolution.
# Note that L (n0l) is prescribed in main.f. You also need to
# edit main.f and re-compile it.)
############################################################
MAP=.WFDEI    # for Global 2018 (.hlf)
SUF=.hlf
 
#MAP=.SNU     # for Korean peninsula (.ko5)
#SUF=.ko5

#MAP=.kyusyu  # for Kyusyu (.ks1)
#SUF=.ks1
############################################################
# Hydrological Input (Edit here if you wish)
############################################################
#QTOT=../../met/dat/Qtot____/${PRJ}${RUN}${SUF}DY   # Total runoff
QTOT=../../lnd/out/Qtot____/${PRJ}${RUN}${SUF}DY   # Total runoff
############################################################
# Map (Do not edit here unless you are an expert)
############################################################
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}	# River sequence
RIVNXL=../../map/out/riv_nxl_/rivnxl${MAP}${SUF}	# Next grid
RIVNXD=../../map/out/riv_nxd_/rivnxd${MAP}${SUF}	# Distance to next grid
LNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}	# Land area
############################################################
# Output Directory (Do not edit here unless you are an expert)
############################################################
DIRRIVSTO=../../riv/out/riv_sto_
DIRRIVOUT=../../riv/out/riv_out_
############################################################
# Output (Edit here if you wish)
############################################################
RIVSTO=${DIRRIVSTO}/${PRJ}${RUN}${SUF}MO # River storage
RIVOUT=${DIRRIVOUT}/${PRJ}${RUN}${SUF}MO # River discharge
############################################################
# Parameter (Edit here if you wish)
############################################################
FLWVEL=../../riv/dat/uniform.0.5${SUF}       # Flow velocity
MEDRAT=../../riv/dat/uniform.1.4${SUF}       # Meandering ratio
############################################################
# Initial condition  (Edit here if you wish)
############################################################
RIVSTOINI=../../riv/ini/uniform.0.0${SUF}	# Initial river storage
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d $DIRRIVSTO    ]; then mkdir -p $DIRRIVSTO;    fi
if [ ! -d $DIRRIVOUT    ]; then mkdir -p $DIRRIVOUT;    fi
############################################################
# Job (Making Log file)
############################################################
DATE=`date +"%Y%m%d"`
DIRLOG=../../riv/log
if [ ! -d $DIRLOG ]; then
  mkdir $DIRLOG
fi
LOGFILE=${DIRLOG}/${PRJ}${RUN}${DATE}.log
############################################################
# Job (Making Setting file)
############################################################
DIRSET=../../riv/set
if [ ! -d $DIRSET ]; then
  mkdir $DIRSET
fi
SETFILE=${DIRSET}/${PRJ}${RUN}${DATE}.set
if [ -f $SETFILE ]; then
  rm $SETFILE
fi
cat << EOF >> $SETFILE
&setriv
i0yearmin=$YEARMIN
i0yearmax=$YEARMAX
i0ldbg=$LDBG
i0secint=$SECINT
c0qtot='$QTOT'
c0rivsto='$RIVSTO'
c0rivout='$RIVOUT'
c0rivstoini='$RIVSTOINI'
c0rivseq='$RIVSEQ'
c0rivnxl='$RIVNXL'
c0rivnxd='$RIVNXD'
c0lndara='$LNDARA'
c0flwvel='$FLWVEL'
c0medrat='$MEDRAT'
i0spnflg=$SPNFLG
r0spnerr=$SPNERR
r0spnrat=$SPNRAT
&end
EOF
############################################################
# Job (Start)
############################################################
echo "$PROG $SETFILE > $LOGFILE 2>&1 &"
      $PROG $SETFILE > $LOGFILE 2>&1 &
echo "$PROG: See [$LOGFILE] to check the execusion. For example by,"
echo "% tail -f $LOGFILE"

