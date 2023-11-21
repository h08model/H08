############################################################
#to   provide settings for bash users
#by   2010/08/23, hanasaki, NIES: H08ver1.0
############################################################
# Do you have a path to "current directory"? If no, add such as,
############################################################
export PATH=.:$PATH
############################################################
# Do you have a path to ncdump? If no, find it and add such as,
############################################################
export PATH=$PATH:/sw/bin
############################################################
# Set H08 directory such as,
############################################################
export DIRH08=/Users/Naota/H08
############################################################
# Set Htool path
############################################################
export PATH=.:${DIRH08}/bin:$PATH
############################################################
# H08 setting for 1deg x 1deg of globe (.one)
############################################################

export LONE=64800
export XYONE="360 180"
export L2XONE=${DIRH08}/map/dat/l2x_l2y_/l2x.one.txt
export L2YONE=${DIRH08}/map/dat/l2x_l2y_/l2y.one.txt
export LONLATONE="-180 180 -90 90"
export ARGONE="$LONE $XYONE $L2XONE $L2YONE $LONLATONE"
#
alias createone='    htcreate   $LONE'
alias addone='       htmath     $LONE add'
alias subone='       htmath     $LONE sub'
alias mulone='       htmath     $LONE mul'
alias proone='       htmath     $LONE mul'
alias divone='       htmath     $LONE div'
alias ratone='       htmath     $LONE div'
alias maxone='       htstat     $ARGONE max'
alias minone='       htstat     $ARGONE min'
alias sumone='       htstat     $ARGONE sum'
alias aveone='       htstat     $ARGONE ave'
alias one2asc='      htformat   $ARGONE binary asciiu'
alias one2xyz='      htformat   $ARGONE binary ascii3'
alias asc2one='      htformat   $ARGONE asciiu binary'
alias xyz2one='      htformat   $ARGONE ascii3 binary'
alias shiftone='     htarray    $LONE $XYONE $L2XONE $L2YONE shift'
alias upsidedownone='htarray    $LONE $XYONE $L2XONE $L2YONE upsidedown'
alias mon2yearone='  httime     $LONE'
alias meanone='      htmean     $LONE'
alias pointone='     htpoint    $ARGONE'
alias punchone='     htpointts  $ARGONE'
alias findone='      htmask     $ARGONE'
alias maskone='      htmask     $ARGONE'
alias rplcone='      htmaskrplc $ARGONE'
alias maskrplcone='  htmaskrplc $ARGONE'
alias one2eps='      htdraw     $ARGONE'
alias idone='        htid       $ARGONE'
alias editone='      htedit     $ARGONE'
############################################################
# H08 setting for global 5min x 5min 
############################################################
export LGL5="9331200"
export XYGL5="4320 2160"
export L2XGL5=${DIRH08}/map/dat/l2x_l2y_/l2x.gl5.txt
export L2YGL5=${DIRH08}/map/dat/l2x_l2y_/l2y.gl5.txt
export LONLATGL5="-180 180 -90 90"
export ARGGL5="$LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5"
#
alias creategl5='    htcreate   $LGL5'
alias addgl5='       htmath     $LGL5 add'
alias subgl5='       htmath     $LGL5 sub'
alias mulgl5='       htmath     $LGL5 mul'
alias progl5='       htmath     $LGL5 mul'
alias divgl5='       htmath     $LGL5 div'
alias ratgl5='       htmath     $LGL5 div'
alias maxgl5='       htstat     $ARGGL5 max'
alias mingl5='       htstat     $ARGGL5 min'
alias sumgl5='       htstat     $ARGGL5 sum'
alias avegl5='       htstat     $ARGGL5 ave'
alias gl52asc='      htformat   $ARGGL5 binary asciiu'
alias gl52xyz='      htformat   $ARGGL5 binary ascii3'
alias asc2gl5='      htformat   $ARGGL5 asciiu binary'
alias xyz2gl5='      htformat   $ARGGL5 ascii3 binary'
alias shiftgl5='     htarray    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 shift'
alias upsidedowngl5='htarray    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 upsidedown'
alias mon2yeargl5='  httime     $LGL5'
alias meangl5='      htmean     $LGL5'
alias pointgl5='     htpoint    $ARGGL5'
alias punchgl5='     htpointts  $ARGGL5'
alias findgl5='      htmask     $ARGGL5'
alias maskgl5='      htmask     $ARGGL5'
alias rplcgl5='      htmaskrplc $ARGGL5'
alias maskrplcgl5='  htmaskrplc $ARGGL5'
alias gl52eps='      htdraw     $ARGGL5'
alias idgl5='        htid       $ARGGL5'
alias editgl5='      htedit     $ARGGL5'
############################################################
# H08 setting for 0.5deg x 0.5deg of globe (.hlf)
############################################################
export LHLF=259200
export XYHLF="720 360"
export L2XHLF=${DIRH08}/map/dat/l2x_l2y_/l2x.hlf.txt
export L2YHLF=${DIRH08}/map/dat/l2x_l2y_/l2y.hlf.txt
export LONLATHLF="-180 180 -90 90"
export ARGHLF="$LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF"
#
alias createhlf='    htcreate   $LHLF'
alias addhlf='       htmath     $LHLF add'
alias subhlf='       htmath     $LHLF sub'
alias mulhlf='       htmath     $LHLF mul'
alias prohlf='       htmath     $LHLF mul'
alias divhlf='       htmath     $LHLF div'
alias rathlf='       htmath     $LHLF div'
alias maxhlf='       htstat     $ARGHLF max'
alias minhlf='       htstat     $ARGHLF min'
alias sumhlf='       htstat     $ARGHLF sum'
alias avehlf='       htstat     $ARGHLF ave'
alias hlf2asc='      htformat   $ARGHLF binary asciiu'
alias hlf2xyz='      htformat   $ARGHLF binary ascii3'
alias asc2hlf='      htformat   $ARGHLF asciiu binary'
alias xyz2hlf='      htformat   $ARGHLF ascii3 binary'
alias shifthlf='     htarray    $LHLF $XYHLF $L2XHLF $L2YHLF shift'
alias upsidedownhlf='htarray    $LHLF $XYHLF $L2XHLF $L2YHLF upsidedown'
alias mon2yearhlf='  httime     $LHLF'
alias meanhlf='      htmean     $LHLF'
alias pointhlf='     htpoint    $ARGHLF'
alias punchhlf='     htpointts  $ARGHLF'
alias findhlf='      htmask     $ARGHLF'
alias maskhlf='      htmask     $ARGHLF'
alias rplchlf='      htmaskrplc $ARGHLF'
alias maskrplchlf='  htmaskrplc $ARGHLF'
alias hlf2eps='      htdraw     $ARGHLF'
alias idhlf='        htid       $ARGHLF'
alias edithlf='      htedit     $ARGHLF'