#!/bin/sh
##################################################################
#
#
##################################################################
V1=$1
SIGN=$2
V2=$3
LAB=$4
UNT=$5
OUT=$6

if [ "$OUT" = "" ]; then
  echo comm_watbal value sign value
  exit
fi
##################################################################
#
##################################################################
  if [ $V2  != -9999.99 ];then
    if [ $SIGN = "plus" ]; then
      V3=`echo $V1 $V2         | awk '{printf("%12.2f",$1+$2)}'`
      echo +$LAB $V2 $UNT | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT

    elif [ $SIGN = "minus" ]; then
      V3=`echo $V1 $V2         | awk '{printf("%12.2f",$1-$2)}'`
      echo -$LAB $V2 $UNT | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT

    elif [ $SIGN = "fin" ]; then
      V3=`echo $V1             | awk '{printf("%12.2f",$1)}'`
      echo =$LAB $V1 $UNT | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
    else
      echo $SGIN not supported.
      exit
    fi
  else
    V3=$V1
  fi
  echo $V3
  
