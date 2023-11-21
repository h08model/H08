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
      program prog_clsest
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   find closest grid
cby   2010/04/08, hanasaki, NIES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c
      integer           n0l
      integer           n0x
      integer           n0y

      real              p0lonmin
      real              p0lonmax
      real              p0latmin
      real              p0latmax
c in
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      integer           i0nofgrd
      real              r0araobs
      real              r0lonorg
      real              r0latorg
      real,allocatable::r2ara(:,:)
      character*128     c0l2x
      character*128     c0l2y
      character*128     c0ifname
c temporary
      real,allocatable::r1tmp(:)
      character*128     c0tmp
c index (array)
      integer           i0x
      integer           i0xadd
      integer           i0y
      integer           i0yadd
c function
      real              rgetlon
      real              rgetlat
      integer           igeti0x
      integer           igeti0y
c local
      integer           i0xorg
      integer           i0yorg
      integer           i0xnew
      integer           i0ynew
      real              r0min
      character*128     s0center
      data              s0center/'center'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.14)then
        write(*,*) 'prog_clsest n0l n0x n0y c0l2x c0l2y'
        write(*,*) '            p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '            r0araobs r0lonorg r0latorg crivara'
        write(*,*) '            i0nofgrd'
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
      call getarg(10,c0tmp)
      read(c0tmp,*) r0araobs
      call getarg(11,c0tmp)
      read(c0tmp,*) r0lonorg
      call getarg(12,c0tmp)
      read(c0tmp,*) r0latorg
      call getarg(13,c0ifname)
      call getarg(14,c0tmp)
      read(c0tmp,*) i0nofgrd
c
      allocate(r1tmp(n0l))
      allocate(r2ara(n0x,n0y))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
c
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0ifname,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2ara)
c
      i0xorg=igeti0x(n0x,p0lonmin,p0lonmax,r0lonorg)
      i0yorg=igeti0y(n0y,p0latmin,p0latmax,r0latorg)
c     write(*,*) i0xorg,i0yorg
c
      r0min=1.0E20
      do i0yadd=-1*i0nofgrd,i0nofgrd
        do i0xadd=-1*i0nofgrd,i0nofgrd
          i0x=i0xorg+i0xadd
          i0y=i0yorg+i0yadd
c         write(*,*) i0x,i0y
          if(abs(r2ara(i0x,i0y)-r0araobs).lt.abs(r0min-r0araobs))then
            r0min=r2ara(i0x,i0y)
c           write(*,*) r0min
            i0xnew=i0x
            i0ynew=i0y
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      write(*,*) rgetlon(n0x,p0lonmin,p0lonmax,i0xnew,s0center),
     $           rgetlat(n0y,p0latmin,p0latmax,i0ynew,s0center)
c
      end
