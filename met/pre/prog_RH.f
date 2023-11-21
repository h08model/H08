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
      program prog_RH
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert Qair into RH
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0t
      parameter        (n0t=3) 
c parameter (physical)
      integer           n0secday
      real              p0icepnt
      parameter        (p0icepnt=273.15)
      parameter        (n0secday=86400)
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20)
c temporary
      character*128     c0tmp
      character*128     s0ave
      data              s0ave/'ave'/ 
c function
      integer           igetday
c in (set)
      integer           i0yearmin
      integer           i0yearmax
c in
      real,allocatable::r1qair(:)    !! specific humidity
      real,allocatable::r1psurf(:)   !! surface pressure
      real,allocatable::r1tair(:)    !! air temperature
      character*128     c0qair
      character*128     c0psurf
      character*128     c0tair
c out
      real,allocatable::r1rh(:)      !! relative humidity
      real,allocatable::r2rh(:,:)    !! relative humidity
      character*128     c0rh
c index (time)
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0sec
c local
      integer           i0monmin
      integer           i0monmax
      integer           i0daymin
      integer           i0daymax
      integer           i0secint
      integer           i0lenrh
      character*128     c0idx
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.7)then
        write(*,*) 'Usage: prog_RH n0l c0qair c0psurf c0tair c0rh'
        write(*,*) '               i0yearmin i0yearmax'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0qair)
      call getarg(3,c0psurf)
      call getarg(4,c0tair)
      call getarg(5,c0rh)
      call getarg(6,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(7,c0tmp)
      read(c0tmp,*) i0yearmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(r1qair(n0l))
      allocate(r1psurf(n0l))
      allocate(r1tair(n0l))
      allocate(r1rh(n0l))
      allocate(r2rh(n0l,0:n0t))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read/Calculate/Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc       
      i0lenrh=len_trim(c0rh)
      c0idx=c0rh(i0lenrh-1:i0lenrh)
      if(c0idx.eq.'MO'.or.c0idx.eq.'MO'.or.c0idx.eq.'DY')then
        i0secint=86400
      else if(c0idx.eq.'6H')then
        i0secint=21600
      else if(c0idx.eq.'3H')then
        i0secint=10800
      else if(c0idx.eq.'HR')then
        i0secint=3600
      else
        write(*,*) 'prog_RH: c0idx: ',c0idx,' not supported.'
        stop
      end if
c
      do i0year=i0yearmin,i0yearmax
        i0monmin=1
        i0monmax=12
        do i0mon=i0monmin,i0monmax
          i0daymin=1
          i0daymax=igetday(i0year,i0mon)
          do i0day=i0daymin,i0daymax
            do i0sec=i0secint,n0secday,i0secint
              call read_result(
     $             n0l,
     $             c0qair     ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             r1qair     )
              call read_result(
     $             n0l,
     $             c0psurf    ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             r1psurf    )
              call read_result(
     $             n0l,
     $             c0tair     ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             r1tair     )
              call conv_qatorh(
     $             n0l,
     $             r1qair,r1psurf,r1tair,
     $             r1rh)
              call wrte_bints2(
     $             n0l,n0t,
     $             r1rh       ,r2rh,
     $             c0rh       ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             s0ave      )
            end do
          end do
        end do
      end do
c
      end
