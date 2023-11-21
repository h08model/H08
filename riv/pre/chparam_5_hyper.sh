#!/bin/sh
########################################
#
#
########################################
THS="a b c d e" #"A B C"
HS="a b c d e" #"A B C"
TES="a b c d e" #"A B C"
OS="a b c d e" #"A B C"
DATE=`date +"%Y%m%d"`
PRJ=AK10
########################################
# sample of fundamental technique
########################################
#cat GSW2AAAA20161124.set | sed -e 's/AAAA/AAAB/g' | sed -e 's/uniform.1.00/uniform.1.00/g' | sed -e 's/uniform.0.003/uniform.0.003/g' | sed -e 's/uniform.2.00/uniform.2.00/g' | sed -e 's/uniform.100.00/uniform.50.00/g'
########################################
#
########################################
echo Caution! This script needs ${PRJ}____${DATE}.set  
echo If you need this, please contact us!

for TH in $THS; do
    for H in $HS; do
	for TE in $TES; do
	    for O in $OS; do
		cat ../../riv/set/${PRJ}____${DATE}.set | \
                sed -e "s/AAAA/${TH}${H}${TE}${O}/g" > \
                ../../riv/set/${PRJ}${TH}${H}${TE}${O}${DATE}.set
                echo ${PRJ}${TH}${H}${TE}${O}${DATE}.set
	    done
 	done
    done
done