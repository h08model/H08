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
      program htuvwind
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate wind from U and V
cby   2012/03/13, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c parameter (default)
      integer           n0if
      integer           n0of
      real              p0mis
      parameter        (n0if=15) 
      parameter        (n0of=16) 
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c temporary
      character*128     c0tmp
      real              r0tmp
c in (set)
      character*128     c0opt
c in (file)
      real,allocatable::r1u(:)
      real,allocatable::r1v(:)
      character*128     c0u
      character*128     c0v
c out
      real,allocatable::r1wind(:)
      character*128     c0wind
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get File Names
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.4) then
        write(6,*) 'Usage: htuvwind n0l c0bin1 c0bin2 c0bin3'
        write(*,*) 'c0bin1: binary containing U'
        write(*,*) 'c0bin2: binary containing V'
        write(*,*) 'c0bin3: binary containing wind speed'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0u)
      call getarg(3,c0v)
      call getarg(4,c0wind)
c
      allocate(r1u(n0l))
      allocate(r1v(n0l))
      allocate(r1wind(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0u,r1u)
      call read_binary(n0l,c0v,r1v)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1u(i0l).ne.p0mis.and.r1v(i0l).ne.p0mis)then
          r1wind(i0l)=(r1u(i0l)**2+r1v(i0l)**2)**0.5
        else
          r1wind(i0l)=p0mis
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1wind,c0wind)
c
      end














