#!/bin/sh
############################################################
#to   prepare crop calendar calculation
#by   2010/03/31, hanasaki, NIES: H08 ver1.0
############################################################
# Basic settings (Edit here if you change settings)
############################################################
PRJ=WFDE             # Project name
RUN=__C_             # Run name
#PRJ=AK10
#RUN=LR__
#RUN=__C_
YEAR=0000            # Year
MON=00               # Month
DAY=00               # Day
MARGIN=15            # Margins between croppings [day]
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200              
SUF=.hlf             

#L=11088      # for Korean peninsula 2018
#SUF=.ko5

#L=32400       # for Kyusyu 2022
#SUF=.ks1
############################################################
# Input (Edit here if you change settings)
############################################################
CRPTYP1ST=../../map/out/crp_typ1/M08_____20000000${SUF}
CRPTYP2ND=../../map/out/crp_typ2/M08_____20000000${SUF}
#CRPTYP1ST=../../map/org/KYUSYU/crp_typ_first${SUF}
#CRPTYP2ND=../../map/org/KYUSYU/crp_typ_second${SUF}
############################################################
# Input (Do not edit here basically) 
############################################################
PD01=../../crp/out/plt_bar_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
PD02=../../crp/out/plt_casg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
PD03=../../crp/out/plt_cot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD04=../../crp/out/plt_grn_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD05=../../crp/out/plt_mai_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD06=../../crp/out/plt_milg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD07=../../crp/out/plt_oilg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD08=../../crp/out/plt_othg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD09=../../crp/out/plt_pot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD10=../../crp/out/plt_pulg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD11=../../crp/out/plt_rap_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD12=../../crp/out/plt_ric_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD13=../../crp/out/plt_rye_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD14=../../crp/out/plt_sor_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD15=../../crp/out/plt_soy_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD16=../../crp/out/plt_sub_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD17=../../crp/out/plt_suc_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD18=../../crp/out/plt_sun_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
PD19=../../crp/out/plt_whe_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}

HD01=../../crp/out/hvs_bar_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
HD02=../../crp/out/hvs_casg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
HD03=../../crp/out/hvs_cot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD04=../../crp/out/hvs_grn_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD05=../../crp/out/hvs_mai_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD06=../../crp/out/hvs_milg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD07=../../crp/out/hvs_oilg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD08=../../crp/out/hvs_othg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD09=../../crp/out/hvs_pot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD10=../../crp/out/hvs_pulg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD11=../../crp/out/hvs_rap_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD12=../../crp/out/hvs_ric_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD13=../../crp/out/hvs_rye_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD14=../../crp/out/hvs_sor_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD15=../../crp/out/hvs_soy_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD16=../../crp/out/hvs_sub_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD17=../../crp/out/hvs_suc_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD18=../../crp/out/hvs_sun_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
HD19=../../crp/out/hvs_whe_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}

CD01=../../crp/out/crp_bar_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
CD02=../../crp/out/crp_casg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
CD03=../../crp/out/crp_cot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD04=../../crp/out/crp_grn_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD05=../../crp/out/crp_mai_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD06=../../crp/out/crp_milg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD07=../../crp/out/crp_oilg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD08=../../crp/out/crp_othg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD09=../../crp/out/crp_pot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD10=../../crp/out/crp_pulg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD11=../../crp/out/crp_rap_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD12=../../crp/out/crp_ric_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD13=../../crp/out/crp_rye_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD14=../../crp/out/crp_sor_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD15=../../crp/out/crp_soy_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD16=../../crp/out/crp_sub_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD17=../../crp/out/crp_suc_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD18=../../crp/out/crp_sun_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
CD19=../../crp/out/crp_whe_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}

YD01=../../crp/out/yld_bar_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
YD02=../../crp/out/yld_casg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
YD03=../../crp/out/yld_cot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD04=../../crp/out/yld_grn_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD05=../../crp/out/yld_mai_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD06=../../crp/out/yld_milg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD07=../../crp/out/yld_oilg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD08=../../crp/out/yld_othg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD09=../../crp/out/yld_pot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD10=../../crp/out/yld_pulg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD11=../../crp/out/yld_rap_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD12=../../crp/out/yld_ric_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD13=../../crp/out/yld_rye_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD14=../../crp/out/yld_sor_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD15=../../crp/out/yld_soy_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD16=../../crp/out/yld_sub_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD17=../../crp/out/yld_suc_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD18=../../crp/out/yld_sun_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
YD19=../../crp/out/yld_whe_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}

RG01=../../crp/out/reg_bar_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
RG02=../../crp/out/reg_casg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
RG03=../../crp/out/reg_cot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG04=../../crp/out/reg_grn_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG05=../../crp/out/reg_mai_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG06=../../crp/out/reg_milg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG07=../../crp/out/reg_oilg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG08=../../crp/out/reg_othg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG09=../../crp/out/reg_pot_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG10=../../crp/out/reg_pulg/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG11=../../crp/out/reg_rap_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG12=../../crp/out/reg_ric_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG13=../../crp/out/reg_rye_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG14=../../crp/out/reg_sor_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG15=../../crp/out/reg_soy_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG16=../../crp/out/reg_sub_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG17=../../crp/out/reg_suc_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG18=../../crp/out/reg_sun_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF} 
RG19=../../crp/out/reg_whe_/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
############################################################
# Output directory (Do not edit here basically)
############################################################
DIRDOYOCUINI=../../crp/out/ocu_ini_ # first date [DOY] of occupation
DIRDOYOCUEND=../../crp/out/ocu_end_ # final date [DOY] of occupation 
DIRPLT1ST=../../crp/out/plt_1st_
DIRHVS1ST=../../crp/out/hvs_1st_
DIRCRP1ST=../../crp/out/crp_1st_
DIRYLD1ST=../../crp/out/yld_1st_
DIRREG1ST=../../crp/out/reg_1st_
############################################################
# Output (Do not edit here basically)
############################################################
DOYOCUINI=${DIRDOYOCUINI}/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
DOYOCUEND=${DIRDOYOCUEND}/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
PLT1ST=${DIRPLT1ST}/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
HVS1ST=${DIRHVS1ST}/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
CRP1ST=${DIRCRP1ST}/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
YLD1ST=${DIRYLD1ST}/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
REG1ST=${DIRREG1ST}/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
############################################################
# Job (make directory)
############################################################
if [ ! -d $DIRDOYOCUINI ]; then  mkdir   $DIRDOYOCUINI; fi
if [ ! -d $DIRDOYOCUEND ]; then  mkdir   $DIRDOYOCUEND; fi
if [ ! -d $DIRPLT1ST    ]; then  mkdir   $DIRPLT1ST; fi
if [ ! -d $DIRHVS1ST    ]; then  mkdir   $DIRHVS1ST; fi
if [ ! -d $DIRCRP1ST    ]; then  mkdir   $DIRCRP1ST; fi
if [ ! -d $DIRYLD1ST    ]; then  mkdir   $DIRYLD1ST; fi
if [ ! -d $DIRREG1ST    ]; then  mkdir   $DIRREG1ST; fi
############################################################
# Job (make setting file)
############################################################
SETFILE=temp.txt
if [ -f $SETFILE ]; then
  rm $SETFILE
fi
cat << EOF >> $SETFILE
&setcal
n0l=$L
i0margin=$MARGIN
c0crptyp1st='$CRPTYP1ST'
c0crptyp2nd='$CRPTYP2ND'
c1plt(1)='$PD01'
c1plt(2)='$PD02'
c1plt(3)='$PD03'
c1plt(4)='$PD04'
c1plt(5)='$PD05'
c1plt(6)='$PD06'
c1plt(7)='$PD07'
c1plt(8)='$PD08'
c1plt(9)='$PD09'
c1plt(10)='$PD10'
c1plt(11)='$PD11'
c1plt(12)='$PD12'
c1plt(13)='$PD13'
c1plt(14)='$PD14'
c1plt(15)='$PD15'
c1plt(16)='$PD16'
c1plt(17)='$PD17'
c1plt(18)='$PD18'
c1plt(19)='$PD19'
c1hvs(1)='$HD01'
c1hvs(2)='$HD02'
c1hvs(3)='$HD03'
c1hvs(4)='$HD04'
c1hvs(5)='$HD05'
c1hvs(6)='$HD06'
c1hvs(7)='$HD07'
c1hvs(8)='$HD08'
c1hvs(9)='$HD09'
c1hvs(10)='$HD10'
c1hvs(11)='$HD11'
c1hvs(12)='$HD12'
c1hvs(13)='$HD13'
c1hvs(14)='$HD14'
c1hvs(15)='$HD15'
c1hvs(16)='$HD16'
c1hvs(17)='$HD17'
c1hvs(18)='$HD18'
c1hvs(19)='$HD19'
c1crp(1)='$CD01'
c1crp(2)='$CD02'
c1crp(3)='$CD03'
c1crp(4)='$CD04'
c1crp(5)='$CD05'
c1crp(6)='$CD06'
c1crp(7)='$CD07'
c1crp(8)='$CD08'
c1crp(9)='$CD09'
c1crp(10)='$CD10'
c1crp(11)='$CD11'
c1crp(12)='$CD12'
c1crp(13)='$CD13'
c1crp(14)='$CD14'
c1crp(15)='$CD15'
c1crp(16)='$CD16'
c1crp(17)='$CD17'
c1crp(18)='$CD18'
c1crp(19)='$CD19'
c1yld(1)='$YD01'
c1yld(2)='$YD02'
c1yld(3)='$YD03'
c1yld(4)='$YD04'
c1yld(5)='$YD05'
c1yld(6)='$YD06'
c1yld(7)='$YD07'
c1yld(8)='$YD08'
c1yld(9)='$YD09'
c1yld(10)='$YD10'
c1yld(11)='$YD11'
c1yld(12)='$YD12'
c1yld(13)='$YD13'
c1yld(14)='$YD14'
c1yld(15)='$YD15'
c1yld(16)='$YD16'
c1yld(17)='$YD17'
c1yld(18)='$YD18'
c1yld(19)='$YD19'
c1reg(1)='$RG01'
c1reg(2)='$RG02'
c1reg(3)='$RG03'
c1reg(4)='$RG04'
c1reg(5)='$RG05'
c1reg(6)='$RG06'
c1reg(7)='$RG07'
c1reg(8)='$RG08'
c1reg(9)='$RG09'
c1reg(10)='$RG10'
c1reg(11)='$RG11'
c1reg(12)='$RG12'
c1reg(13)='$RG13'
c1reg(14)='$RG14'
c1reg(15)='$RG15'
c1reg(16)='$RG16'
c1reg(17)='$RG17'
c1reg(18)='$RG18'
c1reg(19)='$RG19'
c0doyocuini='$DOYOCUINI'
c0doyocuend='$DOYOCUEND'
c0plt1st='$PLT1ST'
c0hvs1st='$HVS1ST'
c0crp1st='$CRP1ST'
c0yld1st='$YLD1ST'
c0reg1st='$REG1ST'
&end
EOF
############################################################
# Job (Start)
############################################################
prog_crpcal $SETFILE

