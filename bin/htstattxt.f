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
      program htstattxt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate text data
cby   2010/08/23, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (default)
      integer           n0of
      integer           n0yearmin
      integer           n0yearmax
      real              p0mis
      real              p0minini
      real              p0maxini
      parameter        (n0of=15)
      parameter        (n0yearmin=1800)
      parameter        (n0yearmax=2300)
      parameter        (p0mis=1.0E20) 
      parameter        (p0minini=9.9E20) 
      parameter        (p0maxini=-9.9E20) 
c parameter (physical)
      integer           n0secday
      parameter        (n0secday=86400) 
c index (time)
      integer           i0year
      integer           i0year_min
      integer           i0year_max
      integer           i0mon
      integer           i0mon_min
      integer           i0mon_max
      integer           i0monmin
      integer           i0monmax
      integer           i0day
      integer           i0day_min
      integer           i0day_max
      integer           i0daymin
      integer           i0daymax
      integer           i0sec
      integer           i0secint
c function
      integer           igetday
      character*128     len_trim
c in (set)
      integer           i0yearmin
      integer           i0yearmax
      real              r3in(0:n0yearmax-n0yearmin+1,0:12,0:31)
      character*128     c0in
      character*128     c0opt
c out
      real              r0sum
      real              r0ave
      real              r0min
      real              r0max
c local
      integer           i0in
      integer           i0cnt
      real              r0in
      character*128     c0idx
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.2) then
        write(6,*) 'Usage: htstattxt OPTION c0ascts'
        write(*,*) 'OPTION: ["min","max","sum","ave"]'
        stop
      end if
c
      call getarg(1,c0opt)
      call getarg(2,c0in)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get index 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0in=len_trim(c0in)
      c0idx=c0in(i0in-1:i0in)
c
      if(c0idx.ne.'YR'.and.c0idx.ne.'MO'.and.c0idx.ne.'DY')then
        write(*,*) 'htstattxt: c0idx: ',c0idx,' not supported.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read original text
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_ascii4(
     $     c0in,
     $     r3in,
     $     i0yearmin,i0yearmax)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r0sum=0.0
      i0cnt=0
      r0max=p0maxini
      r0min=p0minini
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0year=i0yearmin,i0yearmax
        if(c0idx.eq.'YR')then
          i0monmin=0
          i0monmax=0
        else
          i0monmin=1
          i0monmax=12
        end if
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'YR'.or.c0idx.eq.'MO')then
            i0daymin=0
            i0daymax=0
          else
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
          end if
          do i0day=i0daymin,i0daymax
            i0secint=86400
            do i0sec=i0secint,n0secday,i0secint
d             write(*,*) i0year,i0mon,i0day,i0sec,
d    $              r3in(i0year-n0yearmin+1,i0mon,i0day)
              if(i0year.eq.0)then
                r0in=r3in(0,i0mon,i0day)
              else
                r0in=r3in(i0year-n0yearmin+1,i0mon,i0day)
              end if
              if(r0in.ne.p0mis)then
                r0sum=r0sum+r0in
                i0cnt=i0cnt+1
c                r0min=min(r0min,r0in)
                if(r0in.lt.r0min)then
                  r0min=r0in
                  i0year_min=i0year
                  i0mon_min=i0mon
                  i0day_min=i0day
                end if
c                r0max=max(r0max,r0in)
                if(r0in.gt.r0max)then
                  r0max=r0in
                  i0year_max=i0year
                  i0mon_max=i0mon
                  i0day_max=i0day
                end if
              end if
            end do
          end do
        end do
      end do
c
      if(i0cnt.ne.0)then
        r0ave=r0sum/real(i0cnt)
      else
        r0ave=p0mis
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0opt.eq.'max')then
        write(*,*) r0max,i0year_max,i0mon_max,i0day_max
      else if(c0opt.eq.'min')then
        write(*,*) r0min,i0year_min,i0mon_min,i0day_min
      else if(c0opt.eq.'sum')then
        write(*,*) r0sum
      else if(c0opt.eq.'ave')then
        write(*,*) r0ave
      end if
c
      end






