#!/bin/sh

#PN=$1
#BN=$2
ZY=$1
ZM=$2
#ZD=01
########################################################################################################
#ABOUT DATA TYPE
#DATA=01:psur     DATA=03:rain    DATA=06:tair   DATA=09:RH    DATA=11:wind    DATA=14:daylight_hours
########################################################################################################
for DATA in 01 03 06 11 14
do
    ZD=1
    ZDEND=`htcal $ZY $ZM`
    while [ $ZD -le $ZDEND ]; do
      ZD=`printf %02d $ZD`
#    for ZD in  01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#    do
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_47809_${ZY}_${ZM}.txt | awk '{print "iizuka__"" " "130.6933"" " "33.65167"" " $'${DATA}' }' > data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_47807_${ZY}_${ZM}.txt | awk '{print "fukuoka_"" " "130.3750"" " "33.58167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_47814_${ZY}_${ZM}.txt | awk '{print "hita____"" " "130.9283"" " "33.32167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_47815_${ZY}_${ZM}.txt | awk '{print "oita____"" " "131.6183"" " "33.23500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47805_${ZY}_${ZM}.txt | awk '{print "hirado__"" " "129.5500"" " "33.36000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47812_${ZY}_${ZM}.txt | awk '{print "sasebo__"" " "129.7267"" " "33.15833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47817_${ZY}_${ZM}.txt | awk '{print "nagasaki"" " "129.8667"" " "32.73333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47818_${ZY}_${ZM}.txt | awk '{print "unzendak"" " "130.2617"" " "32.73667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_47813_${ZY}_${ZM}.txt | awk '{print "saga____"" " "130.3050"" " "33.26500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47819_${ZY}_${ZM}.txt | awk '{print "kumamoto"" " "130.7067"" " "32.81333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47821_${ZY}_${ZM}.txt | awk '{print "asosan__"" " "131.0733"" " "32.88000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47824_${ZY}_${ZM}.txt | awk '{print "hitoyosi"" " "130.7550"" " "32.21667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47838_${ZY}_${ZM}.txt | awk '{print "ushibuka"" " "130.0267"" " "32.19667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47822_${ZY}_${ZM}.txt | awk '{print "nobeoka_"" " "131.6567"" " "32.58167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47829_${ZY}_${ZM}.txt | awk '{print "miyakono"" " "131.0817"" " "31.73000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47830_${ZY}_${ZM}.txt | awk '{print "miyazaki"" " "131.4133"" " "31.93833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47835_${ZY}_${ZM}.txt | awk '{print "aburatu_"" " "131.4067"" " "31.57833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47823_${ZY}_${ZM}.txt | awk '{print "akune___"" " "130.2000"" " "32.02667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47827_${ZY}_${ZM}.txt | awk '{print "kagosima"" " "130.5467"" " "31.55500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47831_${ZY}_${ZM}.txt | awk '{print "makuraza"" " "130.2917"" " "31.27167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -e 's/)//g'  -e '/[^-.0-9a-z)_ ]/d' -e 's/--/0.0/g' data_AMeDAS/AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2A${DATA}_${ZY}_${ZM}_${ZD}.txt
#        sed -e '/\/\/\//d' -e '/#/d' -e '/*/d' -e '/--/d' -e '/class="data_0_0"/d' -e '/style="text-align:center">/d' -e '/[^.0-9a-z_ ]/d'  AMeDAS2a${DATA}_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2A${DATA}_${ZY}_${ZM}_${ZD}.txt
	ZD=`expr $ZD + 1`
     done
done
#mv AMeDAS2a*.txt data_AMeDAS/

#########################################################################################################
#FOR QAIR DATA
#TAIR      RH       PSUR
#########################################################################################################
ZD=1
while [ $ZD -le $ZDEND ]; do
    ZD=`printf %02d $ZD`
#for ZD in  01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#    do
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_47809_${ZY}_${ZM}.txt | awk '{print "iizuka__"" " "130.6933"" " "33.65167"" " $06 " " $09 " " $01 }' > data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_47807_${ZY}_${ZM}.txt | awk '{print "fukuoka_"" " "130.3750"" " "33.58167"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_47814_${ZY}_${ZM}.txt | awk '{print "hita____"" " "130.9283"" " "33.32167"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_47815_${ZY}_${ZM}.txt | awk '{print "oita____"" " "131.6183"" " "33.23500"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47805_${ZY}_${ZM}.txt | awk '{print "hirado__"" " "129.5500"" " "33.36000"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47812_${ZY}_${ZM}.txt | awk '{print "sasebo__"" " "129.7267"" " "33.15833"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47817_${ZY}_${ZM}.txt | awk '{print "nagasaki"" " "129.8667"" " "32.73333"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47818_${ZY}_${ZM}.txt | awk '{print "unzendak"" " "130.2617"" " "32.73667"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_47813_${ZY}_${ZM}.txt | awk '{print "saga____"" " "130.3050"" " "33.26500"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47819_${ZY}_${ZM}.txt | awk '{print "kumamoto"" " "130.7067"" " "32.81333"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47821_${ZY}_${ZM}.txt | awk '{print "asosan__"" " "131.0733"" " "32.88000"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47824_${ZY}_${ZM}.txt | awk '{print "hitoyosi"" " "130.7550"" " "32.21667"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47838_${ZY}_${ZM}.txt | awk '{print "ushibuka"" " "130.0267"" " "32.19667"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47822_${ZY}_${ZM}.txt | awk '{print "nobeoka_"" " "131.6567"" " "32.58167"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47829_${ZY}_${ZM}.txt | awk '{print "miyakono"" " "131.0817"" " "31.73000"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47830_${ZY}_${ZM}.txt | awk '{print "miyazaki"" " "131.4133"" " "31.93833"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47835_${ZY}_${ZM}.txt | awk '{print "aburatu_"" " "131.4067"" " "31.57833"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47823_${ZY}_${ZM}.txt | awk '{print "akune___"" " "130.2000"" " "32.02667"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47827_${ZY}_${ZM}.txt | awk '{print "kagosima"" " "130.5467"" " "31.55500"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47831_${ZY}_${ZM}.txt | awk '{print "makuraza"" " "130.2917"" " "31.27167"" " $06 " " $09 " " $01 }' >> data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt
        sed -e 's/)//g'  -e '/[^-.0-9a-z)_ ]/d'  -e 's/--/0.0/g' -e 's/]//g' data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2A3Q_${ZY}_${ZM}_${ZD}.txt 
#        sed -e '/\/\/\//d' -e '/#/d' -e '/*/d' -e '/--/d' -e '/class="data_0_0"/d'  -e '/style="text-align:center">/d' -e '/[^.0-9a-z_ ]/d' data_AMeDAS/AMeDAS2a3Q_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2A3Q_${ZY}_${ZM}_${ZD}.txt
	ZD=`expr $ZD + 1`
     done
#mv AMeDAS2a3Q_*.txt data_AMeDAS/
#########################################################################################################                                                                                   
#FOR LWDO  DATA                                                                                                                                                                               
#TAIR      RH       PSUR      RN
#########################################################################################################
ZD=1
while [ $ZD -le $ZDEND ]; do
    ZD=`printf %02d $ZD`        
#for ZD in  01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#    do
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_47809_${ZY}_${ZM}.txt | awk '{print "iizuka__"" " "130.6933"" " "33.65167"" " $06 " " $09 " " $01 " " $14 }' > data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_47807_${ZY}_${ZM}.txt | awk '{print "fukuoka_"" " "130.3750"" " "33.58167"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_47814_${ZY}_${ZM}.txt | awk '{print "hita____"" " "130.9283"" " "33.32167"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_47815_${ZY}_${ZM}.txt | awk '{print "oita____"" " "131.6183"" " "33.23500"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47805_${ZY}_${ZM}.txt | awk '{print "hirado__"" " "129.5500"" " "33.36000"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47812_${ZY}_${ZM}.txt | awk '{print "sasebo__"" " "129.7267"" " "33.15833"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47817_${ZY}_${ZM}.txt | awk '{print "nagasaki"" " "129.8667"" " "32.73333"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_47818_${ZY}_${ZM}.txt | awk '{print "unzendak"" " "130.2617"" " "32.73667"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_47813_${ZY}_${ZM}.txt | awk '{print "saga____"" " "130.3050"" " "33.26500"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47819_${ZY}_${ZM}.txt | awk '{print "kumamoto"" " "130.7067"" " "32.81333"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47821_${ZY}_${ZM}.txt | awk '{print "asosan__"" " "131.0733"" " "32.88000"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47824_${ZY}_${ZM}.txt | awk '{print "hitoyosi"" " "130.7550"" " "32.21667"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_47838_${ZY}_${ZM}.txt | awk '{print "ushibuka"" " "130.0267"" " "32.19667"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47822_${ZY}_${ZM}.txt | awk '{print "nobeoka_"" " "131.6567"" " "32.58167"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47829_${ZY}_${ZM}.txt | awk '{print "miyakono"" " "131.0817"" " "31.73000"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47830_${ZY}_${ZM}.txt | awk '{print "miyazaki"" " "131.4133"" " "31.93833"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_47835_${ZY}_${ZM}.txt | awk '{print "aburatu_"" " "131.4067"" " "31.57833"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47823_${ZY}_${ZM}.txt | awk '{print "akune___"" " "130.2000"" " "32.02667"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47827_${ZY}_${ZM}.txt | awk '{print "kagosima"" " "130.5467"" " "31.55500"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_47831_${ZY}_${ZM}.txt | awk '{print "makuraza"" " "130.2917"" " "31.27167"" " $06 " " $09 " " $01 " " $14}' >> data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt
        sed -e 's/)//g'  -e '/[^-.0-9a-z)_ ]/d' -e 's/--/0.0/g' -e 's/]//g' data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2A4L_${ZY}_${ZM}_${ZD}.txt
#       sed -e '/\/\/\//d' -e '/#/d' -e '/*/d' -e '/--/d' -e '/class="data_0_0"/d'  -e '/style="text-align:center">/d' -e '/[^.0-9a-z_ ]/d' data_AMeDAS/AMeDAS2a4L_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2A4L_${ZY}_${ZM}_${ZD}.txt
	ZD=`expr $ZD + 1`
     done
#mv AMeDAS2a4L_*.txt data_AMeDAS/

#mv AMeDAS2_8*_47*.txt data_AMeDAS/
