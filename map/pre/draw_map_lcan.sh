#!/bin/sh
############################################################
#
#
############################################################
# set
############################################################


############################################################
# macro
############################################################
EPS=temp.eps
CPTRIVINT=temp.int.cpt
CPTRIVCNT=temp.cnt.cpt
CPTRIVSCO=temp.sco.cpt
MAP=.WFDEI
############################################################
# in
############################################################
BINRIVINT=../../map/out/riv_int_/rivint.l${MAP}.hlf
BINRIVCNT=../../map/out/riv_cnt_/rivcnt${MAP}.hlf
BINRIVSCO=../../map/out/riv_sco_/rivsco${MAP}.hlf
############################################################
# out
############################################################
DIRRIVINT=../../map/fig/riv_int_
DIRRIVCNT=../../map/fig/riv_cnt_
DIRRIVSCO=../../map/fig/riv_sco_
#
if [ ! -d $DIRRIVINT ]; then mkdir -p $DIRRIVINT; fi
if [ ! -d $DIRRIVCNT ]; then mkdir -p $DIRRIVCNT; fi
if [ ! -d $DIRRIVSCO ]; then mkdir -p $DIRRIVSCO; fi
#
PNGRIVINT=${DIRRIVINT}/rivint${MAP}.png
PNGRIVCNT=${DIRRIVCNT}/rivcnt${MAP}.png
PNGRIVSCO=${DIRRIVSCO}/rivsco${MAP}.png
############################################################
# job
############################################################
gmt makecpt -T0/5/1 -Cgray  > $CPTRIVCNT
gmt makecpt -T-0.5/1.5/1    > $CPTRIVINT
gmt makecpt -T3/9/1         > $CPTRIVSCO
#
../../bin/htdraw_cp5.sh $ARGHLF $BINRIVCNT $CPTRIVCNT $EPS
htconv $EPS    $PNGRIVCNT rot
echo   $PNGRIVCNT
htdraw $ARGHLF $BINRIVINT $CPTRIVINT $EPS
htconv $EPS    $PNGRIVINT rot
echo   $PNGRIVINT
htdraw $ARGHLF $BINRIVSCO $CPTRIVSCO $EPS
htconv $EPS    $PNGRIVSCO rot
echo   $PNGRIVSCO
