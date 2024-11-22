#!/bin/sh
############################################################
#to   run the coupled model
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Basic settings (Edit here if you like)
############################################################
PRJ=AK10		# Project name
#RUN=NEmD                # Run name 
#RUN=N_C_
RUN=LECD
YEARMIN=2014            # 
YEARMAX=2014            # 
SECINT=86400            # interval
LDBG=9079              # debugging point (high plains)
#
PRJMET=AMeD             # Project name of meteorological data
RUNMET=AS1_             # Run     name of meteorological data
PRJLR__=AK10            # Project name of LR__ simulation (Manual Ch.8,9)
#RUNLR__=DMLu            # Run     name of LR__ simulation (Manual Ch.8,9)
RUNLR__=LR__
PRJ__C_=AK10            # Project name of __C_ simulation (Manual Ch.10)
RUN__C_=__C_            # Run     name of __C_ simulation (Manual Ch.10)
PRJN_C_=AK10            # Project name of N_C_ simulation (Manual Ch.13)
RUNN_C_=N_C_            # Run     name of N_C_ simulation (Manual Ch.13)
############################################################
# Expert settings (Do not edit here unless you are an expert)
############################################################
SPNFLG=0                # spinup flag (1 for skip spinup)
SPNERR=0.05             # spinup error torrelance
SPNRAT=0.95             # spinup threshold
ENGBALC=1.0             # energy inbalance tolerance
WATBALC=0.1             # water inbalance tolerance
CNTC=1000               # maximum iteration
PROG=./main_F18             # program
############################################################
# Geographical settings (edit here if you change spatial domain/resolution.
# Note that L (n0l) is prescribed in main.f. You also need to
# edit main.f and re-compile it.)
############################################################
SUF=.ks1                # Suffix
CANSUF=.binks1
MAP=.kyusyu             # Map
############################################################
# Mosaic settings (Do not edit here unless you are an expert)
# 20200710
############################################################
NOFMOS=5                # number of mosaic (sub-grid cell)
#
#ARAFRC1=../../map/out/irg_frcd/S05_____20000000${SUF}
#ARAFRC2=../../map/out/irg_frcs/S05_____20000000${SUF}
#ARAFRC3=../../map/out/rfd_frc_/S05_____20000000${SUF}
#ARAFRC4=../../map/out/non_frc_/S05_____20000000${SUF}
#
DIRARAFRC=../../map/out/ara_frc_   # for revised code
ARAFRC1=$DIRARAFRC/irg2frcP${SUF}  # for revised code
ARAFRC2=$DIRARAFRC/irg_frcP${SUF}  # for revised code
ARAFRC3=$DIRARAFRC/irg_frcF${SUF}  # for revised code
ARAFRC4=$DIRARAFRC/rfd_frcF${SUF}  # for revised code
ARAFRC5=$DIRARAFRC/non_frc_${SUF}  # for revised code
#
#DIRMOZC=../../map/org/KYUSYU/mozaic   # Data by Nagasaki U
#ARAFRC1=$DIRMOZC/irg_/irg2flcP${SUF}  # Data by Nagasaki U
#ARAFRC2=$DIRMOZC/irg_/irg_flcP${SUF}  # Data by Nagasaki U
#ARAFRC3=$DIRMOZC/irg_/irg_flcF${SUF}  # Data by Nagasaki U
#ARAFRC4=$DIRMOZC/irg_/rfd_flcF${SUF}  # Data by Nagasaki U
#ARAFRC5=$DIRMOZC/irg_/non_flc_${SUF}  # Data by Nagasaki U
#
#OPTLNDUSE1=dci          # dci for double crop irrigated
#OPTLNDUSE2=sci          # sci for single crop irrigated
#OPTLNDUSE3=scr          # scr for single crop rainfed
#OPTLNDUSE4=non          # non for no crop
#OPTLNDUSE5=non
OPTLNDUSE1=dpi          # dpi for double paddy irrigated
OPTLNDUSE2=spi          # spi for single paddy irrigated
OPTLNDUSE3=sci          # sci for single crop irrigated
OPTLNDUSE4=scr          # scr for single crop rainfed
OPTLNDUSE5=non          # non for no crop
############################################################
# Input for lnd (Edit here if you wish)
############################################################
    WIND=../../met/dat/Wind____/${PRJMET}${RUNMET}${SUF}DY
   RAINF=../../met/dat/Rainf___/${PRJMET}${RUNMET}${SUF}DY
#   SNOWF=../../met/dat/Snowf___/wfde____${SUF}DY
   SNOWF=../../met/dat/Snowf___/${PRJMET}${RUNMET}${SUF}DY
    TAIR=../../met/dat/Tair____/${PRJMET}${RUNMET}${SUF}DY
    QAIR=../../met/dat/Qair____/${PRJMET}${RUNMET}${SUF}DY
      RH=NO                                     
#    QAIR=NO
#      RH=../../met/dat/RH______/${PRJMET}${RUNMET}${SUF}DY
   PSURF=../../met/dat/PSurf___/${PRJMET}${RUNMET}${SUF}DY
  SWDOWN=../../met/dat/SWdown__/${PRJMET}${RUNMET}${SUF}DY
  LWDOWN=../../met/dat/LWdown__/${PRJMET}${RUNMET}${SUF}DY
############################################################
# Input for lnd (Edit here if you wish)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
BALBEDO=../../map/dat/Albedo__/GSW2____${SUF}MM
############################################################
# Input for riv (Edit here if you wish)
############################################################
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}   # River sequence
RIVNXL=../../map/out/riv_nxl_/rivnxl${MAP}${SUF}   # Next grid
RIVNXD=../../map/out/riv_nxd_/rivnxd${MAP}${SUF}   # Distance to next grid
LNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}   # Land area
############################################################
# Input for crp (Edit here if you wish)
# 20200710 -2
############################################################
#PLTDOY1=../../crp/out/plt_1st_/${PRJ__C_}${RUN__C_}00000000${SUF}
#PLTDOY2=../../crp/out/plt_2nd_/${PRJ__C_}${RUN__C_}00000000${SUF}
#HVSDOY1=../../crp/out/hvs_1st_/${PRJ__C_}${RUN__C_}00000000${SUF}
#HVSDOY2=../../crp/out/hvs_2nd_/${PRJ__C_}${RUN__C_}00000000${SUF}
#CRPTYP1=../../map/org/KYUSYU/mozaic/crptyp/crp_typ1/crp_typP${SUF} #12 rice
#CRPTYP2=../../map/org/KYUSYU/mozaic/crptyp/crp_typ2/crp_typP2${SUF} #19 wheat

#PLTDOYP1=../../map/org/KYUSYU/doy/plt_1stP/${PRJ__C_}${RUN__C_}00000002${SUF}
#PLTDOYP2=../../map/org/KYUSYU/doy/plt_2ndP/${PRJ__C_}${RUN__C_}00000000${SUF}
#HVSDOYP1=../../map/org/KYUSYU/doy/hvs_1stP/${PRJ__C_}${RUN__C_}00000000${SUF}
#HVSDOYP2=../../map/org/KYUSYU/doy/hvs_2ndP/${PRJ__C_}${RUN__C_}00000000${SUF}
#PLTDOYF1=../../map/org/KYUSYU/doy/plt_1stF/${PRJ__C_}${RUN__C_}00000000${SUF}
#PLTDOYF2=../../map/org/KYUSYU/doy/plt_2ndF/${PRJ__C_}${RUN__C_}00000000${SUF}
#HVSDOYF1=../../map/org/KYUSYU/doy/hvs_1stF/${PRJ__C_}${RUN__C_}00000000${SUF}
#HVSDOYF2=../../map/org/KYUSYU/doy/hvs_2ndF/${PRJ__C_}${RUN__C_}00000000${SUF}
#CRPTYPP1=../../map/org/KYUSYU/mozaic/crptyp/crp_typ1/crp_typP${SUF} #12 rice
#CRPTYPP2=../../map/org/KYUSYU/mozaic/crptyp/crp_typ2/crp_typP2.2${SUF} #19 whe
#CRPTYPF1=../../map/org/KYUSYU/mozaic/crptyp/crp_typ1/crp_typF2.0717${SUF}
#CRPTYPF2=../../map/org/KYUSYU/mozaic/crptyp/crp_typ2/crp_typF${SUF} #0

#PLTDOYP1=../../crp/out/plt_ric_/${PRJ__C_}${RUN__C_}00000000.30${SUF}
PLTDOYP1=../../crp/out/plt_ric_/${PRJ__C_}${RUN__C_}00000000${SUF}
PLTDOYP2=../../crp/out/uniform.0.0${SUF}
HVSDOYP1=../../crp/out/uniform.0.0${SUF}
HVSDOYP2=../../crp/out/uniform.0.0${SUF}

PLTDOYF1=../../crp/out/plt_othg/${PRJ__C_}${RUN__C_}00000000${SUF}
PLTDOYF2=../../crp/out/uniform.0.0${SUF}
HVSDOYF1=../../crp/out/uniform.0.0${SUF}
HVSDOYF2=../../crp/out/uniform.0.0${SUF}

CRPTYPP1=../../crp/out/uniform.12.0${SUF}
CRPTYPP2=../../crp/out/uniform.0.0${SUF}
CRPTYPF1=../../crp/out/uniform.8.0${SUF}
CRPTYPF2=../../crp/out/uniform.0.0${SUF}
############################################################
# Input for water abstraction (Edit here if you wish)
############################################################
#DEMIND=../../map/dat/dem_ind_/AQUASTAT20000000${SUF} # Ind wat dem
#DEMDOM=../../map/dat/dem_dom_/AQUASTAT20000000${SUF} # Dom wat dem
#
##DEMIND=../../map/dat/dem_ind_/METIms__20150000${SUF} # Ind wat dem
##DEMDOM=../../map/dat/dem_dom_/JWRC____20160000${SUF} # Dom wat dem
#
DEMIND=../../map/dat/dem_ind_/METIms__20150000${SUF} # Ind wat dem
DEMDOM=../../map/dat/dem_dom_/JWRC____20160000${SUF} # Dom wat dem
#
#FRCGWAGR=../../map/dat/aeigfrc_/GMIA5___20050000${MAP}${SUF} # gw fraction
#FRCGWIND=../../map/dat/frc_gwi_/D12${MAP}${SUF}              # gw fraction
#FRCGWDOM=../../map/dat/frc_gwd_/D12${MAP}${SUF}              # gw fraction
##FRCGWAGR=../../map/dat/aeigfrc_/GMIA5___20050000.htlinear${SUF} # gw fraction
FRCGWAGR=../../map/dat/aeigfrc_/GMIA5___20050000${MAP}${SUF} # gw fraction
#FRCGWIND=./uniform.0.25${SUF}  # /data7/...map/dat/fgwInd__/IGRAC...
#FRCGWDOM=./uniform.0.32${SUF}  # /data7/...map/dat/fgwDom__/IGRAC...
#FRCGWIND=../../map/dat/frc_gwi_/MLIT____20200000.ks1
#FRCGWDOM=../../map/dat/frc_gwd_/MLIT____20200000.ks1
FRCGWIND=../../map/dat/frc_gwi_/MLIT____${SUF}
FRCGWDOM=../../map/dat/frc_gwd_/MLIT____${SUF}
############################################################
# Input for environmental flow (Edit here if you wish)
############################################################
#
# setting to enable environmental flow
#
ENVFLW=../../riv/out/env_out_/${PRJLR__}${RUNLR__}${SUF}MO
#
# setting to disable environmental flow (Hanasaki et al. 2018)
#
ENVFLW=NO                    # Environmental flow
############################################################
# Input for reservoirs (Edit here if you wish)
############################################################
#
# reservoir settings shown in Hanasaki et al 2008, 2010, and 2013
#
      DAMID_=../../map/dat/dam_id__/H06_____20000000${SUF}
      DAMPRP=../../map/dat/dam_prp_/H06_____20000000${SUF}
      DAMCAP=../../map/dat/dam_cap_/H06_____20000000${SUF}
      DAMSRF=NO
   DAMMON1ST=../../riv/out/fld2dro_/${PRJLR__}${RUNLR__}00000000${SUF}
      DAMALC=../../map/out/dam_alc_/${PRJLR__}${RUNLR__}${SUF}ID
DAMRIVOUTFIX=../../riv/out/riv_out_/${PRJLR__}${RUNLR__}00000000${SUF}
DAMDEMAGRFIX=../../lnd/out/DemAgr__/${PRJN_C_}${RUNN_C_}00000000${SUF}FX
      MSRCAP=../../map/dat/msr_cap_/H10_____20000000${SUF} # Med res capacity
      MSRAFC=../../map/dat/dam_afc_/temp${SUF}
#
# reservoir settings shown in Hanasaki et al 2018
#
      DAMID_=../../map/dat/dam_id__/GRanD_L_20000000${SUF}
      DAMPRP=../../map/dat/dam_prp_/GRanD_L_20000000${SUF}
      DAMCAP=../../map/dat/dam_cap_/GRanD_L_20000000${SUF}
      DAMSRF=NO
   DAMMON1ST=../../riv/out/fld2dro_/${PRJLR__}${RUNLR__}00000000${SUF}
      DAMALC=../../map/out/dam_alc_/${PRJLR__}${RUNLR__}${SUF}ID
DAMRIVOUTFIX=../../riv/out/riv_out_/${PRJLR__}${RUNLR__}00000000${SUF}
DAMDEMAGRFIX=../../lnd/out/DemAgr__/${PRJN_C_}${RUNN_C_}00000000${SUF}FX
      MSRCAP=../../map/dat/dam_cap_/GRanD_M_20000000${SUF} # Med res capacity
      MSRAFC=../../map/dat/dam_afc_/GRanD_M_20000000${SUF} # Med res area
#
# 20200717
      DAMID_=../../map/dat/dam_id__/KYSY____20000000${SUF}
      DAMPRP=../../map/dat/dam_prp_/KYSY____20000000${SUF}
      DAMCAP=../../map/dat/dam_cap_/KYSY____20000000${SUF}
      DAMSRF=NO
      DAMALC=../../map/out/dam_alc_/${PRJLR__}${RUNLR__}${SUF}ID
DAMRIVOUTFIX=../../riv/out/riv_out_/${PRJLR__}${RUNLR__}00000000${SUF}
DAMDEMAGRFIX=../../lnd/out/DemAgr__/${PRJN_C_}${RUNN_C_}00000000${SUF}FX
#      DAMALC=../../lnd/dat/uniform.0.0${SUF}FX
#DAMRIVOUTFIX=../../lnd/dat/uniform.0.0${SUF}
#DAMDEMAGRFIX=../../lnd/dat/uniform.0.0${SUF}FX
   DAMMON1ST=../../riv/out/fld2dro_/${PRJLR__}${RUNLR__}00000000${SUF}
      MSRCAP=NO
      MSRAFC=NO
#
# disable reservoir operation
#
#      DAMID_=NO              # Large reservoir ID
#      DAMPRP=NO              # Large reservoir primary purpose
#      DAMCAP=NO              # Large reservoir capacity
#      DAMSRF=NO              # Reservoir surface area
#   DAMMON1ST=NO              # 1st month of operating year
#      DAMALC=NO              # Reservoir demand allocation (kalc)
#DAMRIVOUTFIX=NO              # Mean ann riv dis
#DAMDEMAGRFIX=NO              # Mean ann agr wat dem
#      MSRCAP=NO              # Medium size reservoir capacity
#      MSRAFC=NO              # Areal fraction of Medium size res.
############################################################
# Input for hum-new (Edit here if you wish)
############################################################
OPTRIV=yes
OPTRGW=yes
############################################################
# Input for aqueduct (Edit here if you wish)
############################################################
#
# disable aqueduct
#
LCAN=../../dam/dat/uniform.0.0${CANSUF} # must be 10 times larger than the binary.
#
# aqueduct settings shown in Hanasaki et al. 2018 
#
#LCAN=../../map/out/can_des_/candes.l.partially.5${MAP}${CANSUF} #5c
#LCAN=../../map/out/can_des_/candes.l.merged.5${MAP}${CANSUF}    #5m
#LCAN=../../map/out/can_des_/candes.l.within.5${MAP}${CANSUF}  #5w
#
#LCAN=../../map/out/can_des_/candes.l.within.1${MAP}${CANSUF}  #NECD
LCAN=../../map/out/can_des_/candes.l.merged.5${MAP}${CANSUF}  #N_C_
############################################################
# Input for water efficiency 1 (Edit here if you wish)
############################################################
#IRGEFFS=../../map/dat/irg_eff_/DS02____00000000${SUF}
#IRGEFFS=../../dam/dat/uniform.0.35.ks1 # Default
IRGEFFS=../../dam/dat/uniform.0.45${SUF} # Regionalized
IRGEFFG=../../dam/dat/uniform.1.0${SUF}
############################################################
# Input for water efficiency 2 (Edit here if you wish)
############################################################
#
# settings to revisit Hanasaki et al. 2008, 2010, and 2013
#
INDEFF=../../dam/dat/uniform.1.0${SUF}
DOMEFF=../../dam/dat/uniform.1.0${SUF}
IRGLOS=../../dam/dat/uniform.0.0${SUF}
#
# settings shown in Hanasaki et al. 2018
#
INDEFF=../../dam/dat/uniform.0.1${SUF}
DOMEFF=../../dam/dat/uniform.0.15${SUF}
IRGLOS=../../dam/dat/uniform.0.5${SUF}
############################################################
# Input for desalinated water (Edit here if you wish)
############################################################
#
# disable desalinated water
#
OPTDES=Conservative      # conservative: desalination as the last choice
DESPOT=../../dam/dat/uniform.0.0${SUF}
#
# enable desalinated water
#
OPTDES=H16               # H16: desalination as the first choice
DESPOT=../../map/out/des_pot_/Hist____20050000${MAP}.14000.0.08${SUF}
#
DESPOT=../../dam/dat/uniform.0.0${SUF}
############################################################
# Input for recycled water (Do not edit here)
############################################################
OPTRCL=no
RCLPOT=../../dam/dat/uniform.0.0${SUF}
############################################################
# Parameter for soil moisture (Edit here if you wish)
############################################################
#SOILDEPTH=../../lnd/dat/uniform.1.00${SUF}
 FIELDCAP=../../lnd/dat/uniform.0.30${SUF}
     WILT=../../lnd/dat/uniform.0.15${SUF}
       CG=../../lnd/dat/uniform.13000.00${SUF}
#       CD=../../lnd/dat/uniform.0.003${SUF}
#    GAMMA=../../lnd/dat/gamma___/${PRJMET}${RUNMET}00000000${SUF}
#      TAU=../../lnd/dat/tau_____/${PRJMET}${RUNMET}00000000${SUF}
#
SOILDEPTH=../../lnd/dat/DMLu.SD${SUF}
       CD=../../lnd/dat/DMLu.CD${SUF}
    GAMMA=../../lnd/dat/DMLu.GAMMA${SUF}
      TAU=../../lnd/dat/DMLu.TAU${SUF}
#
SOILDEPTH=../../lnd/dat/AK10.sd${SUF}
       CD=../../lnd/dat/AK10.cd${SUF}
    GAMMA=../../lnd/dat/AK10.gamma${SUF}
      TAU=../../lnd/dat/AK10.tau${SUF}
############################################################
# Parameter for groundwater (Edit here if you wish)
############################################################
  GWDEPTH=../../lnd/dat/uniform.1.00${SUF}
  GWYIELD=../../lnd/dat/uniform.0.30${SUF}
  GWGAMMA=../../lnd/dat/uniform.2.00${SUF}
    GWTAU=../../lnd/dat/uniform.100.00${SUF}
    GWRCF=../../lnd/dat/gwr_____/fg${SUF}
  GWRCMAX=../../lnd/dat/gwr_____/rgmax${SUF}
############################################################
# Parameter for riv (Edit here if you wish)
############################################################
FLWVEL=../../riv/dat/uniform.0.5${SUF}       # Flow velocity
MEDRAT=../../riv/dat/uniform.1.4${SUF}       # Meandering ratio
############################################################
# Parameter for crp (Edit here if you wish)
############################################################
RAM2SWIM=../../crp/org/SWIM/ram2swim.txt
SWIM2RAM=../../crp/org/SWIM/swim2ram.txt
  CRPPAR=../../crp/org/SWIM/crppar.txt
INTCRPDAYMAX=300
REGFMIN=0.7
TDORM=5.0
TFRZ=-10.0
HUNMAX=12.5
IHUNMAT=0.95
TSAW=10.0
THVS=10.0
OPTTS=yes
OPTWS=yes
OPTNS=no
OPTPS=no
OPTFRZ=no
OPTHVSDOY=free 
############################################################
# Parameter for irrigation (Edit here if you wish)
############################################################
DAYADVIRG=30     # irrigation prior to planting date
FCTPAD=1.00      # factor for paddy
FCTNONPAD=0.75   # factor for other than paddy
############################################################
# Parameter for reservoir operation (Edit here if you wish)
############################################################
KNORM=0.85       # alpha in Hanasaki et al. 2006
OPTKRLS=yes      # yes for enable krls,
OPTDAMRLS=F18    # H06 for res. operation shown  in Hanasaki et al. 2006
OPTDAMWBC=no     # no for not execute water balance calculation
# F18 start (20200717)
FACTOR='../../map/org/KYUSYU/dam/factor.txt'
MINSTO='../../map/org/KYUSYU/dam/lwc-y.txt'
MINDOY='../../map/org/KYUSYU/dam/lwc-x.txt'
MAXSTO='../../map/org/KYUSYU/dam/upc-y.txt'
MAXDOY='../../map/org/KYUSYU/dam/upc-x.txt'
RLSRLS='../../map/org/KYUSYU/dam/damrls-y.txt'
RLSDOY='../../map/org/KYUSYU/dam/damrls-x.txt'
# F18 end
############################################################
# Parameter for NNBW (Edit here if you wish)
############################################################
#
#OPTNNB=no        # non-local & non-renwable water source (J. Hydrol., 2010)
#
OPTNNB=yes       # non-local & non-renwable water source (J. Hydrol., 2010)
############################################################
# Input for climate change (Edit here if you wish)
############################################################
    TCOR=../../met/dat/Tair__DF/m32ma213${SUF}MM
    PCOR=../../met/dat/Prcp__RT/m32ma213${SUF}MM
    LCOR=../../met/dat/LWdownDF/m32ma213${SUF}MM
#
    TCOR=NO
    PCOR=NO
    LCOR=NO
############################################################
# Output directory for climate change (Do not edit here unless you are an expert)
############################################################
DIRTAIROUT=../../lnd/out/Tairout_
DIRRAINFOUT=../../lnd/out/Rainfout
DIRSNOWFOUT=../../lnd/out/Snowfout
DIRLWDOWNOUT=../../lnd/out/LWdownou
############################################################
# Output for climate change (Edit here if you wish)
############################################################
 TAIROUT=$DIRTAIROUT/${PRJ}${RUN}${SUF}MO
RAINFOUT=$DIRRAINFOUT/${PRJ}${RUN}${SUF}MO
SNOWFOUT=$DIRSNOWFOUT/${PRJ}${RUN}${SUF}MO
LWDOWNOUT=$DIRLWDOWNOUT/${PRJ}${RUN}${SUF}MO
#
 TAIROUT=NO
RAINFOUT=NO
SNOWFOUT=NO
LWDOWNOUT=NO
############################################################
# Initial condition for lnd (Edit here if you wish)
############################################################
SOILMOISTINI0=../../lnd/ini/uniform.150.0${SUF}
 SOILTEMPINI0=../../lnd/ini/uniform.283.15${SUF}
      SWEINI0=../../lnd/ini/uniform.0.0${SUF}
 AVGSURFTINI0=../../lnd/ini/uniform.283.15${SUF}
       GWINI0=../../lnd/ini/uniform.0.0${SUF}
#
SOILMOISTINI1=../../lnd/ini/uniform.150.0${SUF}
 SOILTEMPINI1=../../lnd/ini/uniform.283.15${SUF}
      SWEINI1=../../lnd/ini/uniform.0.0${SUF}
 AVGSURFTINI1=../../lnd/ini/uniform.283.15${SUF}
       GWINI1=../../lnd/ini/uniform.0.0${SUF}
#
SOILMOISTINI2=../../lnd/ini/uniform.150.0${SUF}
 SOILTEMPINI2=../../lnd/ini/uniform.283.15${SUF}
      SWEINI2=../../lnd/ini/uniform.0.0${SUF}
 AVGSURFTINI2=../../lnd/ini/uniform.283.15${SUF}
       GWINI2=../../lnd/ini/uniform.0.0${SUF}
#
SOILMOISTINI3=../../lnd/ini/uniform.150.0${SUF}
 SOILTEMPINI3=../../lnd/ini/uniform.283.15${SUF}
      SWEINI3=../../lnd/ini/uniform.0.0${SUF}
 AVGSURFTINI3=../../lnd/ini/uniform.283.15${SUF}
       GWINI3=../../lnd/ini/uniform.0.0${SUF}
#
SOILMOISTINI4=../../lnd/ini/uniform.150.0${SUF}
 SOILTEMPINI4=../../lnd/ini/uniform.283.15${SUF}
      SWEINI4=../../lnd/ini/uniform.0.0${SUF}
 AVGSURFTINI4=../../lnd/ini/uniform.283.15${SUF}
       GWINI4=../../lnd/ini/uniform.0.0${SUF}
# 20200710
SOILMOISTINI5=../../lnd/ini/uniform.150.0${SUF}
 SOILTEMPINI5=../../lnd/ini/uniform.283.15${SUF}
      SWEINI5=../../lnd/ini/uniform.0.0${SUF}
 AVGSURFTINI5=../../lnd/ini/uniform.283.15${SUF}
       GWINI5=../../lnd/ini/uniform.0.0${SUF}
############################################################
# Initial condition for riv (Edit here if you wish)
############################################################
RIVSTOINI=../../riv/ini/uniform.0.0${SUF}  # Initial river storage
############################################################
# Initial condition for crp (Edit here if you wish)
############################################################
  BTINI0=../../dam/ini/uniform.0.0${SUF}
 RSDINI0=../../dam/ini/uniform.0.0${SUF}
OUTBINI0=../../dam/ini/uniform.0.0${SUF}
  BTINI1=../../dam/ini/uniform.0.0${SUF}
 RSDINI1=../../dam/ini/uniform.0.0${SUF}
OUTBINI1=../../dam/ini/uniform.0.0${SUF}
  BTINI2=../../dam/ini/uniform.0.0${SUF}
 RSDINI2=../../dam/ini/uniform.0.0${SUF}
OUTBINI2=../../dam/ini/uniform.0.0${SUF}
  BTINI3=../../dam/ini/uniform.0.0${SUF}
 RSDINI3=../../dam/ini/uniform.0.0${SUF}
OUTBINI3=../../dam/ini/uniform.0.0${SUF}
  BTINI4=../../dam/ini/uniform.0.0${SUF}
 RSDINI4=../../dam/ini/uniform.0.0${SUF}
OUTBINI4=../../dam/ini/uniform.0.0${SUF}
# 20200710
  BTINI5=../../dam/ini/uniform.0.0${SUF}
 RSDINI5=../../dam/ini/uniform.0.0${SUF}
OUTBINI5=../../dam/ini/uniform.0.0${SUF}

 HUNAINI0=../../crp/ini/uniform.0.0${SUF}
  SWUINI0=../../crp/ini/uniform.0.0${SUF}
  SWPINI0=../../crp/ini/uniform.0.0${SUF}
REGFWINI0=../../crp/ini/uniform.0.0${SUF}
REGFLINI0=../../crp/ini/uniform.0.0${SUF}
REGFHINI0=../../crp/ini/uniform.0.0${SUF}
REGFNINI0=../../crp/ini/uniform.0.0${SUF}
REGFPINI0=../../crp/ini/uniform.0.0${SUF}

 HUNAINI1=../../crp/ini/uniform.0.0${SUF}
  SWUINI1=../../crp/ini/uniform.0.0${SUF}
  SWPINI1=../../crp/ini/uniform.0.0${SUF}
REGFWINI1=../../crp/ini/uniform.0.0${SUF}
REGFLINI1=../../crp/ini/uniform.0.0${SUF}
REGFHINI1=../../crp/ini/uniform.0.0${SUF}
REGFNINI1=../../crp/ini/uniform.0.0${SUF}
REGFPINI1=../../crp/ini/uniform.0.0${SUF}

 HUNAINI2=../../crp/ini/uniform.0.0${SUF}
  SWUINI2=../../crp/ini/uniform.0.0${SUF}
  SWPINI2=../../crp/ini/uniform.0.0${SUF}
REGFWINI2=../../crp/ini/uniform.0.0${SUF}
REGFLINI2=../../crp/ini/uniform.0.0${SUF}
REGFHINI2=../../crp/ini/uniform.0.0${SUF}
REGFNINI2=../../crp/ini/uniform.0.0${SUF}
REGFPINI2=../../crp/ini/uniform.0.0${SUF}

 HUNAINI3=../../crp/ini/uniform.0.0${SUF}
  SWUINI3=../../crp/ini/uniform.0.0${SUF}
  SWPINI3=../../crp/ini/uniform.0.0${SUF}
REGFWINI3=../../crp/ini/uniform.0.0${SUF}
REGFLINI3=../../crp/ini/uniform.0.0${SUF}
REGFHINI3=../../crp/ini/uniform.0.0${SUF}
REGFNINI3=../../crp/ini/uniform.0.0${SUF}
REGFPINI3=../../crp/ini/uniform.0.0${SUF}

 HUNAINI4=../../crp/ini/uniform.0.0${SUF}
  SWUINI4=../../crp/ini/uniform.0.0${SUF}
  SWPINI4=../../crp/ini/uniform.0.0${SUF}
REGFWINI4=../../crp/ini/uniform.0.0${SUF}
REGFLINI4=../../crp/ini/uniform.0.0${SUF}
REGFHINI4=../../crp/ini/uniform.0.0${SUF}
REGFNINI4=../../crp/ini/uniform.0.0${SUF}
REGFPINI4=../../crp/ini/uniform.0.0${SUF}

# 20200710
 HUNAINI5=../../crp/ini/uniform.0.0${SUF}
  SWUINI5=../../crp/ini/uniform.0.0${SUF}
  SWPINI5=../../crp/ini/uniform.0.0${SUF}
REGFWINI5=../../crp/ini/uniform.0.0${SUF}
REGFLINI5=../../crp/ini/uniform.0.0${SUF}
REGFHINI5=../../crp/ini/uniform.0.0${SUF}
REGFNINI5=../../crp/ini/uniform.0.0${SUF}
REGFPINI5=../../crp/ini/uniform.0.0${SUF}
############################################################
# Initial value for hum (Do not edit here unless you are an expert)
############################################################
DAMSTOINI=../../dam/ini/uniform.0.0${SUF}  # Initial large reservoir storage
MSRSTOINI=../../dam/ini/uniform.0.0${SUF}  # Initial medium reservoir storage
############################################################
# Output directory Land (Do not edit here unless you are an expert)
############################################################
    DIRSWNET0=../../lnd/out/SWnet___
    DIRLWNET0=../../lnd/out/LWnet___
      DIRQLE0=../../lnd/out/Qle_____
       DIRQH0=../../lnd/out/Qh______
       DIRQG0=../../lnd/out/Qg______
     DIREVAP0=../../lnd/out/Evap____
  DIRPOTEVAP0=../../lnd/out/PotEvap_
       DIRQS0=../../lnd/out/Qs______
      DIRQSB0=../../lnd/out/Qsb_____
     DIRQTOT0=../../lnd/out/Qtot____
DIRSOILMOIST0=../../lnd/out/SoilMois
 DIRSOILTEMP0=../../lnd/out/SoilTemp
      DIRSWE0=../../lnd/out/SWE_____
 DIRAVGSURFT0=../../lnd/out/AvgSurfT
       DIRGW0=../../lnd/out/GW______
      DIRQBF0=../../lnd/out/Qbf_____
      DIRQRC0=../../lnd/out/Qrc_____

    DIRSWNET1=../../lnd/out/SWnet__1
    DIRLWNET1=../../lnd/out/LWnet__1
      DIRQLE1=../../lnd/out/Qle____1
       DIRQH1=../../lnd/out/Qh_____1
     DIREVAP1=../../lnd/out/Evap___1
  DIRPOTEVAP1=../../lnd/out/PotEvap1
       DIRQS1=../../lnd/out/Qs_____1
      DIRQSB1=../../lnd/out/Qsb____1
     DIRQTOT1=../../lnd/out/Qtot___1
DIRSOILMOIST1=../../lnd/out/SoilMoi1
 DIRSOILTEMP1=../../lnd/out/SoilTem1
      DIRSWE1=../../lnd/out/SWE____1
 DIRAVGSURFT1=../../lnd/out/AvgSurf1
       DIRGW1=../../lnd/out/GW_____1
      DIRQBF1=../../lnd/out/Qbf____1
      DIRQRC1=../../lnd/out/Qrc____1

    DIRSWNET2=../../lnd/out/SWnet__2
    DIRLWNET2=../../lnd/out/LWnet__2
      DIRQLE2=../../lnd/out/Qle____2
       DIRQH2=../../lnd/out/Qh_____2
     DIREVAP2=../../lnd/out/Evap___2
  DIRPOTEVAP2=../../lnd/out/PotEvap2
       DIRQS2=../../lnd/out/Qs_____2
      DIRQSB2=../../lnd/out/Qsb____2
     DIRQTOT2=../../lnd/out/Qtot___2
DIRSOILMOIST2=../../lnd/out/SoilMoi2
 DIRSOILTEMP2=../../lnd/out/SoilTem2
      DIRSWE2=../../lnd/out/SWE____2
 DIRAVGSURFT2=../../lnd/out/AvgSurf2
       DIRGW2=../../lnd/out/GW_____2
      DIRQBF2=../../lnd/out/Qbf____2
      DIRQRC2=../../lnd/out/Qrc____2

    DIRSWNET3=../../lnd/out/SWnet__3
    DIRLWNET3=../../lnd/out/LWnet__3
      DIRQLE3=../../lnd/out/Qle____3
       DIRQH3=../../lnd/out/Qh_____3
     DIREVAP3=../../lnd/out/Evap___3
  DIRPOTEVAP3=../../lnd/out/PotEvap3
       DIRQS3=../../lnd/out/Qs_____3
      DIRQSB3=../../lnd/out/Qsb____3
     DIRQTOT3=../../lnd/out/Qtot___3
DIRSOILMOIST3=../../lnd/out/SoilMoi3
 DIRSOILTEMP3=../../lnd/out/SoilTem3
      DIRSWE3=../../lnd/out/SWE____3
 DIRAVGSURFT3=../../lnd/out/AvgSurf3
       DIRGW3=../../lnd/out/GW_____3
      DIRQBF3=../../lnd/out/Qbf____3
      DIRQRC3=../../lnd/out/Qrc____3

    DIRSWNET4=../../lnd/out/SWnet__4
    DIRLWNET4=../../lnd/out/LWnet__4
      DIRQLE4=../../lnd/out/Qle____4
       DIRQH4=../../lnd/out/Qh_____4
     DIREVAP4=../../lnd/out/Evap___4
  DIRPOTEVAP4=../../lnd/out/PotEvap4
       DIRQS4=../../lnd/out/Qs_____4
      DIRQSB4=../../lnd/out/Qsb____4
     DIRQTOT4=../../lnd/out/Qtot___4
DIRSOILMOIST4=../../lnd/out/SoilMoi4
 DIRSOILTEMP4=../../lnd/out/SoilTem4
      DIRSWE4=../../lnd/out/SWE____4
 DIRAVGSURFT4=../../lnd/out/AvgSurf4
       DIRGW4=../../lnd/out/GW_____4
      DIRQBF4=../../lnd/out/Qbf____4
      DIRQRC4=../../lnd/out/Qrc____4

# 20200710
    DIRSWNET5=../../lnd/out/SWnet__5
    DIRLWNET5=../../lnd/out/LWnet__5
      DIRQLE5=../../lnd/out/Qle____5
       DIRQH5=../../lnd/out/Qh_____5
     DIREVAP5=../../lnd/out/Evap___5
  DIRPOTEVAP5=../../lnd/out/PotEvap5
       DIRQS5=../../lnd/out/Qs_____5
      DIRQSB5=../../lnd/out/Qsb____5
     DIRQTOT5=../../lnd/out/Qtot___5
DIRSOILMOIST5=../../lnd/out/SoilMoi5
 DIRSOILTEMP5=../../lnd/out/SoilTem5
      DIRSWE5=../../lnd/out/SWE____5
 DIRAVGSURFT5=../../lnd/out/AvgSurf5
       DIRGW5=../../lnd/out/GW_____5
      DIRQBF5=../../lnd/out/Qbf____5
      DIRQRC5=../../lnd/out/Qrc____5
############################################################
# Output for lnd (Do not edit here unless you are an expert)
############################################################
    SWNET0=NO
    LWNET0=NO
      QLE0=NO
       QH0=NO
       QG0=NO
       QF0=NO
       QV0=NO
     EVAP0=NO
       QS0=NO
      QSB0=NO
     QTOT0=NO
      QSM0=NO
      QST0=NO
   ALBEDO0=NO
  SOILWET0=NO
  POTEVAP0=NO
       ET0=NO
  SUBSNOW0=NO
  SALBEDO0=NO
SOILMOIST0=NO   # Caution: state variables should be written out
 SOILTEMP0=NO   # Caution: state variables should be written out
      SWE0=NO   # Caution: state variables should be written out
 AVGSURFT0=NO   # Caution: state variables should be written out
       GW0=NO
      QBF0=NO
      QRC0=NO

    SWNET1=NO
    LWNET1=NO
      QLE1=NO
       QH1=NO
       QG1=NO
       QF1=NO
       QV1=NO
     EVAP1=NO
       QS1=NO
      QSB1=NO
     QTOT1=NO
      QSM1=NO
      QST1=NO
   ALBEDO1=NO
  SOILWET1=NO
  POTEVAP1=NO
       ET1=NO
  SUBSNOW1=NO
  SALBEDO1=NO
SOILMOIST1=NO   # Caution: state variables should be written out
 SOILTEMP1=NO   # Caution: state variables should be written out
      SWE1=NO   # Caution: state variables should be written out
 AVGSURFT1=NO   # Caution: state variables should be written out
       GW1=NO
      QBF1=NO
      QRC1=NO

    SWNET2=NO
    LWNET2=NO
      QLE2=NO
       QH2=NO
       QG2=NO
       QF2=NO
       QV2=NO
     EVAP2=NO
       QS2=NO
      QSB2=NO
     QTOT2=NO
      QSM2=NO
      QST2=NO
   ALBEDO2=NO
  SOILWET2=NO
  POTEVAP2=NO
       ET2=NO
  SUBSNOW2=NO
  SALBEDO2=NO
SOILMOIST2=NO   # Caution: state variables should be written out
 SOILTEMP2=NO   # Caution: state variables should be written out
      SWE2=NO   # Caution: state variables should be written out
 AVGSURFT2=NO   # Caution: state variables should be written out
       GW2=NO
      QBF2=NO
      QRC2=NO

    SWNET3=NO
    LWNET3=NO
      QLE3=NO
       QH3=NO
       QG3=NO
       QF3=NO
       QV3=NO
     EVAP3=NO
       QS3=NO
      QSB3=NO
     QTOT3=NO
      QSM3=NO
      QST3=NO
   ALBEDO3=NO
  SOILWET3=NO
  POTEVAP3=NO
       ET3=NO
  SUBSNOW3=NO
  SALBEDO3=NO
SOILMOIST3=NO   # Caution: state variables should be written out
 SOILTEMP3=NO   # Caution: state variables should be written out
      SWE3=NO   # Caution: state variables should be written out
 AVGSURFT3=NO   # Caution: state variables should be written out
       GW3=NO
      QBF3=NO
      QRC3=NO

    SWNET4=NO
    LWNET4=NO
      QLE4=NO
       QH4=NO
       QG4=NO
       QF4=NO
       QV4=NO
     EVAP4=NO
       QS4=NO
      QSB4=NO
     QTOT4=NO
      QSM4=NO
      QST4=NO
   ALBEDO4=NO
  SOILWET4=NO
  POTEVAP4=NO
       ET4=NO
  SUBSNOW4=NO
  SALBEDO4=NO
SOILMOIST4=NO   # Caution: state variables should be written out
 SOILTEMP4=NO   # Caution: state variables should be written out
      SWE4=NO   # Caution: state variables should be written out
 AVGSURFT4=NO   # Caution: state variables should be written out
       GW4=NO
      QBF4=NO
      QRC4=NO

# 20200710
    SWNET5=NO
    LWNET5=NO
      QLE5=NO
       QH5=NO
       QG5=NO
       QF5=NO
       QV5=NO
     EVAP5=NO
       QS5=NO
      QSB5=NO
     QTOT5=NO
      QSM5=NO
      QST5=NO
   ALBEDO5=NO
  SOILWET5=NO
  POTEVAP5=NO
       ET5=NO
  SUBSNOW5=NO
  SALBEDO5=NO
SOILMOIST5=NO   # Caution: state variables should be written out
 SOILTEMP5=NO   # Caution: state variables should be written out
      SWE5=NO   # Caution: state variables should be written out
 AVGSURFT5=NO   # Caution: state variables should be written out
       GW5=NO
      QBF5=NO
      QRC5=NO
#
    SWNET0=${DIRSWNET0}/${PRJ}${RUN}${SUF}MO
    LWNET0=${DIRLWNET0}/${PRJ}${RUN}${SUF}MO
      QLE0=${DIRQLE0}/${PRJ}${RUN}${SUF}MO
       QH0=${DIRQH0}/${PRJ}${RUN}${SUF}MO
       QG0=${DIRQG0}/${PRJ}${RUN}${SUF}MO
     EVAP0=${DIREVAP0}/${PRJ}${RUN}${SUF}MO
       QS0=${DIRQS0}/${PRJ}${RUN}${SUF}MO
      QSB0=${DIRQSB0}/${PRJ}${RUN}${SUF}MO
     QTOT0=${DIRQTOT0}/${PRJ}${RUN}${SUF}DY
  POTEVAP0=${DIRPOTEVAP0}/${PRJ}${RUN}${SUF}MO
SOILMOIST0=${DIRSOILMOIST0}/${PRJ}${RUN}${SUF}MO
 SOILTEMP0=${DIRSOILTEMP0}/${PRJ}${RUN}${SUF}DY
      SWE0=${DIRSWE0}/${PRJ}${RUN}${SUF}MO
 AVGSURFT0=${DIRAVGSURFT0}/${PRJ}${RUN}${SUF}MO
       GW0=${DIRGW0}/${PRJ}${RUN}${SUF}MO
      QBF0=${DIRQBF0}/${PRJ}${RUN}${SUF}MO
      QRC0=${DIRQRC0}/${PRJ}${RUN}${SUF}MO
#
#    SWNET1=${DIRSWNET1}/${PRJ}${RUN}${SUF}DY
#    LWNET1=${DIRLWNET1}/${PRJ}${RUN}${SUF}DY
#      QLE1=${DIRQLE1}/${PRJ}${RUN}${SUF}DY
#       QH1=${DIRQH1}/${PRJ}${RUN}${SUF}DY
#     EVAP1=${DIREVAP1}/${PRJ}${RUN}${SUF}DY
#       QS1=${DIRQS1}/${PRJ}${RUN}${SUF}DY
#      QSB1=${DIRQSB1}/${PRJ}${RUN}${SUF}DY
#     QTOT1=${DIRQTOT1}/${PRJ}${RUN}${SUF}DY
#  POTEVAP1=${DIRPOTEVAP1}/${PRJ}${RUN}${SUF}DY
#SOILMOIST1=${DIRSOILMOIST1}/${PRJ}${RUN}${SUF}DY
# SOILTEMP1=${DIRSOILTEMP1}/${PRJ}${RUN}${SUF}DY
#      SWE1=${DIRSWE1}/${PRJ}${RUN}${SUF}DY
# AVGSURFT1=${DIRAVGSURFT1}/${PRJ}${RUN}${SUF}DY
#       GW1=${DIRGW1}/${PRJ}${RUN}${SUF}MO
#      QBF1=${DIRQBF1}/${PRJ}${RUN}${SUF}MO
#      QRC1=${DIRQRC1}/${PRJ}${RUN}${SUF}MO
#
#    SWNET2=${DIRSWNET2}/${PRJ}${RUN}${SUF}DY
#    LWNET2=${DIRLWNET2}/${PRJ}${RUN}${SUF}DY
#      QLE2=${DIRQLE2}/${PRJ}${RUN}${SUF}DY
#       QH2=${DIRQH2}/${PRJ}${RUN}${SUF}DY
#     EVAP2=${DIREVAP2}/${PRJ}${RUN}${SUF}DY
#       QS2=${DIRQS2}/${PRJ}${RUN}${SUF}DY
#      QSB2=${DIRQSB2}/${PRJ}${RUN}${SUF}DY
#     QTOT2=${DIRQTOT2}/${PRJ}${RUN}${SUF}DY
#  POTEVAP2=${DIRPOTEVAP2}/${PRJ}${RUN}${SUF}DY
#SOILMOIST2=${DIRSOILMOIST2}/${PRJ}${RUN}${SUF}DY
# SOILTEMP2=${DIRSOILTEMP2}/${PRJ}${RUN}${SUF}DY
#      SWE2=${DIRSWE2}/${PRJ}${RUN}${SUF}DY
# AVGSURFT2=${DIRAVGSURFT2}/${PRJ}${RUN}${SUF}DY
#       GW2=${DIRGW2}/${PRJ}${RUN}${SUF}MO
#      QBF2=${DIRQBF2}/${PRJ}${RUN}${SUF}MO
#      QRC2=${DIRQRC2}/${PRJ}${RUN}${SUF}MO
#
#    SWNET3=${DIRSWNET3}/${PRJ}${RUN}${SUF}DY
#    LWNET3=${DIRLWNET3}/${PRJ}${RUN}${SUF}DY
#      QLE3=${DIRQLE3}/${PRJ}${RUN}${SUF}DY
#       QH3=${DIRQH3}/${PRJ}${RUN}${SUF}DY
#     EVAP3=${DIREVAP3}/${PRJ}${RUN}${SUF}DY
#       QS3=${DIRQS3}/${PRJ}${RUN}${SUF}DY
#      QSB3=${DIRQSB3}/${PRJ}${RUN}${SUF}DY
#     QTOT3=${DIRQTOT3}/${PRJ}${RUN}${SUF}DY
#  POTEVAP3=${DIRPOTEVAP3}/${PRJ}${RUN}${SUF}DY
#SOILMOIST3=${DIRSOILMOIST3}/${PRJ}${RUN}${SUF}DY
# SOILTEMP3=${DIRSOILTEMP3}/${PRJ}${RUN}${SUF}DY
#      SWE3=${DIRSWE3}/${PRJ}${RUN}${SUF}DY
# AVGSURFT3=${DIRAVGSURFT3}/${PRJ}${RUN}${SUF}DY
#       GW3=${DIRGW3}/${PRJ}${RUN}${SUF}MO
#      QBF3=${DIRQBF3}/${PRJ}${RUN}${SUF}MO
#      QRC3=${DIRQRC3}/${PRJ}${RUN}${SUF}MO
#
#    SWNET4=${DIRSWNET4}/${PRJ}${RUN}${SUF}DY
#    LWNET4=${DIRLWNET4}/${PRJ}${RUN}${SUF}DY
#      QLE4=${DIRQLE4}/${PRJ}${RUN}${SUF}DY
#       QH4=${DIRQH4}/${PRJ}${RUN}${SUF}DY
#     EVAP4=${DIREVAP4}/${PRJ}${RUN}${SUF}DY
#       QS4=${DIRQS4}/${PRJ}${RUN}${SUF}DY
#      QSB4=${DIRQSB4}/${PRJ}${RUN}${SUF}DY
#     QTOT4=${DIRQTOT4}/${PRJ}${RUN}${SUF}DY
#  POTEVAP4=${DIRPOTEVAP4}/${PRJ}${RUN}${SUF}DY
#SOILMOIST4=${DIRSOILMOIST4}/${PRJ}${RUN}${SUF}DY
# SOILTEMP4=${DIRSOILTEMP4}/${PRJ}${RUN}${SUF}DY
#      SWE4=${DIRSWE4}/${PRJ}${RUN}${SUF}DY
# AVGSURFT4=${DIRAVGSURFT4}/${PRJ}${RUN}${SUF}DY
#       GW4=${DIRGW4}/${PRJ}${RUN}${SUF}MO
#      QBF4=${DIRQBF4}/${PRJ}${RUN}${SUF}MO
#      QRC4=${DIRQRC4}/${PRJ}${RUN}${SUF}MO
############################################################
# Output directory for riv (Do not edit here unless you are an expert)
############################################################
DIRRIVSTO=../../riv/out/riv_sto_
DIRRIVOUT=../../riv/out/riv_out_
############################################################
# Output for riv(Do not edit here unless you are an expert)
############################################################
RIVSTO=${DIRRIVSTO}/${PRJ}${RUN}${SUF}DY # River storage
   DIS=${DIRRIVOUT}/${PRJ}${RUN}${SUF}DY # River discharge
############################################################
# Output directory for crp (Do not edit here unless you are an expert)
############################################################
   DIRYLDOUT1ST0=../../crp/out/yld_1st0
   DIRCWDOUT1ST0=../../crp/out/cwd_1st0
   DIRCWSOUT1ST0=../../crp/out/cws_1st0
 DIRREGFDOUT1ST0=../../crp/out/reg_1st0
DIRHVSDOYOUT1ST0=../../crp/out/hvs_1st0
DIRCRPDAYOUT1ST0=../../crp/out/crp_1st0
   DIRYLDOUT2ND0=../../crp/out/yld_2nd0
   DIRCWDOUT2ND0=../../crp/out/cwd_2nd0
   DIRCWSOUT2ND0=../../crp/out/cws_2nd0
 DIRREGFDOUT2ND0=../../crp/out/reg_2nd0
DIRHVSDOYOUT2ND0=../../crp/out/hvs_2nd0
DIRCRPDAYOUT2ND0=../../crp/out/crp_2nd0
   DIRYLDOUT1ST1=../../crp/out/yld_1st1
   DIRCWDOUT1ST1=../../crp/out/cwd_1st1
   DIRCWSOUT1ST1=../../crp/out/cws_1st1
 DIRREGFDOUT1ST1=../../crp/out/reg_1st1
DIRHVSDOYOUT1ST1=../../crp/out/hvs_1st1
DIRCRPDAYOUT1ST1=../../crp/out/crp_1st1
   DIRYLDOUT2ND1=../../crp/out/yld_2nd1
   DIRCWDOUT2ND1=../../crp/out/cwd_2nd1
   DIRCWSOUT2ND1=../../crp/out/cws_2nd1
 DIRREGFDOUT2ND1=../../crp/out/reg_2nd1
DIRHVSDOYOUT2ND1=../../crp/out/hvs_2nd1
DIRCRPDAYOUT2ND1=../../crp/out/crp_2nd1
   DIRYLDOUT1ST2=../../crp/out/yld_1st2
   DIRCWDOUT1ST2=../../crp/out/cwd_1st2
   DIRCWSOUT1ST2=../../crp/out/cws_1st2
 DIRREGFDOUT1ST2=../../crp/out/reg_1st2
DIRHVSDOYOUT1ST2=../../crp/out/hvs_1st2
DIRCRPDAYOUT1ST2=../../crp/out/crp_1st2
   DIRYLDOUT2ND2=../../crp/out/yld_2nd2
   DIRCWDOUT2ND2=../../crp/out/cwd_2nd2
   DIRCWSOUT2ND2=../../crp/out/cws_2nd2
 DIRREGFDOUT2ND2=../../crp/out/reg_2nd2
DIRHVSDOYOUT2ND2=../../crp/out/hvs_2nd2
DIRCRPDAYOUT2ND2=../../crp/out/crp_2nd2
   DIRYLDOUT1ST3=../../crp/out/yld_1st3
   DIRCWDOUT1ST3=../../crp/out/cwd_1st3
   DIRCWSOUT1ST3=../../crp/out/cws_1st3
 DIRREGFDOUT1ST3=../../crp/out/reg_1st3
DIRHVSDOYOUT1ST3=../../crp/out/hvs_1st3
DIRCRPDAYOUT1ST3=../../crp/out/crp_1st3
   DIRYLDOUT2ND3=../../crp/out/yld_2nd3
   DIRCWDOUT2ND3=../../crp/out/cwd_2nd3
   DIRCWSOUT2ND3=../../crp/out/cws_2nd3
 DIRREGFDOUT2ND3=../../crp/out/reg_2nd3
DIRHVSDOYOUT2ND3=../../crp/out/hvs_2nd3
DIRCRPDAYOUT2ND3=../../crp/out/crp_2nd3
   DIRYLDOUT1ST4=../../crp/out/yld_1st4
   DIRCWDOUT1ST4=../../crp/out/cwd_1st4
   DIRCWSOUT1ST4=../../crp/out/cws_1st4
 DIRREGFDOUT1ST4=../../crp/out/reg_1st4
DIRHVSDOYOUT1ST4=../../crp/out/hvs_1st4
DIRCRPDAYOUT1ST4=../../crp/out/crp_1st4
   DIRYLDOUT2ND4=../../crp/out/yld_2nd4
   DIRCWDOUT2ND4=../../crp/out/cwd_2nd4
   DIRCWSOUT2ND4=../../crp/out/cws_2nd4
 DIRREGFDOUT2ND4=../../crp/out/reg_2nd4
DIRHVSDOYOUT2ND4=../../crp/out/hvs_2nd4
DIRCRPDAYOUT2ND4=../../crp/out/crp_2nd4

# 20200710
    DIRBTOUT1ST5=../../crp/out/bt__1st5
   DIRYLDOUT1ST5=../../crp/out/yld_1st5
   DIRCWDOUT1ST5=../../crp/out/cwd_1st5
   DIRCWSOUT1ST5=../../crp/out/cws_1st5
 DIRREGFDOUT1ST5=../../crp/out/reg_1st5
DIRHVSDOYOUT1ST5=../../crp/out/hvs_1st5
DIRCRPDAYOUT1ST5=../../crp/out/crp_1st5
    DIRBTOUT2ND5=../../crp/out/bt__2nd5
   DIRYLDOUT2ND5=../../crp/out/yld_2nd5
   DIRCWDOUT2ND5=../../crp/out/cwd_2nd5
   DIRCWSOUT2ND5=../../crp/out/cws_2nd5
 DIRREGFDOUT2ND5=../../crp/out/reg_2nd5
DIRHVSDOYOUT2ND5=../../crp/out/hvs_2nd5
DIRCRPDAYOUT2ND5=../../crp/out/crp_2nd5

#
DIRCWSOUT1STGRN0=../../crp/out/cwsg1st0
DIRCWSOUT2NDGRN0=../../crp/out/cwsg2nd0
DIRCWSOUT1STBLU0=../../crp/out/cwsb1st0
DIRCWSOUT2NDBLU0=../../crp/out/cwsb2nd0
DIRCWSOUT1STGRN1=../../crp/out/cwsg1st1
DIRCWSOUT2NDGRN1=../../crp/out/cwsg2nd1
DIRCWSOUT1STBLU1=../../crp/out/cwsb1st1
DIRCWSOUT2NDBLU1=../../crp/out/cwsb2nd1
DIRCWSOUT1STGRN2=../../crp/out/cwsg1st2
DIRCWSOUT2NDGRN2=../../crp/out/cwsg2nd2
DIRCWSOUT1STBLU2=../../crp/out/cwsb1st2
DIRCWSOUT2NDBLU2=../../crp/out/cwsb2nd2
DIRCWSOUT1STGRN3=../../crp/out/cwsg1st3
DIRCWSOUT2NDGRN3=../../crp/out/cwsg2nd3
DIRCWSOUT1STBLU3=../../crp/out/cwsb1st3
DIRCWSOUT2NDBLU3=../../crp/out/cwsb2nd3
DIRCWSOUT1STGRN4=../../crp/out/cwsg1st4
DIRCWSOUT2NDGRN4=../../crp/out/cwsg2nd4
DIRCWSOUT1STBLU4=../../crp/out/cwsb1st4
DIRCWSOUT2NDBLU4=../../crp/out/cwsb2nd4
# 2020071
DIRCWSOUT1STGRN5=../../crp/out/cwsg1st5
DIRCWSOUT2NDGRN5=../../crp/out/cwsg2nd5
DIRCWSOUT1STBLU5=../../crp/out/cwsb1st5
DIRCWSOUT2NDBLU5=../../crp/out/cwsb2nd5
############################################################
# Output for crp (Do not edit here unless you are an expert)
############################################################
   YLDOUT1ST0=${DIRYLDOUT1ST0}/${PRJ}${RUN}${SUF}YR
   YLDOUT2ND0=${DIRYLDOUT2ND0}/${PRJ}${RUN}${SUF}YR
   CWDOUT1ST0=${DIRCWDOUT1ST0}/${PRJ}${RUN}${SUF}YR
   CWDOUT2ND0=${DIRCWDOUT2ND0}/${PRJ}${RUN}${SUF}YR
   CWSOUT1ST0=${DIRCWSOUT1ST0}/${PRJ}${RUN}${SUF}YR
   CWSOUT2ND0=${DIRCWSOUT2ND0}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT1ST0=${DIRHVSDOYOUT1ST0}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT2ND0=${DIRHVSDOYOUT2ND0}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT1ST0=${DIRCRPDAYOUT1ST0}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT2ND0=${DIRCRPDAYOUT2ND0}/${PRJ}${RUN}${SUF}YR
 REGFDOUT1ST0=${DIRREGFDOUT1ST0}/${PRJ}${RUN}${SUF}YR
 REGFDOUT2ND0=${DIRREGFDOUT2ND0}/${PRJ}${RUN}${SUF}YR

   YLDOUT1ST1=${DIRYLDOUT1ST1}/${PRJ}${RUN}${SUF}YR
   YLDOUT2ND1=${DIRYLDOUT2ND1}/${PRJ}${RUN}${SUF}YR
   CWDOUT1ST1=${DIRCWDOUT1ST1}/${PRJ}${RUN}${SUF}YR
   CWDOUT2ND1=${DIRCWDOUT2ND1}/${PRJ}${RUN}${SUF}YR
   CWSOUT1ST1=${DIRCWSOUT1ST1}/${PRJ}${RUN}${SUF}YR
   CWSOUT2ND1=${DIRCWSOUT2ND1}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT1ST1=${DIRHVSDOYOUT1ST1}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT2ND1=${DIRHVSDOYOUT2ND1}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT1ST1=${DIRCRPDAYOUT1ST1}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT2ND1=${DIRCRPDAYOUT2ND1}/${PRJ}${RUN}${SUF}YR
 REGFDOUT1ST1=${DIRREGFDOUT1ST1}/${PRJ}${RUN}${SUF}YR
 REGFDOUT2ND1=${DIRREGFDOUT2ND1}/${PRJ}${RUN}${SUF}YR

   YLDOUT1ST2=${DIRYLDOUT1ST2}/${PRJ}${RUN}${SUF}YR
   YLDOUT2ND2=${DIRYLDOUT2ND2}/${PRJ}${RUN}${SUF}YR
   CWDOUT1ST2=${DIRCWDOUT1ST2}/${PRJ}${RUN}${SUF}YR
   CWDOUT2ND2=${DIRCWDOUT2ND2}/${PRJ}${RUN}${SUF}YR
   CWSOUT1ST2=${DIRCWSOUT1ST2}/${PRJ}${RUN}${SUF}YR
   CWSOUT2ND2=${DIRCWSOUT2ND2}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT1ST2=${DIRHVSDOYOUT1ST2}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT2ND2=${DIRHVSDOYOUT2ND2}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT1ST2=${DIRCRPDAYOUT1ST2}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT2ND2=${DIRCRPDAYOUT2ND2}/${PRJ}${RUN}${SUF}YR
 REGFDOUT1ST2=${DIRREGFDOUT1ST2}/${PRJ}${RUN}${SUF}YR
 REGFDOUT2ND2=${DIRREGFDOUT2ND2}/${PRJ}${RUN}${SUF}YR

   YLDOUT1ST3=${DIRYLDOUT1ST3}/${PRJ}${RUN}${SUF}YR
   YLDOUT2ND3=${DIRYLDOUT2ND3}/${PRJ}${RUN}${SUF}YR
   CWDOUT1ST3=${DIRCWDOUT1ST3}/${PRJ}${RUN}${SUF}YR
   CWDOUT2ND3=${DIRCWDOUT2ND3}/${PRJ}${RUN}${SUF}YR
   CWSOUT1ST3=${DIRCWSOUT1ST3}/${PRJ}${RUN}${SUF}YR
   CWSOUT2ND3=${DIRCWSOUT2ND3}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT1ST3=${DIRHVSDOYOUT1ST3}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT2ND3=${DIRHVSDOYOUT2ND3}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT1ST3=${DIRCRPDAYOUT1ST3}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT2ND3=${DIRCRPDAYOUT2ND3}/${PRJ}${RUN}${SUF}YR
 REGFDOUT1ST3=${DIRREGFDOUT1ST3}/${PRJ}${RUN}${SUF}YR
 REGFDOUT2ND3=${DIRREGFDOUT2ND3}/${PRJ}${RUN}${SUF}YR

   YLDOUT1ST4=${DIRYLDOUT1ST4}/${PRJ}${RUN}${SUF}YR
   YLDOUT2ND4=${DIRYLDOUT2ND4}/${PRJ}${RUN}${SUF}YR
   CWDOUT1ST4=${DIRCWDOUT1ST4}/${PRJ}${RUN}${SUF}YR
   CWDOUT2ND4=${DIRCWDOUT2ND4}/${PRJ}${RUN}${SUF}YR
   CWSOUT1ST4=${DIRCWSOUT1ST4}/${PRJ}${RUN}${SUF}YR
   CWSOUT2ND4=${DIRCWSOUT2ND4}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT1ST4=${DIRHVSDOYOUT1ST4}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT2ND4=${DIRHVSDOYOUT2ND4}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT1ST4=${DIRCRPDAYOUT1ST4}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT2ND4=${DIRCRPDAYOUT2ND4}/${PRJ}${RUN}${SUF}YR
 REGFDOUT1ST4=${DIRREGFDOUT1ST4}/${PRJ}${RUN}${SUF}YR
 REGFDOUT2ND4=${DIRREGFDOUT2ND4}/${PRJ}${RUN}${SUF}YR

# 20200710
   YLDOUT1ST5=${DIRYLDOUT1ST5}/${PRJ}${RUN}${SUF}YR
   YLDOUT2ND5=${DIRYLDOUT2ND5}/${PRJ}${RUN}${SUF}YR
   CWDOUT1ST5=${DIRCWDOUT1ST5}/${PRJ}${RUN}${SUF}YR
   CWDOUT2ND5=${DIRCWDOUT2ND5}/${PRJ}${RUN}${SUF}YR
   CWSOUT1ST5=${DIRCWSOUT1ST5}/${PRJ}${RUN}${SUF}YR
   CWSOUT2ND5=${DIRCWSOUT2ND5}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT1ST5=${DIRHVSDOYOUT1ST5}/${PRJ}${RUN}${SUF}YR
HVSDOYOUT2ND5=${DIRHVSDOYOUT2ND5}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT1ST5=${DIRCRPDAYOUT1ST5}/${PRJ}${RUN}${SUF}YR
CRPDAYOUT2ND5=${DIRCRPDAYOUT2ND5}/${PRJ}${RUN}${SUF}YR
 REGFDOUT1ST5=${DIRREGFDOUT1ST5}/${PRJ}${RUN}${SUF}YR
 REGFDOUT2ND5=${DIRREGFDOUT2ND5}/${PRJ}${RUN}${SUF}YR

CWSOUT1STGRN0=${DIRCWSOUT1STGRN0}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDGRN0=${DIRCWSOUT2NDGRN0}/${PRJ}${RUN}${SUF}YR
CWSOUT1STBLU0=${DIRCWSOUT1STBLU0}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDBLU0=${DIRCWSOUT2NDBLU0}/${PRJ}${RUN}${SUF}YR

CWSOUT1STGRN1=${DIRCWSOUT1STGRN1}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDGRN1=${DIRCWSOUT2NDGRN1}/${PRJ}${RUN}${SUF}YR
CWSOUT1STBLU1=${DIRCWSOUT1STBLU1}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDBLU1=${DIRCWSOUT2NDBLU1}/${PRJ}${RUN}${SUF}YR

CWSOUT1STGRN2=${DIRCWSOUT1STGRN2}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDGRN2=${DIRCWSOUT2NDGRN2}/${PRJ}${RUN}${SUF}YR
CWSOUT1STBLU2=${DIRCWSOUT1STBLU2}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDBLU2=${DIRCWSOUT2NDBLU2}/${PRJ}${RUN}${SUF}YR

CWSOUT1STGRN3=${DIRCWSOUT1STGRN3}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDGRN3=${DIRCWSOUT2NDGRN3}/${PRJ}${RUN}${SUF}YR
CWSOUT1STBLU3=${DIRCWSOUT1STBLU3}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDBLU3=${DIRCWSOUT2NDBLU3}/${PRJ}${RUN}${SUF}YR

CWSOUT1STGRN4=${DIRCWSOUT1STGRN4}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDGRN4=${DIRCWSOUT2NDGRN4}/${PRJ}${RUN}${SUF}YR
CWSOUT1STBLU4=${DIRCWSOUT1STBLU4}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDBLU4=${DIRCWSOUT2NDBLU4}/${PRJ}${RUN}${SUF}YR

# 20200710
CWSOUT1STGRN5=${DIRCWSOUT1STGRN5}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDGRN5=${DIRCWSOUT2NDGRN5}/${PRJ}${RUN}${SUF}YR
CWSOUT1STBLU5=${DIRCWSOUT1STBLU5}/${PRJ}${RUN}${SUF}YR
CWSOUT2NDBLU5=${DIRCWSOUT2NDBLU5}/${PRJ}${RUN}${SUF}YR
############################################################
# Output directory for hum (Do not edit here unless you are an expert)
############################################################
DIRDEMAGR0=../../lnd/out/DemAgr__
DIRDEMAGR1=../../lnd/out/DemAgr_1
DIRDEMAGR2=../../lnd/out/DemAgr_2
DIRDEMAGR3=../../lnd/out/DemAgr_3
DIRDEMAGR4=../../lnd/out/DemAgr_4
DIRDEMAGR5=../../lnd/out/DemAgr_5
#
DIRSUPAGR=../../lnd/out/SupAgr__
DIRDAMSTO=../../dam/out/dam_sto_       # large reservoir storage
DIRMSRSTO=../../dam/out/msr_sto_       # medium-sized reservoir storage
DIRDAMOUT=../../dam/out/dam_out_       # large reservoir release
DIRDAMDEM=../../dam/out/dam_dem_       # large reservoir release
DIRMSROUT=../../dam/out/msr_out_       # medium-sezed reservoir storage
# 20200710
  DIRKRLS=../../dam/out/krls____
#
DIRSUPIND=../../lnd/out/SupInd__       # industrial water supply
DIRSUPDOM=../../lnd/out/SupDom__       # domestic water supply
DIRSUPAGRRIV=../../lnd/out/SupAgrR_    # agricultral water supply from river
DIRSUPINDRIV=../../lnd/out/SupIndR_    # industrial water supply from river
DIRSUPDOMRIV=../../lnd/out/SupDomR_    # domestic water supply from river
DIRSUPAGRCAN=../../lnd/out/SupAgrC_    # agricultral water supply from canal
DIRSUPINDCAN=../../lnd/out/SupIndC_    # industrial water supply from canal
DIRSUPDOMCAN=../../lnd/out/SupDomC_    # domestic water supply from canal
DIRSUPAGRRGW=../../lnd/out/SupAgrGR    # agricultral water supply from RGW
DIRSUPINDRGW=../../lnd/out/SupIndGR    # industrial water supply from RGW
DIRSUPDOMRGW=../../lnd/out/SupDomGR    # domestic water supply from RGW
DIRSUPAGRMSR=../../lnd/out/SupAgrM_    # agricultural water supply from m-s r
DIRSUPINDMSR=../../lnd/out/SupIndM_    # industrial water supply from m-s r
DIRSUPDOMMSR=../../lnd/out/SupDomM_    # domestic water supply from m-s r
DIRSUPAGRNNBS=../../lnd/out/SupAgrSN    # agricultural water supply from NNBW
DIRSUPINDNNBS=../../lnd/out/SupIndSN    # industrial water supply from NNBW
DIRSUPDOMNNBS=../../lnd/out/SupDomSN    # domestic water supply from NNBW
DIRSUPAGRNNBG=../../lnd/out/SupAgrGN    # agricultural water supply from NNBW
DIRSUPINDNNBG=../../lnd/out/SupIndGN    # industrial water supply from NNBW
DIRSUPDOMNNBG=../../lnd/out/SupDomGN    # domestic water supply from NNBW
DIRSUPAGRDES=../../lnd/out/SupAgrD_    # agricultural water supply from des 
DIRSUPINDDES=../../lnd/out/SupIndD_    # industrial water supply from desal
DIRSUPDOMDES=../../lnd/out/SupDomD_    # domestic water supply from desal
DIRSUPAGRRCL=../../lnd/out/SupAgrL_    # agricultural water supply from rec
DIRSUPINDRCL=../../lnd/out/SupIndL_    # industrial water supply from recycl
DIRSUPDOMRCL=../../lnd/out/SupDomL_    # domestic water supply from recycl
DIRSUPAGRDEF=../../lnd/out/SupAgrF_    # agricultural water deficit
DIRSUPINDDEF=../../lnd/out/SupIndF_    # industrial water deficit
DIRSUPDOMDEF=../../lnd/out/SupDomF_    # domestic water deficit
DIRLOSAGR=../../lnd/out/LosAgr__       # irrigation loss
DIRRTFAGR=../../lnd/out/RtFAgr__       # returnflow agricultural
DIRRTFIND=../../lnd/out/RtFInd__       # returnflow industrial
DIRRTFDOM=../../lnd/out/RtFDom__       # returnflow domestic
############################################################
# Output for hum (Do not edit here unless you are an expert)
############################################################
    DEMAGR0=NO
    DEMAGR1=NO
    DEMAGR2=NO
    DEMAGR3=NO
    DEMAGR4=NO
    DEMAGR5=NO
    SUPAGR=NO
    DAMSTO=NO
    MSRSTO=NO
    DAMINF=NO
    DAMOUT=NO
    DAMDEM=NO
    MSRINF=NO
    MSROUT=NO
    SUPIND=NO
    SUPDOM=NO
    SUPAGRRIV=NO
    SUPINDRIV=NO
    SUPDOMRIV=NO
    SUPAGRCAN=NO
    SUPINDCAN=NO
    SUPDOMCAN=NO
    SUPAGRRGW=NO
    SUPINDRGW=NO
    SUPDOMRGW=NO
    SUPAGRMSR=NO
    SUPINDMSR=NO
    SUPDOMMSR=NO
    SUPAGRNNBS=NO
    SUPINDNNBS=NO
    SUPDOMNNBS=NO
    SUPAGRNNBG=NO
    SUPINDNNBG=NO
    SUPDOMNNBG=NO
    SUPAGRDES=NO
    SUPINDDES=NO
    SUPDOMDES=NO
    SUPAGRRCL=NO
    SUPINDRCL=NO
    SUPDOMRCL=NO
    SUPAGRDEF=NO
    SUPINDDEF=NO
    SUPDOMDEF=NO
    LOSAGR=NO
    RTFAGR=NO
    RTFIND=NO
    RTFDOM=NO
#
    DEMAGR0=${DIRDEMAGR0}/${PRJ}${RUN}${SUF}DY
    DEMAGR1=${DIRDEMAGR1}/${PRJ}${RUN}${SUF}MO
    DEMAGR2=${DIRDEMAGR2}/${PRJ}${RUN}${SUF}MO
    DEMAGR3=${DIRDEMAGR3}/${PRJ}${RUN}${SUF}MO
    DEMAGR4=${DIRDEMAGR4}/${PRJ}${RUN}${SUF}MO
    DEMAGR5=${DIRDEMAGR5}/${PRJ}${RUN}${SUF}MO
    SUPAGR=${DIRSUPAGR}/${PRJ}${RUN}${SUF}MO
    DAMSTO=${DIRDAMSTO}/${PRJ}${RUN}${SUF}DY
    DAMOUT=${DIRDAMOUT}/${PRJ}${RUN}${SUF}DY
    DAMDEM=${DIRDAMDEM}/${PRJ}${RUN}${SUF}DY
      KRLS=${DIRKRLS}/${PRJ}${RUN}${SUF}YR # 20200710
    MSRSTO=${DIRMSRSTO}/${PRJ}${RUN}${SUF}MO
    MSROUT=${DIRMSROUT}/${PRJ}${RUN}${SUF}MO
    SUPIND=${DIRSUPIND}/${PRJ}${RUN}${SUF}MO
    SUPDOM=${DIRSUPDOM}/${PRJ}${RUN}${SUF}MO
    SUPAGRRIV=${DIRSUPAGRRIV}/${PRJ}${RUN}${SUF}MO
    SUPINDRIV=${DIRSUPINDRIV}/${PRJ}${RUN}${SUF}MO
    SUPDOMRIV=${DIRSUPDOMRIV}/${PRJ}${RUN}${SUF}MO
    SUPAGRCAN=${DIRSUPAGRCAN}/${PRJ}${RUN}${SUF}MO
    SUPINDCAN=${DIRSUPINDCAN}/${PRJ}${RUN}${SUF}MO
    SUPDOMCAN=${DIRSUPDOMCAN}/${PRJ}${RUN}${SUF}MO
    SUPAGRRGW=${DIRSUPAGRRGW}/${PRJ}${RUN}${SUF}MO
    SUPINDRGW=${DIRSUPINDRGW}/${PRJ}${RUN}${SUF}MO
    SUPDOMRGW=${DIRSUPDOMRGW}/${PRJ}${RUN}${SUF}MO
    SUPAGRMSR=${DIRSUPAGRMSR}/${PRJ}${RUN}${SUF}MO
    SUPINDMSR=${DIRSUPINDMSR}/${PRJ}${RUN}${SUF}MO
    SUPDOMMSR=${DIRSUPDOMMSR}/${PRJ}${RUN}${SUF}MO
   SUPAGRNNBS=${DIRSUPAGRNNBS}/${PRJ}${RUN}${SUF}MO
   SUPINDNNBS=${DIRSUPINDNNBS}/${PRJ}${RUN}${SUF}MO
   SUPDOMNNBS=${DIRSUPDOMNNBS}/${PRJ}${RUN}${SUF}MO
   SUPAGRNNBG=${DIRSUPAGRNNBG}/${PRJ}${RUN}${SUF}MO
   SUPINDNNBG=${DIRSUPINDNNBG}/${PRJ}${RUN}${SUF}MO
   SUPDOMNNBG=${DIRSUPDOMNNBG}/${PRJ}${RUN}${SUF}MO
    SUPAGRDES=${DIRSUPAGRDES}/${PRJ}${RUN}${SUF}MO
    SUPINDDES=${DIRSUPINDDES}/${PRJ}${RUN}${SUF}MO
    SUPDOMDES=${DIRSUPDOMDES}/${PRJ}${RUN}${SUF}MO
    SUPAGRRCL=${DIRSUPAGRRCL}/${PRJ}${RUN}${SUF}MO
    SUPINDRCL=${DIRSUPINDRCL}/${PRJ}${RUN}${SUF}MO
    SUPDOMRCL=${DIRSUPDOMRCL}/${PRJ}${RUN}${SUF}MO
    SUPAGRDEF=${DIRSUPAGRDEF}/${PRJ}${RUN}${SUF}MO
    SUPINDDEF=${DIRSUPINDDEF}/${PRJ}${RUN}${SUF}MO
    SUPDOMDEF=${DIRSUPDOMDEF}/${PRJ}${RUN}${SUF}MO
    LOSAGR=${DIRLOSAGR}/${PRJ}${RUN}${SUF}MO
    RTFAGR=${DIRRTFAGR}/${PRJ}${RUN}${SUF}MO
    RTFIND=${DIRRTFIND}/${PRJ}${RUN}${SUF}MO
    RTFDOM=${DIRRTFDOM}/${PRJ}${RUN}${SUF}MO
############################################################
# Edit here if you wish (new, out directory)
############################################################
DIRFRCSOILMOISTGRN0=../../lnd/out/SoilmGF_
DIRFRCSOILMOISTRIV0=../../lnd/out/SoilmRF_
DIRFRCSOILMOISTMSR0=../../lnd/out/SoilmMF_
DIRFRCSOILMOISTNNB0=../../lnd/out/SoilmNF_
DIRFRCSOILMOISTGRN1=../../lnd/out/SoilmGF1
DIRFRCSOILMOISTRIV1=../../lnd/out/SoilmRF1
DIRFRCSOILMOISTMSR1=../../lnd/out/SoilmMF1
DIRFRCSOILMOISTNNB1=../../lnd/out/SoilmNF1
DIRFRCSOILMOISTGRN2=../../lnd/out/SoilmGF2
DIRFRCSOILMOISTRIV2=../../lnd/out/SoilmRF2
DIRFRCSOILMOISTMSR2=../../lnd/out/SoilmMF2
DIRFRCSOILMOISTNNB2=../../lnd/out/SoilmNF2
DIRFRCSOILMOISTGRN3=../../lnd/out/SoilmGF3
DIRFRCSOILMOISTRIV3=../../lnd/out/SoilmRF3
DIRFRCSOILMOISTMSR3=../../lnd/out/SoilmMF3
DIRFRCSOILMOISTNNB3=../../lnd/out/SoilmNF3
DIRFRCSOILMOISTGRN4=../../lnd/out/SoilmGF4
DIRFRCSOILMOISTRIV4=../../lnd/out/SoilmRF4
DIRFRCSOILMOISTMSR4=../../lnd/out/SoilmMF4
DIRFRCSOILMOISTNNB4=../../lnd/out/SoilmNF4
# 20200710
DIRFRCSOILMOISTGRN5=../../lnd/out/SoilmGF5
DIRFRCSOILMOISTRIV5=../../lnd/out/SoilmRF5
DIRFRCSOILMOISTMSR5=../../lnd/out/SoilmMF5
DIRFRCSOILMOISTNNB5=../../lnd/out/SoilmNF5
DIREVAPGRN0=../../lnd/out/Evap__G_
DIREVAPBLU0=../../lnd/out/Evap__B_
DIREVAPGRN1=../../lnd/out/Evap__G1
DIREVAPBLU1=../../lnd/out/Evap__B1
DIREVAPGRN2=../../lnd/out/Evap__G2
DIREVAPBLU2=../../lnd/out/Evap__B2
DIREVAPGRN3=../../lnd/out/Evap__G3
DIREVAPBLU3=../../lnd/out/Evap__B3
DIREVAPGRN4=../../lnd/out/Evap__G4
DIREVAPBLU4=../../lnd/out/Evap__B4
# 20200710
DIREVAPGRN5=../../lnd/out/Evap__G5
DIREVAPBLU5=../../lnd/out/Evap__B5
############################################################
# Edit here if you wish (new, out)
############################################################
FRCSOILMOISTGRN0=NO
FRCSOILMOISTRIV0=NO
FRCSOILMOISTMSR0=NO
FRCSOILMOISTNNB0=NO
FRCSOILMOISTGRN1=NO
FRCSOILMOISTRIV1=NO
FRCSOILMOISTMSR1=NO
FRCSOILMOISTNNB1=NO
FRCSOILMOISTGRN2=NO
FRCSOILMOISTRIV2=NO
FRCSOILMOISTMSR2=NO
FRCSOILMOISTNNB2=NO
FRCSOILMOISTGRN3=NO
FRCSOILMOISTRIV3=NO
FRCSOILMOISTMSR3=NO
FRCSOILMOISTNNB3=NO
FRCSOILMOISTGRN4=NO
FRCSOILMOISTRIV4=NO
FRCSOILMOISTMSR4=NO
FRCSOILMOISTNNB4=NO
# 20200710
FRCSOILMOISTGRN5=NO
FRCSOILMOISTRIV5=NO
FRCSOILMOISTMSR5=NO
FRCSOILMOISTNNB5=NO

EVAPGRN0=NO
EVAPBLU0=NO
EVAPGRN1=NO
EVAPBLU1=NO
EVAPGRN2=NO
EVAPBLU2=NO
EVAPGRN3=NO
EVAPBLU3=NO
EVAPGRN4=NO
EVAPBLU4=NO
# 20200710
EVAPGRN5=NO
EVAPBLU5=NO
#
FRCSOILMOISTGRN0=${DIRFRCSOILMOISTGRN0}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTRIV0=${DIRFRCSOILMOISTRIV0}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTMSR0=${DIRFRCSOILMOISTMSR0}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTNNB0=${DIRFRCSOILMOISTNNB0}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTGRN1=${DIRFRCSOILMOISTGRN1}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTRIV1=${DIRFRCSOILMOISTRIV1}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTMSR1=${DIRFRCSOILMOISTMSR1}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTNNB1=${DIRFRCSOILMOISTNNB1}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTGRN2=${DIRFRCSOILMOISTGRN2}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTRIV2=${DIRFRCSOILMOISTRIV2}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTMSR2=${DIRFRCSOILMOISTMSR2}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTNNB2=${DIRFRCSOILMOISTNNB2}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTGRN3=${DIRFRCSOILMOISTGRN3}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTRIV3=${DIRFRCSOILMOISTRIV3}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTMSR3=${DIRFRCSOILMOISTMSR3}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTNNB3=${DIRFRCSOILMOISTNNB3}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTGRN4=${DIRFRCSOILMOISTGRN4}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTRIV4=${DIRFRCSOILMOISTRIV4}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTMSR4=${DIRFRCSOILMOISTMSR4}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTNNB4=${DIRFRCSOILMOISTNNB4}/${PRJ}${RUN}${SUF}MO
# 20200710 
FRCSOILMOISTGRN5=${DIRFRCSOILMOISTGRN5}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTRIV5=${DIRFRCSOILMOISTRIV5}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTMSR5=${DIRFRCSOILMOISTMSR5}/${PRJ}${RUN}${SUF}MO
FRCSOILMOISTNNB5=${DIRFRCSOILMOISTNNB5}/${PRJ}${RUN}${SUF}MO

EVAPGRN0=${DIREVAPGRN0}/${PRJ}${RUN}${SUF}MO
EVAPBLU0=${DIREVAPBLU0}/${PRJ}${RUN}${SUF}MO
EVAPGRN1=${DIREVAPGRN1}/${PRJ}${RUN}${SUF}MO
EVAPBLU1=${DIREVAPBLU1}/${PRJ}${RUN}${SUF}MO
EVAPGRN2=${DIREVAPGRN2}/${PRJ}${RUN}${SUF}MO
EVAPBLU2=${DIREVAPBLU2}/${PRJ}${RUN}${SUF}MO
EVAPGRN3=${DIREVAPGRN3}/${PRJ}${RUN}${SUF}MO
EVAPBLU3=${DIREVAPBLU3}/${PRJ}${RUN}${SUF}MO
EVAPGRN4=${DIREVAPGRN4}/${PRJ}${RUN}${SUF}MO
EVAPBLU4=${DIREVAPBLU4}/${PRJ}${RUN}${SUF}MO
# 20200710
EVAPGRN5=${DIREVAPGRN5}/${PRJ}${RUN}${SUF}MO
EVAPBLU5=${DIREVAPBLU5}/${PRJ}${RUN}${SUF}MO
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d $DIRTAIROUT ];   then mkdir -p $DIRTAIROUT;   fi
if [ ! -d $DIRRAINFOUT ];  then mkdir -p $DIRRAINFOUT;  fi
if [ ! -d $DIRSNOWFOUT ];  then mkdir -p $DIRSNOWFOUT;  fi
if [ ! -d $DIRLWDOWNOUT ]; then mkdir -p $DIRLWDOWNOUT; fi
############################################################
# Job (Prepare directory NEW)
############################################################
if [ ! -d $DIRLOSAGR ]; then mkdir -p $DIRLOSAGR; fi
if [ ! -d $DIRRTFAGR ]; then mkdir -p $DIRRTFAGR; fi
if [ ! -d $DIRRTFIND ]; then mkdir -p $DIRRTFIND; fi
if [ ! -d $DIRRTFDOM ]; then mkdir -p $DIRRTFDOM; fi
############################################################
# Job (Prepare directory Land)
############################################################
if [ ! -d ../../lnd/out ]; then mkdir -p ../../lnd/out; fi
if [ ! -d $DIRSWNET0     ]; then mkdir -p $DIRSWNET0;     fi
if [ ! -d $DIRLWNET0     ]; then mkdir -p $DIRLWNET0;     fi
if [ ! -d $DIRQH0        ]; then mkdir -p $DIRQH0;        fi
if [ ! -d $DIRQG0        ]; then mkdir -p $DIRQG0;        fi
if [ ! -d $DIRQLE0       ]; then mkdir -p $DIRQLE0;       fi
if [ ! -d $DIREVAP0      ]; then mkdir -p $DIREVAP0;      fi
if [ ! -d $DIRPOTEVAP0   ]; then mkdir -p $DIRPOTEVAP0;   fi
if [ ! -d $DIRQS0        ]; then mkdir -p $DIRQS0;        fi
if [ ! -d $DIRQSB0       ]; then mkdir -p $DIRQSB0;       fi
if [ ! -d $DIRQTOT0      ]; then mkdir -p $DIRQTOT0;      fi
if [ ! -d $DIRSOILMOIST0 ]; then mkdir -p $DIRSOILMOIST0; fi
if [ ! -d $DIRSOILTEMP0  ]; then mkdir -p $DIRSOILTEMP0;  fi
if [ ! -d $DIRSWE0       ]; then mkdir -p $DIRSWE0;       fi
if [ ! -d $DIRAVGSURFT0  ]; then mkdir -p $DIRAVGSURFT0;  fi
if [ ! -d $DIRGW0        ]; then mkdir -p $DIRGW0;        fi
if [ ! -d $DIRQBF0       ]; then mkdir -p $DIRQBF0;       fi
if [ ! -d $DIRQRC0       ]; then mkdir -p $DIRQRC0;       fi

if [ ! -d $DIRSWNET1     ]; then mkdir -p $DIRSWNET1;     fi
if [ ! -d $DIRLWNET1     ]; then mkdir -p $DIRLWNET1;     fi
if [ ! -d $DIRQH1        ]; then mkdir -p $DIRQH1;        fi
if [ ! -d $DIRQLE1       ]; then mkdir -p $DIRQLE1;       fi
if [ ! -d $DIREVAP1      ]; then mkdir -p $DIREVAP1;      fi
if [ ! -d $DIRPOTEVAP1   ]; then mkdir -p $DIRPOTEVAP1;   fi
if [ ! -d $DIRQS1        ]; then mkdir -p $DIRQS1;        fi
if [ ! -d $DIRQSB1       ]; then mkdir -p $DIRQSB1;       fi
if [ ! -d $DIRQTOT1      ]; then mkdir -p $DIRQTOT1;      fi
if [ ! -d $DIRSOILMOIST1 ]; then mkdir -p $DIRSOILMOIST1; fi
if [ ! -d $DIRSOILTEMP1  ]; then mkdir -p $DIRSOILTEMP1;  fi
if [ ! -d $DIRSWE1       ]; then mkdir -p $DIRSWE1;       fi
if [ ! -d $DIRAVGSURFT1  ]; then mkdir -p $DIRAVGSURFT1;  fi
if [ ! -d $DIRGW1        ]; then mkdir -p $DIRGW1;        fi
if [ ! -d $DIRQBF1       ]; then mkdir -p $DIRQBF1;       fi
if [ ! -d $DIRQRC1       ]; then mkdir -p $DIRQRC1;       fi

if [ ! -d $DIRSWNET2     ]; then mkdir -p $DIRSWNET2;     fi
if [ ! -d $DIRLWNET2     ]; then mkdir -p $DIRLWNET2;     fi
if [ ! -d $DIRQH2        ]; then mkdir -p $DIRQH2;        fi
if [ ! -d $DIRQLE2       ]; then mkdir -p $DIRQLE2;       fi
if [ ! -d $DIREVAP2      ]; then mkdir -p $DIREVAP2;      fi
if [ ! -d $DIRPOTEVAP2   ]; then mkdir -p $DIRPOTEVAP2;   fi
if [ ! -d $DIRQS2        ]; then mkdir -p $DIRQS2;        fi
if [ ! -d $DIRQSB2       ]; then mkdir -p $DIRQSB2;       fi
if [ ! -d $DIRQTOT2      ]; then mkdir -p $DIRQTOT2;      fi
if [ ! -d $DIRSOILMOIST2 ]; then mkdir -p $DIRSOILMOIST2; fi
if [ ! -d $DIRSOILTEMP2  ]; then mkdir -p $DIRSOILTEMP2;  fi
if [ ! -d $DIRSWE2       ]; then mkdir -p $DIRSWE2;       fi
if [ ! -d $DIRAVGSURFT2  ]; then mkdir -p $DIRAVGSURFT2;  fi
if [ ! -d $DIRGW2        ]; then mkdir -p $DIRGW2;        fi
if [ ! -d $DIRQBF2       ]; then mkdir -p $DIRQBF2;       fi
if [ ! -d $DIRQRC2       ]; then mkdir -p $DIRQRC2;       fi

if [ ! -d $DIRSWNET3     ]; then mkdir -p $DIRSWNET3;     fi
if [ ! -d $DIRLWNET3     ]; then mkdir -p $DIRLWNET3;     fi
if [ ! -d $DIRQH3        ]; then mkdir -p $DIRQH3;        fi
if [ ! -d $DIRQLE3       ]; then mkdir -p $DIRQLE3;       fi
if [ ! -d $DIREVAP3      ]; then mkdir -p $DIREVAP3;      fi
if [ ! -d $DIRPOTEVAP3   ]; then mkdir -p $DIRPOTEVAP3;   fi
if [ ! -d $DIRQS3        ]; then mkdir -p $DIRQS3;        fi
if [ ! -d $DIRQSB3       ]; then mkdir -p $DIRQSB3;       fi
if [ ! -d $DIRQTOT3      ]; then mkdir -p $DIRQTOT3;      fi
if [ ! -d $DIRSOILMOIST3 ]; then mkdir -p $DIRSOILMOIST3; fi
if [ ! -d $DIRSOILTEMP3  ]; then mkdir -p $DIRSOILTEMP3;  fi
if [ ! -d $DIRSWE3       ]; then mkdir -p $DIRSWE3;       fi
if [ ! -d $DIRAVGSURFT3  ]; then mkdir -p $DIRAVGSURFT3;  fi
if [ ! -d $DIRGW3        ]; then mkdir -p $DIRGW3;        fi
if [ ! -d $DIRQBF3       ]; then mkdir -p $DIRQBF3;       fi
if [ ! -d $DIRQRC3       ]; then mkdir -p $DIRQRC3;       fi

if [ ! -d $DIRSWNET4     ]; then mkdir -p $DIRSWNET4;     fi
if [ ! -d $DIRLWNET4     ]; then mkdir -p $DIRLWNET4;     fi
if [ ! -d $DIRQH4        ]; then mkdir -p $DIRQH4;        fi
if [ ! -d $DIRQLE4       ]; then mkdir -p $DIRQLE4;       fi
if [ ! -d $DIREVAP4      ]; then mkdir -p $DIREVAP4;      fi
if [ ! -d $DIRPOTEVAP4   ]; then mkdir -p $DIRPOTEVAP4;   fi
if [ ! -d $DIRQS4        ]; then mkdir -p $DIRQS4;        fi
if [ ! -d $DIRQSB4       ]; then mkdir -p $DIRQSB4;       fi
if [ ! -d $DIRQTOT4      ]; then mkdir -p $DIRQTOT4;      fi
if [ ! -d $DIRSOILMOIST4 ]; then mkdir -p $DIRSOILMOIST4; fi
if [ ! -d $DIRSOILTEMP4  ]; then mkdir -p $DIRSOILTEMP4;  fi
if [ ! -d $DIRSWE4       ]; then mkdir -p $DIRSWE4;       fi
if [ ! -d $DIRAVGSURFT4  ]; then mkdir -p $DIRAVGSURFT4;  fi
if [ ! -d $DIRGW4        ]; then mkdir -p $DIRGW4;        fi
if [ ! -d $DIRQBF4       ]; then mkdir -p $DIRQBF4;       fi
if [ ! -d $DIRQRC4       ]; then mkdir -p $DIRQRC4;       fi

# 20200710
if [ ! -d $DIRSWNET5     ]; then mkdir -p $DIRSWNET5;     fi
if [ ! -d $DIRLWNET5     ]; then mkdir -p $DIRLWNET5;     fi
if [ ! -d $DIRQH5        ]; then mkdir -p $DIRQH5;        fi
if [ ! -d $DIRQLE5       ]; then mkdir -p $DIRQLE5;       fi
if [ ! -d $DIREVAP5      ]; then mkdir -p $DIREVAP5;      fi
if [ ! -d $DIRPOTEVAP5   ]; then mkdir -p $DIRPOTEVAP5;   fi
if [ ! -d $DIRQS5        ]; then mkdir -p $DIRQS5;        fi
if [ ! -d $DIRQSB5       ]; then mkdir -p $DIRQSB5;       fi
if [ ! -d $DIRQTOT5      ]; then mkdir -p $DIRQTOT5;      fi
if [ ! -d $DIRSOILMOIST5 ]; then mkdir -p $DIRSOILMOIST5; fi
if [ ! -d $DIRSOILTEMP5  ]; then mkdir -p $DIRSOILTEMP5;  fi
if [ ! -d $DIRSWE5       ]; then mkdir -p $DIRSWE5;       fi
if [ ! -d $DIRAVGSURFT5  ]; then mkdir -p $DIRAVGSURFT5;  fi
if [ ! -d $DIRGW5        ]; then mkdir -p $DIRGW5;        fi
if [ ! -d $DIRQBF5       ]; then mkdir -p $DIRQBF5;       fi
if [ ! -d $DIRQRC5       ]; then mkdir -p $DIRQRC5;       fi
############################################################
# Job (Prepare directory for riv)
############################################################
if [ ! -d ../../riv/out ]; then mkdir -p ../../riv/out; fi
if [ ! -d $DIRRIVSTO    ]; then mkdir -p $DIRRIVSTO;    fi
if [ ! -d $DIRRIVOUT    ]; then mkdir -p $DIRRIVOUT;    fi
############################################################
# Job (Prepare directory for crp)
############################################################
if [ ! -d $DIRYLDOUT1ST0    ]; then mkdir -p $DIRYLDOUT1ST0;    fi
if [ ! -d $DIRCWDOUT1ST0    ]; then mkdir -p $DIRCWDOUT1ST0;    fi
if [ ! -d $DIRCWSOUT1ST0    ]; then mkdir -p $DIRCWSOUT1ST0;    fi
if [ ! -d $DIRREGFDOUT1ST0  ]; then mkdir -p $DIRREGFDOUT1ST0;  fi
if [ ! -d $DIRHVSDOYOUT1ST0 ]; then mkdir -p $DIRHVSDOYOUT1ST0; fi
if [ ! -d $DIRCRPDAYOUT1ST0 ]; then mkdir -p $DIRCRPDAYOUT1ST0; fi
if [ ! -d $DIRYLDOUT2ND0    ]; then mkdir -p $DIRYLDOUT2ND0;    fi
if [ ! -d $DIRCWDOUT2ND0    ]; then mkdir -p $DIRCWDOUT2ND0;    fi
if [ ! -d $DIRCWSOUT2ND0    ]; then mkdir -p $DIRCWSOUT2ND0;    fi
if [ ! -d $DIRREGFDOUT2ND0  ]; then mkdir -p $DIRREGFDOUT2ND0;  fi
if [ ! -d $DIRHVSDOYOUT2ND0 ]; then mkdir -p $DIRHVSDOYOUT2ND0; fi
if [ ! -d $DIRCRPDAYOUT2ND0 ]; then mkdir -p $DIRCRPDAYOUT2ND0; fi
if [ ! -d $DIRYLDOUT1ST1    ]; then mkdir -p $DIRYLDOUT1ST1;    fi
if [ ! -d $DIRCWDOUT1ST1    ]; then mkdir -p $DIRCWDOUT1ST1;    fi
if [ ! -d $DIRCWSOUT1ST1    ]; then mkdir -p $DIRCWSOUT1ST1;    fi
if [ ! -d $DIRREGFDOUT1ST1  ]; then mkdir -p $DIRREGFDOUT1ST1;  fi
if [ ! -d $DIRHVSDOYOUT1ST1 ]; then mkdir -p $DIRHVSDOYOUT1ST1; fi
if [ ! -d $DIRCRPDAYOUT1ST1 ]; then mkdir -p $DIRCRPDAYOUT1ST1; fi
if [ ! -d $DIRYLDOUT2ND1    ]; then mkdir -p $DIRYLDOUT2ND1;    fi
if [ ! -d $DIRCWDOUT2ND1    ]; then mkdir -p $DIRCWDOUT2ND1;    fi
if [ ! -d $DIRCWSOUT2ND1    ]; then mkdir -p $DIRCWSOUT2ND1;    fi
if [ ! -d $DIRREGFDOUT2ND1  ]; then mkdir -p $DIRREGFDOUT2ND1;  fi
if [ ! -d $DIRHVSDOYOUT2ND1 ]; then mkdir -p $DIRHVSDOYOUT2ND1; fi
if [ ! -d $DIRCRPDAYOUT2ND1 ]; then mkdir -p $DIRCRPDAYOUT2ND1; fi
if [ ! -d $DIRYLDOUT1ST2    ]; then mkdir -p $DIRYLDOUT1ST2;    fi
if [ ! -d $DIRCWDOUT1ST2    ]; then mkdir -p $DIRCWDOUT1ST2;    fi
if [ ! -d $DIRCWSOUT1ST2    ]; then mkdir -p $DIRCWSOUT1ST2;    fi
if [ ! -d $DIRREGFDOUT1ST2  ]; then mkdir -p $DIRREGFDOUT1ST2;  fi
if [ ! -d $DIRHVSDOYOUT1ST2 ]; then mkdir -p $DIRHVSDOYOUT1ST2; fi
if [ ! -d $DIRCRPDAYOUT1ST2 ]; then mkdir -p $DIRCRPDAYOUT1ST2; fi
if [ ! -d $DIRYLDOUT2ND2    ]; then mkdir -p $DIRYLDOUT2ND2;    fi
if [ ! -d $DIRCWDOUT2ND2    ]; then mkdir -p $DIRCWDOUT2ND2;    fi
if [ ! -d $DIRCWSOUT2ND2    ]; then mkdir -p $DIRCWSOUT2ND2;    fi
if [ ! -d $DIRREGFDOUT2ND2  ]; then mkdir -p $DIRREGFDOUT2ND2;  fi
if [ ! -d $DIRHVSDOYOUT2ND2 ]; then mkdir -p $DIRHVSDOYOUT2ND2; fi
if [ ! -d $DIRCRPDAYOUT2ND2 ]; then mkdir -p $DIRCRPDAYOUT2ND2; fi
if [ ! -d $DIRYLDOUT1ST3    ]; then mkdir -p $DIRYLDOUT1ST3;    fi
if [ ! -d $DIRCWDOUT1ST3    ]; then mkdir -p $DIRCWDOUT1ST3;    fi
if [ ! -d $DIRCWSOUT1ST3    ]; then mkdir -p $DIRCWSOUT1ST3;    fi
if [ ! -d $DIRREGFDOUT1ST3  ]; then mkdir -p $DIRREGFDOUT1ST3;  fi
if [ ! -d $DIRHVSDOYOUT1ST3 ]; then mkdir -p $DIRHVSDOYOUT1ST3; fi
if [ ! -d $DIRCRPDAYOUT1ST3 ]; then mkdir -p $DIRCRPDAYOUT1ST3; fi
if [ ! -d $DIRYLDOUT2ND3    ]; then mkdir -p $DIRYLDOUT2ND3;    fi
if [ ! -d $DIRCWDOUT2ND3    ]; then mkdir -p $DIRCWDOUT2ND3;    fi
if [ ! -d $DIRCWSOUT2ND3    ]; then mkdir -p $DIRCWSOUT2ND3;    fi
if [ ! -d $DIRREGFDOUT2ND3  ]; then mkdir -p $DIRREGFDOUT2ND3;  fi
if [ ! -d $DIRHVSDOYOUT2ND3 ]; then mkdir -p $DIRHVSDOYOUT2ND3; fi
if [ ! -d $DIRCRPDAYOUT2ND3 ]; then mkdir -p $DIRCRPDAYOUT2ND3; fi
if [ ! -d $DIRYLDOUT1ST4    ]; then mkdir -p $DIRYLDOUT1ST4;    fi
if [ ! -d $DIRCWDOUT1ST4    ]; then mkdir -p $DIRCWDOUT1ST4;    fi
if [ ! -d $DIRCWSOUT1ST4    ]; then mkdir -p $DIRCWSOUT1ST4;    fi
if [ ! -d $DIRREGFDOUT1ST4  ]; then mkdir -p $DIRREGFDOUT1ST4;  fi
if [ ! -d $DIRHVSDOYOUT1ST4 ]; then mkdir -p $DIRHVSDOYOUT1ST4; fi
if [ ! -d $DIRCRPDAYOUT1ST4 ]; then mkdir -p $DIRCRPDAYOUT1ST4; fi
if [ ! -d $DIRYLDOUT2ND4    ]; then mkdir -p $DIRYLDOUT2ND4;    fi
if [ ! -d $DIRCWDOUT2ND4    ]; then mkdir -p $DIRCWDOUT2ND4;    fi
if [ ! -d $DIRCWSOUT2ND4    ]; then mkdir -p $DIRCWSOUT2ND4;    fi
if [ ! -d $DIRREGFDOUT2ND4  ]; then mkdir -p $DIRREGFDOUT2ND4;  fi
if [ ! -d $DIRHVSDOYOUT2ND4 ]; then mkdir -p $DIRHVSDOYOUT2ND4; fi
if [ ! -d $DIRCRPDAYOUT2ND4 ]; then mkdir -p $DIRCRPDAYOUT2ND4; fi

# 20200710
if [ ! -d $DIRYLDOUT1ST5    ]; then mkdir -p $DIRYLDOUT1ST5;    fi
if [ ! -d $DIRCWDOUT1ST5    ]; then mkdir -p $DIRCWDOUT1ST5;    fi
if [ ! -d $DIRCWSOUT1ST5    ]; then mkdir -p $DIRCWSOUT1ST5;    fi
if [ ! -d $DIRREGFDOUT1ST5  ]; then mkdir -p $DIRREGFDOUT1ST5;  fi
if [ ! -d $DIRHVSDOYOUT1ST5 ]; then mkdir -p $DIRHVSDOYOUT1ST5; fi
if [ ! -d $DIRCRPDAYOUT1ST5 ]; then mkdir -p $DIRCRPDAYOUT1ST5; fi
if [ ! -d $DIRYLDOUT2ND5    ]; then mkdir -p $DIRYLDOUT2ND5;    fi
if [ ! -d $DIRCWDOUT2ND5    ]; then mkdir -p $DIRCWDOUT2ND5;    fi
if [ ! -d $DIRCWSOUT2ND5    ]; then mkdir -p $DIRCWSOUT2ND5;    fi
if [ ! -d $DIRREGFDOUT2ND5  ]; then mkdir -p $DIRREGFDOUT2ND5;  fi
if [ ! -d $DIRHVSDOYOUT2ND5 ]; then mkdir -p $DIRHVSDOYOUT2ND5; fi
if [ ! -d $DIRCRPDAYOUT2ND5 ]; then mkdir -p $DIRCRPDAYOUT2ND5; fi
#
if [ ! -d $DIRCWSOUT1STGRN0 ]; then mkdir -p $DIRCWSOUT1STGRN0; fi
if [ ! -d $DIRCWSOUT2NDGRN0 ]; then mkdir -p $DIRCWSOUT2NDGRN0; fi
if [ ! -d $DIRCWSOUT1STBLU0 ]; then mkdir -p $DIRCWSOUT1STBLU0; fi
if [ ! -d $DIRCWSOUT2NDBLU0 ]; then mkdir -p $DIRCWSOUT2NDBLU0; fi

if [ ! -d $DIRCWSOUT1STGRN1 ]; then mkdir -p $DIRCWSOUT1STGRN1; fi
if [ ! -d $DIRCWSOUT2NDGRN1 ]; then mkdir -p $DIRCWSOUT2NDGRN1; fi
if [ ! -d $DIRCWSOUT1STBLU1 ]; then mkdir -p $DIRCWSOUT1STBLU1; fi
if [ ! -d $DIRCWSOUT2NDBLU1 ]; then mkdir -p $DIRCWSOUT2NDBLU1; fi

if [ ! -d $DIRCWSOUT1STGRN2 ]; then mkdir -p $DIRCWSOUT1STGRN2; fi
if [ ! -d $DIRCWSOUT2NDGRN2 ]; then mkdir -p $DIRCWSOUT2NDGRN2; fi
if [ ! -d $DIRCWSOUT1STBLU2 ]; then mkdir -p $DIRCWSOUT1STBLU2; fi
if [ ! -d $DIRCWSOUT2NDBLU2 ]; then mkdir -p $DIRCWSOUT2NDBLU2; fi

if [ ! -d $DIRCWSOUT1STGRN3 ]; then mkdir -p $DIRCWSOUT1STGRN3; fi
if [ ! -d $DIRCWSOUT2NDGRN3 ]; then mkdir -p $DIRCWSOUT2NDGRN3; fi
if [ ! -d $DIRCWSOUT1STBLU3 ]; then mkdir -p $DIRCWSOUT1STBLU3; fi
if [ ! -d $DIRCWSOUT2NDBLU3 ]; then mkdir -p $DIRCWSOUT2NDBLU3; fi

if [ ! -d $DIRCWSOUT1STGRN4 ]; then mkdir -p $DIRCWSOUT1STGRN4; fi
if [ ! -d $DIRCWSOUT2NDGRN4 ]; then mkdir -p $DIRCWSOUT2NDGRN4; fi
if [ ! -d $DIRCWSOUT1STBLU4 ]; then mkdir -p $DIRCWSOUT1STBLU4; fi
if [ ! -d $DIRCWSOUT2NDBLU4 ]; then mkdir -p $DIRCWSOUT2NDBLU4; fi
# 20200710
if [ ! -d $DIRCWSOUT1STGRN5 ]; then mkdir -p $DIRCWSOUT1STGRN5; fi
if [ ! -d $DIRCWSOUT2NDGRN5 ]; then mkdir -p $DIRCWSOUT2NDGRN5; fi
if [ ! -d $DIRCWSOUT1STBLU5 ]; then mkdir -p $DIRCWSOUT1STBLU5; fi
if [ ! -d $DIRCWSOUT2NDBLU5 ]; then mkdir -p $DIRCWSOUT2NDBLU5; fi
############################################################
# Job (Prepare directory for hum)
############################################################
if [ ! -d $DIRDEMAGR0    ]; then mkdir -p $DIRDEMAGR0;     fi
if [ ! -d $DIRDEMAGR1    ]; then mkdir -p $DIRDEMAGR1;     fi
if [ ! -d $DIRDEMAGR2    ]; then mkdir -p $DIRDEMAGR2;     fi
if [ ! -d $DIRDEMAGR3    ]; then mkdir -p $DIRDEMAGR3;     fi
if [ ! -d $DIRDEMAGR4    ]; then mkdir -p $DIRDEMAGR4;     fi
if [ ! -d $DIRDEMAGR5    ]; then mkdir -p $DIRDEMAGR5;     fi
if [ ! -d $DIRSUPAGR     ]; then mkdir -p $DIRSUPAGR;      fi
if [ ! -d $DIRDAMSTO     ]; then mkdir -p $DIRDAMSTO;        fi
if [ ! -d $DIRDAMOUT     ]; then mkdir -p $DIRDAMOUT;        fi
if [ ! -d $DIRDAMDEM     ]; then mkdir -p $DIRDAMDEM;        fi
if [ ! -d $DIRKRLS       ]; then mkdir -p $DIRKRLS;        fi #20200710
if [ ! -d $DIRMSRSTO     ]; then mkdir -p $DIRMSRSTO;        fi
if [ ! -d $DIRMSROUT     ]; then mkdir -p $DIRMSROUT;        fi
if [ ! -d $DIRSUPIND     ]; then mkdir -p $DIRSUPIND;        fi
if [ ! -d $DIRSUPDOM     ]; then mkdir -p $DIRSUPDOM;        fi
if [ ! -d $DIRSUPAGRRIV  ]; then mkdir -p $DIRSUPAGRRIV;     fi
if [ ! -d $DIRSUPINDRIV  ]; then mkdir -p $DIRSUPINDRIV;     fi
if [ ! -d $DIRSUPDOMRIV  ]; then mkdir -p $DIRSUPDOMRIV;     fi
if [ ! -d $DIRSUPAGRCAN  ]; then mkdir -p $DIRSUPAGRCAN;     fi
if [ ! -d $DIRSUPINDCAN  ]; then mkdir -p $DIRSUPINDCAN;     fi
if [ ! -d $DIRSUPDOMCAN  ]; then mkdir -p $DIRSUPDOMCAN;     fi
if [ ! -d $DIRSUPAGRRGW  ]; then mkdir -p $DIRSUPAGRRGW;     fi
if [ ! -d $DIRSUPINDRGW  ]; then mkdir -p $DIRSUPINDRGW;     fi
if [ ! -d $DIRSUPDOMRGW  ]; then mkdir -p $DIRSUPDOMRGW;     fi
if [ ! -d $DIRSUPAGRMSR  ]; then mkdir -p $DIRSUPAGRMSR;     fi
if [ ! -d $DIRSUPINDMSR  ]; then mkdir -p $DIRSUPINDMSR;     fi
if [ ! -d $DIRSUPDOMMSR  ]; then mkdir -p $DIRSUPDOMMSR;     fi
if [ ! -d $DIRSUPAGRNNBS ]; then mkdir -p $DIRSUPAGRNNBS;    fi
if [ ! -d $DIRSUPINDNNBS ]; then mkdir -p $DIRSUPINDNNBS;    fi
if [ ! -d $DIRSUPDOMNNBS ]; then mkdir -p $DIRSUPDOMNNBS;    fi
if [ ! -d $DIRSUPAGRNNBG ]; then mkdir -p $DIRSUPAGRNNBG;    fi
if [ ! -d $DIRSUPINDNNBG ]; then mkdir -p $DIRSUPINDNNBG;    fi
if [ ! -d $DIRSUPDOMNNBG ]; then mkdir -p $DIRSUPDOMNNBG;    fi
if [ ! -d $DIRSUPAGRDES  ]; then mkdir -p $DIRSUPAGRDES;     fi
if [ ! -d $DIRSUPINDDES  ]; then mkdir -p $DIRSUPINDDES;     fi
if [ ! -d $DIRSUPDOMDES  ]; then mkdir -p $DIRSUPDOMDES;     fi
if [ ! -d $DIRSUPAGRRCL  ]; then mkdir -p $DIRSUPAGRRCL;     fi
if [ ! -d $DIRSUPINDRCL  ]; then mkdir -p $DIRSUPINDRCL;     fi
if [ ! -d $DIRSUPDOMRCL  ]; then mkdir -p $DIRSUPDOMRCL;     fi
if [ ! -d $DIRSUPAGRDEF  ]; then mkdir -p $DIRSUPAGRDEF;     fi
if [ ! -d $DIRSUPINDDEF  ]; then mkdir -p $DIRSUPINDDEF;     fi
if [ ! -d $DIRSUPDOMDEF  ]; then mkdir -p $DIRSUPDOMDEF;     fi
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d $DIRFRCSOILMOISTGRN0  ]; then mkdir -p $DIRFRCSOILMOISTGRN0; fi
if [ ! -d $DIRFRCSOILMOISTRIV0  ]; then mkdir -p $DIRFRCSOILMOISTRIV0; fi
if [ ! -d $DIRFRCSOILMOISTMSR0  ]; then mkdir -p $DIRFRCSOILMOISTMSR0; fi
if [ ! -d $DIRFRCSOILMOISTNNB0  ]; then mkdir -p $DIRFRCSOILMOISTNNB0; fi
if [ ! -d $DIRFRCSOILMOISTGRN1  ]; then mkdir -p $DIRFRCSOILMOISTGRN1; fi
if [ ! -d $DIRFRCSOILMOISTRIV1  ]; then mkdir -p $DIRFRCSOILMOISTRIV1; fi
if [ ! -d $DIRFRCSOILMOISTMSR1  ]; then mkdir -p $DIRFRCSOILMOISTMSR1; fi
if [ ! -d $DIRFRCSOILMOISTNNB1  ]; then mkdir -p $DIRFRCSOILMOISTNNB1; fi
if [ ! -d $DIRFRCSOILMOISTGRN2  ]; then mkdir -p $DIRFRCSOILMOISTGRN2; fi
if [ ! -d $DIRFRCSOILMOISTRIV2  ]; then mkdir -p $DIRFRCSOILMOISTRIV2; fi
if [ ! -d $DIRFRCSOILMOISTMSR2  ]; then mkdir -p $DIRFRCSOILMOISTMSR2; fi
if [ ! -d $DIRFRCSOILMOISTNNB2  ]; then mkdir -p $DIRFRCSOILMOISTNNB2; fi
if [ ! -d $DIRFRCSOILMOISTGRN3  ]; then mkdir -p $DIRFRCSOILMOISTGRN3; fi
if [ ! -d $DIRFRCSOILMOISTRIV3  ]; then mkdir -p $DIRFRCSOILMOISTRIV3; fi
if [ ! -d $DIRFRCSOILMOISTMSR3  ]; then mkdir -p $DIRFRCSOILMOISTMSR3; fi
if [ ! -d $DIRFRCSOILMOISTNNB3  ]; then mkdir -p $DIRFRCSOILMOISTNNB3; fi
if [ ! -d $DIRFRCSOILMOISTGRN4  ]; then mkdir -p $DIRFRCSOILMOISTGRN4; fi
if [ ! -d $DIRFRCSOILMOISTRIV4  ]; then mkdir -p $DIRFRCSOILMOISTRIV4; fi
if [ ! -d $DIRFRCSOILMOISTMSR4  ]; then mkdir -p $DIRFRCSOILMOISTMSR4; fi
if [ ! -d $DIRFRCSOILMOISTNNB4  ]; then mkdir -p $DIRFRCSOILMOISTNNB4; fi
# 20200710
if [ ! -d $DIRFRCSOILMOISTGRN5  ]; then mkdir -p $DIRFRCSOILMOISTGRN5; fi
if [ ! -d $DIRFRCSOILMOISTRIV5  ]; then mkdir -p $DIRFRCSOILMOISTRIV5; fi
if [ ! -d $DIRFRCSOILMOISTMSR5  ]; then mkdir -p $DIRFRCSOILMOISTMSR5; fi
if [ ! -d $DIRFRCSOILMOISTNNB5  ]; then mkdir -p $DIRFRCSOILMOISTNNB5; fi

if [ ! -d $DIREVAPGRN0  ]; then mkdir -p $DIREVAPGRN0; fi
if [ ! -d $DIREVAPBLU0  ]; then mkdir -p $DIREVAPBLU0; fi
if [ ! -d $DIREVAPGRN1  ]; then mkdir -p $DIREVAPGRN1; fi
if [ ! -d $DIREVAPBLU1  ]; then mkdir -p $DIREVAPBLU1; fi
if [ ! -d $DIREVAPGRN2  ]; then mkdir -p $DIREVAPGRN2; fi
if [ ! -d $DIREVAPBLU2  ]; then mkdir -p $DIREVAPBLU2; fi
if [ ! -d $DIREVAPGRN3  ]; then mkdir -p $DIREVAPGRN3; fi
if [ ! -d $DIREVAPBLU3  ]; then mkdir -p $DIREVAPBLU3; fi
if [ ! -d $DIREVAPGRN4  ]; then mkdir -p $DIREVAPGRN4; fi
if [ ! -d $DIREVAPBLU4  ]; then mkdir -p $DIREVAPBLU4; fi
# 20200710
if [ ! -d $DIREVAPGRN5  ]; then mkdir -p $DIREVAPGRN5; fi
if [ ! -d $DIREVAPBLU5  ]; then mkdir -p $DIREVAPBLU5; fi
############################################################
# Job (Making Log file)
############################################################
DATE=`date +"%Y%m%d"`
DIRLOG=../../lnd/log
if [ ! -d $DIRLOG ]; then
  mkdir -p $DIRLOG
fi
LOGFILE=${DIRLOG}/${PRJ}${RUN}${DATE}.log
############################################################
# Job (Making SET file (lnd))
############################################################
DIRSET=../../lnd/set
if [ ! -d $DIRSET ]; then
  mkdir -p $DIRSET
fi
SETLND=${DIRSET}/${PRJ}${RUN}${DATE}.set
#
if [ -f $SETLND ]; then
  rm $SETLND
fi
#
cat <<EOF>> $SETLND
&setlnd
i0yearmin=$YEARMIN
i0yearmax=$YEARMAX
i0secint=$SECINT
i0ldbg=$LDBG
i0cntc=$CNTC
i0spnflg=$SPNFLG
r0spnerr=$SPNERR
r0spnrat=$SPNRAT
r0engbalc=$ENGBALC
r0watbalc=$WATBALC
c0lndmsk='$LNDMSK'
c0soildepth='$SOILDEPTH'
c0w_fieldcap='$FIELDCAP'
c0w_wilt='$WILT'
c0cg='$CG'
c0cd='$CD'
c0gamma='$GAMMA'
c0tau='$TAU'
c0balbedo='$BALBEDO'
c0rgwdepth='$GWDEPTH'
c0w_rgwyield='$GWYIELD'
c0rgwgamma='$GWGAMMA'
c0rgwtau='$GWTAU'
c0rgwrcf='$GWRCF'
c0rgwrcmax='$GWRCMAX'

c0wind='$WIND'
c0rainf='$RAINF'
c0snowf='$SNOWF'
c0tair='$TAIR'
c0qair='$QAIR'
c0rh='$RH'
c0psurf='$PSURF'
c0swdown='$SWDOWN'
c0lwdown='$LWDOWN'
c1soilmoist(0)='$SOILMOIST0'
c1soiltemp(0)='$SOILTEMP0'
c1avgsurft(0)='$AVGSURFT0'
c1swe(0)='$SWE0'
c1swnet(0)='$SWNET0'
c1lwnet(0)='$LWNET0'
c1qle(0)='$QLE0'
c1qh(0)='$QH0'
c1qg(0)='$QG0'
c1qf(0)='$QF0'
c1qv(0)='$QV0'
c1evap(0)='$EVAP0'
c1qs(0)='$QS0'
c1qsb(0)='$QSB0'
c1qtot(0)='$QTOT0'
c1qsm(0)='$QSM0'
c1qst(0)='$QST0'
c1albedo(0)='$ALBEDO0'
c1soilwet(0)='$SOILWET0'
c1potevap(0)='$POTEVAP0'
c1et(0)='$ET0'
c1subsnow(0)='$SUBSNOW0'
c1salbedo(0)='$SALBEDO0'
c1rgw(0)='$GW0'
c1qbf(0)='$QBF0'
c1qrc(0)='$QRC0'
c1soilmoist(1)='$SOILMOIST1'
c1soiltemp(1)='$SOILTEMP1'
c1avgsurft(1)='$AVGSURFT1'
c1swe(1)='$SWE1'
c1swnet(1)='$SWNET1'
c1lwnet(1)='$LWNET1'
c1qle(1)='$QLE1'
c1qh(1)='$QH1'
c1qg(1)='$QG1'
c1qf(1)='$QF1'
c1qv(1)='$QV1'
c1evap(1)='$EVAP1'
c1qs(1)='$QS1'
c1qsb(1)='$QSB1'
c1qtot(1)='$QTOT1'
c1qsm(1)='$QSM1'
c1qst(1)='$QST1'
c1albedo(1)='$ALBEDO1'
c1soilwet(1)='$SOILWET1'
c1potevap(1)='$POTEVAP1'
c1et(1)='$ET1'
c1subsnow(1)='$SUBSNOW1'
c1salbedo(1)='$SALBEDO1'
c1rgw(1)='$GW1'
c1qbf(1)='$QBF1'
c1qrc(1)='$QRC1'
c1soilmoistini(0)='$SOILMOISTINI0'
c1soiltempini(0)='$SOILTEMPINI0'
c1avgsurftini(0)='$AVGSURFTINI0'
c1sweini(0)='$SWEINI0'
c1rgwini(0)='$GWINI0'
c1soilmoistini(1)='$SOILMOISTINI1'
c1soiltempini(1)='$SOILTEMPINI1'
c1avgsurftini(1)='$AVGSURFTINI1'
c1sweini(1)='$SWEINI1'
c1rgwini(1)='$GWINI1'
c0tcor='$TCOR'
c0pcor='$PCOR'
c0lcor='$LCOR'
c0tairout='$TAIROUT'
c0rainfout='$RAINFOUT'
c0snowfout='$SNOWFOUT'
c0lwdownout='$LWDOWNOUT'
EOF

if [ $NOFMOS -ge 2 ]; then
  cat <<EOF>> $SETLND
c1soilmoist(2)='$SOILMOIST2'
c1soiltemp(2)='$SOILTEMP2'
c1avgsurft(2)='$AVGSURFT2'
c1swe(2)='$SWE2'
c1swnet(2)='$SWNET2'
c1lwnet(2)='$LWNET2'
c1qle(2)='$QLE2'
c1qh(2)='$QH2'
c1qg(2)='$QG2'
c1qf(2)='$QF2'
c1qv(2)='$QV2'
c1evap(2)='$EVAP2'
c1qs(2)='$QS2'
c1qsb(2)='$QSB2'
c1qtot(2)='$QTOT2'
c1qsm(2)='$QSM2'
c1qst(2)='$QST2'
c1albedo(2)='$ALBEDO2'
c1soilwet(2)='$SOILWET2'
c1potevap(2)='$POTEVAP2'
c1et(2)='$ET2'
c1subsnow(2)='$SUBSNOW2'
c1salbedo(2)='$SALBEDO2'
c1rgw(2)='$GW2'
c1qbf(2)='$QBF2'
c1qrc(2)='$QRC2'
c1soilmoistini(2)='$SOILMOISTINI2'
c1soiltempini(2)='$SOILTEMPINI2'
c1avgsurftini(2)='$AVGSURFTINI2'
c1sweini(2)='$SWEINI2'
c1rgwini(2)='$GWINI2'
EOF
fi

if [ $NOFMOS -ge 3 ]; then
  cat <<EOF>> $SETLND
c1soilmoist(3)='$SOILMOIST3'
c1soiltemp(3)='$SOILTEMP3'
c1avgsurft(3)='$AVGSURFT3'
c1swe(3)='$SWE3'
c1swnet(3)='$SWNET3'
c1lwnet(3)='$LWNET3'
c1qle(3)='$QLE3'
c1qh(3)='$QH3'
c1qg(3)='$QG3'
c1qf(3)='$QF3'
c1qv(3)='$QV3'
c1evap(3)='$EVAP3'
c1qs(3)='$QS3'
c1qsb(3)='$QSB3'
c1qtot(3)='$QTOT3'
c1qsm(3)='$QSM3'
c1qst(3)='$QST3'
c1albedo(3)='$ALBEDO3'
c1soilwet(3)='$SOILWET3'
c1potevap(3)='$POTEVAP3'
c1et(3)='$ET3'
c1subsnow(3)='$SUBSNOW3'
c1salbedo(3)='$SALBEDO3'
c1rgw(3)='$GW3'
c1qbf(3)='$QBF3'
c1qrc(3)='$QRC3'
c1soiltempini(3)='$SOILTEMPINI3'
c1soilmoistini(3)='$SOILMOISTINI3'
c1avgsurftini(3)='$AVGSURFTINI3'
c1sweini(3)='$SWEINI3'
c1rgwini(3)='$GWINI3'
EOF
fi

if [ $NOFMOS -ge 4 ]; then
  cat <<EOF>> $SETLND
c1soilmoist(4)='$SOILMOIST4'
c1soiltemp(4)='$SOILTEMP4'
c1avgsurft(4)='$AVGSURFT4'
c1swe(4)='$SWE4'
c1swnet(4)='$SWNET4'
c1lwnet(4)='$LWNET4'
c1qle(4)='$QLE4'
c1qh(4)='$QH4'
c1qg(4)='$QG4'
c1qf(4)='$QF4'
c1qv(4)='$QV4'
c1evap(4)='$EVAP4'
c1qs(4)='$QS4'
c1qsb(4)='$QSB4'
c1qtot(4)='$QTOT4'
c1qsm(4)='$QSM4'
c1qst(4)='$QST4'
c1albedo(4)='$ALBEDO4'
c1soilwet(4)='$SOILWET4'
c1potevap(4)='$POTEVAP4'
c1et(4)='$ET4'
c1subsnow(4)='$SUBSNOW4'
c1salbedo(4)='$SALBEDO4'
c1rgw(4)='$GW4'
c1qbf(4)='$QBF4'
c1qrc(4)='$QRC4'
c1soiltempini(4)='$SOILTEMPINI4'
c1soilmoistini(4)='$SOILMOISTINI4'
c1avgsurftini(4)='$AVGSURFTINI4'
c1sweini(4)='$SWEINI4'
c1rgwini(4)='$GWINI4'
EOF
fi

if [ $NOFMOS -ge 5 ]; then
  cat <<EOF>> $SETLND
c1soilmoist(5)='$SOILMOIST5'
c1soiltemp(5)='$SOILTEMP5'
c1avgsurft(5)='$AVGSURFT5'
c1swe(5)='$SWE5'
c1swnet(5)='$SWNET5'
c1lwnet(5)='$LWNET5'
c1qle(5)='$QLE5'
c1qh(5)='$QH5'
c1qg(5)='$QG5'
c1qf(5)='$QF5'
c1qv(5)='$QV5'
c1evap(5)='$EVAP5'
c1qs(5)='$QS5'
c1qsb(5)='$QSB5'
c1qtot(5)='$QTOT5'
c1qsm(5)='$QSM5'
c1qst(5)='$QST5'
c1albedo(5)='$ALBEDO5'
c1soilwet(5)='$SOILWET5'
c1potevap(5)='$POTEVAP5'
c1et(5)='$ET5'
c1subsnow(5)='$SUBSNOW5'
c1salbedo(5)='$SALBEDO5'
c1rgw(5)='$GW5'
c1qbf(5)='$QBF5'
c1qrc(5)='$QRC5'
c1soiltempini(5)='$SOILTEMPINI5'
c1soilmoistini(5)='$SOILMOISTINI5'
c1avgsurftini(5)='$AVGSURFTINI5'
c1sweini(5)='$SWEINI5'
c1rgwini(5)='$GWINI5'
EOF
fi

cat <<EOF>> $SETLND
&end
EOF
############################################################
# Making SET file (riv)
############################################################
DIRSET=../../riv/set
if [ ! -d $DIRSET ]; then
  mkdir -p $DIRSET
fi
SETRIV=${DIRSET}/${PRJ}${RUN}${DATE}.set
if [ -f $SETRIV ]; then
  rm $SETRIV
fi
cat << EOF >> $SETRIV
&setriv
i0yearmin=$YEARMIN
i0yearmax=$YEARMAX
i0ldbg=$LDBG
i0secint=$SECINT
c0qtot='$QTOT'
c0rivsto='$RIVSTO'
c0dis='$DIS'
c0rivstoini='$RIVSTOINI'
c0rivseq='$RIVSEQ'
c0rivnxl='$RIVNXL'
c0rivnxd='$RIVNXD'
c0lndara='$LNDARA'
c0flwvel='$FLWVEL'
c0medrat='$MEDRAT'
i0spnflg=$SPNFLG
r0spnerr=$SPNERR
r0spnrat=$SPNRAT
&end
EOF
############################################################
# Making SET file (human)
# 20200717 sethum c0factor~c0rlsdoy
############################################################
DIRSET=../../dam/set
if [ ! -d $DIRSET ]; then
  mkdir -p $DIRSET
fi
SETHUM=${DIRSET}/${PRJ}${RUN}${DATE}.set
if [ -f $SETHUM ]; then
  rm $SETHUM
fi
cat << EOF >> $SETHUM
&sethum
c0factor='$FACTOR'
c0minsto='$MINSTO'
c0mindoy='$MINDOY'
c0maxsto='$MAXSTO'
c0maxdoy='$MAXDOY'
c0rlsrls='$RLSRLS'
c0rlsdoy='$RLSDOY'

r0knorm=$KNORM
c0optkrls='$OPTKRLS'
c0optdamrls='$OPTDAMRLS'
c0optdamwbc='$OPTDAMWBC'
c0optnnb='$OPTNNB'
c0opthvsdoy='$OPTHVSDOY'
c0damid_='$DAMID_'
c0damprp='$DAMPRP'
c01stmon='$DAMMON1ST'
c0damcap='$DAMCAP'
c0msrcap='$MSRCAP'
c0msrafc='$MSRAFC'
c0demagrfix='$DAMDEMAGRFIX'
c0demind='$DEMIND'
c0demdom='$DEMDOM'
c0frcgwagr='$FRCGWAGR'
c0frcgwind='$FRCGWIND'
c0frcgwdom='$FRCGWDOM'
c0envflw='$ENVFLW'
c0rivoutfix='$DAMRIVOUTFIX'
c0damsrf='$DAMSRF'
c0damalc='$DAMALC'
c0damsto='$DAMSTO'
c0msrsto='$MSRSTO'
c0damstoini='$DAMSTOINI'
c0msrstoini='$MSRSTOINI'
c0daminf='$DAMINF'
c0damout='$DAMOUT'
c0damdem='$DAMDEM'
c0msrinf='$MSRINF'
c0msrout='$MSROUT'
c0supind='$SUPIND'
c0supdom='$SUPDOM'
c0supagrriv='$SUPAGRRIV'
c0supindriv='$SUPINDRIV'
c0supdomriv='$SUPDOMRIV'
c0supagrcan='$SUPAGRCAN'
c0supindcan='$SUPINDCAN'
c0supdomcan='$SUPDOMCAN'
c0supagrrgw='$SUPAGRRGW'
c0supindrgw='$SUPINDRGW'
c0supdomrgw='$SUPDOMRGW'
c0supagrmsr='$SUPAGRMSR'
c0supindmsr='$SUPINDMSR'
c0supdommsr='$SUPDOMMSR'
c0supagrnnbs='$SUPAGRNNBS'
c0supindnnbs='$SUPINDNNBS'
c0supdomnnbs='$SUPDOMNNBS'
c0supagrnnbg='$SUPAGRNNBG'
c0supindnnbg='$SUPINDNNBG'
c0supdomnnbg='$SUPDOMNNBG'
c0supagrdes='$SUPAGRDES'
c0supinddes='$SUPINDDES'
c0supdomdes='$SUPDOMDES'
c0supagrrcl='$SUPAGRRCL'
c0supindrcl='$SUPINDRCL'
c0supdomrcl='$SUPDOMRCL'
c0supagrdef='$SUPAGRDEF'
c0supinddef='$SUPINDDEF'
c0supdomdef='$SUPDOMDEF'
c0losagr='$LOSAGR'
c0rtfagr='$RTFAGR'
c0rtfind='$RTFIND'
c0rtfdom='$RTFDOM'

i0dayadvirg=$DAYADVIRG
r0fctpad=$FCTPAD
r0fctnonpad=$FCTNONPAD

c1pltdoyf(1)='$PLTDOYF1'
c1pltdoyf(2)='$PLTDOYF2'
c1hvsdoyf(1)='$HVSDOYF1'
c1hvsdoyf(2)='$HVSDOYF2'
c1crptypf(1)='$CRPTYPF1'
c1crptypf(2)='$CRPTYPF2'

c1pltdoyp(1)='$PLTDOYP1'
c1pltdoyp(2)='$PLTDOYP2'
c1hvsdoyp(1)='$HVSDOYP1'
c1hvsdoyp(2)='$HVSDOYP2'
c1crptypp(1)='$CRPTYPP1'
c1crptypp(2)='$CRPTYPP2'

c0lcan='$LCAN'
c0despot='$DESPOT'
c0rclpot='$RCLPOT'
c0irgeffs='$IRGEFFS'
c0irgeffg='$IRGEFFG'
c0irglos='$IRGLOS'
c0indeff='$INDEFF'
c0domeff='$DOMEFF'

c0lndara='$LNDARA'
c0supagr='$SUPAGR'
c1demagr(0)='$DEMAGR0'

c0optriv='$OPTRIV'
c0optrgw='$OPTRGW'
c0optdes='$OPTDES'
c0optrcl='$OPTRCL'

c1demagr(1)='$DEMAGR1'
c1arafrc(1)='$ARAFRC1'
c1optlnduse(1)='$OPTLNDUSE1'



c1frcsoilmoistgrn(0)='$FRCSOILMOISTGRN0'
c1frcsoilmoistriv(0)='$FRCSOILMOISTRIV0'
c1frcsoilmoistmsr(0)='$FRCSOILMOISTMSR0'
c1frcsoilmoistnnb(0)='$FRCSOILMOISTNNB0'
c1evapgrn(0)='$EVAPGRN0'
c1evapblu(0)='$EVAPBLU0'
c1frcsoilmoistgrn(1)='$FRCSOILMOISTGRN1'
c1frcsoilmoistriv(1)='$FRCSOILMOISTRIV1'
c1frcsoilmoistmsr(1)='$FRCSOILMOISTMSR1'
c1frcsoilmoistnnb(1)='$FRCSOILMOISTNNB1'
c1evapgrn(1)='$EVAPGRN1'
c1evapblu(1)='$EVAPBLU1'
EOF

if [ $NOFMOS -ge 2 ]; then
  cat <<EOF>> $SETHUM
c1demagr(2)='$DEMAGR2'
c1arafrc(2)='$ARAFRC2'
c1optlnduse(2)='$OPTLNDUSE2'

c1frcsoilmoistgrn(2)='$FRCSOILMOISTGRN2'
c1frcsoilmoistriv(2)='$FRCSOILMOISTRIV2'
c1frcsoilmoistmsr(2)='$FRCSOILMOISTMSR2'
c1frcsoilmoistnnb(2)='$FRCSOILMOISTNNB2'
c1evapgrn(2)='$EVAPGRN2'
c1evapblu(2)='$EVAPBLU2'
EOF
fi

if [ $NOFMOS -ge 3 ]; then
  cat <<EOF>> $SETHUM
c1demagr(3)='$DEMAGR3'
c1arafrc(3)='$ARAFRC3'
c1optlnduse(3)='$OPTLNDUSE3'

c1frcsoilmoistgrn(3)='$FRCSOILMOISTGRN3'
c1frcsoilmoistriv(3)='$FRCSOILMOISTRIV3'
c1frcsoilmoistmsr(3)='$FRCSOILMOISTMSR3'
c1frcsoilmoistnnb(3)='$FRCSOILMOISTNNB3'
c1evapgrn(3)='$EVAPGRN3'
c1evapblu(3)='$EVAPBLU3'
EOF
fi

if [ $NOFMOS -ge 4 ]; then
  cat <<EOF>> $SETHUM
c1demagr(4)='$DEMAGR4'
c1arafrc(4)='$ARAFRC4'
c1optlnduse(4)='$OPTLNDUSE4'

c1frcsoilmoistgrn(4)='$FRCSOILMOISTGRN4'
c1frcsoilmoistriv(4)='$FRCSOILMOISTRIV4'
c1frcsoilmoistmsr(4)='$FRCSOILMOISTMSR4'
c1frcsoilmoistnnb(4)='$FRCSOILMOISTNNB4'
c1evapgrn(4)='$EVAPGRN4'
c1evapblu(4)='$EVAPBLU4'
EOF
fi

if [ $NOFMOS -ge 5 ]; then
  cat <<EOF>> $SETHUM
c1demagr(5)='$DEMAGR5'
c1arafrc(5)='$ARAFRC5'
c1optlnduse(5)='$OPTLNDUSE5'

c1frcsoilmoistgrn(5)='$FRCSOILMOISTGRN5'
c1frcsoilmoistriv(5)='$FRCSOILMOISTRIV5'
c1frcsoilmoistmsr(5)='$FRCSOILMOISTMSR5'
c1frcsoilmoistnnb(5)='$FRCSOILMOISTNNB5'
c1evapgrn(5)='$EVAPGRN5'
c1evapblu(5)='$EVAPBLU5'
EOF
fi

cat <<EOF>> $SETHUM
c0krls='$KRLS'
&end
EOF
############################################################
# Making SET file (human)
############################################################
DIRSET=../../crp/set
if [ ! -d $DIRSET ]; then
  mkdir -p $DIRSET
fi
SETCRP=${DIRSET}/${PRJ}${RUN}${DATE}.set
if [ -f $SETCRP ]; then
  rm $SETCRP
fi
cat << EOF >> $SETCRP
&setcrp
i0crpdaymax=$INTCRPDAYMAX
r0regfmin=$REGFMIN
r0tdorm=$TDORM
r0tfrz=$TFRZ
r0hunmax=$HUNMAX
r0ihunmat=$IHUNMAT
r0tsaw=$TSAW
r0thvs=$THVS
c0optts='$OPTTS'
c0optws='$OPTWS'
c0optns='$OPTNS'
c0optps='$OPTPS'
c0optfrz='$OPTFRZ'
c0ram2swim='$RAM2SWIM'
c0swim2ram='$SWIM2RAM'
c0crppar='$CRPPAR'

c1hunaini(0)='$HUNAINI0'
c1swuini(0)='$SWUINI0'
c1swpini(0)='$SWPINI0'
c1regfwini(0)='$REGFWINI0'
c1regflini(0)='$REGFLINI0'
c1regfhini(0)='$REGFHINI0'
c1regfnini(0)='$REGFNINI0'
c1regfpini(0)='$REGFPINI0'
c1btini(0)='$BTINI0'
c1rsdini(0)='$RSDINI0'
c1outbini(0)='$OUTBINI0'
c1yldout1st(0)='$YLDOUT1ST0'
c1cwdout1st(0)='$CWDOUT1ST0'
c1cwsout1st(0)='$CWSOUT1ST0'
c1regfdout1st(0)='$REGFDOUT1ST0'
c1hvsdoyout1st(0)='$HVSDOYOUT1ST0'
c1crpdayout1st(0)='$CRPDAYOUT1ST0'
c1yldout2nd(0)='$YLDOUT2ND0'
c1cwdout2nd(0)='$CWDOUT2ND0'
c1cwsout2nd(0)='$CWSOUT2ND0'
c1regfdout2nd(0)='$REGFDOUT2ND0'
c1hvsdoyout2nd(0)='$HVSDOYOUT2ND0'
c1crpdayout2nd(0)='$CRPDAYOUT2ND0'
c1cwsout1stgrn(0)='$CWSOUT1STGRN0'
c1cwsout2ndgrn(0)='$CWSOUT2NDGRN0'
c1cwsout1stblu(0)='$CWSOUT1STBLU0'
c1cwsout2ndblu(0)='$CWSOUT2NDBLU0'

c1hunaini(1)='$HUNAINI1'
c1swuini(1)='$SWUINI1'
c1swpini(1)='$SWPINI1'
c1regfwini(1)='$REGFWINI1'
c1regflini(1)='$REGFLINI1'
c1regfhini(1)='$REGFHINI1'
c1regfnini(1)='$REGFNINI1'
c1regfpini(1)='$REGFPINI1'
c1btini(1)='$BTINI1'
c1rsdini(1)='$RSDINI1'
c1outbini(1)='$OUTBINI1'
c1yldout1st(1)='$YLDOUT1ST1'
c1cwdout1st(1)='$CWDOUT1ST1'
c1cwsout1st(1)='$CWSOUT1ST1'
c1regfdout1st(1)='$REGFDOUT1ST1'
c1hvsdoyout1st(1)='$HVSDOYOUT1ST1'
c1crpdayout1st(1)='$CRPDAYOUT1ST1'
c1yldout2nd(1)='$YLDOUT2ND1'
c1cwdout2nd(1)='$CWDOUT2ND1'
c1cwsout2nd(1)='$CWSOUT2ND1'
c1regfdout2nd(1)='$REGFDOUT2ND1'
c1hvsdoyout2nd(1)='$HVSDOYOUT2ND1'
c1crpdayout2nd(1)='$CRPDAYOUT2ND1'
c1cwsout1stgrn(1)='$CWSOUT1STGRN1'
c1cwsout2ndgrn(1)='$CWSOUT2NDGRN1'
c1cwsout1stblu(1)='$CWSOUT1STBLU1'
c1cwsout2ndblu(1)='$CWSOUT2NDBLU1'
EOF

if [ $NOFMOS -ge 2 ]; then
  cat <<EOF>> $SETCRP
c1hunaini(2)='$HUNAINI2'
c1swuini(2)='$SWUINI2'
c1swpini(2)='$SWPINI2'
c1regfwini(2)='$REGFWINI2'
c1regflini(2)='$REGFLINI2'
c1regfhini(2)='$REGFHINI2'
c1regfnini(2)='$REGFNINI2'
c1regfpini(2)='$REGFPINI2'
c1btini(2)='$BTINI2'
c1rsdini(2)='$RSDINI2'
c1outbini(2)='$OUTBINI2'
c1yldout1st(2)='$YLDOUT1ST2'
c1cwdout1st(2)='$CWDOUT1ST2'
c1cwsout1st(2)='$CWSOUT1ST2'
c1regfdout1st(2)='$REGFDOUT1ST2'
c1hvsdoyout1st(2)='$HVSDOYOUT1ST2'
c1crpdayout1st(2)='$CRPDAYOUT1ST2'
c1yldout2nd(2)='$YLDOUT2ND2'
c1cwdout2nd(2)='$CWDOUT2ND2'
c1cwsout2nd(2)='$CWSOUT2ND2'
c1regfdout2nd(2)='$REGFDOUT2ND2'
c1hvsdoyout2nd(2)='$HVSDOYOUT2ND2'
c1crpdayout2nd(2)='$CRPDAYOUT2ND2'
c1cwsout1stgrn(2)='$CWSOUT1STGRN2'
c1cwsout2ndgrn(2)='$CWSOUT2NDGRN2'
c1cwsout1stblu(2)='$CWSOUT1STBLU2'
c1cwsout2ndblu(2)='$CWSOUT2NDBLU2'
EOF
fi

if [ $NOFMOS -ge 3 ]; then
  cat <<EOF>> $SETCRP
c1hunaini(3)='$HUNAINI3'
c1swuini(3)='$SWUINI3'
c1swpini(3)='$SWPINI3'
c1regfwini(3)='$REGFWINI3'
c1regflini(3)='$REGFLINI3'
c1regfhini(3)='$REGFHINI3'
c1regfnini(3)='$REGFNINI3'
c1regfpini(3)='$REGFPINI3'
c1btini(3)='$BTINI3'
c1rsdini(3)='$RSDINI3'
c1outbini(3)='$OUTBINI3'
c1yldout1st(3)='$YLDOUT1ST3'
c1cwdout1st(3)='$CWDOUT1ST3'
c1cwsout1st(3)='$CWSOUT1ST3'
c1regfdout1st(3)='$REGFDOUT1ST3'
c1hvsdoyout1st(3)='$HVSDOYOUT1ST3'
c1crpdayout1st(3)='$CRPDAYOUT1ST3'
c1yldout2nd(3)='$YLDOUT2ND3'
c1cwdout2nd(3)='$CWDOUT2ND3'
c1cwsout2nd(3)='$CWSOUT2ND3'
c1regfdout2nd(3)='$REGFDOUT2ND3'
c1hvsdoyout2nd(3)='$HVSDOYOUT2ND3'
c1crpdayout2nd(3)='$CRPDAYOUT2ND3'
c1cwsout1stgrn(3)='$CWSOUT1STGRN3'
c1cwsout2ndgrn(3)='$CWSOUT2NDGRN3'
c1cwsout1stblu(3)='$CWSOUT1STBLU3'
c1cwsout2ndblu(3)='$CWSOUT2NDBLU3'
EOF
fi

if [ $NOFMOS -ge 4 ]; then
  cat <<EOF>> $SETCRP
c1hunaini(4)='$HUNAINI4'
c1swuini(4)='$SWUINI4'
c1swpini(4)='$SWPINI4'
c1regfwini(4)='$REGFWINI4'
c1regflini(4)='$REGFLINI4'
c1regfhini(4)='$REGFHINI4'
c1regfnini(4)='$REGFNINI4'
c1regfpini(4)='$REGFPINI4'
c1btini(4)='$BTINI4'
c1rsdini(4)='$RSDINI4'
c1outbini(4)='$OUTBINI4'
c1yldout1st(4)='$YLDOUT1ST4'
c1cwdout1st(4)='$CWDOUT1ST4'
c1cwsout1st(4)='$CWSOUT1ST4'
c1regfdout1st(4)='$REGFDOUT1ST4'
c1hvsdoyout1st(4)='$HVSDOYOUT1ST4'
c1crpdayout1st(4)='$CRPDAYOUT1ST4'
c1yldout2nd(4)='$YLDOUT2ND4'
c1cwdout2nd(4)='$CWDOUT2ND4'
c1cwsout2nd(4)='$CWSOUT2ND4'
c1regfdout2nd(4)='$REGFDOUT2ND4'
c1hvsdoyout2nd(4)='$HVSDOYOUT2ND4'
c1crpdayout2nd(4)='$CRPDAYOUT2ND4'
c1cwsout1stgrn(4)='$CWSOUT1STGRN4'
c1cwsout2ndgrn(4)='$CWSOUT2NDGRN4'
c1cwsout1stblu(4)='$CWSOUT1STBLU4'
c1cwsout2ndblu(4)='$CWSOUT2NDBLU4'
EOF
fi

if [ $NOFMOS -ge 5 ]; then
  cat <<EOF>> $SETCRP
c1hunaini(5)='$HUNAINI5'
c1swuini(5)='$SWUINI5'
c1swpini(5)='$SWPINI5'
c1regfwini(5)='$REGFWINI5'
c1regflini(5)='$REGFLINI5'
c1regfhini(5)='$REGFHINI5'
c1regfnini(5)='$REGFNINI5'
c1regfpini(5)='$REGFPINI5'
c1btini(5)='$BTINI5'
c1rsdini(5)='$RSDINI5'
c1outbini(5)='$OUTBINI5'
c1yldout1st(5)='$YLDOUT1ST5'
c1cwdout1st(5)='$CWDOUT1ST5'
c1cwsout1st(5)='$CWSOUT1ST5'
c1regfdout1st(5)='$REGFDOUT1ST5'
c1hvsdoyout1st(5)='$HVSDOYOUT1ST5'
c1crpdayout1st(5)='$CRPDAYOUT1ST5'
c1yldout2nd(5)='$YLDOUT2ND5'
c1cwdout2nd(5)='$CWDOUT2ND5'
c1cwsout2nd(5)='$CWSOUT2ND5'
c1regfdout2nd(5)='$REGFDOUT2ND5'
c1hvsdoyout2nd(5)='$HVSDOYOUT2ND5'
c1crpdayout2nd(5)='$CRPDAYOUT2ND5'
c1cwsout1stgrn(5)='$CWSOUT1STGRN5'
c1cwsout2ndgrn(5)='$CWSOUT2NDGRN5'
c1cwsout1stblu(5)='$CWSOUT1STBLU5'
c1cwsout2ndblu(5)='$CWSOUT2NDBLU5'
EOF
fi

cat <<EOF>> $SETCRP
&end
EOF
############################################################
# Start 
############################################################
echo "$PROG $SETLND $SETRIV $SETHUM $SETCRP > $LOGFILE 2>&1 &"
      $PROG $SETLND $SETRIV $SETHUM $SETCRP > $LOGFILE 2>&1 &
echo "$PROG: See [$LOGFILE] to check the execusion. For example by,"
echo "% tail -f $LOGFILE"
