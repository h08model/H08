#/bin/sh

G1="htarray      htbin2list htcal     htcat      htcatchment"
G2="htcatts      htcreate   htedit    htformat   htid"
G3="htidw        htl2xl2y   htlinear  htlist2bin htlsmtxt"
G4="htmask       htmath     htmean    htmeantxt  htmettxt"
G5="htpercentile htpoint    htpointts htrank     htranktxt"
G6="htmaskrplc   htstat     htstattxt httime     httimetxt    htuvwind"

ALL=`echo $G1 $G2 $G3 $G4 $G5 $G6`

for COMMAND in $ALL; do
  echo
  echo ------- $COMMAND -------
  echo
  $COMMAND
done