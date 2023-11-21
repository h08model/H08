#!/bin/sh
############################################################
#to   prepare relative humidity
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Basic settings (Edit here if you wish)
############################################################
PRJ=GSW2
RUN=B1b_
YEARMIN=1986
YEARMAX=1986
############################################################
# Geographical setting (Edit here if you change spatial domain/resolution)
############################################################
L=64800
SUF=.one
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
 QAIR=../../met/dat/Qair____/${PRJ}${RUN}${SUF}3H
PSURF=../../met/dat/PSurf___/${PRJ}${RUN}${SUF}3H
 TAIR=../../met/dat/Tair____/${PRJ}${RUN}${SUF}3H
############################################################
# Output directory (Do not edit here unless you are an expert)
############################################################
DIRRH=../../met/dat/RH______
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
RH=${DIRRH}/${PRJ}${RUN}${SUF}3H
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d $DIRRH ]; then mkdir -p $DIRRH; fi
############################################################
# Job (Convert specific humidity into relative humidity)
############################################################
prog_RH $L $QAIR $PSURF $TAIR $RH $YEARMIN $YEARMAX
