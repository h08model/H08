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
      program htarray
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   shift binary array
con   2010/03/31, hanasaki: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
c temporary
      character*128     c0tmp
      real              r0tmp
      real,allocatable::r1tmp(:)
c function
      integer           iargc
c in (set)
      character*128     c0opt
c in (map)
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128     c0l2x
      character*128     c0l2y
c in (flux)
      real,allocatable::r2dat(:,:)
      character*128     c0ifname
c out
      real,allocatable::r2out(:,:)
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if (iargc().ne.8)then
        write(*,*) 'Usage: htarray n0l n0x n0y c0l2x c0l2y'
        write(*,*) '               OPTION c0bin c0bin'
        write(*,*) 'OPTION: ["upsidedown","shift"]'
        write(*,*) '  upsidedown for upsidedown'
        write(*,*) '  shift      for exchange western and eastern half'
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
      call getarg(6,c0opt)
      call getarg(7,c0ifname)
      call getarg(8,c0ofname)
c
      allocate(r1tmp(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      allocate(r2dat(n0x,n0y))
      allocate(r2out(n0x,n0y))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
      call read_binary(n0l,c0ifname,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calclulate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'upsidedown')then
        do i0y=1,n0y
          do i0x=1,n0x
            r2out(i0x,i0y)=r2dat(i0x,n0y-i0y+1)
          end do
        end do
      end if
c
      if(c0opt.eq.'shift')then
        do i0y=1,n0y
          do i0x=1,n0x/2
            r2out(i0x,i0y)=r2dat(i0x+n0x/2,i0y)
          end do
          do i0x=n0x/2+1,n0x
            r2out(i0x,i0y)=r2dat(i0x-n0x/2,i0y)
          end do
        end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,r2out,r1tmp)
      call wrte_binary(n0l,r1tmp,c0ofname)
c
      end
