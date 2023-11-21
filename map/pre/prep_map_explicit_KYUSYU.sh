#!/bin/sh
############################################################
#to   prepare explicit canal files
#by   hanasaki, 2021/11/23
#
# there are two original MS Excel files 
# One contains
# X-coordinate, Y-coordinate, L-coordinate, and ID
# for the destinations
# The other contains same for the origins.
#
# ID=3, *=origin, >=canal
# -------------
# | |*|>|>|>| |
# -------------
#
# The output file "INBIN" contains
# -------------
# |0|0|3|3|3| |
# -------------
#
# The output file "OUTBIN" contains
# -------------
# |0|3|0|0|0| |
# -------------
#
############################################################
# in
############################################################
 INASC=../org/KYUSYU/in__3___00000000.xls.txt  # destination (x,y,l,id)
OUTASC=../org/KYUSYU/out_3___00000000.xls.txt  # origin  (x,y,l,id)
############################################################
# out
############################################################
 INBIN=../org/KYUSYU/in__3___00000000.ks1      # destination (id)
OUTBIN=../org/KYUSYU/out_3___00000000.ks1      # origin (id)
############################################################
# Job: destination (flow in)
############################################################
htcreate $LKS1 0 $INBIN
REC=1
RECMAX=`wc $INASC | awk '{print $1}'`
while [ $REC -le $RECMAX ]; do
  STRING=`sed -n $REC'p' $INASC | awk '{print $4,$1,$2}'`
  htedit $ARGKS1 xy $INBIN $STRING > /dev/null
  REC=`expr $REC + 1`
done
############################################################
# Job: origin (flow out) 
############################################################
htcreate $LKS1 0 $OUTBIN
REC=1
RECMAX=`wc $OUTASC | awk '{print $1}'`
while [ $REC -le $RECMAX ]; do
  STRING=`sed -n $REC'p' $OUTASC | awk '{print $4,$1,$2}'`
  htedit $ARGKS1 xy $OUTBIN $STRING > /dev/null
  REC=`expr $REC + 1`
done
#

