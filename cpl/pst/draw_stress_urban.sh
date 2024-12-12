#!/bin/sh
############################################################
#to   draw stress
#by   2020/06/16 hanasaki
############################################################
# Setting
############################################################
OPTTT=TT
OPTTR=TR
OPTTT=ST
OPTTR=SR

L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
MAP=.kyusyu
#
#L=14400                    # for Naka and Kuji river 
#XY="120 120"
#L2X=../../map/dat/l2x_l2y_/l2x.nk1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.nk1.txt
#LONLAT="139 141 36 38"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.nk1
#MAP=.NakaKuji
#
L=1296; XY="$LCT5"; LONLAT="$LONLATCT5"; ARG="$ARGCT5"; SUF=.ct5; ID=00000098
L=1728; XY="$LCN5"; LONLAT="$LONLATCN5"; ARG="$ARGCN5"; SUF=.cn5; ID=00000032
L=1728; XY="$LLN5"; LONLAT="$LONLATLN5"; ARG="$ARGLN5"; SUF=.ln5; ID=00000038
L=1728; XY="$LTK5"; LONLAT="$LONLATTK5"; ARG="$ARGTK5"; SUF=.tk5
L=2304; XY="$LLA5"; LONLAT="$LONLATLA5"; ARG="$ARGLA5"; SUF=.la5; ID=00000017
L=4032; XY="$LRJ5"; LONLAT="$LONLATRJ5"; ARG="$ARGRJ5"; SUF=.rj5; ID=00000016
#L=5148; XY="$LPR5"; LONLAT="$LONLATPR5"; ARG="$ARGPR5"; SUF=.pr5; ID=00000021



L2X=../../map/dat/l2x_l2y_/l2x${SUF}.txt
L2Y=../../map/dat/l2x_l2y_/l2y${SUF}.txt
MAP=.CAMA
#
YEARMIN=2014
YEARMAX=2014
YEARMIN=2019
YEARMAX=2019
############################################################
DIROUT=../../lnd/out/wat_idx_
DIRFIG=../../lnd/fig/wat_idx_
#
#PRJRUN=AK10N_C_
#PRJRUN=AK10N_C1
#PRJRUN=AK10N_C2
PRJRUN=AK10LECD
#PRJRUN=AK10LEC2
#PRJRUN=AK10NEmD       # Simulation
#PRJRUN=AK105cm_
#PRJRUN=AK105mm_
#PRJRUN=AK105wm_
PRJRUN=W5E5N_C_
#PRJRUN=W5E5N_C1
#PRJRUN=W5E5N_C2
#PRJRUN=W5E5N_C3
#PRJRUN=W5E5N_C4     # without aqueducts
PRJRUN=W5E5N_c4    # with aqueducts
#PRJRUN=W5E5N_x4    # with aqueducts (explicit only)
#PRJRUN=W5E5N_C5
#PRJRUN=W5E5N_C6
#PRJRUN=W5E5NDC_
#PRJRUN=W5E5NDC1
#PRJRUN=W5E5NDC2
#PRJRUN=W5E5NDC3
#
PRJRUNNAT=AK10LR__
#PRJRUNNAT=AK10DMLu     # Precitine simulation
PRJRUNNAT=W5E5LR__
YEAR=0000
#
CPTWTA=${DIRFIG}/wta.cpt
CPTCAD=${DIRFIG}/cad.cpt
CPTTMP=cad.cpt
OPTWITMSK=yes; MIN=30     # unit:kg/s, e.g., no water stress below 30kg/s of withdrawal.
OPTWITMSK=no
OPTMEAN=yes               # yes
OPTCITY=yes
#OPTCITY=no

CTYMSK=../../map/dat/cty_msk_/city_${ID}${SUF}
if [ "$SUF" = ".tk5" ]; then
  CTYMSK=../../URBAN/org/KKT/cty_msk_${SUF}
fi
############################################################
# In
############################################################
WITALL=../../lnd/out/SupAID${OPTTT}/${PRJRUN}${YEAR}0000${SUF}
WITREN=../../lnd/out/SupAID${OPTTR}/${PRJRUN}${YEAR}0000${SUF}
WITALLURB=../../lnd/out/SupID_${OPTTT}/${PRJRUN}${YEAR}0000${SUF}
WITRENURB=../../lnd/out/SupID_${OPTTR}/${PRJRUN}${YEAR}0000${SUF}
ROFNAT=../../riv/out/riv_out_/${PRJRUNNAT}${YEAR}0000${SUF}
MSK=../../map/dat/flw_dir_/flwdir${MAP}${SUF}
MSK=../../map/out/riv_mou_/rivmou${MAP}${SUF}
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
############################################################
# Temporary
############################################################
TMP=temp${SUF}
EPS=temp.eps
############################################################
# Out
############################################################
   WTA=${DIROUT}/aid.wta.${PRJRUN}${SUF}
PNGWTA=${DIRFIG}/aid.wta.${PRJRUN}.png
   CAD=${DIROUT}/aid.cad.${PRJRUN}.${OPTWITMSK}${SUF}
PNGCAD=${DIRFIG}/aid.cad.${PRJRUN}.${OPTWITMSK}.png
   WTAURB=${DIROUT}/id_.wta.${PRJRUN}${SUF}
PNGWTAURB=${DIRFIG}/id_.wta.${PRJRUN}.png
   CADURB=${DIROUT}/id_.cad.${PRJRUN}.${OPTWITMSK}${SUF}
PNGCADURB=${DIRFIG}/id_.cad.${PRJRUN}.${OPTWITMSK}.png
#
if [ !  -d $DIROUT ]; then
  mkdir -p $DIROUT
fi
if [ !  -d $DIRFIG ]; then
  mkdir -p $DIRFIG
fi
############################################################
# Mean
############################################################
if [ $OPTMEAN = yes ]; then
  htmean $L ../../lnd/out/SupAID${OPTTT}/${PRJRUN}${SUF}YR $YEARMIN $YEARMAX 0000
  htmean $L ../../lnd/out/SupAID${OPTTR}/${PRJRUN}${SUF}YR $YEARMIN $YEARMAX 0000
  htmean $L ../../lnd/out/SupID_${OPTTT}/${PRJRUN}${SUF}YR $YEARMIN $YEARMAX 0000
  htmean $L ../../lnd/out/SupID_${OPTTR}/${PRJRUN}${SUF}YR $YEARMIN $YEARMAX 0000
fi
############################################################
# WTA
############################################################
echo Total withdrawal - all sources
htstat $ARG sum $WITALL | awk '{print $1*0.031536/1000}'
echo Total withdrawal - renewable sources
htstat $ARG sum $WITREN | awk '{print $1*0.031536/1000}'
echo Total natural runoff
htmask $ARG $ROFNAT $MSK eq 9 $TMP
htstat $ARG sum $TMP | awk '{print $1*0.031536/1000}'
############################################################
# CPT
############################################################
#gmt makecpt -T0/1/0.1 -Z > $CPTWTA
#gmt makecpt -T0/1.1/0.1 -Z > $CPTCAD
############################################################
# WTA
############################################################
htmath $L div $WITALL $ROFNAT $WTA
htdraw $ARG $WTA $CPTWTA $EPS 
htconv $EPS $PNGWTA rot
echo $PNGWTA

htmath $L div $WITALLURB $ROFNAT $WTAURB
htdraw $ARG $WTAURB $CPTWTA $EPS 
htconv $EPS $PNGWTAURB rot
echo $PNGWTAURB
############################################################
# CAD
############################################################
htmath $L div $WITREN $WITALL $CAD
#htmaskrplc $ARG $CAD $LNDMSK eq 0 1.0E20 $CAD
htmaskrplc $ARG $CAD $LNDMSK eq 0 1.0 $CAD
if [ $OPTWITMSK = yes ]; then
  htmaskrplc $ARG $CAD $WITALL lt $MIN 1.0 $CAD
fi
htdraw $ARG $CAD $CPTCAD $EPS 
htconv $EPS $PNGCAD rot
echo $PNGCAD


htmath $L div $WITRENURB $WITALLURB $CADURB
if [ "$OPTCITY" = "yes" ]; then
  if [ "$SUF" = ".tk5" ]; then
    SUMNUM=0
    SUMDEN=0

    NUMVAL=`htpoint $ARG l $WITRENURB 772`
    DENVAL=`htpoint $ARG l $WITALLURB 772`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'` 
    echo $NUMVAL $DENVAL    

    NUMVAL=`htpoint $ARG l $WITRENURB 919`
    DENVAL=`htpoint $ARG l $WITALLURB 919`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`    
    echo $NUMVAL $DENVAL
    
    NUMVAL=`htpoint $ARG l $WITRENURB 1023`
    DENVAL=`htpoint $ARG l $WITALLURB 1023`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL   
    
    NUMVAL=`htpoint $ARG l $WITRENURB 1026`
    DENVAL=`htpoint $ARG l $WITALLURB 1026`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL
   
    CADVAL=`echo $SUMNUM $SUMDEN | awk '{print $1/$2}'`
    echo SUMNUM $SUMNUM
    echo SUMDEN $SUMDEN
    echo CADVAL $CADVAL
  elif [ "$SUF" = ".ln5" ]; then
    SUMNUM=0
    SUMDEN=0  
    NUMVAL=`htpoint $ARG l $WITRENURB 945`
    DENVAL=`htpoint $ARG l $WITALLURB 945`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL
   
    CADVAL=`echo $SUMNUM $SUMDEN | awk '{print $1/$2}'`
    echo SUMNUM $SUMNUM
    echo SUMDEN $SUMDEN
    echo CADVAL $CADVAL
  elif [ "$SUF" = ".pr5" ]; then
    SUMNUM=0
    SUMDEN=0  
    NUMVAL=`htpoint $ARG l $WITRENURB 2910`
    DENVAL=`htpoint $ARG l $WITALLURB 2910`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL
   
    CADVAL=`echo $SUMNUM $SUMDEN | awk '{print $1/$2}'`
    echo SUMNUM $SUMNUM
    echo SUMDEN $SUMDEN
    echo CADVAL $CADVAL

  elif [ "$SUF" = ".rj5" ]; then
    SUMNUM=0
    SUMDEN=0  
    NUMVAL=`htpoint $ARG l $WITRENURB 2729`
    DENVAL=`htpoint $ARG l $WITALLURB 2729`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL   
    
    NUMVAL=`htpoint $ARG l $WITRENURB 2732`
    DENVAL=`htpoint $ARG l $WITALLURB 2732`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL
   
    CADVAL=`echo $SUMNUM $SUMDEN | awk '{print $1/$2}'`
    echo SUMNUM $SUMNUM
    echo SUMDEN $SUMDEN
    echo CADVAL $CADVAL
  elif [ "$SUF" = ".la5" ]; then
    SUMNUM=0
    SUMDEN=0  
    NUMVAL=`htpoint $ARG l $WITRENURB 1077`
    DENVAL=`htpoint $ARG l $WITALLURB 1077`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL   

    NUMVAL=`htpoint $ARG l $WITRENURB 1172`
    DENVAL=`htpoint $ARG l $WITALLURB 1172`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL   
    
    NUMVAL=`htpoint $ARG l $WITRENURB 1175`
    DENVAL=`htpoint $ARG l $WITALLURB 1175`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL
   
    CADVAL=`echo $SUMNUM $SUMDEN | awk '{print $1/$2}'`
    echo SUMNUM $SUMNUM
    echo SUMDEN $SUMDEN
    echo CADVAL $CADVAL
  elif [ "$SUF" = ".cn5" ]; then
    SUMNUM=0
    SUMDEN=0  
    NUMVAL=`htpoint $ARG l $WITRENURB 781`
    DENVAL=`htpoint $ARG l $WITALLURB 781`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL   

    NUMVAL=`htpoint $ARG l $WITRENURB 817`
    DENVAL=`htpoint $ARG l $WITALLURB 817`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL   
    
    NUMVAL=`htpoint $ARG l $WITRENURB 925`
    DENVAL=`htpoint $ARG l $WITALLURB 925`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL
   
    CADVAL=`echo $SUMNUM $SUMDEN | awk '{print $1/$2}'`
    echo SUMNUM $SUMNUM
    echo SUMDEN $SUMDEN
    echo CADVAL $CADVAL
  elif [ "$SUF" = ".ct5" ]; then
    SUMNUM=0
    SUMDEN=0  
    NUMVAL=`htpoint $ARG l $WITRENURB 775`
    DENVAL=`htpoint $ARG l $WITALLURB 775`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL   

    NUMVAL=`htpoint $ARG l $WITRENURB 812`
    DENVAL=`htpoint $ARG l $WITALLURB 812`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL   
    
    NUMVAL=`htpoint $ARG l $WITRENURB 851`
    DENVAL=`htpoint $ARG l $WITALLURB 851`
    SUMNUM=`echo $SUMNUM $NUMVAL | awk '{print $1+$2}'`
    SUMDEN=`echo $SUMDEN $DENVAL | awk '{print $1+$2}'`
    echo $NUMVAL $DENVAL
   
    CADVAL=`echo $SUMNUM $SUMDEN | awk '{print $1/$2}'`
    echo SUMNUM $SUMNUM
    echo SUMDEN $SUMDEN
    echo CADVAL $CADVAL
  else
    echo $SUF not supported.----------------------------
  fi
  echo  htmaskrplc $ARG $CADURB $CTYMSK eq 1 $CADVAL $CADURB
  htmaskrplc $ARG $CADURB $CADURB eq 1.0E20 -1 $CADURB
  htmaskrplc $ARG $CADURB $CTYMSK eq 1 $CADVAL $CADURB
  htmaskrplc $ARG $CADURB $CADURB eq -1 1.0E20 $CADURB
  echo converted
fi

htmaskrplc $ARG $CADURB $LNDMSK eq 0 1.0E20 $CADURB
if [ $OPTWITMSK = yes ]; then
  htmaskrplc $ARG $CADURB $WITALL lt $MIN 1.0 $CAD
fi
#htdraw $ARG $CADURB $CPTCAD $EPS
htdraw $ARG $CADURB $CPTTMP $EPS 
htconv $EPS $PNGCADURB rot
echo $PNGCADURB
