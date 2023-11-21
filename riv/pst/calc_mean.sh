#!/bin/sh
############################################################
#to   prepare mean value for coupled simulation
#by   2010/01/31, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf

#L=11088                   # for Korean peninsula 2018
#XY="84 132"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#LONLAT="124 131 33 44"
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
PRJ=WFDE      # project name of river discharge simulation
RUN=LR__      # project name of river discharge simulation
#PRJ=AK10
#RUN=LR__
YEARMIN=1979
YEARMAX=1979
#YEARMIN=2014
#YEARMAX=2014
YEAROUT=0000
############################################################
# Input (Do not edit here basically)
############################################################
DIR=../../riv/out/riv_out_
############################################################
# Job 
############################################################
htmean $L ${DIR}/${PRJ}${RUN}${SUF}MO $YEARMIN $YEARMAX $YEAROUT
htmean $L ${DIR}/${PRJ}${RUN}${SUF}YR $YEARMIN $YEARMAX $YEAROUT

