cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Copyright (c) 2023 Dr. Naota HANASAKI, NIES
c
c Licensed under the Apache License, Version 2.0 (the "License");
c   You may not use this file except in compliance with the License.
c   You may obtain a copy of the License at:
c
c     http://www.apache.org/licenses/LICENSE-2.0
c
c Unless required by applicable law or agreed to in writing, software
c distributed under the License is distributed on an "AS IS" BASIS,
c WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
c either express or implied.
c See the License for the specific language governing permissions and
c limitations under the License.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      real function rgetlat(n0y,p0latmin,p0latmax,i0y,c0opt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   return latitudes at (i0y) in (n0y)
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
c
c       (plonmin,p0latmax)     (plonmax,p0latmax)
c         /                          /
c        /__________   ____________ /
c        |       |       |         |
c        |(1,1)  |  ...  |(n0x,1)  |
c        |_______|__   __|_________|
c        |       |                 |
c           .     .    
c           .       .
c           .         .
c        |_______|__   ____________|
c        |       |       |         |
c        |(1,n0y)|  ...  |(n0x,n0y)|
c        |_______|__   __|_________|
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0y
      real              p0latmin
      real              p0latmax
c in
      integer           i0y
      character*128     c0opt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'south')then
        rgetlat=p0latmax-(p0latmax-p0latmin)/real(n0y)*(real(i0y)-1.0)
      else if(c0opt.eq.'north')then
        rgetlat=p0latmax-(p0latmax-p0latmin)/real(n0y)*(real(i0y)-0.0)
      else
        rgetlat=p0latmax-(p0latmax-p0latmin)/real(n0y)*(real(i0y)-0.5)
      end if
c
      end

