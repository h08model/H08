#!/bin/sh
############################################################
#to   prepare optimal parameter file
#by   2015/10/6, hanasaki
#
#     before editing and running this script,
#     complete mulitple-parameter simulation and validation.
#
############################################################
# settings (esit below)
############################################################
S_PRJ=GSW2
I_IDS="7 4 2 9 10 3 1 8 6 5"  # sort by catchment area order
#
R_DEFSD=1.0     # default parameter for SD
R_DEFCD=0.003   # default parameter for CD
R_DEFGAMMA=2.0  # default parameter for GAMMA
R_DEFTAU=100.0  # default parameter for TAU
#
############################################################
# geography (edit below)
############################################################
I_L=11088
S_SUF=.ko5
S_MAP=.SNU
F_L2X=../../map/dat/l2x_l2y_/l2x${S_SUF}.txt
F_L2Y=../../map/dat/l2x_l2y_/l2y${S_SUF}.txt 
XY="84 132"
LONLAT="124 131 33 44"
#
S_ARG="$I_L $XY $F_L2X $F_L2Y $LONLAT"
############################################################
# input 
############################################################
F_LSTSD=../../lnd/dat/par_lst_/${S_PRJ}.sd.txt         # par. option of SD
F_LSTCD=../../lnd/dat/par_lst_/${S_PRJ}.cd.txt         # par. option of CD
F_LSTGAMMA=../../lnd/dat/par_lst_/${S_PRJ}.gamma.txt   # par. option of GAMMA
F_LSTTAU=../../lnd/dat/par_lst_/${S_PRJ}.tau.txt       # par. option of TAU
#
F_FLWDIR=../../map/dat/flw_dir_/flwdir${S_MAP}${S_SUF}
F_RIVSEQ=../../map/out/riv_seq_/rivseq${S_MAP}${S_SUF}
F_RIVNUM=../../map/out/riv_num_/rivnum${S_MAP}${S_SUF}
#
F_PARCMB=../../riv/out/par_cmb_/${S_PRJ}.txt       # opt.par. combination
F_STNLST=../../riv/dat/stn_lst_/stnlst${S_MAP}.txt         # station list
############################################################
# out
############################################################
F_SD=../../lnd/dat/${S_PRJ}.sd${S_SUF}
F_CD=../../lnd/dat/${S_PRJ}.cd${S_SUF}
F_GAMMA=../../lnd/dat/${S_PRJ}.gamma${S_SUF}
F_TAU=../../lnd/dat/${S_PRJ}.tau${S_SUF}
#
D_SUBBSN=../../map/out/sub_bsn_      # directory for sub-basin mask
if [ ! -d $D_SUBBSN ]; then mkdir -p $D_SUBBSN; fi
############################################################
# initialize (fill parameter file with the default value)
############################################################
htcreate $I_L $R_DEFSD    $F_SD
htcreate $I_L $R_DEFCD    $F_CD
htcreate $I_L $R_DEFGAMMA $F_GAMMA
htcreate $I_L $R_DEFTAU   $F_TAU
############################################################
# job
############################################################
for I_ID in $I_IDS; do
#
# extract basic information from station list file
#
  I_ID8=`echo $I_ID | awk '{printf("%8.8d",$1)}'`
  R_LON=`awk '($1=="'$I_ID'"){print $7}' $F_STNLST`       # need check
  R_LAT=`awk '($1=="'$I_ID'"){print $8}' $F_STNLST`       # need check
  S_NAME=`awk '($1=="'$I_ID'"){print $2}' $F_STNLST`      # need check
  echo -----------------
  echo Preparing $S_NAME
#
# make basin mask
#
  F_SUBBSN=${D_SUBBSN}/________${I_ID8}${S_SUF}
  htcatchment $S_ARG lonlat $F_FLWDIR $F_RIVSEQ $F_RIVNUM $F_SUBBSN $R_LON $R_LAT 
  echo Sub-basin mask file made: $F_SUBBSN
#
# extract the best parameter combination from list file (e.g. AAAA)
#
  R_PARCMB=`awk '($1=="'$I_ID'"){print $3}' $F_PARCMB`
  echo Optimum parameter combination: $R_PARCMB
#
# value look up parameter values from parameter option files
#
  C=`echo $R_PARCMB | awk '{c=substr($1,1,1); print c} '`
  R_SD=`awk '($1=="'$C'"){print $2}' $F_LSTSD`
  C=`echo $R_PARCMB | awk '{c=substr($1,2,1); print c} '`
  R_CD=`awk '($1=="'$C'"){print $2}' $F_LSTCD`
  C=`echo $R_PARCMB | awk '{c=substr($1,3,1); print c} '`
  R_GAMMA=`awk '($1=="'$C'"){print $2}' $F_LSTGAMMA`
  C=`echo $R_PARCMB | awk '{c=substr($1,4,1); print c} '`
  R_TAU=`awk '($1=="'$C'"){print $2}' $F_LSTTAU`
  echo SD $R_SD
  echo CD $R_CD
  echo GAMMA $R_GAMMA
  echo TAU $R_TAU
#
# replace parameter value for sub-basins
#
#echo htmaskrplc  $S_ARG $F_SD    $F_SUBBSN eq 1 $R_SD    $F_SD    #> /dev/null
  htmaskrplc  $S_ARG $F_SD    $F_SUBBSN eq 1 $R_SD    $F_SD    #> /dev/null
  htmaskrplc  $S_ARG $F_CD    $F_SUBBSN eq 1 $R_CD    $F_CD    > /dev/null
  htmaskrplc  $S_ARG $F_GAMMA $F_SUBBSN eq 1 $R_GAMMA $F_GAMMA > /dev/null
  htmaskrplc  $S_ARG $F_TAU   $F_SUBBSN eq 1 $R_TAU   $F_TAU   > /dev/null
done