#!/bin/sh
############################################################
#to   prepare dam data
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Setting (Edit here)
############################################################
#
PRJ=H06_            # Project name
RUN=____            # Run name
YEARDAM=2000        # Dams completed by this year is included.
LST=../../map/org/H06/damlst.WFDEI.hlf.txt
#LST=../../map/org/KYUSYU/dam/damlst.kyusyu.ks1.txt
PRJ=GRan            # Project name
#PRJ=KYSY
YEARDAM=2000        # Dams completed by this year is included.
#
RUNS="D_L_ D_M_"
############################################################
# Geography (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=$L2XHLF
L2Y=$L2YHLF
LONLAT="-180 180 -90 90"
SUF=.hlf
ARG="$L $XY $L2X $L2Y $LONLAT"
MAP=.WFDEI
LDBG=1

#5min x 5min for Korean Peninsula (.ko5)
#L=11088
#XY="84 132"
#L2X=$L2XKO5
#L2Y=$L2YKO5
#LONLAT="124 131 33 44"
#SUF=.ko5
#ARG="$L $XY $L2X $L2Y $LONLAT"
#MAP=.kyusyu
#LDBG=1

#1min x 1min for Kyusyu (.ks1)
#L=32400
#XY="180 180"
#L2X=$L2XKS1
#L2Y=$L2YKS1
#LONLAT="129 132 31 34"
#SUF=.ks1
#ARG="$L $XY $L2X $L2Y $LONLAT"
#MAP=.kyusyu
#LDBG=5734

############################################################
# Input (Do not edit here unless you are an expert)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
GRDARA=../../map/dat/grd_ara_/grdara${SUF}
LOG=temp.log
############################################################
# Job (make directory)
############################################################
DIRDAMCAP=../../map/dat/dam_cap_
DIRDAMCAT=../../map/dat/dam_cat_
DIRDAMID_=../../map/dat/dam_id__
DIRDAMNUM=../../map/dat/dam_num_
DIRDAMPRP=../../map/dat/dam_prp_
DIRDAMSRF=../../map/dat/dam_srf_
DIRDAMYR_=../../map/dat/dam_yr__
DIRDAMAFC=../../map/dat/dam_afc_
#
if [ ! -d $DIRDAMCAP ]; then mkdir -p $DIRDAMCAP; fi
if [ ! -d $DIRDAMCAT ]; then mkdir -p $DIRDAMCAT; fi
if [ ! -d $DIRDAMID_ ]; then mkdir -p $DIRDAMID_; fi
if [ ! -d $DIRDAMNUM ]; then mkdir -p $DIRDAMNUM; fi
if [ ! -d $DIRDAMPRP ]; then mkdir -p $DIRDAMPRP; fi
if [ ! -d $DIRDAMSRF ]; then mkdir -p $DIRDAMSRF; fi
if [ ! -d $DIRDAMYR_ ]; then mkdir -p $DIRDAMYR_; fi
if [ ! -d $DIRDAMAFC ]; then mkdir -p $DIRDAMAFC; fi
############################################################
# Job (loop &  condition setting)
############################################################
for RUN in $RUNS; do
  if [ $RUN = "D_L_" ]; then
    LST=../../map/org/GRanD/GRanD_L.txt
  elif [ $RUN = "D_M_" ]; then
    LST=../../map/org/GRanD/GRanD_M.txt
  else
    echo "$RUN not supported."
    exit
  fi
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
  DAMCAP=${DIRDAMCAP}/${PRJ}${RUN}${YEARDAM}0000${SUF}
  DAMCAT=${DIRDAMCAT}/${PRJ}${RUN}${YEARDAM}0000${SUF}
  DAMID_=${DIRDAMID_}/${PRJ}${RUN}${YEARDAM}0000${SUF}
  DAMNUM=${DIRDAMNUM}/${PRJ}${RUN}${YEARDAM}0000${SUF}
  DAMPRP=${DIRDAMPRP}/${PRJ}${RUN}${YEARDAM}0000${SUF}
  DAMSRF=${DIRDAMSRF}/${PRJ}${RUN}${YEARDAM}0000${SUF}
  DAMYR_=${DIRDAMYR_}/${PRJ}${RUN}${YEARDAM}0000${SUF}
  DAMAFC=${DIRDAMAFC}/${PRJ}${RUN}${YEARDAM}0000${SUF}
############################################################
# Job  (generate files)
############################################################
  prog_damgrd $L $XY $L2X $L2Y $LONLAT $LST $DAMNUM $DAMCAP $DAMCAT $DAMID_ $DAMPRP $DAMSRF $DAMYR_ $YEARDAM $LNDMSK $LDBG         >  $LOG
#
  htmath     $L div $DAMCAT $GRDARA $DAMAFC
  htmaskrplc $ARG $DAMAFC $DAMAFC gt 1.0 1.0 $DAMAFC >> $LOG
done
#
echo Log: $LOG
