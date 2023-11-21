#!/bin/sh
############################################################
#to   prepare AQUASTAT data
#by   2011/04/04, hanasaki, NIES: H08ver1.0
#
# Source:
#
#  FAO AQUASTAT
#  http://www.fao.org/nr/water/aquastat/main/index.stm
#
############################################################
# Preparation
############################################################
#
# For users:
# please download map-org-AQUASTAT.tar.gz from H08 file server
#
# How I prepared map-org-AQUASTAT.tar.gz
#
# 1) I visited the web site of AQUASTAT 
#   (http://www.fao.org/nr/water/aquastat/main/index.stm)
# 2) I downloaded csv file with the following options
#    Agricultural: all countries, all period, x:year, y:countries
#    (Do not show value years and data symbols)
# 3) I opened the file with MS Excel.
# 4) I filled blank cells with -9999 by developing a simple macro.
# 5) I converted " " and "'" with "_".
# 6) I removed footer (e.g. F-FAO estimate, L-Modelled data, copyright)
#    (Do not remove header)
# 7) I saved as tab separated text, entitled agricultural.txt.
# 8) I repeated 2)-7) for industrial and municipal water.
#
############################################################
# Setting (Edit here) 
############################################################
JOBS="agr ind dom"       # agr for agricultural water withdrawal
YEAR=2000
OPT=latest  # latest for latest data for $YEAR, exact for exact data for $YEAR
############################################################
# Geography (Edit here if you change spatial domain/resolution)
############################################################
L=259200
SUF=.hlf
############################################################
# Input (Do not change here unless you are an expert)
############################################################
DIRORG=../org/AQUASTAT
#
MSK=../dat/nat_msk_/C05_____20000000${SUF}
COD=../dat/nat_cod_/C05_____20000000.txt
#
LOG=temp.log
############################################################
# Job
############################################################
for JOB in $JOBS; do

  if [ "$JOB" = "agr" ]; then
    DIRWIT=../dat/wit_agr_
    DIRDEM=../dat/dem_agr_
    LSTWIT=${DIRWIT}/AQUASTAT${YEAR}0000.lst
    TXTWIT=${DIRWIT}/AQUASTAT${YEAR}0000.txt
    BINWIT=${DIRWIT}/AQUASTAT${YEAR}0000${SUF}
    LSTDEM=${DIRDEM}/AQUASTAT${YEAR}0000.lst
    BINDEM=${DIRDEM}/AQUASTAT${YEAR}0000${SUF}
    ORG=${DIRORG}/agricultural.txt
    WGT=../dat/irg_ara_/S05_____20000000${SUF}
  elif [ "$JOB" = "ind" ]; then
    DIRWIT=../dat/wit_ind_
    DIRDEM=../dat/dem_ind_
    LSTWIT=${DIRWIT}/AQUASTAT${YEAR}0000.lst
    TXTWIT=${DIRWIT}/AQUASTAT${YEAR}0000.txt
    BINWIT=${DIRWIT}/AQUASTAT${YEAR}0000${SUF}
    LSTDEM=${DIRDEM}/AQUASTAT${YEAR}0000.lst
    BINDEM=${DIRDEM}/AQUASTAT${YEAR}0000${SUF}
    ORG=${DIRORG}/industrial.txt
    WGT=../dat/pop_tot_/C05_a___20000000${SUF}
    FACTOR=0.10
  elif [ "$JOB" = "dom" ]; then
    DIRWIT=../dat/wit_dom_
    DIRDEM=../dat/dem_dom_
    LSTWIT=${DIRWIT}/AQUASTAT${YEAR}0000.lst
    TXTWIT=${DIRWIT}/AQUASTAT${YEAR}0000.txt
    BINWIT=${DIRWIT}/AQUASTAT${YEAR}0000${SUF}
    LSTDEM=${DIRDEM}/AQUASTAT${YEAR}0000.lst
    BINDEM=${DIRDEM}/AQUASTAT${YEAR}0000${SUF}
    ORG=${DIRORG}/municipal.txt
    WGT=../dat/pop_tot_/C05_a___20000000${SUF}
    FACTOR=0.15
  fi

  if [ ! -d $DIRWIT ]; then
    mkdir -p $DIRWIT
  fi
  #
  # convert original list into hformatted list
  #
  prog_map_AQUASTAT  $ORG $LSTWIT $YEAR $OPT
  #
  # convert list into 2D binary
  #
  htlist2bin $L $LSTWIT $MSK $COD $BINWIT weight $WGT > $LOG
  #
  # change unit from km3/yr to kg/s
  #
  htmath $L div $BINWIT 0.000031536 $BINWIT
  #
  # convert 2D binary into list
  #
  htbin2list $L $BINWIT $MSK $COD $TXTWIT sum >> $LOG
  #
  # convert from water withdrawal to consumptive water use
  #
  if [ $JOB = ind -o $JOB = dom ]; then
    if [ ! -d $DIRDEM ]; then
      mkdir -p $DIRDEM
    fi
    htmath $L mul $BINWIT $FACTOR $BINDEM
  fi
done
echo Log: $LOG
