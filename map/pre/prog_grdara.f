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
      program prog_grdara
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate grid area 
cby   2010/09/30, hanasaki, NIES: H08ver1.0
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
c index (array)
      integer           i0x
      integer           i0y
c temporary
      character*128     c0tmp
      real,allocatable::r2tmp(:,:)
c function
      real              rgetlon
      real              rgetlat
      real              rgetara
c in (map)
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128     c0l2x
      character*128     c0l2y
c out
      real,allocatable::r1grdara(:)
      character*128     c0grdara
c local
      real              r0lon1
      real              r0lon2
      real              r0lat1
      real              r0lat2
      character*128     c0opt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.10)then
        write(*,*) 'prog_grdara n0l n0x n0y c0l2x c0l2y'
        write(*,*) '            p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '            c0grdara'
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
      call getarg(10,c0grdara)
c
      allocate(r2tmp(n0x,n0y))
      allocate(r1grdara(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c     
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
c
      do i0y=1,n0y
        do i0x=1,n0x
          c0opt='east'
          r0lon1=rgetlon(n0x,p0lonmin,p0lonmax,i0x,c0opt)
          c0opt='west'
          r0lon2=rgetlon(n0x,p0lonmin,p0lonmax,i0x,c0opt)
          c0opt='north'
          r0lat1=rgetlat(n0y,p0latmin,p0latmax,i0y,c0opt)
          c0opt='south'
          r0lat2=rgetlat(n0y,p0latmin,p0latmax,i0y,c0opt)
          r2tmp(i0x,i0y)=rgetara(r0lon1,r0lon2,r0lat1,r0lat2)
        end do
      end do
c
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,r2tmp,r1grdara)
      call wrte_binary(n0l,r1grdara,c0grdara)
c
      end
