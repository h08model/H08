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
      program httimetxt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert temporal resolution (fine to coarse)
cby   2010/03/31, hanasaki: H08ver1.0, modified on 2018/10/30
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (default)
      integer           n0of
      integer           n0yearmin
      integer           n0yearmax
      real              p0mis
      parameter        (n0of=15)
      parameter        (n0yearmin=1800)
      parameter        (n0yearmax=2300)
      parameter        (p0mis=1.0E20) 
c parameter (physical)
      integer           n0hourday
      parameter        (n0hourday=23) 
c index (time)
      integer           i0year
      integer           i0yearmin
      integer           i0yearmax
      integer           i0mon
      integer           i0monmin
      integer           i0monmax
      integer           i0day
      integer           i0daymin
      integer           i0daymax
      integer           i0hour
      integer           i0hourint
c function
      integer           igetday
      character*128     len_trim
c in (set)
      real              r3in(0:n0yearmax-n0yearmin+1,0:12,0:31)
      real              r4in(0:n0yearmax-n0yearmin+1,0:12,0:31,0:24)
      character*128     c0in
c out
      real              r3out(0:n0yearmax-n0yearmin+1,0:12,0:31)
      real              r4out(0:n0yearmax-n0yearmin+1,0:12,0:31,0:24)
      character*128     c0out
c local
      integer           i0in
      integer           i3cnt(0:n0yearmax-n0yearmin+1,0:12,0:31)
      integer           i4cnt(0:n0yearmax-n0yearmin+1,0:12,0:31,0:24)
      character*128     c0idx
      character*128     c0ifname
      character*128     c0tmp
      real              r0fct
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.2.and.iargc().ne.3) then
        write(6,*) 'Usage: httimetxt c0in c0out [r0fct]'
        write(*,*) 'caution: this takes simple average'
        write(*,*) 'for hourly data, apply converter (divide by r0fct).'
        stop
      end if
c
      call getarg(1,c0in)
      call getarg(2,c0out)
      if(iargc().eq.3)then
        call getarg(3,c0tmp)        
        read(c0tmp,*) r0fct
      else
        r0fct=1.0
      end if
      write(*,*) r0fct
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get index 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0in=len_trim(c0in)
      c0idx=c0in(i0in-1:i0in)
      c0ifname=c0in(1:i0in-2)
c
      if(c0idx.ne.'MO'.and.c0idx.ne.'DY'.and.
     $   c0idx.ne.'HR'.and.c0idx.ne.'3H'.and.c0idx.ne.'6H')then
        write(*,*) 'httimetxt: c0idx: ',c0idx,' not supported.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read original text
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0idx.eq.'MO'.or.c0idx.eq.'DY')then
        call read_ascii4(
     $     c0in,
     $     r3in,
     $     i0yearmin,i0yearmax)
      else
        call read_ascii5(
     $     c0in,
     $     r4in,
     $     i0yearmin,i0yearmax)
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i3cnt=0
      r3out=0.0
      i4cnt=0
      r4out=0.0
c      
      do i0year=i0yearmin,i0yearmax
        i0monmin=1
        i0monmax=12
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'YR'.or.c0idx.eq.'MO')then
            i0daymin=0
            i0daymax=0
          else
            i0daymin=1
            i0daymax=igetday(0,i0mon)
          end if
          do i0day=i0daymin,i0daymax
            if(c0idx.eq.'HR')then
              i0hourint=1
            else if(c0idx.eq.'3H')then
              i0hourint=3
            else if(c0idx.eq.'6H')then
              i0hourint=6
            else
              i0hourint=23
            end if
            do i0hour=0,n0hourday,i0hourint

d             write(*,*) i0year,i0mon,i0day,i0hour,
d    $             r3in(i0year-n0yearmin+1,i0mon,i0day)

              if(c0idx.eq.'DY')then
                if(r3in  (i0year-n0yearmin+1,i0mon,i0day).ne.p0mis)then
                  r3out(i0year-n0yearmin+1,i0mon,0)
     $           =r3out(i0year-n0yearmin+1,i0mon,0)
     $           +r3in (i0year-n0yearmin+1,i0mon,i0day)
                  i3cnt(i0year-n0yearmin+1,i0mon,0)
     $           =i3cnt(i0year-n0yearmin+1,i0mon,0)+1
c
                  r3out(i0year-n0yearmin+1,0,0)
     $           =r3out(i0year-n0yearmin+1,0,0)
     $           +r3in (i0year-n0yearmin+1,i0mon,i0day)
                  i3cnt(i0year-n0yearmin+1,0,0)
     $           =i3cnt(i0year-n0yearmin+1,0,0)+1
                end if
              else if(c0idx.eq.'HR'.or.c0idx.eq.'3H'.or.
     $                c0idx.eq.'6H')then
                if(r4in  (i0year-n0yearmin+1,i0mon,i0day,i0hour).ne.
     $               p0mis)then
                  r4out(i0year-n0yearmin+1,i0mon,i0day,24)
     $           =r4out(i0year-n0yearmin+1,i0mon,i0day,24)
     $           +r4in (i0year-n0yearmin+1,i0mon,i0day,i0hour)
                  i4cnt(i0year-n0yearmin+1,i0mon,i0day,24)
     $           =i4cnt(i0year-n0yearmin+1,i0mon,i0day,24)+1
c
                  r4out(i0year-n0yearmin+1,i0mon,0,0)
     $           =r4out(i0year-n0yearmin+1,i0mon,0,0)
     $           +r4in (i0year-n0yearmin+1,i0mon,i0day,i0hour)
                  i4cnt(i0year-n0yearmin+1,i0mon,0,0)
     $           =i4cnt(i0year-n0yearmin+1,i0mon,0,0)+1
c
                  r4out(i0year-n0yearmin+1,0,0,0)
     $           =r4out(i0year-n0yearmin+1,0,0,0)
     $           +r4in (i0year-n0yearmin+1,i0mon,i0day,i0hour)
                  i4cnt(i0year-n0yearmin+1,0,0,0)
     $           =i4cnt(i0year-n0yearmin+1,0,0,0)+1
                end if
              else if(c0idx.eq.'MO')then
                if(r3in  (i0year-n0yearmin+1,i0mon,i0day).ne.p0mis)then
                  r3out(i0year-n0yearmin+1,0,0)
     $           =r3out(i0year-n0yearmin+1,0,0)
     $           +r3in(i0year-n0yearmin+1,i0mon,0)*igetday(i0year,i0mon)
                  i3cnt(i0year-n0yearmin+1,0,0)
     $           =i3cnt(i0year-n0yearmin+1,0,0)+igetday(i0year,i0mon)
                end if
              end if

            end do
c
c daily
c
            if(c0idx.eq.'HR'.or.c0idx.eq.'3H'.or.c0idx.eq.'6H')then
              if(i4cnt(i0year-n0yearmin+1,i0mon,i0day,24).ne.0)then
                r4out(i0year-n0yearmin+1,i0mon,i0day,24)
     $         =r4out(i0year-n0yearmin+1,i0mon,i0day,24)
     $         /i4cnt(i0year-n0yearmin+1,i0mon,i0day,24)/r0fct
d               write(*,*) 'httimetxt: daily average: ',
d    $               r4out(i0year-n0yearmin+1,i0mon,i0day,24),
d    $               i4cnt(i0year-n0yearmin+1,i0mon,i0day,24)
              else
                r4out(i0year-n0yearmin+1,i0mon,i0day,24)=p0mis
              end if
            end if
c
c
c
          end do
c
c monthly
c
          if(c0idx.eq.'HR'.or.c0idx.eq.'3H'.or.c0idx.eq.'6H')then
            if(i4cnt(i0year-n0yearmin+1,i0mon,0,0).ne.0)then
              r4out(i0year-n0yearmin+1,i0mon,0,0)
     $       =r4out(i0year-n0yearmin+1,i0mon,0,0)
     $       /i4cnt(i0year-n0yearmin+1,i0mon,0,0)/r0fct
d             write(*,*) 'httimetxt: monthly average: ',
d    $             r4out(i0year-n0yearmin+1,i0mon,0,0),
d    $             i4cnt(i0year-n0yearmin+1,i0mon,0,0)
            else
c              r4out(i0year-n0yearmin+1,i0mon,i0day,0)=p0mis
              r4out(i0year-n0yearmin+1,i0mon,0,0)=p0mis
            end if
          end if
c
          if(c0idx.eq.'DY')then
            if(i3cnt(i0year-n0yearmin+1,i0mon,0).ne.0)then
              r3out(i0year-n0yearmin+1,i0mon,0)
     $       =r3out(i0year-n0yearmin+1,i0mon,0)
     $       /i3cnt(i0year-n0yearmin+1,i0mon,0)
d             write(*,*) 'httimetxt: monthly average: ',
d    $             r3out(i0year-n0yearmin+1,i0mon,0),
d    $             i3cnt(i0year-n0yearmin+1,i0mon,0)
            else
              r3out(i0year-n0yearmin+1,i0mon,0)=p0mis
            end if

          end if
c
c
c
        end do
c
c yearly
c
        if(c0idx.eq.'HR'.or.c0idx.eq.'3H'.or.c0idx.eq.'6H')then
          if(i4cnt(i0year-n0yearmin+1,0,0,0).ne.0)then
            r4out(i0year-n0yearmin+1,0,0,0)
     $     =r4out(i0year-n0yearmin+1,0,0,0)
     $     /i4cnt(i0year-n0yearmin+1,0,0,0)/r0fct
d           write(*,*) 'httimetxt: yearly average: ',
d    $           r4out(i0year-n0yearmin+1,0,0,0),
d    $           i4cnt(i0year-n0yearmin+1,0,0,0)
          else
            r4out(i0year-n0yearmin+1,0,0,0)=p0mis
          end if
        end if
c
        if(c0idx.eq.'DY'.or.c0idx.eq.'MO')then
          if(i3cnt(i0year-n0yearmin+1,0,0).ne.0)then
            r3out(i0year-n0yearmin+1,0,0)
     $     =r3out(i0year-n0yearmin+1,0,0)
     $     /i3cnt(i0year-n0yearmin+1,0,0)
d           write(*,*) 'httimetxt: yearly average: ',
d    $           r3out(i0year-n0yearmin+1,0,0),
d    $           i3cnt(i0year-n0yearmin+1,0,0)
          else
            r3out(i0year-n0yearmin+1,0,0)=p0mis
          end if
        end if
c
c
c
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.eq.'YR'.or.c0idx.eq.'MO'.or.c0idx.eq.'DY')then
        call wrte_ascii4(
     $     i0yearmin,i0yearmax,
     $     r3out,
     $     c0out)
      else if(c0idx.eq.'HR'.or.c0idx.eq.'3H'.or.c0idx.eq.'6H')then
        call wrte_ascii5(
     $     i0yearmin,i0yearmax,
     $     r4out,
     $     c0out)
      end if
c
      end






