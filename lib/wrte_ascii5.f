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
      subroutine wrte_ascii5(
     $     i0yearmin,i0yearmax,
     $     r4out,
     $     c0out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   write ascii time-series data
cby   20100331, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (temporal)
      integer           n0yearmin
      integer           n0yearmax
      parameter        (n0yearmin=1800) 
      parameter        (n0yearmax=2300) 
c parameter (file)
      integer           n0of
      parameter        (n0of=15) 
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (time)
      integer           i0year
      integer           i0mon
      integer           i0monmin
      integer           i0monmax
      integer           i0day
      integer           i0daymin
      integer           i0daymax
      integer           i0hour
      integer           i0hourint
      integer           i0hourini
      integer           i0hourday
c function
      integer           igetday
      character*128     len_trim
c temporary
      real              r0tmp
c in
      integer           i0yearmin
      integer           i0yearmax
      real              r4out(0:n0yearmax-n0yearmin+1,0:12,0:31,0:24)
c out
      character*128     c0out
c local
      integer           i0out
      character*128     c0idx
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Basic info
c - get total number of charcter of c0in
c - get Index (final two character) of c0in
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0out=len_trim(c0out)
      c0idx=c0out(i0out-1:i0out)
      c0ofname=c0out(1:i0out-2)
c
      if(c0idx.ne.'YR'.and.c0idx.ne.'MO'.and.c0idx.ne.'DY'.and.
     $   c0idx.ne.'MY'.and.c0idx.ne.'MM'.and.c0idx.ne.'MD'.and.
     $   c0idx.ne.'HR')then
        write(*,*) 'wrte_ascii5: c0idx ',c0idx,' not supported.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.ne.'NO')then
        open(n0of,file=c0ofname)
        do i0year=i0yearmin,i0yearmax
         if(c0idx.eq.'YR'.or.c0idx.eq.'MY')then
            i0monmin=0
            i0monmax=0
          else
            i0monmin=1
            i0monmax=12
          end if
          do i0mon=i0monmin,i0monmax
            if(c0idx.eq.'DY'.or.c0idx.eq.'MD'.or.c0idx.eq.'HR')then
              i0daymin=1
              i0daymax=igetday(i0year,i0mon)
            else
              i0daymin=0
              i0daymax=0
            end if
            do i0day=i0daymin,i0daymax
              if(c0idx.eq.'HR')then
                i0hourini=0
                i0hourday=23
                i0hourint=1
              else
                i0hourini=24
                i0hourday=24
                i0hourint=1
              end if              
              do i0hour=i0hourini,i0hourday,i0hourint
                if(c0idx.eq.'YR'.or.c0idx.eq.'MO'.or.c0idx.eq.'DY')then
                  if(i0year.eq.0)then
                    r0tmp=r4out(0,i0mon,i0day,24)
                    if(r0tmp.eq.p0mis)then
                      r0tmp=-9999.0
                    end if
                    write(n0of,*) i0year,i0mon,i0day,r0tmp
                  else
                    r0tmp=r4out(i0year-n0yearmin+1,i0mon,i0day,24)
                    if(r0tmp.eq.p0mis)then
                      r0tmp=-9999.0
                    end if
                    write(n0of,*) i0year,i0mon,i0day,r0tmp
                  end if
                else if(c0idx.eq.'HR')then
                  if(i0year.eq.0)then
                    r0tmp=r4out(0,i0mon,i0day,i0hour)
                    if(r0tmp.eq.p0mis)then
                      r0tmp=-9999.0
                    end if
                    write(n0of,*) i0year,i0mon,i0day,i0hour,r0tmp
                  else
                    r0tmp=r4out(i0year-n0yearmin+1,i0mon,i0day,i0hour)
                    if(r0tmp.eq.p0mis)then
                      r0tmp=-9999.0
                    end if
                    write(n0of,*) i0year,i0mon,i0day,i0hour,r0tmp
                  end if                
                end if
              end do
            end do
          end do
        end do
        close(n0of)
      end if
c
      end
