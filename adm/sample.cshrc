############################################################
#to   provide settings for bash users
#by   2010/08/23, hanasaki, NIES: H08ver1.0
############################################################
# Do you have a path to "current directory"? If no, add such as,
############################################################
setenv PATH .:$PATH
############################################################
# Do you have a path to ncdump? If no, find it and add such as,
############################################################
setenv PATH $PATH:/sw/bin
############################################################
# Set H08 directory such as,
############################################################
setenv DIRH08 /Users/Naota/H08
############################################################
# Set Htool path
############################################################
setenv PATH .:${DIRH08}/bin:$PATH
############################################################
# H08 setting for 1deg x 1deg of globe (.one)
############################################################

setenv LONE 64800
setenv XYONE "360 180"
setenv L2XONE ${DIRH08}/map/dat/l2x_l2y_/l2x.one.txt
setenv L2YONE ${DIRH08}/map/dat/l2x_l2y_/l2y.one.txt
setenv LONLATONE "-180 180 -90 90"
#
alias createone '  htcreate  $LONE'
alias addone '     htmath    $LONE add'
alias subone '     htmath    $LONE sub'
alias mulone '     htmath    $LONE mul'
alias proone '     htmath    $LONE mul'
alias divone '     htmath    $LONE div'
alias ratone '     htmath    $LONE div'
alias maxone '     htstat    $LONE $XYONE $L2XONE $L2YONE $LONLATONE max'
alias minone '     htstat    $LONE $XYONE $L2XONE $L2YONE $LONLATONE min'
alias sumone '     htstat    $LONE $XYONE $L2XONE $L2YONE $LONLATONE sum'
alias aveone '     htstat    $LONE $XYONE $L2XONE $L2YONE $LONLATONE ave'
alias one2asc '    htformat  $LONE $XYONE $L2XONE $L2YONE $LONLATONE binary asciiu'
alias one2xyz '    htformat  $LONE $XYONE $L2XONE $L2YONE $LONLATONE binary ascii3'
alias asc2one '    htformat  $LONE $XYONE $L2XONE $L2YONE $LONLATONE asciiu binary'
alias xyz2one '    htformat  $LONE $XYONE $L2XONE $L2YONE $LONLATONE ascii3 binary'
alias shiftone '   htarray   $LONE $XYONE $L2XONE $L2YONE shift'
alias upsidedownone 'htarray $LONE $XYONE $L2XONE $L2YONE upsidedown'
alias mon2yearone 'httime    $LONE'
alias meanone '    htmean    $LONE'
alias pointone '   htpoint   $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
alias punchone '   htpointts $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
alias findone '    htmask    $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
alias maskone '    htmask    $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
alias rplcone '    htmaskrplc    $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
alias maskrplcone 'htmaskrplc    $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
alias one2eps '    htdraw    $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
alias idone '      htid      $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
alias editone '    htedit    $LONE $XYONE $L2XONE $L2YONE $LONLATONE'
############################################################
# H08 setting for 5min x 5min of Globe (.gl5)
############################################################
setenv LGL5 9331200
setenv XYGL5 "4320 2160"
setenv L2XGL5 ${DIRH08}/map/dat/l2x_l2y_/l2x.gl5.txt
setenv L2YGL5 ${DIRH08}/map/dat/l2x_l2y_/l2y.gl5.txt
setenv LONLATGL5 "-180 180 -90 90"
#
alias creategl5 '  htcreate  $LGL5'
alias addgl5 '     htmath    $LGL5 add'
alias subgl5 '     htmath    $LGL5 sub'
alias mulgl5 '     htmath    $LGL5 mul'
alias progl5 '     htmath    $LGL5 mul'
alias divgl5 '     htmath    $LGL5 div'
alias ratgl5 '     htmath    $LGL5 div'
alias maxgl5 '     htstat    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 max'
alias mingl5 '     htstat    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 min'
alias sumgl5 '     htstat    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 sum'
alias avegl5 '     htstat    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 ave'
alias gl52asc '    htformat  $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 binary asciiu'
alias gl52xyz '    htformat  $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 binary ascii3'
alias asc2gl5 '    htformat  $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 asciiu binary'
alias xyz2gl5 '    htformat  $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 ascii3 binary'
alias little2gl5 ' htformat  $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5 little binary'
alias shiftgl5 '   htarray   $LGL5 $XYGL5 $L2XGL5 $L2YGL5 shift'
alias upsidedowngl5 'htarray $LGL5 $XYGL5 $L2XGL5 $L2YGL5 upsidedown'
alias mon2yeargl5 'httime    $LGL5'
alias meangl5 '    htmean    $LGL5'
alias pointgl5 '   htpoint   $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
alias punchgl5 '   htpointts $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
alias findgl5 '    htmask    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
alias maskgl5 '    htmask    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
alias rplcgl5 '    htmaskrplc    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
alias maskrplcgl5 'htmaskrplc    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
alias gl52eps '    htdraw    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
alias idgl5 '      htid      $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
alias editgl5 '    htedit    $LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5'
############################################################
# H08 setting for 0.5deg x 0.5deg of globe (.hlf)
############################################################
setenv LHLF 259200
setenv XYHLF "720 360"
setenv L2XHLF ${DIRH08}/map/dat/l2x_l2y_/l2x.hlf.txt
setenv L2YHLF ${DIRH08}/map/dat/l2x_l2y_/l2y.hlf.txt
setenv LONLATHLF "-180 180 -90 90"
#
alias createhlf '  htcreate  $LHLF'
alias addhlf '     htmath    $LHLF add'
alias subhlf '     htmath    $LHLF sub'
alias mulhlf '     htmath    $LHLF mul'
alias prohlf '     htmath    $LHLF mul'
alias divhlf '     htmath    $LHLF div'
alias rathlf '     htmath    $LHLF div'
alias maxhlf '     htstat    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF max'
alias minhlf '     htstat    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF min'
alias sumhlf '     htstat    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF sum'
alias avehlf '     htstat    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF ave'
alias hlf2asc '    htformat  $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF binary asciiu'
alias hlf2xyz '    htformat  $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF binary ascii3'
alias asc2hlf '    htformat  $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF asciiu binary'
alias xyz2hlf '    htformat  $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF ascii3 binary'
alias shifthlf '   htarray   $LHLF $XYHLF $L2XHLF $L2YHLF shift'
alias upsidedownhlf 'htarray $LHLF $XYHLF $L2XHLF $L2YHLF upsidedown'
alias mon2yearhlf 'httime    $LHLF'
alias meanhlf '    htmean    $LHLF'
alias pointhlf '   htpoint   $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'
alias punchhlf '   htpointts $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'
alias findhlf '    htmask    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'
alias maskhlf '    htmask    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'
alias rplchlf '    htmaskrplc    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'
alias maskrplchlf 'htmaskrplc    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'
alias hlf2eps '    htdraw    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'
alias idhlf '      htid      $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'
alias edithlf '    htedit    $LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF'