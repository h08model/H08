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
      subroutine read_ascii5(
     $     c0in,
     $     r4out,
     $     i0yearmin,i0yearmax)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   read ascii time-series data
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (default)
      integer           n0yearmin
      integer           n0yearmax
      integer           n0minini
      integer           n0maxini
      integer           n0if
      integer           n0mis
      real              p0mis
      parameter        (n0yearmin=1800) 
      parameter        (n0yearmax=2300) 
      parameter        (n0minini=999999999) 
      parameter        (n0maxini=-999999999) 
      parameter        (n0if=15) 
      parameter        (p0mis=1.0E20) 
      parameter        (n0mis=-9999)
c temporary
      real              r0tmp
c function
      integer           igetday
c in
      character*128     c0in
c out
      real              r4out(0:n0yearmax-n0yearmin+1,0:12,0:31,0:24)
      integer           i0yearmin
      integer           i0yearmax
c local
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0hour
      integer           i0in
      integer           i0daymax
      character*128     c0ifname
      character*128     c0idx
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get index
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0in=len_trim(c0in)
      c0idx=c0in(i0in-1:i0in)
      c0ifname=c0in(1:i0in-2)
c
      if(c0idx.ne.'HR'.and.c0idx.ne.'3H'.and.c0idx.ne.'6H'.and.
     $   c0idx.ne.'NO')then
        write(*,*) 'read_ascii5: c0idx ',c0idx,' not supported.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r4out=p0mis
      i0yearmin=n0minini
      i0yearmax=n0maxini
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.ne.'NO')then
        open(n0if,file=c0ifname,status='old')
 55     read(n0if,*,end=99) i0year,i0mon,i0day,i0hour,r0tmp
c bug fix 2021/12/6
        if(i0hour.eq.24)then
          i0hour=0
          i0day=i0day+1
          i0daymax=igetday(i0year,i0mon)
          if(i0day.gt.i0daymax)then
            i0day=1
            i0mon=i0mon+1
            if(i0mon.eq.13)then
              i0year=i0year+1
              i0mon=1
              if(i0year.eq.1)then
                i0year=0
              end if
            end if
          end if
        end if
c bug fix end
        if(r0tmp.eq.real(n0mis))then
          r0tmp=p0mis
        end if
        i0yearmin=min(i0year,i0yearmin)
        i0yearmax=max(i0year,i0yearmax)
        if(i0year.eq.0)then
          r4out(0,i0mon,i0day,i0hour)=r0tmp
        else if(i0year.ge.n0yearmin.and.i0year.le.n0yearmax)then
          r4out(i0year-n0yearmin+1,i0mon,i0day,i0hour)=r0tmp
        else
          write(*,*) 'read_ascii5: Error'
          stop
        end if
        goto 55
 99     continue
        close(n0if)
      end if
c
      end
