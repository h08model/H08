#!/bin/sh
############################################################
#
#
############################################################
if [ $# -ne 2 ]; then
  echo Usage: htgmtparam OPT r0dat
  echo OPT:   [max ano tit]
  exit
else
  OPT=$1
  VAL=$2
fi
VAL=`echo $VAL | awk '{printf("%d",$1)}'`
############################################################
#
############################################################
if   [ $VAL -le 4 ]; then
  MAX=5;         ANO=1         TIT=5.5
elif [ $VAL -le 8 ]; then
  MAX=10;        ANO=2         TIT=11
elif [ $VAL -le 40 ]; then
  MAX=50;        ANO=10        TIT=55
elif [ $VAL -le 80 ]; then
  MAX=100;       ANO=20        TIT=110
elif [ $VAL -le 400 ]; then
  MAX=500;       ANO=100       TIT=550
elif [ $VAL -le 800 ]; then
  MAX=1000;      ANO=200       TIT=1100
elif [ $VAL -le 4000 ]; then
  MAX=5000;      ANO=1000      TIT=5500
elif [ $VAL -le 8000 ]; then
  MAX=10000;     ANO=2000      TIT=11000
elif [ $VAL -le 40000 ]; then
  MAX=50000;     ANO=10000     TIT=55000
elif [ $VAL -le 80000 ]; then
  MAX=100000;    ANO=20000     TIT=110000
elif [ $VAL -le 400000 ]; then
  MAX=500000;    ANO=100000    TIT=550000
elif [ $VAL -le 800000 ]; then
  MAX=1000000;   ANO=200000    TIT=1100000
elif [ $VAL -le 4000000 ]; then
  MAX=5000000;   ANO=1000000   TIT=5500000
elif [ $VAL -le 8000000 ]; then
  MAX=10000000;  ANO=2000000   TIT=11000000
elif [ $VAL -le 40000000 ]; then
  MAX=50000000;  ANO=10000000  TIT=55000000
elif [ $VAL -le 80000000 ]; then
  MAX=100000000; ANO=20000000  TIT=110000000
elif [ $VAL -le 400000000 ]; then
  MAX=500000000; ANO=100000000 TIT=550000000
else
  echo htgmtparam_error: $VAL greater equal 5000000
  exit
fi
############################################################
#
############################################################
if   [ $OPT = "max" ]; then
  echo $MAX
elif [ $OPT = "ano" ]; then
  echo $ANO
elif [ $OPT = "tit" ]; then
  echo $TIT
else
  echo htgmtparam_error: $OPT not found.
fi