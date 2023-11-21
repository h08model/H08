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
      program httime
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   convert time resolution
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
      integer           n0t
      parameter        (n0t=3) 
c parameter (physical)
      integer           n0secday
      parameter        (n0secday=86400)
c index (array)
      integer           i0l
c index (array)
      integer           i0year
      integer           i0mon
      integer           i0monmin
      integer           i0monmax
      integer           i0day
      integer           i0daymin
      integer           i0daymax
      integer           i0sec
      integer           i0secint
c temporary
      character*128     c0tmp
c function
      integer           igetday
c in (set)
      integer           i0yearmin
      integer           i0yearmax
      integer           i0ldbg
      data              i0ldbg/1/ 
c in (flux)
      real,allocatable::r1dat(:)
      character*128     c0in
c out
      real,allocatable::r1out(:)
      real,allocatable::r2out(:,:)
      character*128     c0out
c local
      character*128     s0ave
      data              s0ave/'ave'/
      integer           i0lenin
      character*128     c0idx
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.5)then
        write(*,*) 'Usage: httime n0l'
        write(*,*) '              c0bints i0yearmin i0yearmax c0bints'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0in)
      call getarg(3,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(4,c0tmp)
      read(c0tmp,*) i0yearmax
      call getarg(5,c0out)
c
      allocate(r1dat(n0l))
      allocate(r1out(n0l))
      allocate(r2out(n0l,0:n0t))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r1out=0.0
      r2out=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0lenin=len_trim(c0in)
      c0idx=c0in(i0lenin-1:i0lenin)
      if(c0idx.eq.'MO'.or.c0idx.eq.'MO'.or.c0idx.eq.'DY')then
        i0secint=86400
      else if(c0idx.eq.'6H')then
        i0secint=21600
      else if(c0idx.eq.'3H')then
        i0secint=10800
      else if(c0idx.eq.'HR')then
        i0secint=3600
      else
        write(*,*) 'httime: c0idx: ',c0idx,' not supported.'
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
     $             c0in       ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             r1dat      )
              call wrte_bints2(
     $             n0l,n0t,
     $             r1dat      ,r2out,
     $             c0out      ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             s0ave      )
c             write(*,*) r1dat(i0ldbg),r1out(i0ldbg),
c     $             r1out_dy(i0ldbg)   ,r1out_mo(i0ldbg)   ,
c     $             r1out_yr(i0ldbg)
            end do
          end do
        end do
      end do
c
      end
