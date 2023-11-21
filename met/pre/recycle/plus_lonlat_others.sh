#!/bin/sh

#PN=$1
#BN=$2
ZY=$1
ZM=$2
#ZD=01
#########################################################################################
#ABOUT DATA TYPE
#DATA=01:rain   DATA=02:tair   DATA=03:wind   DATA=04:daylight_hours
#########################################################################################
for DATA in 01 02 03 04 
do
    ZD=1
    ZDEND=`htcal $ZY $ZM`
    while [ $ZD -le $ZDEND ]; do
      ZD=`printf %02d $ZD`
#    for ZD in  01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#    do
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0780_${ZY}_${ZM}.txt | awk '{print "yahata__"" " "130.7433"" " "33.85167"" " $'${DATA}' }' > data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0782_${ZY}_${ZM}.txt | awk '{print "yukuhasi"" " "130.9750"" " "33.71333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0785_${ZY}_${ZM}.txt | awk '{print "maebaru_"" " "130.1900"" " "33.56000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0788_${ZY}_${ZM}.txt | awk '{print "asakura_"" " "130.6950"" " "33.40500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0790_${ZY}_${ZM}.txt | awk '{print "kurume__"" " "130.4933"" " "33.30333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0792_${ZY}_${ZM}.txt | awk '{print "kuroki__"" " "130.6450"" " "33.22500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0793_${ZY}_${ZM}.txt | awk '{print "omuta___"" " "130.4667"" " "33.00667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0943_${ZY}_${ZM}.txt | awk '{print "munakata"" " "130.5383"" " "33.80833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_1046_${ZY}_${ZM}.txt | awk '{print "soeda___"" " "130.8550"" " "33.55833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_1141_${ZY}_${ZM}.txt | awk '{print "dazaihu_"" " "130.4900"" " "33.49667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0794_${ZY}_${ZM}.txt | awk '{print "nakatsu_"" " "131.2450"" " "33.58667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0795_${ZY}_${ZM}.txt | awk '{print "bungotak"" " "131.4333"" " "33.57000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0799_${ZY}_${ZM}.txt | awk '{print "yuhuin__"" " "131.3467"" " "33.25333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0805_${ZY}_${ZM}.txt | awk '{print "inukai__"" " "131.6317"" " "33.06500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0806_${ZY}_${ZM}.txt | awk '{print "takeda__"" " "131.3983"" " "32.97333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0808_${ZY}_${ZM}.txt | awk '{print "saiki___"" " "131.9017"" " "32.95000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0810_${ZY}_${ZM}.txt | awk '{print "kamae___"" " "131.9233"" " "32.79500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0931_${ZY}_${ZM}.txt | awk '{print "innai___"" " "131.3167"" " "33.42000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0932_${ZY}_${ZM}.txt | awk '{print "kusu____"" " "131.1550"" " "33.29167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_1137_${ZY}_${ZM}.txt | awk '{print "kunimi__"" " "131.5900"" " "33.67500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_1142_${ZY}_${ZM}.txt | awk '{print "ume_____"" " "131.6750"" " "32.84500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_1237_${ZY}_${ZM}.txt | awk '{print "kitsuki_"" " "131.5967"" " "33.41667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_0814_${ZY}_${ZM}.txt | awk '{print "matsura_"" " "129.7117"" " "33.34167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_0817_${ZY}_${ZM}.txt | awk '{print "oseto___"" " "129.6317"" " "32.94833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_0922_${ZY}_${ZM}.txt | awk '{print "kutinotu"" " "130.1933"" " "32.61167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_0962_${ZY}_${ZM}.txt | awk '{print "simabara"" " "130.3750"" " "32.74167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_1138_${ZY}_${ZM}.txt | awk '{print "arikawa_"" " "129.1183"" " "32.98167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_1144_${ZY}_${ZM}.txt | awk '{print "ashibe__"" " "129.7217"" " "33.80000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_1441_${ZY}_${ZM}.txt | awk '{print "nomosaki"" " "129.7400"" " "32.57833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_0824_${ZY}_${ZM}.txt | awk '{print "ezarugi_"" " "129.8983"" " "33.49833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_0829_${ZY}_${ZM}.txt | awk '{print "siroisi_"" " "130.1483"" " "33.18333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_0830_${ZY}_${ZM}.txt | awk '{print "uresino_"" " "129.9950"" " "33.11667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_1075_${ZY}_${ZM}.txt | awk '{print "imari___"" " "129.8783"" " "33.26667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_1610_${ZY}_${ZM}.txt | awk '{print "karatsu_"" " "129.9550"" " "33.45833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0832_${ZY}_${ZM}.txt | awk '{print "kahoku__"" " "130.6917"" " "33.11500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0833_${ZY}_${ZM}.txt | awk '{print "minamiog"" " "131.0667"" " "33.10333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0834_${ZY}_${ZM}.txt | awk '{print "taimei__"" " "130.5117"" " "32.91500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0835_${ZY}_${ZM}.txt | awk '{print "kikuchi_"" " "130.7817"" " "32.94500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0840_${ZY}_${ZM}.txt | awk '{print "takamori"" " "131.1250"" " "32.82167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0842_${ZY}_${ZM}.txt | awk '{print "kousa___"" " "130.8100"" " "32.64500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0843_${ZY}_${ZM}.txt | awk '{print "matusima"" " "130.4467"" " "32.51500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0845_${ZY}_${ZM}.txt | awk '{print "hondo___"" " "130.1800"" " "32.46833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0846_${ZY}_${ZM}.txt | awk '{print "yasiro__"" " "130.6067"" " "32.47333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0924_${ZY}_${ZM}.txt | awk '{print "minamata"" " "130.4067"" " "32.20500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0926_${ZY}_${ZM}.txt | awk '{print "ue______"" " "130.9050"" " "32.22500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_1081_${ZY}_${ZM}.txt | awk '{print "misumi__"" " "130.4783"" " "32.61167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_1240_${ZY}_${ZM}.txt | awk '{print "asotohim"" " "131.0400"" " "32.94000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0852_${ZY}_${ZM}.txt | awk '{print "takatiho"" " "131.2900"" " "32.71167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0857_${ZY}_${ZM}.txt | awk '{print "hyuga___"" " "131.6000"" " "32.40833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0859_${ZY}_${ZM}.txt | awk '{print "takanabe"" " "131.5267"" " "32.12333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0860_${ZY}_${ZM}.txt | awk '{print "kakutou_"" " "130.8100"" " "32.06000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0861_${ZY}_${ZM}.txt | awk '{print "saito___"" " "131.4133"" " "32.06333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0863_${ZY}_${ZM}.txt | awk '{print "kobayasi"" " "130.9533"" " "32.00000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0868_${ZY}_${ZM}.txt | awk '{print "aosima__"" " "131.4600"" " "31.80333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0872_${ZY}_${ZM}.txt | awk '{print "kusima__"" " "131.2200"" " "31.46500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1135_${ZY}_${ZM}.txt | awk '{print "furue___"" " "131.8200"" " "32.71167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1345_${ZY}_${ZM}.txt | awk '{print "nisimera"" " "131.1517"" " "32.23000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1348_${ZY}_${ZM}.txt | awk '{print "kuraoka_"" " "131.1567"" " "32.64333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1353_${ZY}_${ZM}.txt | awk '{print "mikado__"" " "131.3317"" " "32.38500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0875_${ZY}_${ZM}.txt | awk '{print "okuchi__"" " "130.6267"" " "32.04667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0878_${ZY}_${ZM}.txt | awk '{print "satumasi"" " "130.4550"" " "31.91667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0879_${ZY}_${ZM}.txt | awk '{print "nakakosi"" " "129.8667"" " "31.83500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0880_${ZY}_${ZM}.txt | awk '{print "sendai__"" " "130.3150"" " "31.83333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0883_${ZY}_${ZM}.txt | awk '{print "higasiit"" " "130.3283"" " "31.66833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0887_${ZY}_${ZM}.txt | awk '{print "kaseda__"" " "130.3250"" " "31.41500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0890_${ZY}_${ZM}.txt | awk '{print "kiire___"" " "130.5400"" " "31.38667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0893_${ZY}_${ZM}.txt | awk '{print "ibusuki_"" " "130.6367"" " "31.25000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0895_${ZY}_${ZM}.txt | awk '{print "utinoura"" " "131.0550"" " "31.27667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0935_${ZY}_${ZM}.txt | awk '{print "makinoha"" " "130.8433"" " "31.66167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0936_${ZY}_${ZM}.txt | awk '{print "shibushi"" " "131.0950"" " "31.47833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0937_${ZY}_${ZM}.txt | awk '{print "kanoya__"" " "130.8633"" " "31.39167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_1136_${ZY}_${ZM}.txt | awk '{print "tasiro__"" " "130.8433"" " "31.19833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_1146_${ZY}_${ZM}.txt | awk '{print "kihoku__"" " "130.8550"" " "31.58833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_1181_${ZY}_${ZM}.txt | awk '{print "kimotuki"" " "130.9383"" " "31.34000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
        sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0944_${ZY}_${ZM}.txt | awk '{print "kagumeyo"" " "130.8433"" " "33.74167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_82_0945_${ZY}_${ZM}.txt | awk '{print "yanagawa"" " "130.4033"" " "33.16000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0979_${ZY}_${ZM}.txt | awk '{print "yabakei_"" " "131.1150"" " "33.44500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0801_${ZY}_${ZM}.txt | awk '{print "saganose"" " "131.8650"" " "33.24833"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_83_0933_${ZY}_${ZM}.txt | awk '{print "usuki___"" " "131.7967"" " "33.13167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_84_0820_${ZY}_${ZM}.txt | awk '{print "isahaya_"" " "130.0250"" " "32.84333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_85_0825_${ZY}_${ZM}.txt | awk '{print "watada__"" " "129.9850"" " "33.42500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_1368_${ZY}_${ZM}.txt | awk '{print "itsuki__"" " "130.8267"" " "32.39500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_0946_${ZY}_${ZM}.txt | awk '{print "tanoura_"" " "130.5083"" " "32.36333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_1435_${ZY}_${ZM}.txt | awk '{print "yamae___"" " "130.7467"" " "32.30167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_86_1086_${ZY}_${ZM}.txt | awk '{print "yunomaey"" " "131.0433"" " "32.26333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1275_${ZY}_${ZM}.txt | awk '{print "mitate__"" " "131.4483"" " "32.78333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0854_${ZY}_${ZM}.txt | awk '{print "nakagoya"" " "131.3967"" " "32.56500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1432_${ZY}_${ZM}.txt | awk '{print "kitakata"" " "131.5250"" " "32.56167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1343_${ZY}_${ZM}.txt | awk '{print "morotsuk"" " "131.3350"" " "32.51667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1433_${ZY}_${ZM}.txt | awk '{print "kamisiba"" " "131.1567"" " "32.46500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0865_${ZY}_${ZM}.txt | awk '{print "kunitomi"" " "131.2967"" " "32.00667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_0862_${ZY}_${ZM}.txt | awk '{print "ebino___"" " "130.8400"" " "31.94500"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_87_1164_${ZY}_${ZM}.txt | awk '{print "fukase__"" " "131.2500"" " "31.63667"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0934_${ZY}_${ZM}.txt | awk '{print "izumi___"" " "130.3517"" " "32.09333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_1149_${ZY}_${ZM}.txt | awk '{print "ohsumi__"" " "131.0050"" " "31.58000"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_0888_${ZY}_${ZM}.txt | awk '{print "yosigabe"" " "130.8600"" " "31.46167"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -n -e ${ZD}p data_AMeDAS/AMeDAS2_88_1161_${ZY}_${ZM}.txt | awk '{print "sata____"" " "130.6900"" " "31.09333"" " $'${DATA}' }' >> data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt
	sed -e 's/)//g'  -e '/[^-.0-9a-z)_ ]/d' -e 's/--/0.0/g' data_AMeDAS/AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2B${DATA}_${ZY}_${ZM}_${ZD}.txt
#	sed -e '/\/\/\//d'  -e '/#/d' -e '/*/d' -e '/--/d' -e '/class=data_0_0/d' -e '/style="text-align:center">/d' -e '/[^.0-9a-z_ ]/d'  AMeDAS2b${DATA}_${ZY}_${ZM}_${ZD}.txt > AMeDAS2B${DATA}_${ZY}_${ZM}_${ZD}.txt
	ZD=`expr $ZD + 1`
    done


done
#mv  AMeDAS2b*.txt  data_AMeDAS/
#mv  AMeDAS2_8*.txt data_AMeDAS/