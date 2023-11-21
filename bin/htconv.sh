#!/bin/sh
######################################################################
#to  convert EPS file into raster figure file
#by  2010/03/31, hanasaki: H08 ver1.0
######################################################################
if [ $# -lt 2 ] ; then
   echo "Usage : htconv c0eps c0ras [OPT]"
   echo "OPT   : [rot hr rothr]"
   echo "  rot   for rotate"
   echo "  hr    for high resolution"
   echo "  rothr for rotate and high resolution"
   exit
fi
######################################################################
if [ "$3" = "rot" ]; then
  convert -alpha off -trim -density 144 -geometry 50% -rotate 90 $1 $2
elif [ "$3" = "rothr" ]; then
  convert -alpha off -trim -density 288 -geometry 50% -rotate 90 $1 $2
elif [ "$3" = "hr" ]; then
  convert -alpha off -trim -density 288 -geometry 50% $1 $2
else
  convert -alpha off -trim -density 144 -geometry 50% $1 $2
fi
