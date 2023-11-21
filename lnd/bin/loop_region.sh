#!/bin/sh
############################################################
#to    execute multiple jobs
#by   2015/12/15, hanasaki
############################################################
# Settings (edit here)
############################################################
SDS="A B C"
CDS="A B C"
GAMMAS="A B C"
TAUS="A B C"

PROG=./main          # program to execute
NOFCPU=4             # no of CPUs, or how many runs to execute at once
DATE=`date +"%Y%m%d"`        # date in the setting file
PRJ=GSW2             # project name
#PRJ=WFDE             # for H08 ver2018
############################################################
#
############################################################
CNT=1                                                             # counter
for SD in $SDS; do
  for CD in $CDS; do
    for GAMMA in $GAMMAS; do
      for TAU in $TAUS; do
        echo ${SD}${CD}${GAMMA}${TAU}
        SET=../set/${PRJ}${SD}${CD}${GAMMA}${TAU}${DATE}.set
        LOG=../log/${PRJ}${SD}${CD}${GAMMA}${TAU}${DATE}.log
        REM=`echo $CNT $NOFCPU  | awk '{print $1-int($1/$2)*$2}'` # remainder
        if [ $REM = 0 ]; then
            $PROG $SET >  $LOG     # for foreground execution
        else
            $PROG $SET >  $LOG &   # for background execution
        fi
        CNT=`expr $CNT + 1`
      done
    done
  done
done


