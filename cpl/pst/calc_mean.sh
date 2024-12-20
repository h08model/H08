#!/bin/sh
############################################################
#to   prepare mean value for coupled simulation
#by   2010/01/31, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200                   # for Global (2D)
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf

#L=67209                    # for parallel computing (Land only)
#XY="720 360"
#L2X=../../map/dat/l2x_l2y_/l2x.hlo.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.hlo.txt
#LONLAT="-180 180 -90 90"
#SUF=.hlo

#L=11088                   # for Korean peninsula 2018
#XY="84 132"
#LONLAT="124 131 33 44"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#SUF=.ko5

#L=32400                    # for Kyusyu 2022
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#SUF=.ks1

############################################################
# Settings (Edit here)
############################################################
PRJ=WFDE      # project name of agricultral water demand simulation
#RUN=LECD
#PRJ=AK10
RUN=N_C_      # project name of agricultral water demand simulation
YEARMIN=1979
YEARMAX=1979
#YEARMIN=2014
#YEARMAX=2014
YEAROUT=0000
############################################################
# Input (Do not edit here basically)
############################################################
DIR=../../lnd/out/DemAgr__
############################################################
# Job 
############################################################
htmean $L ${DIR}/${PRJ}${RUN}${SUF}YR $YEARMIN $YEARMAX $YEAROUT
