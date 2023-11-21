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
      program htmeantxt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate mean of year-mon-day-data file
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (physical)
      integer           n0secday
      parameter        (n0secday=86400) 
c parameter (default)
      integer           n0of
      integer           n0yearmin
      integer           n0yearmax
      real              p0mis
      parameter        (n0of=15)
      parameter        (n0yearmin=1800)
      parameter        (n0yearmax=2300)
      parameter        (p0mis=1.0E20) 
c index (time)
      integer           i0year
      integer           i0mon
      integer           i0monmin
      integer           i0monmax
      integer           i0day
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
c in (flux)
      real              r3in(0:n0yearmax-n0yearmin+1,0:12,0:31)
      character*128     c0in
c out
      character*128     c0out
c local
      integer           i0in
      real              i2cnt(0:12,0:31)
      character*128     c0idx
      character*128     c0ifname
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().lt.2) then
        write(6,*) 'Usage: htmeantxt c0ascts c0ascts'
        stop
      end if
c
      call getarg(1,c0in)
      call getarg(2,c0out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0in=len_trim(c0in)
      c0idx=c0in(i0in-1:i0in)
      c0ifname=c0in(1:i0in-2)
c
      if(c0idx.ne.'YR'.and.c0idx.ne.'MO'.and.c0idx.ne.'DY')then
        write(*,*) 'htmeantxt: c0idx: ',c0idx,' not supported.'
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
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i2cnt=0
      do i0mon=0,12
        do i0day=0,31
          r3in(0,i0mon,i0day)=0.0
        end do
      end do
c      
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
          i0daymax=igetday(0,i0mon)
        end if
        do i0day=i0daymin,i0daymax
          i0secint=86400
          do i0sec=i0secint,n0secday,i0secint
            do i0year=i0yearmin,i0yearmax

d              write(*,*) i0year,i0mon,i0day,i0sec,
d    $             r3in(i0year-n0yearmin+1,i0mon,i0day)

              if(r3in(i0year-n0yearmin+1,i0mon,i0day).ne.p0mis)then
                  r3in(0,i0mon,i0day)
     $           =r3in(0,i0mon,i0day)
     $           +r3in(i0year-n0yearmin+1,i0mon,i0day)
                  i2cnt(i0mon,i0day)
     $           =i2cnt(i0mon,i0day)+1
              end if


            end do
            if(i2cnt(i0mon,i0day).ne.0)then
              r3in(0,i0mon,i0day)
     $             =r3in(0,i0mon,i0day)
     $             /i2cnt(i0mon,i0day)
            else
              r3in(0,i0mon,i0day)=p0mis
            end if
          end do
        end do
      end do
c debug
d      write(*,*) 'htmeantxt: i2cnt: '
d      write(*,*) (i2cnt(i0mon,0),i0mon=1,12)
d      write(*,*) 'htmeantxt: r3in: '
d      write(*,*) (r3in(0,i0mon,0),i0mon=1,12)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_ascii4(
     $     0,0,
     $     r3in,
     $     c0out)
c
      end






