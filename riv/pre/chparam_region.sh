#!/bin/sh
########################################
#
#
########################################
THS="A B C"
HS="A B C"
TES="A B C"
OS="A B C"

DATA=`date +"%Y%m%d"`
PRJ=GSW2     # project name
########################################
# sample of fundamental technique
########################################
#cat GSW2AAAA20151002.set | sed -e 's/AAAA/AAAB/g' | sed -e 's/uniform.1.00/uniform.1.00/g' | sed -e 's/uniform.0.003/uniform.0.003/g' | sed -e 's/uniform.2.00/uniform.2.00/g' | sed -e 's/uniform.100.00/uniform.50.00/g'
########################################
#
########################################
echo Caution! This script needs ${PRJ}____00000000.set  
echo If you need this, please contact us!

for TH in $THS; do
    for H in $HS; do
	for TE in $TES; do
	    for O in $OS; do
		cat ../../riv/set/${PRJ}____00000000.set | \
                sed -e "s/AAAA/${TH}${H}${TE}${O}/g" > \
                ../../riv/set/${PRJ}${TH}${H}${TE}${O}${DATA}.set
                echo ${PRJ}${TH}${H}${TE}${O}${DATA}.set
	    done
 	done
    done
done