#!/bin/sh
########################################################
#PN=$1
#BN=$2
ZY=$1
ZM=$2
########################################################
DMIN=81
DMAX=111
########################################################
for PN in 82 83 84 85 86 87 88; do
    if [ $PN -eq 82 ]; then
	BNS="47807 47809"
	elif [ $PN -eq 83 ]; then
	BNS="47814 47815"
	elif [ $PN -eq 84 ]; then
	BNS="47805 47812 47817 47818"
	elif [ $PN -eq 85 ]; then
	BNS="47813"
	elif [ $PN -eq 86 ]; then
	BNS="47819 47821 47824 47838"
	elif [ $PN -eq 87 ]; then
	BNS="47822 47829 47830 47835"
	elif [ $PN -eq 88 ]; then
	BNS="47823 47827 47831"
    fi

	for BN in $BNS; do
	    D=$DMIN
	    : > AMeDAS_${PN}_${BN}_${ZY}_${ZM}.txt
	    while [ $D -le $DMAX ]; do
	    awk 'NR=='"${D}" "daily_s1.php?prec_no=${PN}&block_no=${BN}&year=${ZY}&month=${ZM}&day=&view=p1" >> AMeDAS_${PN}_${BN}_${ZY}_${ZM}.txt	 
	    D=`expr $D + 1`
	    done
	    sed -e 's/"data_0_0"><\/td/"data_0_0">0.0<\/td/g' -e 's/class="data_0_0">//g' -e  's/..td>//g' -e 's/middle">//g'\
            -e 's/<td//g' -e 's/ )//g' -e 's/ ]//g' AMeDAS_${PN}_${BN}_${ZY}_${ZM}.txt \
            | awk '{print $7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$21,$24}' > data_AMeDAS/AMeDAS2_${PN}_${BN}_${ZY}_${ZM}.txt

	    if [ $PN -eq 82 ]; then
		echo data_AMeDAS/AMeDAS2_${PN}_${BN}_${ZY}_${ZM}.txt
	    fi

	    mv AMeDAS_${PN}_${BN}_${ZY}_${ZM}.txt data_AMeDAS/
        done

done