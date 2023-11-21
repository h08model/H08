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
      subroutine read_ascii3(
     $     n0l,n0x,n0y,i1l2x,i1l2y,
     $     p0lonmin,p0lonmax,p0latmin,p0latmax,
     $     c0ifname,
     $     r1out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   read lon,lat,data formatted ascii
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
      real              p0lonmin
      real              p0lonmax
      real              p0latmin
      real              p0latmax
c parameter (default)
      integer           n0if
      parameter        (n0if=15) 
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
c function
      integer           igeti0x
      integer           igeti0y
c in
      character*128     c0ifname
      integer           i1l2x(n0l)
      integer           i1l2y(n0l)
c out
      real              r1out(n0l)
c local
      real              r0lon
      real              r0lat
      real              r0out
      real              r2out(n0x,n0y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1out=0.0
      r0lon=0.0
      r0lat=0.0
      r0out=0.0
      r2out=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(n0if,file=c0ifname,status='old')
c      do i0l=1,n0l
 10   read(n0if,*,end=20) r0lon,r0lat,r0out
        i0x=igeti0x(n0x,p0lonmin,p0lonmax,r0lon)
        i0y=igeti0y(n0y,p0latmin,p0latmax,r0lat)
        r2out(i0x,i0y)=r0out
        go to 10
c      end do
 20    close(n0if)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,
     $     r2out,
     $     r1out)
c
      end
