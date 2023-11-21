#!/bin/sh
########################################
#
#
########################################
THS="A B C"
HS="A B C"
TES="A B C"
OS="A B C"

#PRJ=WFDE        # for H08 ver2018
PRJ=GSW2        # for Korean peninsula (.ko5)
#PRJ=NK03        # for Naka and Kuji river
#PRJ=AK10        # for Kyusyu (.ks1)
#########################################
SD_A=0.25;  SD_B=1.00;  SD_C=4.00
#
CD_A=0.002; CD_B=0.006; CD_C=0.010
#
GAM_A=1.0;  GAM_B=2.0;  GAM_C=3.0
#
TAU_A=25;   TAU_B=100;  TAU_C=400
########################################
# sample of fundamental technique
########################################
#cat GSW2AAAA20151002.set | sed -e 's/AAAA/AAAB/g' | sed -e 's/uniform.1.00/uniform.1.00/g' | sed -e 's/uniform.0.003/uniform.0.003/g' | sed -e 's/uniform.2.00/uniform.2.00/g' | sed -e 's/uniform.100.00/uniform.50.00/g'
########################################
#
########################################
echo Caution! This script needs ${PRJ}____00000000.set  
echo If you need this, please contact us!
DATE=`date +"%Y%m%d"`

for TH in $THS; do
    for H in $HS; do
	for TE in $TES; do
	    for O in $OS; do
		if [ $TH = A ]; then
		    SD=$SD_A
		elif [ $TH = B ]; then
		    SD=$SD_B
		else 
		    SD=$SD_C
		fi
		if [ $H = A ]; then
		    CD=$CD_A
		elif [ $H = B ]; then
		    CD=$CD_B
		else 
		    CD=$CD_C
		fi
		if [ $TE = A ]; then
		    GAM=$GAM_A
		elif [ $TE = B ]; then
		    GAM=$GAM_B
		else 
		    GAM=$GAM_C
		fi
		if [ $O = A ]; then
		    TAU=$TAU_A
		elif [ $O = B ]; then
		    TAU=$TAU_B
		else 
		    TAU=$TAU_C
		fi
		cat ../../lnd/set/${PRJ}____00000000.set | \
                sed -e "s/AAAA/${TH}${H}${TE}${O}/g" | \
                sed -e "s/FILESD/uniform.${SD}/g" | \
                sed -e "s/FILECD/uniform.${CD}/g" | \
                sed -e "s/FILEGAMMA/uniform.${GAM}/g" | \
                sed -e "s/FILETAU/uniform.${TAU}/g" > \
                ../../lnd/set/${PRJ}${TH}${H}${TE}${O}${DATE}.set
                echo ${PRJ}${TH}${H}${TE}${O}${DATE}.set
	    done
 	done
    done
done
