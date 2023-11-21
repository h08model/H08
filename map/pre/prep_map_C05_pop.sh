#!/bin/sh
############################################################
#to   prepare CIESIN Gridded Population of the World Ver 3
#by   2011/03/30, hanasaki, NIES
#
# Source: 
#
# Center for International Earth Science Information Network (CIESIN) 
# Columbia University, and Centro Internacional de Agricultura 
# Tropical (CIAT) (2005), Gridded Population of the World Version 3 (GPWv3): 
# Population Grids, Socioeconomic Data and Applications Center (SEDAC) 
# Columbia University, Palisades, NY.
#
############################################################
# Preparation
############################################################
#
# For users:
# Download map-org-C05.tar.gz from the H08 file server.
#
# Methods:
#
# I obtained data below from http://sedac.ciesin.columbia.edu/gpw/global.jsp,
# and put them in ${DIRH08}/map/org/C05.
#
# Population grid: .ascii, 1deg, 0.5deg and 2.5min, 1990 and 2000
#
# The directory contains following sub direcotires.
# gl_gpwv3_pcount_90_ascii_half   gl_gpwv3_pcount_00_ascii_half
# gl_gpwv3_pcount_90_ascii_one    gl_gpwv3_pcount_00_ascii_one
# gl_gpwv3_pcount_90_ascii_25     gl_gpwv3_pcount_00_ascii_25
# 
############################################################
# Settings (Edit here)
############################################################
JOBS="one00 half00 one90 half90 gl500" # one00 for population of 2000 at 1 deg
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
DIR=../org/C05
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIROUT=../dat/pop_tot_
############################################################
# Macro
############################################################
L2XONE=../../map/dat/l2x_l2y_/l2x.one.txt
L2YONE=../../map/dat/l2x_l2y_/l2y.one.txt
L2XHLF=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2YHLF=../../map/dat/l2x_l2y_/l2y.hlf.txt
L2XGL5=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=../../map/dat/l2x_l2y_/l2y.gl5.txt
L2XGL2=../../map/dat/l2x_l2y_/l2x.gl2.txt
L2YGL2=../../map/dat/l2x_l2y_/l2y.gl2.txt
#
TMP=temp.txt
############################################################
# Job (prepare directory)
############################################################
if [ ! -d $DIROUT ]; then    mkdir -p $DIROUT;  fi
############################################################
# Job (generate files)
############################################################
for JOB in $JOBS; do

  if   [ $JOB = one00  ]; then
    DIRSUB=gl_gpwv3_pcount_00_ascii_one
    FILE=${DIR}/${DIRSUB}/glp00ag60.asc
    OUT=${DIROUT}/C05_a___20000000.one
  elif [ $JOB = half00 ]; then
    DIRSUB=gl_gpwv3_pcount_00_ascii_half 
    FILE=${DIR}/${DIRSUB}/glp00ag30.asc
    OUT=${DIROUT}/C05_a___20000000.hlf
  elif [ $JOB = gl500 ]; then
    DIRSUB=gl_gpwv3_pcount_00_ascii_25
    FILE=${DIR}/${DIRSUB}/glp00ag.asc
    OUT=${DIROUT}/C05_a___20000000.gl5
  elif [ $JOB = one90  ]; then
    DIRSUB=gl_gpwv3_pcount_90_ascii_one
    FILE=${DIR}/${DIRSUB}/glp90ag60.asc
    OUT=${DIROUT}/C05_a___19900000.one
  elif [ $JOB = half90 ]; then
    DIRSUB=gl_gpwv3_pcount_90_ascii_half
    FILE=${DIR}/${DIRSUB}/glp90ag30.asc
    OUT=${DIROUT}/C05_a___19900000.hlf
  fi
  
  sed -e '1,6d' $FILE > $TMP
  prog_map_C05_pop $TMP $OUT $JOB $L2XONE $L2YONE $L2XHLF $L2YHLF $L2XGL5 $L2YGL5 $L2XGL2 $L2YGL2

done






