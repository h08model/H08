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
      program calc_center
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate the lon/lat of the geographical center of basins
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c     Copyright (C) 2010,2011 Naota Hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer              n0l                 !! total cells
      integer              n0x                 !! horizontal cells
      integer              n0y                 !! vertical cells
      integer              n0rivnum            !! number of basins
      parameter           (n0rivnum=10000)
      real                 p0lonmin
      real                 p0lonmax
      real                 p0latmin
      real                 p0latmax
c index (array)
      integer              i0x
      integer              i0y
      integer              i0rivnum
c temporary
      real,allocatable::   r1tmp(:)            !! temporary
      real,allocatable::   r2tmp(:,:)          !! temporary
      character*128        c0tmp               !! temporary
      character*128        c0opt               !! option
c function
      real                 rgetlon
      real                 rgetlat
c in
      integer,allocatable::i1l2x(:)            !! land to x LUT
      integer,allocatable::i1l2y(:)            !! land to y LUT
      integer,allocatable::i2rivnum(:,:)       !! array of rivnum 
      character*128        c0l2x
      character*128        c0l2y
      character*128        c0rivnum
c out
      real,allocatable::   r1loncen(:)         !! longitude
      real,allocatable::   r1latcen(:)         !! latitude
c local
      integer,allocatable::i1cntgrd(:)         !! counter of grids
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.10)then
        write(*,*) 'calc_center n0l n0x n0y c0l2x c0l2y'
        write(*,*) '            p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '            c0rivnum'
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
      call getarg(10,c0rivnum)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(r1tmp(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      allocate(r2tmp(n0x,n0y))
      allocate(i2rivnum(n0x,n0y))
      allocate(r1loncen(n0rivnum))
      allocate(r1latcen(n0rivnum))
      allocate(i1cntgrd(n0rivnum))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
      r1loncen=0.0
      r1latcen=0.0
c local
      i1cntgrd=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read files
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(
     $     n0l,
     $     c0l2x,c0l2y,
     $     i1l2x,i1l2y)
      call read_binary(n0l,c0rivnum,r1tmp)
      call conv_r1toi2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,i2rivnum)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c calculate the center point (lon/lat) of each river basin
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c refresh matrix
      do i0rivnum=1,n0rivnum
        r1loncen(i0rivnum)=0.0
        r1latcen(i0rivnum)=0.0
        i1cntgrd(i0rivnum)=0
      end do
c sum up lon and lat and calculate number of grids
      do i0y=1,n0y
        do i0x=1,n0x
          if(i2rivnum(i0x,i0y).ge.1)then
            c0opt='center'
            r1loncen(i2rivnum(i0x,i0y))
     $           = r1loncen(i2rivnum(i0x,i0y))
     $           +rgetlon(n0x,p0lonmin,p0lonmax,i0x,c0opt)
            c0opt='center'
            r1latcen(i2rivnum(i0x,i0y))
     $           = r1latcen(i2rivnum(i0x,i0y))
     $           +rgetlat(n0y,p0latmin,p0latmax,i0y,c0opt)
            i1cntgrd(i2rivnum(i0x,i0y))=i1cntgrd(i2rivnum(i0x,i0y))+1
          end if
        end do
      end do
c calculate (lon/lat) of the center point
      do i0rivnum=1,n0rivnum
        if(i1cntgrd(i0rivnum).ge.1)then
          r1loncen(i0rivnum)=r1loncen(i0rivnum)/real(i1cntgrd(i0rivnum))
          r1latcen(i0rivnum)=r1latcen(i0rivnum)/real(i1cntgrd(i0rivnum))
          write(*,*) r1loncen(i0rivnum), r1latcen(i0rivnum)
        end if
      end do
c
      end
