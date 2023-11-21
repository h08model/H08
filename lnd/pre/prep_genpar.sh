#!/bin/sh
############################################################
#to   prepare parameter files (filled with a single value)
#by   2015/10/08, hanasaki
#
#     Before editing/running this script, 
#     prepare four parameter files.
#
#       SD=../../lnd/dat/par_lst_/${PRJ}.sd.txt
#       CD=../../lnd/dat/par_lst_/${PRJ}.cd.txt
#    GAMMA=../../lnd/dat/par_lst_/${PRJ}.gamma.txt
#      TAU=../../lnd/dat/par_lst_/${PRJ}.tau.txt
#
############################################################
# setting (edit below)
############################################################
#PRJ=WFDE      # for H08 ver2018
PRJ=GSW2       # for Korean peninsula (.ko5)
#PRJ=AK10      # for Kyusyu (.ks1)
#
L=11088        # for Korean peninsula (.ko5)
SUF=.ko5 
#
#L=32400       # for Kyusyu (.ks1)
#SUF=.ks1

############################################################
# in (do not edit below unless you are H08 expert)
############################################################
   SD=../../lnd/dat/par_lst_/${PRJ}.sd.txt
   CD=../../lnd/dat/par_lst_/${PRJ}.cd.txt
GAMMA=../../lnd/dat/par_lst_/${PRJ}.gamma.txt
  TAU=../../lnd/dat/par_lst_/${PRJ}.tau.txt
############################################################
# out (do not edit below unless you are H08 expert)
############################################################
DIR=../../lnd/dat
############################################################
# job
############################################################
FILES="$SD $CD $GAMMA $TAU"
for FILE in $FILES; do
  VALS=`awk '{print $2}' $FILE`
  for VAL in $VALS; do
      htcreate $L $VAL $DIR/uniform.${VAL}${SUF}
  done
done

