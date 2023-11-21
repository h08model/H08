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
      real function rgetlon(n0x,p0lonmin,p0lonmax,i0x,c0opt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   return longitude at (i0x) in (n0x)
cby   2010/03/31, hanasaki, NIES: H08ver1.0
c
c       (p0lonmin,platmax)       (p0lonmax,platmax)
c         /                         /
c        /__________   ____________/
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
      integer           n0x
      real              p0lonmin
      real              p0lonmax
c in
      integer           i0x
      character*128     c0opt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'east')then
        rgetlon=p0lonmin+(p0lonmax-p0lonmin)/real(n0x)*(real(i0x)-1.0)
      else if(c0opt.eq.'west')then
        rgetlon=p0lonmin+(p0lonmax-p0lonmin)/real(n0x)*(real(i0x)-0.0)
      else
        rgetlon=p0lonmin+(p0lonmax-p0lonmin)/real(n0x)*(real(i0x)-0.5)
      end if
c
      end

