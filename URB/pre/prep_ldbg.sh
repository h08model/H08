#!/bin/sh


L=50
LMAX=4000
while [ $L -le $LMAX ]; do
  CT5=`htpoint $ARGCT5 l ../../map/dat/lnd_msk_/lndmsk.CAMA.ct5 $L`
  LN5=`htpoint $ARGLN5 l ../../map/dat/lnd_msk_/lndmsk.CAMA.ln5 $L`
  TK5=`htpoint $ARGTK5 l ../../map/dat/lnd_msk_/lndmsk.CAMA.tk5 $L`
  CN5=`htpoint $ARGCN5 l ../../map/dat/lnd_msk_/lndmsk.CAMA.cn5 $L`
  LA5=`htpoint $ARGLA5 l ../../map/dat/lnd_msk_/lndmsk.CAMA.la5 $L`
  RJ5=`htpoint $ARGRJ5 l ../../map/dat/lnd_msk_/lndmsk.CAMA.rj5 $L`
  PR5=`htpoint $ARGPR5 l ../../map/dat/lnd_msk_/lndmsk.CAMA.pr5 $L`
  SY5=`htpoint $ARGSY5 l ../../map/dat/lnd_msk_/lndmsk.CAMA.sy5 $L`
  SUM=`echo $CT5 $LN5 $TK5 $CN5 $LA5 $RJ5 $PR5 $SY5 | awk '{printf("%d",$1+$2+$3+$4+$5+$6+$7+$8)}'`
  if [ $SUM -ge 1 ]; then 
    echo $L $SUM $CT5 $LN5 $TK5 $CN5 $LA5 $RJ5 $PR5 $SY5
  fi
  L=`expr $L + 50`
  
done
