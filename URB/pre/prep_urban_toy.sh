#!/bin/bash
source ~/.bashrc
############################################################
#to prepare urban data for the toy model
#by 2024/2/26 nhanasaki
#
# data developers: Kajiyama, Kakiuchi, Takahashi (KKT)
############################################################
# Input
############################################################
#Tokyo
SUF=.tk5
MSK=../org/KKT/cty_msk_${SUF}
PRF=../org/KKT/cty_prf_${SUF}
SWG=../org/KKT/cty_swg_${SUF}
L=$LTK5
ARG=$ARGTK5
#
# temporary
#
TMP=./temp${SUF}
EPS=./temp.eps
CPT=./map.cpt
#
# output
#
PNG=./temp${SUF}.org.png
#outdated PRFNEW=../dat/cty_prf_.toy${SUF}   
#outdated SWGNEW=../dat/cty_swg_.toy${SUF}
PRFNEW=../../map/dat/cty_prf_/KKT_toy_00000000${SUF}   
SWGNEW=../../map/dat/cty_swg_/KKT_toy_00000000${SUF}
PNGNEW=./temp${SUF}.toy.png
############################################################
# draw a map
############################################################
htcreate $L 0.0 $TMP
htmath $L add $TMP $MSK $TMP   # urban area:   1
htmath $L add $TMP $PRF $TMP   # intake point: 2
htmath $L add $TMP $SWG $TMP
htmath $L add $TMP $SWG $TMP   # waste water treatment plant: 3
htdraw $ARG $TMP $CPT $EPS
htconv $EPS $PNG rot
############################################################
# list up location
############################################################
#findtk5 $MSK $MSK eq 1 $TMP long
htmask $ARG $PRF $PRF eq 1 $TMP long
htmask $ARG $SWG $SWG eq 1 $TMP long
############################################################
# new data sparse map
############################################################
htcreate $L 0.0 $PRFNEW
#htedit $ARG  l $PRFNEW 1.0  808    # Tokyo
htcreate $L 0.0 $SWGNEW
#htedit $ARG   l $SWGNEW 1.0 1031   # Tokyo
############################################################
# draw a map
############################################################
htcreate $L 0.0 $TMP
htmath $L add $TMP $MSK $TMP   # urban area:   1
htmath $L add $TMP $PRFNEW $TMP   # intake point: 2
htmath $L add $TMP $SWGNEW $TMP
htmath $L add $TMP $SWGNEW $TMP   # waste water treatment plant: 3
#htedit $ARG   l $TMP 4.0  846       # Tokyo main channel of ara
#htedit $ARG   l $TMP 4.0  883       # Tokyo main channel of ara
#htedit $ARG   l $TMP 4.0  919       # Tokyo main channel of ara
#htedit $ARG   l $TMP 4.0  956       # Tokyo main channel of ara
#htedit $ARG   l $TMP 4.0  957       # Tokyo main channel of ara
#htedit $ARG   l $TMP 4.0  958       # Tokyo main channel of ara
#htedit $ARG   l $TMP 4.0  995       # Tokyo main channel of ara
htdraw $ARG $TMP $CPT $EPS
htconv  $EPS $PNGNEW rot

#../org/KKT/cty_prf_.tk5
