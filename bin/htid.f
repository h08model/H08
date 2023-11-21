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
      program htid
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert l, xy, and lonlat coordinate
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer              n0l
      integer              n0x
      integer              n0y
      real                 p0lonmin
      real                 p0lonmax
      real                 p0latmin
      real                 p0latmax
c index (array)
      integer              i0l
      integer              i0x
      integer              i0y
c temporary
      character*128        c0tmp
      character*128        s0center
      data                 s0center/'center'/ 
c function
      integer              igeti0x
      integer              igeti0y
      integer              igeti0l
      real                 rgetlon
      real                 rgetlat
c in (set)
      real                 r0lon
      real                 r0lat
      character*128        c0opt
c in (map)
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128        c0l2x
      character*128        c0l2y
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.12.and.iargc().ne.11)then
        write(*,*) 'Usage: htid n0l n0x n0y c0l2x c0l2y'
        write(*,*) '            p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '            OPTION'
        write(*,*) 'OPTION: [{"lonlat" r0lon r0lat}'
        write(*,*) '         {"xy"     i0x i0y}'
        write(*,*) '         {"l"      i0l}]'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) n0x
      call getarg(3,c0tmp)
      read(c0tmp,*) n0y
      call getarg(4,c0l2x)
      call getarg(5,c0l2y)
      call getarg(6,c0tmp)
      read(c0tmp,*) p0lonmin
      call getarg(7,c0tmp)
      read(c0tmp,*) p0lonmax
      call getarg(8,c0tmp)
      read(c0tmp,*) p0latmin
      call getarg(9,c0tmp)
      read(c0tmp,*) p0latmax
      call getarg(10,c0opt)
      if(c0opt.eq.'lonlat')then
        call getarg(11,c0tmp)
        read(c0tmp,*) r0lon
        call getarg(12,c0tmp)
        read(c0tmp,*) r0lat
      else if(c0opt.eq.'xy')then
        call getarg(11,c0tmp)
        read(c0tmp,*) i0x
        call getarg(12,c0tmp)
        read(c0tmp,*) i0y
      else if(c0opt.eq.'l')then
        call getarg(11,c0tmp)
        read(c0tmp,*) i0l        
      end if
c
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'lonlat')then
        i0x=igeti0x(n0x,p0lonmin,p0lonmax,r0lon)
        i0y=igeti0y(n0y,p0latmin,p0latmax,r0lat)
        i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
        write(*,*) i0x,i0y,i0l
      else if(c0opt.eq.'xy')then
        r0lon=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0center)
        r0lat=rgetlat(n0y,p0latmin,p0latmax,i0y,s0center)
        i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
        write(*,*) r0lon,r0lat,i0l
      else if(c0opt.eq.'l')then
        i0x=i1l2x(i0l)
        i0y=i1l2y(i0l)
        r0lon=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0center)
        r0lat=rgetlat(n0y,p0latmin,p0latmax,i0y,s0center)
        write(*,*) r0lon,r0lat,i0x,i0y
      else
        write(*,*) 'htid: c0opt: ',c0opt,' not supported.'
        stop
      end if
c
      end
