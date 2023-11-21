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
      subroutine wrte_ascii3(
     $     n0l,n0x,n0y,i1l2x,i1l2y,
     $     p0lonmin,p0lonmax,p0latmin,p0latmax,
     $     r1dat,
     $     c0ofname)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   write lon,lat,data formatted ascii
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
      integer           n0of
      parameter        (n0of=16) 
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
c function
      real              rgetlat
      real              rgetlon
c in
      integer           i1l2x(n0l)
      integer           i1l2y(n0l)
      real              r1dat(n0l)
c out
      character*128     c0ofname
c local
      real              r1lon(n0x)
      real              r1lat(n0y)
      real              r2dat(n0x,n0y)
      character*128     s0center
      data              s0center/'center'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1lon=0.0
      r1lat=0.0
      r2dat=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call conv_r1tor2(
     $     n0l,n0x,n0y,i1l2x,i1l2y,
     $     r1dat,
     $     r2dat)
c
      do i0y=1,n0y
        r1lat(i0y)=rgetlat(n0y,p0latmin,p0latmax,i0y,s0center)
      end do
c
      do i0x=1,n0x
        r1lon(i0x)=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0center)
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(n0of,file=c0ofname)
      do i0y=1,n0y
        do i0x=1,n0x
          write(n0of,*) r1lon(i0x),r1lat(i0y),r2dat(i0x,i0y)
        end do
      end do
      close(n0of)
c
      end
