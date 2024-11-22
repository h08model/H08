#!/bin/sh
############################################################
#to  calculate water balance
#by  2010/03/31, nhanasaki, NIES: H08ver1.0
############################################################
# Settings (Edit here if you change settings)
############################################################
PRJ="WFDE"                         # project
#PRJ="AK10"
RUN="LR__"                          # run
#PRJMET=WFDE                        # project for meteorology
#RUNMET=I___
PRJMET=wfde
RUNMET=____                        # run     for meteorology
#PRJMET=AMeD
#RUNMET=AS1_
PRJDEM=WFDE                         # project for water demand
RUNDEM=N_C_                        # run     for water demand
#RUNDEM=LECD
PRJENV=WFDE                         # project for environmental flow
RUNENV=LR__                         # run     for environmental flow
#PRJENV=AK10                        # setting for Kyusyu
#RUNENV=LR__
#
#PRJ="mesc"                          # project
#RUN="LR__"                          # run
#PRJMET=mesc                         # project for meteorology
#RUNMET=hs1_                         # run     for meteorology
#PRJDEM=mesc                         # project for water demand
#RUNDEM=N_C_                         # run     for water demand
#PRJENV=mesc                         # project for environmental flow
#RUNENV=LR__                         # run     for environmental flow
#
OPTNNB=new
############################################################
# Settings Time (Edit here if you change settings)
############################################################
#
#YEAR=2000;    MON=00;    DAY=00     # year, month, day to report
#YEARINI=1999; MONINI=12; DAYINI=00  # year, month, day of initial state
#YEAREND=2000; MONEND=12; DAYEND=00  # year, month, day of final   state
#DAYS=366; TIME=31622400
#
#YEAR=2081;    MON=00;    DAY=00     # year, month, day to report
#YEARINI=2080; MONINI=12; DAYINI=00  # year, month, day of initial state
#YEAREND=2081; MONEND=12; DAYEND=00  # year, month, day of final   state
#DAYS=365; TIME=31536000
#
#YEAR=2063;    MON=00;    DAY=00     # year, month, day to report
#YEARINI=2062; MONINI=12; DAYINI=00  # year, month, day of initial state
#YEAREND=2063; MONEND=12; DAYEND=00  # year, month, day of final   state
#DAYS=365; TIME=31536000
#
YEAR=1979;    MON=00;    DAY=00     # year, month, day to report
YEARINI=1978; MONINI=12; DAYINI=00  # year, month, day of initial state
YEAREND=1979; MONEND=12; DAYEND=00  # year, month, day of final   state
DAYS=365; TIME=31536000
#
#YEAR=2079;    MON=00;    DAY=00     # year, month, day to report
#YEARINI=2078; MONINI=12; DAYINI=00  # year, month, day of initial state
#YEAREND=2079; MONEND=12; DAYEND=00  # year, month, day of final   state
#DAYS=365; TIME=31536000
############################################################
# Settings Domain (Edit here if you change settings)
############################################################
NUM=0                            # id of basin (0 for globe)
#NUM=1                            # id of nation (0 for globe)
############################################################
# Geography (Edit here if you change spatial domain/resolution)
############################################################
L="259200"                          # total num of cells
XY="720 360"                        # X and Y
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt 
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"            # geographical range
SUF=.hlf                            # suffix
MAP=.WFDEI                          # map
#
# for parallel computing (Land only)
#L="67209"                          # total num of land cells
#XY="720 360"                        # X and Y
#L2X=../../map/dat/l2x_l2y_/l2x.hlo.txt 
#L2Y=../../map/dat/l2x_l2y_/l2y.hlo.txt
#LONLAT="-180 180 -90 90"            # geographical range
#SUF=.hlo                            # suffix
#MAP=.WFDEI                          # map
#
# Regional setting (.ko5)
#L=11088
#XY="84 132"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#LONLAT="124 131 33 44"            
#SUF=.ko5
#MAP=.SNU
#
# Regional setting (.ks1)
#L=32400
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#SUF=.ks1
#MAP=.kyusyu

#
ARG="$L $XY $L2X $L2Y $LONLAT"
############################################################
# Input Directory (Change rainf/snowf dir if you run climate change simulat.)
############################################################
    DIRRAINF=../../met/dat/Rainf___ # Rainfall 
    DIRSNOWF=../../met/dat/Snowf___ # Snowfall
#    DIRRAINF=../../lnd/out/Rainfout # Rainfall (climate change)
#    DIRSNOWF=../../lnd/out/Snowfout # Snowfall (climate change)
############################################################
# Input Directory (Do not edit here basically)
############################################################
     DIREVAP=../../lnd/out/Evap____ # Total evaporation (all terms)
     DIRQTOT=../../lnd/out/Qtot____ # Total runoff
       DIRQS=../../lnd/out/Qs______ # Surface runoff
      DIRQSB=../../lnd/out/Qsb_____ # Subsurface runoff
      DIRQRC=../../lnd/out/Qrc_____ # Recharge
      DIRQBF=../../lnd/out/Qbf_____ # Baseflow
DIRSOILMOIST=../../lnd/out/SoilMois # Soil moisture
      DIRSWE=../../lnd/out/SWE_____ # Snow water equivalent
       DIRGW=../../lnd/out/GW______ # Groundwater
#
   DIRRIVOUT=../../riv/out/riv_out_ # River flow
   DIRRIVSTO=../../riv/out/riv_sto_ # River storage
   DIRENVOUT=../../riv/out/env_out_ # Env. flow
#
   DIRDAMSTO=../../dam/out/dam_sto_
   DIRMSRSTO=../../dam/out/msr_sto_
#
   DIRDEMAGR=../../lnd/out/DemAgr__
   DIRSUPAGR=../../lnd/out/SupAgr__
DIRSUPAGRRIV=../../lnd/out/SupAgrR_
DIRSUPAGRCAN=../../lnd/out/SupAgrC_
 DIRSUPAGRGW=../../lnd/out/SupAgrGR
   DIRRTFAGR=../../lnd/out/RtFAgr__
DIRSUPAGRMSR=../../lnd/out/SupAgrM_
DIRSUPAGRNNB=../../lnd/out/SupAgrN_
if [ $OPTNNB = new ]; then
  DIRSUPAGRNNBS=../../lnd/out/SupAgrSN
  DIRSUPAGRNNBG=../../lnd/out/SupAgrGN
fi
DIRSUPAGRDES=../../lnd/out/SupAgrD_
DIRSUPAGRRCL=../../lnd/out/SupAgrL_
DIRSUPAGRDEF=../../lnd/out/SupAgrF_
   DIRDEMIND=../../lnd/out/DemInd__
   DIRSUPIND=../../lnd/out/SupInd__
DIRSUPINDRIV=../../lnd/out/SupIndR_
DIRSUPINDCAN=../../lnd/out/SupIndC_
 DIRSUPINDGW=../../lnd/out/SupIndGR
   DIRRTFIND=../../lnd/out/RtFInd__
DIRSUPINDMSR=../../lnd/out/SupIndM_
DIRSUPINDNNB=../../lnd/out/SupIndN_
if [ $OPTNNB = new ]; then
  DIRSUPINDNNBS=../../lnd/out/SupIndSN
  DIRSUPINDNNBG=../../lnd/out/SupIndGN
fi
DIRSUPINDDES=../../lnd/out/SupIndD_
DIRSUPINDRCL=../../lnd/out/SupIndL_
DIRSUPINDDEF=../../lnd/out/SupIndF_
   DIRDEMDOM=../../lnd/out/DemDom__
   DIRSUPDOM=../../lnd/out/SupDom__
DIRSUPDOMRIV=../../lnd/out/SupDomR_
DIRSUPDOMCAN=../../lnd/out/SupDomC_
 DIRSUPDOMGW=../../lnd/out/SupDomGR
   DIRRTFDOM=../../lnd/out/RtFDom__
DIRSUPDOMMSR=../../lnd/out/SupDomM_
DIRSUPDOMNNB=../../lnd/out/SupDomN_
if [ $OPTNNB = new ]; then
  DIRSUPDOMNNBS=../../lnd/out/SupDomSN
  DIRSUPDOMNNBG=../../lnd/out/SupDomGN
fi
DIRSUPDOMDES=../../lnd/out/SupDomD_
DIRSUPDOMRCL=../../lnd/out/SupDomL_
DIRSUPDOMDEF=../../lnd/out/SupDomF_
   DIRLOSAGR=../../lnd/out/LosAgr__
############################################################
# Map (Edit here if you change settings))
############################################################
FRIVNUM=../../map/out/riv_num_/rivnum${MAP}${SUF}  # river id
#FRIVNUM=../../map/dat/nat_msk_/C05_e___20000000${MAP}${SUF}
#FRIVNUM=./temp.baka.hlf
FLNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}  # land area
FFLWDIR=../../map/dat/flw_dir_/flwdir${MAP}${SUF}  # flwo direction
#
FIRGARA=../../map/dat/irg_ara_/S05_____20000000${SUF}
FPOPTOT=../../map/dat/pop_tot_/C05_a___20000000${SUF}
#FPOPTOT=../../map/dat/pop_tot_/popuration${SUF}
#
FDEMIND=../../map/dat/dem_ind_/AQUASTAT20000000${SUF}
FDEMDOM=../../map/dat/dem_dom_/AQUASTAT20000000${SUF}
#FDEMIND=../../map/dat/dem_ind_/METIms__20150000${SUF}
#FDEMDOM=../../map/dat/dem_dom_/JWRC____20160000${SUF}
FWITIND=../../map/dat/wit_ind_/AQUASTAT20000000${MAP}${SUF}
FWITDOM=../../map/dat/wit_dom_/AQUASTAT20000000${MAP}${SUF}
FWITAGR=../../map/dat/wit_agr_/AQUASTAT20000000${SUF}
#FWITIND=../../map/dat/wit_ind_/AQUASTAT20000000${SUF} global
#FWITDOM=../../map/dat/wit_dom_/AQUASTAT20000000${SUF} global
#FWITIND=../../map/dat/wit_ind_/METIms__20150000${SUF}
#FWITDOM=../../map/dat/wit_dom_/JWRC____20160000${SUF}
#
FNONARA=../../map/out/non_ara_/S05_____20000000${SUF}
FIRGEFF=../../map/dat/irg_eff_/DS02____00000000${SUF}
FDAMCAP=../../map/dat/dam_cap_/H06_____20000000${SUF}
#FDAMCAP=../../map/dat/dam_cap_/KYSY____20000000${SUF}
############################################################
# Output (Do not edit here basically)
############################################################
DIROUT=../../cpl/tab/wat_bal_
SUFOUT=.$YEAR.txt                   # suffix of out file
############################################################
# Macro
############################################################
TEMP=temp${SUF}                       # temporary file
MASK=temp.mask${SUF}                  # temporary file
FBALLND=temp.lndbal${SUF}
FBALSW=temp.swbal${SUF}
FBALGW=temp.gwbal${SUF}
FLNDARADUM=temp.lndara${SUF}
DN=/dev/null
htmask $ARG $FLNDARA $FLNDARA gt 0.0 $FLNDARADUM > $DN
############################################################
# Job (Create out file)
############################################################
NUM8=`echo $NUM | awk '{printf("%8.8d",$1)}'`   # id in 8 digits
OUT=${DIROUT}/$PRJ$RUN$NUM8$SUFOUT          # out file
if [ ! -d $DIROUT ]; then  mkdir -p $DIROUT; fi
if [ -f $OUT ]; then rm $OUT; fi
echo results output to $OUT
############################################################
# Job (Create mask)
############################################################
if [ $NUM = 0 ]; then
  htcreate $L  0 $MASK
  htmaskrplc $ARG  $MASK $FRIVNUM eq 0 -1 $MASK > $DN
else 
  MASK=$FRIVNUM
fi
############################################################
# Job (Maps)
############################################################
if [ -f $FLNDARADUM ]; then
  htmask $ARG $FLNDARADUM $MASK eq $NUM $TEMP > $DN
  ARA=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f", $1/1000/1000)}'`
else
  ARA=-9999.99
fi

if [ -f $FNONARA ]; then
  htmask $ARG $FNONARA    $MASK eq $NUM $TEMP > $DN
  ARANON=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f", $1/1000/1000)}'`
else
  ARANON=-9999.99
fi

if [ -f $FIRGARA ]; then
  htmask $ARG $FIRGARA $MASK eq $NUM $TEMP > $DN
  ARAIRG=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f", $1/1000/1000)}'`
else
  ARAIRG=-9999.99
fi

if [ -f $FDAMCAP ]; then
  htmask $ARG $FDAMCAP $MASK eq $NUM $TEMP > $DN
  DAMCAP=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f", $1/1000/1000/1000/1000)}'`
else
  DAMCAP=-9999.99
fi

if [ -f $FPOPTOT ]; then
  htmask $ARG $FPOPTOT $MASK eq $NUM $TEMP > $DN
  POPTOT=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f", $1/1000/1000)}'`
else
  POPTOT=-9999.99
fi
############################################################
# Job (Demand and supply)
############################################################
FDEMAGR=$DIRDEMAGR/$PRJDEM$RUNDEM$YEAR$MON$DAY$SUF
if [ -f $FDEMAGR ]; then
  htmask $ARG $FDEMAGR $MASK eq $NUM $TEMP  > $DN
  DEMAGR=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  DEMAGR=-9999.99
fi

FSUPAGR=$DIRSUPAGR/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGR ]; then
  htmask $ARG $FSUPAGR $MASK eq $NUM $TEMP   > $DN
  SUPAGR=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGR=-9999.99
fi

FSUPAGRRIV=$DIRSUPAGRRIV/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGRRIV ]; then
  htmask $ARG $FSUPAGRRIV $MASK eq $NUM $TEMP > $DN
  SUPAGRRIV=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGRRIV=-9999.99
fi

FSUPAGRCAN=$DIRSUPAGRCAN/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGRCAN ]; then
  htmask $ARG $FSUPAGRCAN $MASK eq $NUM $TEMP > $DN
  SUPAGRCAN=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGRCAN=-9999.99
fi

FSUPAGRGW=$DIRSUPAGRGW/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGRGW ]; then
  htmask $ARG $FSUPAGRGW $MASK eq $NUM $TEMP > $DN
  SUPAGRGW=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGRGW=-9999.99
fi

FSUPAGRMSR=$DIRSUPAGRMSR/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGRMSR ]; then
  htmask $ARG $FSUPAGRMSR $MASK eq $NUM $TEMP > $DN
  SUPAGRMSR=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGRMSR=-9999.99
fi

FSUPAGRNNB=$DIRSUPAGRNNB/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGRNNB ]; then
  htmask $ARG $FSUPAGRNNB $MASK eq $NUM $TEMP > $DN
  SUPAGRNNB=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGRNNB=-9999.99
fi

if [ $OPTNNB = new ]; then
  FSUPAGRNNBS=$DIRSUPAGRNNBS/$PRJ$RUN$YEAR$MON$DAY$SUF
  if [ -f $FSUPAGRNNBS ]; then
    htmask $ARG $FSUPAGRNNBS $MASK eq $NUM $TEMP > $DN
    SUPAGRNNBS=`htstat $ARG sum $TEMP | \
    awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
  else
    SUPAGRNNBS=-9999.99
  fi

  FSUPAGRNNBG=$DIRSUPAGRNNBG/$PRJ$RUN$YEAR$MON$DAY$SUF
  if [ -f $FSUPAGRNNBG ]; then
    htmask $ARG $FSUPAGRNNBG $MASK eq $NUM $TEMP > $DN
    SUPAGRNNBG=`htstat $ARG sum $TEMP | \
    awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
  else
    SUPAGRNNBG=-9999.99
  fi
else
  SUPAGRNNBS=-9999.99
  SUPAGRNNBG=-9999.99
fi

FSUPAGRDES=$DIRSUPAGRDES/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGRDES ]; then
  htmask $ARG $FSUPAGRDES $MASK eq $NUM $TEMP > $DN
  SUPAGRDES=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGRDES=-9999.99
fi

FSUPAGRRCL=$DIRSUPAGRRCL/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGRRCL ]; then
  htmask $ARG $FSUPAGRRCL $MASK eq $NUM $TEMP > $DN
  SUPAGRRCL=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGRRCL=-9999.99
fi

FSUPAGRDEF=$DIRSUPAGRDEF/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPAGRDEF ]; then
  htmask $ARG $FSUPAGRDEF $MASK eq $NUM $TEMP > $DN
  SUPAGRDEF=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  SUPAGRDEF=-9999.99
fi

FRTFAGR=$DIRRTFAGR/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FRTFAGR ]; then
  htmask $ARG $FRTFAGR $MASK eq $NUM $TEMP > $DN
  RTFAGR=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  RTFAGR=-9999.99
fi

if [ -f $FDEMIND ]; then
  htmask $ARG $FDEMIND $MASK eq $NUM $TEMP   > $DN
  DEMIND=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  DEMIND=-9999.99
fi

FSUPIND=$DIRSUPIND/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPIND ]; then
  htmask $ARG $FSUPIND $MASK eq $NUM $TEMP > $DN
  SUPIND=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPIND=-9999.99
fi

FSUPINDRIV=$DIRSUPINDRIV/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPINDRIV ]; then
  htmask $ARG $FSUPINDRIV $MASK eq $NUM $TEMP > $DN
  SUPINDRIV=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPINDRIV=-9999.99
fi

FSUPINDCAN=$DIRSUPINDCAN/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPINDCAN ]; then
  htmask $ARG $FSUPINDCAN $MASK eq $NUM $TEMP > $DN
  SUPINDCAN=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPINDCAN=-9999.99
fi

FSUPINDGW=$DIRSUPINDGW/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPINDGW ]; then
  htmask $ARG $FSUPINDGW $MASK eq $NUM $TEMP > $DN
  SUPINDGW=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPINDGW=-9999.99
fi

FSUPINDMSR=$DIRSUPINDMSR/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPINDMSR ]; then
  htmask $ARG $FSUPINDMSR $MASK eq $NUM $TEMP > $DN
  SUPINDMSR=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPINDMSR=-9999.99
fi

FSUPINDNNB=$DIRSUPINDNNB/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPINDNNB ]; then
  htmask $ARG $FSUPINDNNB $MASK eq $NUM $TEMP > $DN
  SUPINDNNB=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPINDNNB=-9999.99
fi

if [ $OPTNNB = new ]; then
  FSUPINDNNBS=$DIRSUPINDNNBS/$PRJ$RUN$YEAR$MON$DAY$SUF
  if [ -f $FSUPINDNNBS ]; then
    htmask $ARG $FSUPINDNNBS $MASK eq $NUM $TEMP > $DN
    SUPINDNNBS=`htstat $ARG sum $TEMP | \
    awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
  else
    SUPINDNNBS=-9999.99
  fi

  FSUPINDNNBG=$DIRSUPINDNNBG/$PRJ$RUN$YEAR$MON$DAY$SUF
  if [ -f $FSUPINDNNBG ]; then
    htmask $ARG $FSUPINDNNBG $MASK eq $NUM $TEMP > $DN
    SUPINDNNBG=`htstat $ARG sum $TEMP | \
    awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
  else
    SUPINDNNBG=-9999.99
  fi
else
  SUPINDNNBS=-9999.99
  SUPINDNNBG=-9999.99
fi

FSUPINDDES=$DIRSUPINDDES/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPINDDES ]; then
  htmask $ARG $FSUPINDDES $MASK eq $NUM $TEMP > $DN
  SUPINDDES=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPINDDES=-9999.99
fi

FSUPINDRCL=$DIRSUPINDRCL/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPINDRCL ]; then
  htmask $ARG $FSUPINDRCL $MASK eq $NUM $TEMP > $DN
  SUPINDRCL=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPINDRCL=-9999.99
fi

FSUPINDDEF=$DIRSUPINDDEF/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPINDDEF ]; then
  htmask $ARG $FSUPINDDEF $MASK eq $NUM $TEMP > $DN
  SUPINDDEF=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPINDDEF=-9999.99
fi

FRTFIND=$DIRRTFIND/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FRTFIND ]; then
  htmask $ARG $FRTFIND $MASK eq $NUM $TEMP > $DN
  RTFIND=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  RTFIND=-9999.99
fi

if [ -f $FWITIND ]; then
  htmask $ARG $FWITIND $MASK eq $NUM $TEMP  > $DN
  WITIND=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  WITIND=-9999.99
fi

if [ -f $FDEMDOM ]; then
  htmask $ARG $FDEMDOM $MASK eq $NUM $TEMP > $DN
  DEMDOM=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
echo $FDEMDOM not found.
  DEMDOM=-9999.99
fi

FSUPDOM=$DIRSUPDOM/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOM ]; then
  htmask $ARG $FSUPDOM $MASK eq $NUM $TEMP > $DN
  SUPDOM=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOM=-9999.99
fi

FSUPDOMRIV=$DIRSUPDOMRIV/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOMRIV ]; then
  htmask $ARG $FSUPDOMRIV $MASK eq $NUM $TEMP > $DN
  SUPDOMRIV=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOMRIV=-9999.99
fi

FSUPDOMCAN=$DIRSUPDOMCAN/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOMCAN ]; then
  htmask $ARG $FSUPDOMCAN $MASK eq $NUM $TEMP > $DN
  SUPDOMCAN=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOMCAN=-9999.99
fi

FSUPDOMGW=$DIRSUPDOMGW/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOMGW ]; then
  htmask $ARG $FSUPDOMGW $MASK eq $NUM $TEMP > $DN
  SUPDOMGW=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOMGW=-9999.99
fi

FSUPDOMMSR=$DIRSUPDOMMSR/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOMMSR ]; then
  htmask $ARG $FSUPDOMMSR $MASK eq $NUM $TEMP > $DN
  SUPDOMMSR=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOMMSR=-9999.99
fi

FSUPDOMNNB=$DIRSUPDOMNNB/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOMNNB ]; then
  htmask $ARG $FSUPDOMNNB $MASK eq $NUM $TEMP > $DN
  SUPDOMNNB=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOMNNB=-9999.99
fi

if [ $OPTNNB = new ]; then
  FSUPDOMNNBS=$DIRSUPDOMNNBS/$PRJ$RUN$YEAR$MON$DAY$SUF
  if [ -f $FSUPDOMNNBS ]; then
    htmask $ARG $FSUPDOMNNBS $MASK eq $NUM $TEMP > $DN
    SUPDOMNNBS=`htstat $ARG sum $TEMP | \
    awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
  else
    SUPDOMNNBS=-9999.99
  fi

  FSUPDOMNNBG=$DIRSUPDOMNNBG/$PRJ$RUN$YEAR$MON$DAY$SUF
  if [ -f $FSUPDOMNNBG ]; then
    htmask $ARG $FSUPDOMNNBG $MASK eq $NUM $TEMP > $DN
    SUPDOMNNBG=`htstat $ARG sum $TEMP | \
    awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
  else
    SUPDOMNNBG=-9999.99
  fi
else
  SUPDOMNNBS=-9999.99
  SUPDOMNNBG=-9999.99
fi

FSUPDOMDES=$DIRSUPDOMDES/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOMDES ]; then
  htmask $ARG $FSUPDOMDES $MASK eq $NUM $TEMP > $DN
  SUPDOMDES=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOMDES=-9999.99
fi

FSUPDOMRCL=$DIRSUPDOMRCL/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOMRCL ]; then
  htmask $ARG $FSUPDOMRCL $MASK eq $NUM $TEMP > $DN
  SUPDOMRCL=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOMRCL=-9999.99
fi

FSUPDOMDEF=$DIRSUPDOMDEF/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FSUPDOMDEF ]; then
  htmask $ARG $FSUPDOMDEF $MASK eq $NUM $TEMP > $DN
  SUPDOMDEF=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SUPDOMDEF=-9999.99
fi

FRTFDOM=$DIRRTFDOM/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FRTFDOM ]; then
  htmask $ARG $FRTFDOM $MASK eq $NUM $TEMP > $DN
  RTFDOM=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  RTFDOM=-9999.99
fi


FLOSAGR=$DIRLOSAGR/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FLOSAGR ]; then
  htmask $ARG $FLOSAGR $MASK eq $NUM $TEMP > $DN
  LOSAGR=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  LOSAGR=-9999.99
fi

if [ -f $FWITDOM ]; then
  htmask $ARG $FWITDOM $MASK eq $NUM $TEMP  > $DN
  WITDOM=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  WITDOM=-9999.99
fi

if [ -f $FWITAGR ]; then
  htmask $ARG $FWITAGR $MASK eq $NUM $TEMP > $DN
  WITAGR=`htstat $ARG sum $TEMP | \
  awk '{print $1*86400*'${DAYS}'/1000/1000/1000/1000}'`
else
  WITAGR=-9999.99
fi
############################################################
# Job (summation)
############################################################
    WITTOT=0.0
    WITTOT=`echo $WITTOT $WITAGR | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    WITTOT=`echo $WITTOT $WITIND | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    WITTOT=`echo $WITTOT $WITDOM | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    WITTOT=`echo $WITTOT        | awk '{if($1==0.0) print -9999.99; else print $1}'`

    RTFTOT=0.0
    RTFTOT=`echo $RTFTOT $RTFAGR | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    RTFTOT=`echo $RTFTOT $RTFIND | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    RTFTOT=`echo $RTFTOT $RTFDOM | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    RTFTOT=`echo $RTFTOT        | awk '{if($1==0.0) print -9999.99; else print $1}'`

    DEMTOT=0.0
    DEMTOT=`echo $DEMTOT $DEMAGR | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    DEMTOT=`echo $DEMTOT $DEMIND | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    DEMTOT=`echo $DEMTOT $DEMDOM | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    DEMTOT=`echo $DEMTOT        | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOT=0.0
    SUPTOT=`echo $SUPTOT $SUPAGR | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOT=`echo $SUPTOT $SUPIND | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOT=`echo $SUPTOT $SUPDOM | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOT=`echo $SUPTOT        | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTRIV=0.0
    SUPTOTRIV=`echo $SUPTOTRIV $SUPAGRRIV | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTRIV=`echo $SUPTOTRIV $SUPINDRIV | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTRIV=`echo $SUPTOTRIV $SUPDOMRIV | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTRIV=`echo $SUPTOTRIV           | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTCAN=0.0
    SUPTOTCAN=`echo $SUPTOTCAN $SUPAGRCAN | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTCAN=`echo $SUPTOTCAN $SUPINDCAN | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTCAN=`echo $SUPTOTCAN $SUPDOMCAN | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTCAN=`echo $SUPTOTCAN           | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTMSR=0.0
    SUPTOTMSR=`echo $SUPTOTMSR $SUPAGRMSR | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTMSR=`echo $SUPTOTMSR $SUPINDMSR | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTMSR=`echo $SUPTOTMSR $SUPDOMMSR | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTMSR=`echo $SUPTOTMSR           | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTNNBS=0.0
    SUPTOTNNBS=`echo $SUPTOTNNBS $SUPAGRNNBS | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNBS=`echo $SUPTOTNNBS $SUPINDNNBS | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNBS=`echo $SUPTOTNNBS $SUPDOMNNBS | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNBS=`echo $SUPTOTNNBS            | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTNNB=0.0
    SUPTOTNNB=`echo $SUPTOTNNB $SUPAGRNNB | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNB=`echo $SUPTOTNNB $SUPINDNNB | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNB=`echo $SUPTOTNNB $SUPDOMNNB | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNB=`echo $SUPTOTNNB           | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTDES=0.0
    SUPTOTDES=`echo $SUPTOTDES $SUPAGRDES | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTDES=`echo $SUPTOTDES $SUPINDDES | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTDES=`echo $SUPTOTDES $SUPDOMDES | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTDES=`echo $SUPTOTDES           | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTRCL=0.0
    SUPTOTRCL=`echo $SUPTOTRCL $SUPAGRRCL | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTRCL=`echo $SUPTOTRCL $SUPINDRCL | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTRCL=`echo $SUPTOTRCL $SUPDOMRCL | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTRCL=`echo $SUPTOTRCL           | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTDEF=0.0
    SUPTOTDEF=`echo $SUPTOTDEF $SUPAGRDEF | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTDEF=`echo $SUPTOTDEF $SUPINDDEF | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTDEF=`echo $SUPTOTDEF $SUPDOMDEF | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTDEF=`echo $SUPTOTDEF           | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTGW=0.0
    SUPTOTGW=`echo $SUPTOTGW $SUPAGRGW | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTGW=`echo $SUPTOTGW $SUPINDGW | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTGW=`echo $SUPTOTGW $SUPDOMGW | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTGW=`echo $SUPTOTGW          | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTNNBG=0.0
    SUPTOTNNBG=`echo $SUPTOTNNBG $SUPAGRNNBG | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNBG=`echo $SUPTOTNNBG $SUPINDNNBG | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNBG=`echo $SUPTOTNNBG $SUPDOMNNBG | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTNNBG=`echo $SUPTOTNNBG            | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPAGRG=0.0
    SUPAGRG=`echo $SUPAGRG $SUPAGRGW   | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPAGRG=`echo $SUPAGRG $SUPAGRNNBG | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPAGRG=`echo $SUPAGRG             | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPINDG=0.0
    SUPINDG=`echo $SUPINDG $SUPINDGW   | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPINDG=`echo $SUPINDG $SUPINDNNBG | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPINDG=`echo $SUPINDG             | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPDOMG=0.0
    SUPDOMG=`echo $SUPDOMG $SUPDOMGW   | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPDOMG=`echo $SUPDOMG $SUPDOMNNBG | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPDOMG=`echo $SUPDOMG             | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPTOTG=0.0
    SUPTOTG=`echo $SUPTOTG $SUPTOTGW   | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTG=`echo $SUPTOTG $SUPTOTNNBG | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTG=`echo $SUPTOTG             | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPAGRS=0.0
    SUPAGRS=`echo $SUPAGRS $SUPAGRRIV  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPAGRS=`echo $SUPAGRS $SUPAGRCAN  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPAGRS=`echo $SUPAGRS $SUPAGRMSR  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPAGRS=`echo $SUPAGRS $SUPAGRNNBS | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPAGRS=`echo $SUPAGRS             | awk '{if($1==0.0) print -9999.99; else print $1}'`
    SUPINDS=0.0
    SUPINDS=`echo $SUPINDS $SUPINDRIV  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPINDS=`echo $SUPINDS $SUPINDCAN  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPINDS=`echo $SUPINDS $SUPINDMSR  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPINDS=`echo $SUPINDS $SUPINDNNBS | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPINDS=`echo $SUPINDS             | awk '{if($1==0.0) print -9999.99; else print $1}'`
    SUPDOMS=0.0
    SUPDOMS=`echo $SUPDOMS $SUPDOMRIV  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPDOMS=`echo $SUPDOMS $SUPDOMCAN  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPDOMS=`echo $SUPDOMS $SUPDOMMSR  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPDOMS=`echo $SUPDOMS $SUPDOMNNBS | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPDOMS=`echo $SUPDOMS             | awk '{if($1==0.0) print -9999.99; else print $1}'`
    SUPTOTS=0.0
    SUPTOTS=`echo $SUPTOTS $SUPTOTRIV  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTS=`echo $SUPTOTS $SUPTOTCAN  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTS=`echo $SUPTOTS $SUPTOTMSR  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTS=`echo $SUPTOTS $SUPTOTNNBS | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTS=`echo $SUPTOTS             | awk '{if($1==0.0) print -9999.99; else print $1}'`

    SUPAGRSG=0.0
    SUPAGRSG=`echo $SUPAGRSG $SUPAGRS  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPAGRSG=`echo $SUPAGRSG $SUPAGRG  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPINDSG=0.0
    SUPINDSG=`echo $SUPINDSG $SUPINDS  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPINDSG=`echo $SUPINDSG $SUPINDG  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPDOMSG=0.0
    SUPDOMSG=`echo $SUPDOMSG $SUPDOMS  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPDOMSG=`echo $SUPDOMSG $SUPDOMG  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTSG=0.0
    SUPTOTSG=`echo $SUPTOTSG $SUPTOTS  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  
    SUPTOTSG=`echo $SUPTOTSG $SUPTOTG  | awk '{if($2==-9999.99) print $1; else print $1+$2}'`  

############################################################
# Job (Land Fluxes (unit is km3/yr))
############################################################
FRAINF=$DIRRAINF/$PRJMET$RUNMET$YEAR$MON$DAY$SUF
#FRAINF=$DIRRAINF/$PRJ$RUN$YEAR$MON$DAY$SUF   # climate change
if [ -f $FRAINF ]; then
  htmask $ARG $FRAINF $MASK eq $NUM $TEMP > $DN
  htmath $L mul $TEMP $FLNDARADUM $TEMP
  RAINF=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  RAINF=-9999.99
fi

FSNOWF=$DIRSNOWF/$PRJMET$RUNMET$YEAR$MON$DAY$SUF
#FSNOWF=$DIRSNOWF/$PRJ$RUN$YEAR$MON$DAY$SUF    # climate change
if [ -f $FSNOWF ]; then
  htmask $ARG $FSNOWF $MASK eq $NUM $TEMP > $DN
  htmath $L mul $TEMP $FLNDARADUM $TEMP
  SNOWF=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  SNOWF=-9999.99
fi

FEVAP=$DIREVAP/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FEVAP ]; then
  htmask $ARG $FEVAP $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP  $FLNDARADUM $TEMP
  EVAP=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  EVAP=-9999.99
fi

FQTOT=$DIRQTOT/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FQTOT ]; then
  htmask $ARG $FQTOT $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP   $FLNDARADUM $TEMP
  QTOT=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  QTOT=-9999.99
fi

FQS=$DIRQS/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FQS ]; then
  htmask $ARG $FQS $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP   $FLNDARADUM $TEMP
  QS=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  QS=-9999.99
fi

FQSB=$DIRQSB/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FQSB ]; then
  htmask $ARG $FQSB $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP   $FLNDARADUM $TEMP
  QSB=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  QSB=-9999.99
fi

FQRC=$DIRQRC/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FQRC ]; then
  htmask $ARG $FQRC $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP   $FLNDARADUM $TEMP
  QRC=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  QRC=-9999.99
fi

FQBF=$DIRQBF/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FQBF ]; then
  htmask $ARG $FQBF $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP   $FLNDARADUM $TEMP
  QBF=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`
else
  QBF=-9999.99
fi

FSOILMOISTINI=$DIRSOILMOIST/$PRJ$RUN$YEARINI$MONINI$DAYINI$SUF
FSOILMOISTEND=$DIRSOILMOIST/$PRJ$RUN$YEAREND$MONEND$DAYEND$SUF
if [ -f $FSOILMOISTINI ]; then
  htmath $L sub $FSOILMOISTEND $FSOILMOISTINI $TEMP
  htmask $ARG $TEMP $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP   $FLNDARADUM $TEMP
  DELSOILMOIST=`htstat $ARG sum $TEMP   | \
  awk '{printf("%12.2f",$1/1000/1000/1000/1000)}'`
else
  DELSOILMOIST=-9999.99
fi

FSWEINI=$DIRSWE/$PRJ$RUN$YEARINI$MONINI$DAYINI$SUF
FSWEEND=$DIRSWE/$PRJ$RUN$YEAREND$MONEND$DAYEND$SUF
if [ -f $FSWEINI ]; then
  htmath $L sub $FSWEEND $FSWEINI $TEMP
  htmask $ARG $TEMP $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP   $FLNDARADUM $TEMP
  DELSWE=`htstat $ARG sum $TEMP   | \
  awk '{printf("%12.2f",$1/1000/1000/1000/1000)}'`
else
  DELSWE=-9999.99
fi

FGWINI=$DIRGW/$PRJ$RUN$YEARINI$MONINI$DAYINI$SUF
FGWEND=$DIRGW/$PRJ$RUN$YEAREND$MONEND$DAYEND$SUF
if [ -f $FGWINI ]; then
  htmath $L sub $FGWEND $FGWINI $TEMP
  htmask $ARG $TEMP $MASK eq $NUM $TEMP  > $DN
  htmath $L mul $TEMP   $FLNDARADUM $TEMP
  DELGW=`htstat $ARG sum $TEMP   | \
  awk '{printf("%12.2f",$1/1000/1000/1000/1000)}'`
else
  DELGW=-9999.99
fi
############################################################
# Job (River)
############################################################
FRIVOUT=$DIRRIVOUT/$PRJ$RUN$YEAR$MON$DAY$SUF
if [ -f $FRIVOUT ]; then
  htmask $ARG $FRIVOUT $MASK eq $NUM $TEMP > $DN
  htmask $ARG $TEMP  $FFLWDIR eq 9   $TEMP > $DN
  RIVOUT=`htstat $ARG sum $TEMP | \
  awk '{print $1*86400*'${DAYS}'/1000/1000/1000/1000}'`  
else
  RIVOUT=-9999.99
fi

FRIVSTOINI=$DIRRIVSTO/$PRJ$RUN$YEARINI$MONINI$DAYINI$SUF
FRIVSTOEND=$DIRRIVSTO/$PRJ$RUN$YEAREND$MONEND$DAYEND$SUF
if [ -f $FRIVSTOINI ]; then
  htmath $L sub $FRIVSTOEND $FRIVSTOINI $TEMP
  htmask $ARG $TEMP $MASK eq $NUM $TEMP    > $DN
  DELRIVSTO=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1/1000/1000/1000/1000)}'`
else
  DELRIVSTO=-9999.99
fi
############################################################
# Job (Environmental flow)
############################################################
YEARENV=0000
FENVFLW=$DIRENVOUT/$PRJENV$RUNENV$YEARENV$MON$DAY$SUF
if [ -f $FENVFLW ]; then
  htmask $ARG $FENVFLW $MASK eq $NUM $TEMP > $DN
  htmask $ARG $TEMP  $FFLWDIR eq 9   $TEMP > $DN
  ENVFLW=`htstat $ARG sum $TEMP | \
  awk '{printf("%12.2f",$1*86400*'${DAYS}'/1000/1000/1000/1000)}'`  
else
  ENVFLW=-9999.99
fi
############################################################
# Job (Dam)
############################################################
FDAMSTOINI=$DIRDAMSTO/$PRJ$RUN$YEARINI$MONINI$DAYINI$SUF
FDAMSTOEND=$DIRDAMSTO/$PRJ$RUN$YEAREND$MONEND$DAYEND$SUF
if [ -f $FDAMSTOINI -a -f $FDAMSTOEND ]; then
  htmath $L sub $FDAMSTOEND $FDAMSTOINI $TEMP
  htmask $ARG $TEMP $MASK eq $NUM $TEMP  > $DN
  DELDAMSTO=`htstat $ARG sum $TEMP   | \
  awk '{printf("%12.2f",$1/1000/1000/1000/1000)}'`
else
  DELDAMSTO=-9999.99
fi

FMSRSTOINI=$DIRMSRSTO/$PRJ$RUN$YEARINI$MONINI$DAYINI$SUF
FMSRSTOEND=$DIRMSRSTO/$PRJ$RUN$YEAREND$MONEND$DAYEND$SUF
if [ -f $FMSRSTOINI -a -f $FMSRSTOEND ]; then
  htmath $L sub $FMSRSTOEND $FMSRSTOINI $TEMP
  htmask $ARG $TEMP $MASK eq $NUM $TEMP  > $DN
  DELMSRSTO=`htstat $ARG sum $TEMP   | \
  awk '{printf("%12.2f",$1/1000/1000/1000/1000)}'`
else
  DELMSRSTO=-9999.99
fi
############################################################
# Job (Calculate SUPTOT and PRCP)
############################################################
  SUPTOT=0.0
  if [ $SUPAGR != -9999.99 ];then
    SUPTOT=`echo $SUPTOT $SUPAGR | awk '{printf("%12.2f",$1+$2)}'`
  fi
  if [ $SUPIND != -9999.99 ];then
    SUPTOT=`echo $SUPTOT $SUPIND  | awk '{printf("%12.2f",$1+$2)}'`
  fi
  if [ $SUPDOM != -9999.99 ];then
    SUPTOT=`echo $SUPTOT $SUPDOM  | awk '{printf("%12.2f",$1+$2)}'`
  fi
  if [ $SUPTOT = 0.0 ]; then
    SUPTOT=-9999.99
  fi

  PRCP=0.0
  if [ $RAINF != -9999.99 ];then
    PRCP=`echo $PRCP $RAINF | awk '{printf("%12.2f",$1+$2)}'`
  fi
  if [ $SNOWF != -9999.99 ];then
    PRCP=`echo $PRCP $SNOWF | awk '{printf("%12.2f",$1+$2)}'`
  fi
  if [ $PRCP = 0.0 ]; then
    PRCP=-9999.99
  fi
############################################################
# Job (Calculate water imbalance map)
############################################################
  htcreate $L 0.0 $FBALLND
  htmaskrplc $ARG $FBALLND $MASK ne $NUM 1.0E20 $FBALLND > $DN
  if [ $PRCP != -9999.99 ];then
    htmath $L add $FBALLND $FRAINF   $FBALLND # kg/m2/s
    htmath $L add $FBALLND $FSNOWF   $FBALLND # kg/m2/s
  fi
  if [ $SUPAGR != -9999.99 ];then
    htmath $L div $FSUPAGR $FLNDARADUM $TEMP  # kg/s
    htmask $ARG $TEMP $FSUPAGR gt 0 $TEMP > $DN
    htmaskrplc $ARG $TEMP $TEMP eq 1.0E20 0 $TEMP > $DN
    htmath $L add $FBALLND $TEMP    $FBALLND  # kg/s
  fi
  if [ $SUPAGRGW != -9999.99 ];then
    htmath $L div $FSUPAGRGW $FLNDARADUM $TEMP  # kg/s
    htmask $ARG $TEMP $FSUPAGRGW gt 0 $TEMP > $DN
    htmaskrplc $ARG $TEMP $TEMP eq 1.0E20 0 $TEMP > $DN
    htmath $L sub $FBALLND $TEMP    $FBALLND  # kg/s
  fi
  if [ $SUPINDGW != -9999.99 ];then
    htmath $L div $FSUPINDGW $FLNDARADUM $TEMP  # kg/s
    htmask $ARG $TEMP $FSUPINDGW gt 0 $TEMP > $DN
    htmaskrplc $ARG $TEMP $TEMP eq 1.0E20 0 $TEMP > $DN
    htmath $L sub $FBALLND $TEMP    $FBALLND  # kg/s
  fi
  if [ $SUPDOMGW != -9999.99 ];then
    htmath $L div $FSUPDOMGW $FLNDARADUM $TEMP  # kg/s
    htmask $ARG $TEMP $FSUPDOMGW gt 0 $TEMP > $DN
    htmaskrplc $ARG $TEMP $TEMP eq 1.0E20 0 $TEMP > $DN
    htmath $L sub $FBALLND $TEMP    $FBALLND  # kg/s
  fi
  if [ $EVAP != -9999.99 ];then
    htmath $L sub $FBALLND $FEVAP $FBALLND    # kg/m2/s
  fi
  if [ $QTOT != -9999.99 ];then
    htmath $L sub $FBALLND $FQTOT $FBALLND    # kg/m2/s
  fi
  htmath $L mul $FBALLND $TIME $FBALLND    # kg/m2/s --> kg/m2/yr
  if [ $DELSOILMOIST != -9999.99 ];then
    htmath $L sub $FBALLND $FSOILMOISTEND $FBALLND # kg/m2/yr
    htmath $L add $FBALLND $FSOILMOISTINI $FBALLND # kg/m2/yr
  fi
  if [ $DELSWE != -9999.99 ];then
    htmath $L sub $FBALLND $FSWEEND $FBALLND  # kg/m2/yr
    htmath $L add $FBALLND $FSWEINI $FBALLND  # kg/m2/yr
  fi
  if [ $DELGW != -9999.99 ];then
    htmath $L sub $FBALLND $FGWEND $FBALLND   # kg/m2/yr
    htmath $L add $FBALLND $FGWINI $FBALLND   # kg/m2/yr
  fi

#
  BALLNDMAXIBVAL=`htstat $ARG max $FBALLND | awk '{print $1}'`
  BALLNDMAXIBLAT=`htstat $ARG max $FBALLND | awk '{print $6}'`
  BALLNDMAXIBLON=`htstat $ARG max $FBALLND | awk '{print $5}'`
  BALLNDMAXIBNUM=`htmask $ARG $FBALLND $FBALLND gt 1 $TEMP | awk '{print $3}'`
  BALLNDMINIBVAL=`htstat $ARG min $FBALLND | awk '{print $1}'`
  BALLNDMINIBLAT=`htstat $ARG min $FBALLND | awk '{print $6}'`
  BALLNDMINIBLON=`htstat $ARG min $FBALLND | awk '{print $5}'`
  BALLNDMINIBNUM=`htmask $ARG $FBALLND $FBALLND lt -1 $TEMP | awk '{print $3}'`
#
  htmath $L mul $FBALLND $FLNDARADUM $TEMP  # kg/m2/yr --> kg/yr
  BALLNDIBTOT=`htstat $ARG sum $TEMP | awk '{print $1/1000/1000/1000/1000}'`
############################################################
# Job
############################################################
echo                                    >> $OUT
echo '+++ Water balance of land +++'    >> $OUT
echo                                    >> $OUT
BALLND=0
BALLND=`./comm_watbal $BALLND plus  $PRCP         PRCP   [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND plus  $SUPAGR       SUPAGR [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND minus $EVAP         EVAP   [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND minus $QTOT         QTOT   [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND minus $DELSOILMOIST DELSM  [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND minus $DELSWE       DELSWE [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND minus $DELGW        DELGW  [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND minus $SUPAGRGW     SUPAGRGW  [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND minus $SUPINDGW     SUPINDGW  [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND minus $SUPDOMGW     SUPDOMGW  [km3/y] $OUT`
BALLND=`./comm_watbal $BALLND fin   $BALLND       BALLND [km3/y] $OUT`

echo                                               >> $OUT
echo '+++ Water balance of the river system +++'   >> $OUT
echo                                               >> $OUT
BALRIV=0
BALRIV=`./comm_watbal $BALRIV plus  $QTOT      QTOT      [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $RIVOUT    RIVOUT    [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPAGRRIV SUPAGRRIV [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPINDRIV SUPINDRIV [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPDOMRIV SUPDOMRIV [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPAGRCAN SUPAGRCAN [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPINDCAN SUPINDCAN [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPDOMCAN SUPDOMCAN [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV plus  $RTFAGR    RTFAGR    [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV plus  $RTFIND    RTFIND    [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV plus  $RTFDOM    RTFDOM    [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPAGRMSR SUPAGRMSR [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPINDMSR SUPINDMSR [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $SUPDOMMSR SUPDOMMSR [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $DELRIVSTO DELRIVSTO [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $DELDAMSTO DELDAMSTO [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV minus $DELMSRSTO DELMSRSTO [km3/y] $OUT`
BALRIV=`./comm_watbal $BALRIV fin   $BALRIV    BALRIV    [km3/y] $OUT`
########################################################################
# Balance of coupled model
########################################################################
echo                                               >> $OUT
echo '+++ Water balance of the coupled system +++' >> $OUT
echo                                               >> $OUT
BALCPL=0
BALCPL=`./comm_watbal $BALCPL plus  $PRCP      PRCP      [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPAGRNNB SUPAGRNNB [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPINDNNB SUPINDNNB [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPDOMNNB SUPDOMNNB [km3/y] $OUT`
if [ $OPTNNB = new ]; then
BALCPL=`./comm_watbal $BALCPL plus  $SUPAGRNNBS SUPAGRNNBS [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPINDNNBS SUPINDNNBS [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPDOMNNBS SUPDOMNNBS [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPAGRNNBG SUPAGRNNBG [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPINDNNBG SUPINDNNBG [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPDOMNNBG SUPDOMNNBG [km3/y] $OUT`
fi
BALCPL=`./comm_watbal $BALCPL plus  $SUPAGRDES SUPAGRDES [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPINDDES SUPINDDES [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPDOMDES SUPDOMDES [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPAGRRCL SUPAGRRCL [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPINDRCL SUPINDRCL [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL plus  $SUPDOMRCL SUPDOMRCL [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $EVAP      EVAP      [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $RIVOUT    RIVOUT    [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $SUPIND    SUPIND    [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $SUPDOM    SUPDOM    [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $DELSOILMOIST DELSM  [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $DELSWE    DELSWE    [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $DELGW     DELGW     [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $LOSAGR    LOSAGR    [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $DELRIVSTO DELRIVSTO [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $DELDAMSTO DELDAMSTO [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL minus $DELMSRSTO DELMSRSTO [km3/y] $OUT`
BALCPL=`./comm_watbal $BALCPL fin   $BALCPL    BALCPL    [km3/y] $OUT`

echo                                           >> $OUT
echo '+++ Water balance of groundwater +++'    >> $OUT
echo                                           >> $OUT
BALGW=0
BALGW=`./comm_watbal $BALGW  plus   $QRC      QRC      [km3/y] $OUT`
BALGW=`./comm_watbal $BALGW  minus  $QBF      QBF      [km3/y] $OUT`
BALGW=`./comm_watbal $BALGW  minus  $DELGW    DELGW    [km3/y] $OUT`
BALGW=`./comm_watbal $BALGW  minus  $SUPAGRGW SUPAGRGW [km3/y] $OUT`
BALGW=`./comm_watbal $BALGW  minus  $SUPINDGW SUPINDGW [km3/y] $OUT`
BALGW=`./comm_watbal $BALGW  minus  $SUPDOMGW SUPDOMGW [km3/y] $OUT`
BALGW=`./comm_watbal $BALGW  fin    $BALGW    BALGW    [km3/y] $OUT`
echo                                             >> $OUT
echo '+++ Water balance of surface water +++'    >> $OUT
echo                                             >> $OUT
BALSW=0
BALSW=`./comm_watbal $BALSW  plus   $PRCP         PRCP   [km3/y] $OUT`
BALSW=`./comm_watbal $BALSW  plus   $SUPAGR       SUPAGR [km3/y] $OUT`
BALSW=`./comm_watbal $BALSW  minus  $EVAP         EVAP   [km3/y] $OUT`
BALSW=`./comm_watbal $BALSW  minus  $QS           QS     [km3/y] $OUT`
BALSW=`./comm_watbal $BALSW  minus  $QSB          QSB    [km3/y] $OUT`
BALSW=`./comm_watbal $BALSW  minus  $QRC          QRC    [km3/y] $OUT`
BALSW=`./comm_watbal $BALSW  minus  $DELSOILMOIST DELSM  [km3/y] $OUT`
BALSW=`./comm_watbal $BALSW  minus  $DELSWE       DELSWE [km3/y] $OUT`
BALSW=`./comm_watbal $BALSW  fin    $BALSW        BALSW  [km3/y] $OUT`
############################################################
# Job (Write list)
############################################################
echo                                    >> $OUT
echo '+++ General +++'                  >> $OUT
echo                                    >> $OUT
echo AREA..       $ARA          [km2]   | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo ARANON       $ARANON       [km2]   | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo ARAIRG       $ARAIRG       [km2]   | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo DAMCAP       $DAMCAP       [km3]   | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo POPTOT       $POPTOT       [106]   | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo                                    >> $OUT
echo '+++ Agricultural +++'             >> $OUT
echo                                    >> $OUT
echo Consumption                        >> $OUT
echo DEMAGR...    $DEMAGR       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGR...    $SUPAGR       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo Withdrawal                        >> $OUT
echo SUPAGRRIV    $SUPAGRRIV    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRCAN    $SUPAGRCAN    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRGW.    $SUPAGRGW     [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRMSR    $SUPAGRMSR    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRNNB    $SUPAGRNNB    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRNNBS   $SUPAGRNNBS   [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRNNBG   $SUPAGRNNBG   [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRDES    $SUPAGRDES    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRRCL    $SUPAGRRCL    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRDEF    $SUPAGRDEF    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRS..    $SUPAGRS      [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRG..    $SUPAGRG      [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPAGRTOT    $SUPAGRSG     [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo AQUASTAT.    $WITAGR       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo                                    >> $OUT
echo '+++ Industrial +++'               >> $OUT
echo                                    >> $OUT
echo Consumption                        >> $OUT
echo DEMIND...    $DEMIND       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPIND...    $SUPIND       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo Withdrawal                        >> $OUT
echo SUPINDRIV    $SUPINDRIV    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDCAN    $SUPINDCAN    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDGW.    $SUPINDGW     [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDMSR    $SUPINDMSR    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDNNB    $SUPINDNNB    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDNNBS   $SUPINDNNBS   [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDNNBG   $SUPINDNNBG   [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDDES    $SUPINDDES    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDRCL    $SUPINDRCL    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDDEF    $SUPINDDEF    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDS..    $SUPINDS      [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDG..    $SUPINDG      [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPINDTOT    $SUPINDSG     [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo AQUASTAT.    $WITIND       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo                                    >> $OUT
echo '+++ Domestic +++'                 >> $OUT
echo                                    >> $OUT
echo Consumption                        >> $OUT
echo DEMDOM...    $DEMDOM       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOM...    $SUPDOM       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo Withdrawal                        >> $OUT
echo SUPDOMRIV    $SUPDOMRIV    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMCAN    $SUPDOMCAN    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMGW.    $SUPDOMGW     [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMMSR    $SUPDOMMSR    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMNNB    $SUPDOMNNB    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMNNBS   $SUPDOMNNBS   [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMNNBG   $SUPDOMNNBG   [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMDES    $SUPDOMDES    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMRCL    $SUPDOMRCL    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMDEF    $SUPDOMDEF    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMS..    $SUPDOMS      [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMG..    $SUPDOMG      [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPDOMTOT    $SUPDOMSG     [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo AQUASTAT.    $WITDOM       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo                                    >> $OUT
echo '+++ Total +++'                    >> $OUT
echo                                    >> $OUT
echo Consumption                        >> $OUT
echo DEMTOT...    $DEMTOT       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOT...    $SUPTOT       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo Other terms                        >> $OUT
echo RTFTOT       $RTFTOT       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo LOSAGR       $LOSAGR       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo Withdrawal                        >> $OUT
echo SUPTOTRIV    $SUPTOTRIV    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTCAN    $SUPTOTCAN    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTGW.    $SUPTOTGW     [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTMSR    $SUPTOTMSR    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTNNB    $SUPTOTNNB    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTNNBS   $SUPTOTNNBS   [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTNNBG   $SUPTOTNNBG   [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTDES    $SUPTOTDES    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTRCL    $SUPTOTRCL    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTDEF    $SUPTOTDEF    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTSRF    $SUPTOTS      [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTGW.    $SUPTOTG      [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo SUPTOTALL    $SUPTOTSG     [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo AQUASTAT.    $WITTOT       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT

echo                                      >> $OUT
echo '+++ Water imbalance of land +++'    >> $OUT
echo                                      >> $OUT
echo 'MAXVAL..'      $BALLNDMAXIBVAL [mm]    | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LON.....'      $BALLNDMAXIBLON [degN]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LAT.....'      $BALLNDMAXIBLAT [degE]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'NUM[>1].'      $BALLNDMAXIBNUM [cells] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'MINVAL..'      $BALLNDMINIBVAL [mm]    | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LON.....'      $BALLNDMINIBLON [degN]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LAT.....'      $BALLNDMINIBLAT [degE]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'NUM[<-1]'      $BALLNDMINIBNUM [cells] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'BALLND..'      $BALLNDIBTOT    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'FILE....'      $FBALLND        [kg/y]  | awk '{printf("%12s%12s%8s\n",$1,$2,$3)}' >> $OUT
echo                                    >> $OUT
echo '+++ Environmental +++'            >> $OUT
echo                                    >> $OUT
echo ENVFLW       $ENVFLW       [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo                                    >> $OUT
############################################################
# Job (Calculate surface water imbalance map)
############################################################
  htcreate $L 0.0 $FBALSW
  htmaskrplc $ARG $FBALSW $MASK ne $NUM 1.0E20 $FBALSW > $DN
  if [ $PRCP != -9999.99 ];then
    htmath $L add $FBALSW $FRAINF   $FBALSW # kg/m2/s
    htmath $L add $FBALSW $FSNOWF   $FBALSW # kg/m2/s
  fi
  if [ $SUPAGR != -9999.99 ];then
    htmath $L div $FSUPAGR $FLNDARADUM $TEMP  # kg/s
    htmask $ARG $TEMP $FSUPAGR gt 0 $TEMP > $DN
    htmaskrplc $ARG $TEMP $TEMP eq 1.0E20 0 $TEMP > $DN
    htmath $L add $FBALSW $TEMP    $FBALSW  # kg/s
  fi
  if [ $EVAP != -9999.99 ];then
    htmath $L sub $FBALSW $FEVAP    $FBALSW  # kg/s
  fi
  if [ $QS != -9999.99 ];then
    htmath $L sub $FBALSW $FQS      $FBALSW  # kg/s
  fi
  if [ $QSB != -9999.99 ];then
    htmath $L sub $FBALSW $FQSB     $FBALSW  # kg/s
  fi
  if [ $QRC != -9999.99 ];then
    htmath $L sub $FBALSW $FQRC     $FBALSW  # kg/s
  fi
  htmath $L mul $FBALSW $TIME $FBALSW    # kg/m2/s --> kg/m2/yr
  if [ $DELSOILMOIST != -9999.99 ];then
    htmath $L sub $FBALSW $FSOILMOISTEND $FBALSW # kg/m2/yr
    htmath $L add $FBALSW $FSOILMOISTINI $FBALSW # kg/m2/yr
  fi
  if [ $DELSWE != -9999.99 ];then
    htmath $L sub $FBALSW $FSWEEND $FBALSW  # kg/m2/yr
    htmath $L add $FBALSW $FSWEINI $FBALSW  # kg/m2/yr
  fi
#
  BALSWMAXIBVAL=`htstat $ARG max $FBALSW | awk '{print $1}'`
  BALSWMAXIBLAT=`htstat $ARG max $FBALSW | awk '{print $6}'`
  BALSWMAXIBLON=`htstat $ARG max $FBALSW | awk '{print $5}'`
  BALSWMAXIBNUM=`htmask $ARG $FBALSW $FBALSW gt 1 $TEMP | awk '{print $3}'`
  BALSWMINIBVAL=`htstat $ARG min $FBALSW | awk '{print $1}'`
  BALSWMINIBLAT=`htstat $ARG min $FBALSW | awk '{print $6}'`
  BALSWMINIBLON=`htstat $ARG min $FBALSW | awk '{print $5}'`
  BALSWMINIBNUM=`htmask $ARG $FBALSW $FBALSW lt -1 $TEMP | awk '{print $3}'`
#
  htmath $L mul $FBALSW $FLNDARADUM $TEMP  # kg/m2/yr --> kg/yr
  BALSWIBTOT=`htstat $ARG sum $TEMP | awk '{print $1/1000/1000/1000/1000}'`

echo                                               >> $OUT
echo '+++ Water imbalance of surface water +++'    >> $OUT
echo                                               >> $OUT
echo 'MAXVAL..'      $BALSWMAXIBVAL [mm]    | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LON.....'      $BALSWMAXIBLON [degN]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LAT.....'      $BALSWMAXIBLAT [degE]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'NUM[>1].'      $BALSWMAXIBNUM [cells] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'MINVAL..'      $BALSWMINIBVAL [mm]    | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LON.....'      $BALSWMINIBLON [degN]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LAT.....'      $BALSWMINIBLAT [degE]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'NUM[<-1]'      $BALSWMINIBNUM [cells] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'BALSW..'       $BALSWIBTOT    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'FILE....'      $FBALSW        [kg/y]  | awk '{printf("%12s%12s%8s\n",$1,$2,$3)}' >> $OUT
############################################################
# Job (Calculate groundwater imbalance map)
############################################################
  htcreate $L 0.0 $FBALGW
  htmaskrplc $ARG $FBALGW $MASK ne $NUM 1.0E20 $FBALGW > $DN
  if [ $QRC != -9999.99 ];then
    htmath $L add $FBALGW $FQRC     $FBALGW # kg/m2/s
  fi
  if [ $QBF != -9999.99 ];then
    htmath $L sub $FBALGW $FQBF    $FBALGW  # kg/s
  fi
  if [ $SUPAGRGW != -9999.99 ];then
    htmath $L div $FSUPAGRGW $FLNDARADUM $TEMP  # kg/s
    htmask $ARG $TEMP $FSUPAGRGW gt 0 $TEMP > $DN
    htmaskrplc $ARG $TEMP $TEMP eq 1.0E20 0 $TEMP > $DN
    htmath $L sub $FBALGW $TEMP    $FBALGW  # kg/s
  fi
  if [ $SUPINDGW != -9999.99 ];then
    htmath $L div $FSUPINDGW $FLNDARADUM $TEMP  # kg/s
    htmask $ARG $TEMP $FSUPINDGW gt 0 $TEMP > $DN
    htmaskrplc $ARG $TEMP $TEMP eq 1.0E20 0 $TEMP > $DN
    htmath $L sub $FBALGW $TEMP    $FBALGW  # kg/s
  fi
  if [ $SUPINDGW != -9999.99 ];then
    htmath $L div $FSUPDOMGW $FLNDARADUM $TEMP  # kg/s
    htmask $ARG $TEMP $FSUPDOMGW gt 0 $TEMP > $DN
    htmaskrplc $ARG $TEMP $TEMP eq 1.0E20 0 $TEMP > $DN
    htmath $L sub $FBALGW $TEMP    $FBALGW  # kg/s
  fi
  htmath $L mul $FBALGW $TIME $FBALGW    # kg/m2/s --> kg/m2/yr
  if [ $DELGW != -9999.99 ];then
    htmath $L sub $FBALGW $FGWEND $FBALGW  # kg/m2/yr
    htmath $L add $FBALGW $FGWINI $FBALGW  # kg/m2/yr
  fi
#
  BALGWMAXIBVAL=`htstat $ARG max $FBALGW | awk '{print $1}'`
  BALGWMAXIBLAT=`htstat $ARG max $FBALGW | awk '{print $6}'`
  BALGWMAXIBLON=`htstat $ARG max $FBALGW | awk '{print $5}'`
  BALGWMAXIBNUM=`htmask $ARG $FBALGW $FBALGW gt 1 $TEMP | awk '{print $3}'`
  BALGWMINIBVAL=`htstat $ARG min $FBALGW | awk '{print $1}'`
  BALGWMINIBLAT=`htstat $ARG min $FBALGW | awk '{print $6}'`
  BALGWMINIBLON=`htstat $ARG min $FBALGW | awk '{print $5}'`
  BALGWMINIBNUM=`htmask $ARG $FBALGW $FBALGW lt -1 $TEMP | awk '{print $3}'`
#
  htmath $L mul $FBALGW $FLNDARADUM $TEMP  # kg/m2/yr --> kg/yr
  BALGWIBTOT=`htstat $ARG sum $TEMP | awk '{print $1/1000/1000/1000/1000}'`

echo                                               >> $OUT
echo '+++ Water imbalance of groundwater +++'    >> $OUT
echo                                               >> $OUT
echo 'MAXVAL..'      $BALGWMAXIBVAL [mm]    | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LON.....'      $BALGWMAXIBLON [degN]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LAT.....'      $BALGWMAXIBLAT [degE]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'NUM[>1].'      $BALGWMAXIBNUM [cells] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'MINVAL..'      $BALGWMINIBVAL [mm]    | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LON.....'      $BALGWMINIBLON [degN]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'LAT.....'      $BALGWMINIBLAT [degE]  | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'NUM[<-1]'      $BALGWMINIBNUM [cells] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'BALGW..'       $BALGWIBTOT    [km3/y] | awk '{printf("%12s%12.2f%8s\n",$1,$2,$3)}' >> $OUT
echo 'FILE....'      $FBALGW        [kg/y]  | awk '{printf("%12s%12s%8s\n",$1,$2,$3)}' >> $OUT

