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
      program prog_cwd
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calcluate cumulative withdrawal to demand ratio
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c parameter (physical)
      integer           n0secday
      parameter        (n0secday=86400) 
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c index (time)
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0sec
      integer           i0secint
c temporary
      character*128     c0tmp
c function
      integer           igetday
c in (set)
      integer           i0yearmin
      integer           i0yearmax
c in (flux)
      real,allocatable::r1demagr(:)
      real,allocatable::r1demind(:)
      real,allocatable::r1demdom(:)
      real,allocatable::r1supagr(:)
      real,allocatable::r1supind(:)
      real,allocatable::r1supdom(:)
      character*128     c0demagr
      character*128     c0demind
      character*128     c0demdom
      character*128     c0supagr
      character*128     c0supind
      character*128     c0supdom
c out 
      real,allocatable::r1cwd(:)
      character*128     c0cwd
c local
      real,allocatable::r1cw(:)   !! cumulative withdrawal
      real,allocatable::r1cd(:)   !! cumulative demand
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.10)then
        write(*,*) 'prog_cwd n0l i0yearmin i0yearmax'
        write(*,*) '         c0demagr c0demind c0demdom'
        write(*,*) '         c0supagr c0supind c0supdom'
        write(*,*) '         c0cwd'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(3,c0tmp)
      read(c0tmp,*) i0yearmax
      call getarg(4,c0demagr)
      call getarg(5,c0demind)
      call getarg(6,c0demdom)
      call getarg(7,c0supagr)
      call getarg(8,c0supind)
      call getarg(9,c0supdom)
      call getarg(10,c0cwd)
c
      allocate(r1demagr(n0l))
      allocate(r1demind(n0l))
      allocate(r1demdom(n0l))
      allocate(r1supagr(n0l))
      allocate(r1supind(n0l))
      allocate(r1supdom(n0l))
      allocate(r1cwd(n0l))
      allocate(r1cw(n0l))
      allocate(r1cd(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0sec=n0secday
      i0secint=n0secday
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0year=i0yearmin,i0yearmax
        do i0mon=1,12
          do i0day=1,igetday(i0year,i0mon)
            call read_result(
     $      n0l,c0demagr,i0year,i0mon,i0day,i0sec,i0secint,r1demagr)
            call read_result(
     $      n0l,c0demind,i0year,i0mon,i0day,i0sec,i0secint,r1demind)
            call read_result(
     $      n0l,c0demdom,i0year,i0mon,i0day,i0sec,i0secint,r1demdom)
            call read_result(
     $      n0l,c0supagr,i0year,i0mon,i0day,i0sec,i0secint,r1supagr)
            call read_result(
     $      n0l,c0supind,i0year,i0mon,i0day,i0sec,i0secint,r1supind)
            call read_result(
     $      n0l,c0supdom,i0year,i0mon,i0day,i0sec,i0secint,r1supdom)
            do i0l=1,n0l
              r1cw(i0l)=r1cw(i0l)
     $             +r1supagr(i0l)+r1supind(i0l)+r1supdom(i0l)
              if(r1demagr(i0l).ne.p0mis)then
                r1cd(i0l)=r1cd(i0l)+r1demagr(i0l)
              end if
              if(r1demind(i0l).ne.p0mis)then
                r1cd(i0l)=r1cd(i0l)+r1demind(i0l)
              end if
              if(r1demdom(i0l).ne.p0mis)then
                r1cd(i0l)=r1cd(i0l)+r1demdom(i0l)
              end if
            end do
          end do
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1cd(i0l).ne.p0mis.and.r1cd(i0l).ne.0.0)then
          r1cwd(i0l)=r1cw(i0l)/r1cd(i0l)
        else
          r1cwd(i0l)=1.0E20
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1cwd,c0cwd)
c
      end
