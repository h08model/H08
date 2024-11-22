#!/bin/sh
##############################################################
#to   prepare 1 dimentional data
#by   2024/10/21, tamaoki, NIES: H08ver1.0
##############################################################
# Settings (Edit here if you change spacial domain/resolution) 
##############################################################
YEARMIN=1979; YEARMAX=1979
YEARINI=1978
YEARMEAN=0000
MONS="00 01 02 03 04 05 06 07 08 09 10 11 12"
#
LALL=259200                 # L for 2 dimensional data
LLND=67209                  # L for 1 dimensional data
X=720                       
Y=360                       
L2XLND=../../map/dat/l2x_l2y_/l2x.hlo.txt
L2YLND=../../map/dat/l2x_l2y_/l2y.hlo.txt
LONLAT="-180 180 -90 90"
#
SUFIN=.hlf                  # Suffix for 2 dimensional data
SUFOUT=.hlo                 # Suffix for 1 dimensional data
MAP=.WFDEI
CANSUFIN=.binhlf
CANSUFOUT=.binhlo

#
PRJLND=wfde
PRJMET=WFDE
PRJMAP=GSW2
PRJDAM=GRan
RUN___="____"
RUNC__="__C_"
RUNLR_="LR__"
RUNDAL="D_L_"
RUNDAM="D_M_"
#
#############################################################
# Input Directories
#############################################################
DIRMAPDAT=../../map/dat
DIRMAPOUT=../../map/out
DIRRIVINI=../../riv/ini
DIRRIVDAT=../../riv/dat
DIRRIVOUT=../../riv/out
DIRDAMINI=../../dam/ini
DIRDAMDAT=../../dam/dat
DIRLNDINI=../../lnd/ini
DIRLNDDAT=../../lnd/dat
DIRCRPINI=../../crp/ini
DIRCRPOUT=../../crp/out
#############################################################
# Input files
#############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUFIN}
#
LNDARAIN=${DIRMAPDAT}/lnd_ara_/lndara${MAP}${SUFIN}
AEIFRCIN=${DIRMAPDAT}/aeigfrc_/GMIA5___20050000${MAP}${SUFIN}
FLWDIRIN=${DIRMAPDAT}/flw_dir_/flwdir${MAP}${SUFIN}
DAMAFCIN=${DIRMAPDAT}/dam_afc_/${PRJDAM}${RUNDAM}20000000${SUFIN}
DAMCALIN=${DIRMAPDAT}/dam_cap_/${PRJDAM}${RUNDAL}20000000${SUFIN}
DAMCAMIN=${DIRMAPDAT}/dam_cap_/${PRJDAM}${RUNDAM}20000000${SUFIN}
DAMID_IN=${DIRMAPDAT}/dam_id__/${PRJDAM}${RUNDAL}20000000${SUFIN}
DAMPRPIN=${DIRMAPDAT}/dam_prp_/${PRJDAM}${RUNDAL}20000000${SUFIN}
FRCGWDIN=${DIRMAPDAT}/frc_gwd_/D12${MAP}${SUFIN}
FRCGWIIN=${DIRMAPDAT}/frc_gwi_/D12${MAP}${SUFIN}
IRGARAIN=${DIRMAPDAT}/irg_ara_/S05_${RUN___}20000000${SUFIN}
IRGEFFIN=${DIRMAPDAT}/irg_eff_/DS02${RUN___}00000000${SUFIN}
POPTOTIN=${DIRMAPDAT}/pop_tot_/C05_a___20000000${SUFIN}
WITAGRIN=${DIRMAPDAT}/wit_agr_/AQUASTAT20000000${SUFIN}
WITDOMIN=${DIRMAPDAT}/wit_dom_/AQUASTAT20000000${SUFIN}
WITINDIN=${DIRMAPDAT}/wit_ind_/AQUASTAT20000000${SUFIN}
#
DAMDOMIN=${DIRMAPOUT}/dam_dom_/${PRJMET}${RUNLR_}${SUFIN}
DAMUPLIN=${DIRMAPOUT}/dam_up__/${PRJDAM}${RUNDAL}${SUFIN}
DAMUPMIN=${DIRMAPOUT}/dam_up__/${PRJDAM}${RUNDAM}${SUFIN}
DAMUCLIN=${DIRMAPOUT}/dam_upc_/${PRJDAM}${RUNDAL}${SUFIN}
DAMUCMIN=${DIRMAPOUT}/dam_upc_/${PRJDAM}${RUNDAM}${SUFIN}
CRPTY1IN=${DIRMAPOUT}/crp_typ1/M08_${RUN___}20000000${SUFIN}
CRPTY2IN=${DIRMAPOUT}/crp_typ2/M08_${RUN___}20000000${SUFIN}
DESPOTIN=${DIRMAPOUT}/des_pot_/Hist${RUN___}20050000${MAP}.14000.0.08${SUFIN}
NONARAIN=${DIRMAPOUT}/non_ara_/S05_${RUN___}20000000${SUFIN}
IRGFRDIN=${DIRMAPOUT}/irg_frcd/S05_${RUN___}20000000${SUFIN}
IRGFRSIN=${DIRMAPOUT}/irg_frcs/S05_${RUN___}20000000${SUFIN}
RFDFRCIN=${DIRMAPOUT}/rfd_frc_/S05_${RUN___}20000000${SUFIN}
NONFRCIN=${DIRMAPOUT}/non_frc_/S05_${RUN___}20000000${SUFIN}
RIVNUMIN=${DIRMAPOUT}/riv_num_/rivnum${MAP}${SUFIN}
RIVNXDIN=${DIRMAPOUT}/riv_nxd_/rivnxd${MAP}${SUFIN}
RIVNXLIN=${DIRMAPOUT}/riv_nxl_/rivnxl${MAP}${SUFIN}
RIVSEQIN=${DIRMAPOUT}/riv_seq_/rivseq${MAP}${SUFIN}
#
FLD2DRIN=${DIRRIVOUT}/fld2dro_/${PRJMET}${RUNLR_}${YEARMEAN}0000${SUFIN}
#
GAMMA_IN=${DIRLNDDAT}/gamma___/${PRJLND}${RUN___}${YEARMEAN}0000${SUFIN}
TAU___IN=${DIRLNDDAT}/tau_____/${PRJLND}${RUN___}${YEARMEAN}0000${SUFIN}
GWRFA_IN=${DIRLNDDAT}/gwr_____/fa${SUFIN}
GWRFG_IN=${DIRLNDDAT}/gwr_____/fg${SUFIN}
GWRFP_IN=${DIRLNDDAT}/gwr_____/fp${SUFIN}
GWRFR_IN=${DIRLNDDAT}/gwr_____/fr${SUFIN}
GWRFT_IN=${DIRLNDDAT}/gwr_____/ft${SUFIN}
GWRRG_IN=${DIRLNDDAT}/gwr_____/rgmax${SUFIN}
GWRSLPIN=${DIRLNDDAT}/gwr_____/slope${SUFIN}
#
DEMDOMIN=${DIRMAPDAT}/dem_dom_/AQUASTAT20000000${SUFIN}
DEMINDIN=${DIRMAPDAT}/dem_ind_/AQUASTAT20000000${SUFIN}
#
HVS1STIN=${DIRCRPOUT}/hvs_1st_/${PRJMET}${RUNC__}${YEARMEAN}0000${SUFIN}
HVS2NDIN=${DIRCRPOUT}/hvs_2nd_/${PRJMET}${RUNC__}${YEARMEAN}0000${SUFIN}
PLT1STIN=${DIRCRPOUT}/plt_1st_/${PRJMET}${RUNC__}${YEARMEAN}0000${SUFIN}
PLT2NDIN=${DIRCRPOUT}/plt_2nd_/${PRJMET}${RUNC__}${YEARMEAN}0000${SUFIN}

##############################################################
# Input variables
##############################################################
INIVARS="rivini damini crpini"
RIVDATVARS="0.5 1.4"
DAMDATVARS="0.0 1.0"
LNDDATVARS="0.0 150.0 283.15"
#
DATVARS="$LNDARAIN $AEIFRCIN $FLWDIRIN $DAMAFCIN $DAMCALIN $DAMCAMIN $DAMID_IN $DAMPRPIN $DEMDOMIN $DEMINDIN $FRCGWDIN $FRCGWIIN $IRGARAIN $IRGEFFIN $POPTOTIN $WITAGRIN $WITDOMIN $WITINDIN $DAMDOMIN $DAMUPLIN $DAMUPMIN $DAMUCLIN $DAMUCMIN $CRPTY1IN $CRPTY2IN $DESPOTIN $NONARAIN $IRGFRDIN $IRGFRSIN $RFDFRCIN $NONFRCIN $RIVNUMIN $RIVNXDIN $RIVNXLIN $RIVSEQIN $FLD2DRIN $GAMMA_IN $TAU___IN $GWRFA_IN $GWRFG_IN $GWRFP_IN $GWRFR_IN $GWRFT_IN $GWRRG_IN $GWRSLPIN $HVS1STIN $HVS2NDIN $PLT1STIN $PLT2NDIN"
#
RIVOUTVARS="riv_out_ riv_sto_ env_out_"
DAMVARS="dam_alc_ dam_d2d_ dam_d2s_"

#############################################################
# Output Data
#############################################################
#CPT=temp.cpt
#EPS=temp.eps
#PNG=temp.png

#############################################################
# Conversion of parameters (ALL --> LND)
#############################################################
for VAR in $INIVARS; do
    if [ $VAR = "rivini" ]; then
	INIIN=${DIRRIVINI}/uniform.0.0${SUFIN}
	INIOUT=${DIRRIVINI}/uniform.0.0${SUFOUT}
    elif [ $VAR = "damini" ]; then 
	INIIN=${DIRDAMINI}/uniform.0.0${SUFIN}
	INIOUT=${DIRDAMINI}/uniform.0.0${SUFOUT}
    elif [ $VAR = "crpini" ]; then 
	INIIN=${DIRCRPINI}/uniform.0.0${SUFIN}
	INIOUT=${DIRCRPINI}/uniform.0.0${SUFOUT}
    fi
    ht2dto1d $LALL $X $Y $INIIN $LNDMSK $INIOUT
    echo "$INIIN \n$INIOUT"
done

for RIVVAR in $RIVDATVARS; do
    PARAIN=${DIRRIVDAT}/uniform.${RIVVAR}${SUFIN}
    PARAOUT=${PARAIN%${SUFIN}}${SUFOUT}     
    ht2dto1d $LALL $X $Y $PARAIN $LNDMSK $PARAOUT
    echo "$PARAIN \n$PARAOUT"
done

for DAMVAR in $DAMDATVARS; do
    PARAIN=${DIRDAMDAT}/uniform.${DAMVAR}${SUFIN}
    PARAOUT=${PARAIN%${SUFIN}}${SUFOUT}
    ht2dto1d $LALL $X $Y $PARAIN $LNDMSK $PARAOUT
    echo "$PARAIN \n$PARAOUT"
done

for LNDVAR in $LNDDATVARS; do
    PARAIN=${DIRLNDINI}/uniform.${LNDVAR}${SUFIN}
    PARAOUT=${PARAIN%${SUFIN}}${SUFOUT}
    ht2dto1d $LALL $X $Y $PARAIN $LNDMSK $PARAOUT
    echo "$PARAIN \n$PARAOUT"
done

BININ=${DIRDAMDAT}/uniform.0.0${CANSUFIN}
BINOUT=${BININ%${CANSUFIN}}${CANSUFOUT}
split -b1036800 $BININ bin_
BINFILES=`ls bin*`
BINOUTFILES=

for BINFILE in $BINFILES; do
    ht2dto1d $LALL $X $Y $BINFILE $LNDMSK tempbin.$FILE
    BINOUTFILES=`echo $OUTFILES tempbin.$FILE` 
done

cat $BINOUTFILES > $BINOUT
echo $BINOUT

#############################################################
# Conversion of data (ALL --> LND)
#############################################################
for DATVAR in $DATVARS; do
    DATIN=${DATVAR}
    DATOUT=${DATIN%${SUFIN}}${SUFOUT}
    ht2dto1d $LALL $X $Y $DATIN $LNDMSK $DATOUT
    echo "$DATIN \n$DATOUT"
done

#############################################################
# Conversion of period data (ALL --> LND)
#############################################################
# River

for RIVOUTVAR in $RIVOUTVARS; do
    if [ $RIVOUTVAR = "riv_sto_" ]; then
	MONINIS="00 12"
	for MONINI in $MONINIS; do
	    RIVSTOIN=${DIRRIVOUT}/${RIVOUTVAR}/${PRJMET}${RUNLR_}${YEARINI}${MONINI}00${SUFIN}
	    RIVSTOUT=${RIVSTOIN%${SUFIN}}${SUFOUT}
	    ht2dto1d $LALL $X $Y $RIVLRMIN $LNDMSK $RIVLMOUT
	    echo "$RIVSTOIN \n$RIVSTOUT"
	done
    elif [ $RIVOUTVAR = "riv_out_" ] || [ $RIVOUTVAR = "env_out_" ]; then
	for MON in $MONS; do
	    RIVLRMIN=${DIRRIVOUT}/${RIVOUTVAR}/${PRJMET}${RUNLR_}${YEARMEAN}${MON}00${SUFIN}
	    RIVLMOUT=${RIVLRMIN%${SUFIN}}${SUFOUT}
	    ht2dto1d $LALL $X $Y $RIVLRMIN $LNDMSK $RIVLMOUT
	    echo "$RIVLRMIN \n$RIVLMOUT"
	done
    fi

    if [ $RIVOUTVAR = "riv_out_" ] || [ $RIVOUTVAR = "riv_sto_" ]; then 
	YEAR=$YEARMIN
	while [ $YEAR -le $YEARMAX ]; do
	    for MON in $MONS; do
		RIVLR_IN=${DIRRIVOUT}/${RIVOUTVAR}/${PRJMET}${RUNLR_}${YEAR}${MON}00${SUFIN}
		RIVLROUT=${RIVLR_IN%${SUFIN}}${SUFOUT}
		ht2dto1d $LALL $X $Y $RIVLR_IN $LNDMSK $RIVLROUT
		echo "$RIVLR_IN \n$RIVLROUT"
	    done
	    YEAR=`expr $YEAR + 1`
	done
    fi
done

# Dam

for DAMVAR in $DAMVARS; do
    DIRDAM=${DIRMAPOUT}/${DAMVAR}
    if [ $DAMVAR = "dam_alc_" ]; then
	ALCFILES=`ls $DIRDAM`
	for ALCFILE in $ALCFILES; do
	    ALCFILEIN=${DIRDAM}/${ALCFILE}
	    ALCFILEOUT=${ALCFILEIN%${SUFIN}}${SUFOUT}
	    ht2dto1d $LALL $X $Y $ALCFILEIN $LNDMSK $ALCFILEOUT
	    echo $ALCFILEOUT
	done
    elif [ $DAMVAR = "dam_d2d_" ]; then
	D2DFILES=`ls $DIRDAM`
	for D2DFILE in $D2DFILES; do
	    D2DFILEIN=${DIRDAM}/${D2DFILE}
	    D2DFILEOUT=${D2DFILEIN%${SUFIN}}${SUFOUT}
	    ht2dto1d $LALL $X $Y $D2DFILEIN $LNDMSK $D2DFILEOUT
	    echo $D2DFILEOUT
	done
    elif [ $DAMVAR = "dam_d2s_" ]; then
	D2SFILES=`ls $DIRDAM`
	for D2SFILE in $D2SFILES; do
	    D2SFILEIN=${DIRDAM}/${D2SFILE}
	    D2SFILEOUT=${D2SFILEIN%${SUFIN}}${SUFOUT}
	    ht2dto1d $LALL $X $Y $D2SFILEIN $LNDMSK $D2SFILEOUT
	    echo $D2SFILEOUT
	done
    fi
done

#############################################################
# convert bin file 
#############################################################
CANDESIN=${DIRMAPOUT}/can_des_/candes.l.merged.1${MAP}${CANSUFIN}
CANDESOUT=${CANDESIN%${CANSUFIN}}${CANSUFOUT}
split -b1036800 $CANDESIN
FILES=`ls x*`
OUTFILES=
for FILE in $FILES; do
    ht2dto1d $LALL $X $Y $FILE $LNDMSK temp.$FILE temp.l2x temp.l2y yes
    OUTFILES=`echo $OUTFILES temp.$FILE`
done
cat $OUTFILES > $CANDESOUT
echo $CANDESOUT

#############################################################
# convert l data file
#############################################################
CANORGIN=${DIRMAPOUT}/can_org_/canorg.l.merged.1${MAP}${SUFIN}
RIVNXLIN=${DIRMAPOUT}/riv_nxl_/rivnxl.WFDEI${SUFIN}

LDATVARS="$CANORGIN $RIVNXLIN" 
for LDATVAR in $LDATVARS; do
    if [ $LDATVAR = "$CANORGIN" ]; then
        LDATIN=${LDATVAR}
	LDATOUT=${LDATIN%${SUFIN}}${SUFOUT}
	echo $LDATOUT
	ht2dto1d $LALL $X $Y $LDATIN $LNDMSK $LDATOUT temp.l2x temp.l2y yes 
    elif [ $LDATVAR = "$RIVNXLIN" ]; then
	LDATIN=${LDATVAR}
        LDATOUT=${LDATIN%${SUFIN}}${SUFOUT}
	echo $LDATOUT
	ht2dto1d $LALL $X $Y $LDATIN $LNDMSK $LDATOUT temp.l2x temp.l2y yes
    fi
done

#############################################################
# Confirm (max, min, sum, ave)
#############################################################
#           htstat $LLND $X $Y $L2XLND $L2YLND $LONLAT max $OUT
#	    htstat $LLND $X $Y $L2XLND $L2YLND $LONLAT min $OUT
#	    htstat $LLND $X $Y $L2XLND $L2YLND $LONLAT sum $OUT
#	    htstat $LLND $X $Y $L2XLND $L2YLND $LONLAT ave $OUT
		
#############################################################
# 1D-->2D (Graphic converison of meteorological data)
#############################################################
#		if [ $VAR = "Tair____" ]; then
#		    gmt makecpt -T0/330/110 -Z > $CPT
#		elif [ $VAR = "LWdown__" ]; then
#    		    gmt makecpt -T0/550/110 -Z > $CPT
#		elif [ $VAR = "SWdown__" ]; then
#		    gmt makecpt -T0/330/110 -Z > $CPT
#		elif [ $VAR = "Prcp____" ]; then
#		    gmt makecpt -T0/0.0003/0.0001 -Z > $CPT
#		elif [ $VAR = "PSurf___" ]; then
#		    gmt makecpt -T0/110000/55000 -Z > $CPT
#		elif [ $VAR = "Qair____" ]; then
#		    gmt makecpt -T0/0.03/0.01 -Z > $CPT
#		elif [ $VAR = "Rainf___" ]; then
#		    gmt makecpt -T0/0.0003/0.0001 -Z > $CPT
#		elif [ $VAR = "Snowf___" ]; then
#		    gmt makecpt -T0/0.00007/0.000035 -Z > $CPT
#		elif [ $VAR = "Wind____" ]; then
#		    gmt makecpt -T0/15/5 -Z > $CPT
#     		fi

#		htdraw $LLND $X $Y $L2XLND $L2YLND $LONLAT $OUT $CPT $EPS
#	        htconv $EPS $PNG rot



