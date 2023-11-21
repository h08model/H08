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
      program calc_rivnxl
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate downstream
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c     Copyright (C) 2010,2011 Naota Hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer              n0l
      integer              n0x
      integer              n0y
      real                 p0lonmin
      real                 p0latmin
      real                 p0lonmax
      real                 p0latmax
c index
      integer              i0l            !! index of array (land)
      integer              i0x            !! index of array (x)
      integer              i0y            !! index of array (y)
c temporary
      character*128        c0tmp          !! temporary
      real,allocatable::   r1tmp(:)       !! temporary
c function
      integer              igetnxx        !! lib/igetnxx.f
      integer              igetnxy        !! lib/igetnxy.f
      integer              igeti0l
      real                 rgetlat        !! lib/rgetlat.f
      real                 rgetlon        !! lib/rgetlon.f
      real                 rgetlen        !! lib/rgetlen.f
c in (map)
      integer,allocatable::i1l2x(:)       !! l to x 
      integer,allocatable::i1l2y(:)       !! l to y 
      real,allocatable::   r2flwdir(:,:)  !! flow direction
      character*128        c0l2x          !! l to x
      character*128        c0l2y          !! l to y
      character*128        c0flwdir       !! flow direction
c out
      real,allocatable::   r1nxl(:)       !! next l (lower stream)
      real,allocatable::   r1len(:)       !! distance to next l (lower stream)
      character*128        c0nxl          !! next l (lower stream)
      character*128        c0len          !! distance to the lower stream
c local
      integer              i0nxx          !! next x (lower stream)
      integer              i0nxy          !! next y (lower stream)
      integer              i0nxl          !! next l (lower stream)
      real                 r0len          !! distance
      real                 r0lonorg       !! longitude of origin
      real                 r0latorg       !! latitude of origin
      real                 r0londes       !! longitude of destination
      real                 r0latdes       !! latitude of destination
      character*128        c0opt          !! option
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.12)then
        write(*,*) 'calc_nxtmat n0l n0x n0y c0l2x c0l2y '
        write(*,*) '            p0lonmin p0lonmax p0latmin p0latmax '
        write(*,*) '            c0flwdir c0nxl c0len'
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
      call getarg(10,c0flwdir)
      call getarg(11,c0nxl)
      call getarg(12,c0len)
d     write(*,*) 'calc_rivnxl: n0l     ', n0l
d     write(*,*) 'calc_rivnxl: n0x     ', n0x 
d     write(*,*) 'calc_rivnxl: n0y     ', n0y 
d     write(*,*) 'calc_rivnxl: c0l2x   ', c0l2x
d     write(*,*) 'calc_rivnxl: c0l2y   ', c0l2y 
d     write(*,*) 'calc_rivnxl: c0flwdir', c0flwdir
d     write(*,*) 'calc_rivnxl: c0nxl   ', c0nxl
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      allocate(r1tmp(n0l))
      allocate(r2flwdir(n0x,n0y))
      allocate(r1nxl(n0l))
      allocate(r1len(n0l))
d     write(*,*) 'calc_rivnxl: allocation completed'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1nxl=0.0
      r1len=0.0
      i0nxx=0
      i0nxy=0
      i0nxl=0
      r0len=0.0
      r0lonorg=0.0
      r0latorg=0.0
      r0londes=0.0
      r0latdes=0.0
      c0opt=''
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
c - read i1l2x and i1l2y
c - read c0flwdir and convert to 2d
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
d     write(*,*) 'calc_rivnxl: i1l2x',i1l2x(1)
c
      call read_binary(n0l,c0flwdir,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2flwdir)
d     write(*,*) 'calc_rivnxl: read completed'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculation
c - loop start
c - get x,y,lon,lat coordinate of lower grid, and get distance 
c - convert xy coordinate to l coordinate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      c0opt='center'
      do i0x=1,n0x
        do i0y=1,n0y
c
          r0latorg=rgetlat(n0y,p0latmin,p0latmax,i0y,c0opt)
          r0lonorg=rgetlon(n0x,p0lonmin,p0lonmax,i0x,c0opt)
c
          if ((int(r2flwdir(i0x,i0y)).ge.1).and.
     $        (int(r2flwdir(i0x,i0y)).le.8)) then
            i0nxx=igetnxx(n0x,i0x,int(r2flwdir(i0x,i0y)))
            i0nxy=igetnxy(n0y,i0y,int(r2flwdir(i0x,i0y)))
            r0londes=rgetlon(n0x,p0lonmin,p0lonmax,i0nxx,c0opt)
            r0latdes=rgetlat(n0y,p0latmin,p0latmax,i0nxy,c0opt)
            r0len=rgetlen(r0lonorg,r0londes,r0latorg,r0latdes)
          else if((int(r2flwdir(i0x,i0y)).eq.9).or.
     $            (int(r2flwdir(i0x,i0y)).eq.12)) then
            i0nxx=i0x
            i0nxy=i0y
            r0londes=r0lonorg
            r0latdes=rgetlat(n0y,p0latmin,p0latmax,i0y-1,c0opt)
            r0len=rgetlen(r0lonorg,r0londes,r0latorg,r0latdes)
          else
            i0nxx=0
            i0nxy=0
            r0len=0.0
          end if
c
          i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
          i0nxl=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0nxx,i0nxy)
c
          r1nxl(i0l)=real(i0nxl)
          r1len(i0l)=r0len
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1nxl,c0nxl)
      call wrte_binary(n0l,r1len,c0len)
c
      end

            
