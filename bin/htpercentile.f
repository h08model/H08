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
      program htpercentile
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calclulate percentile value from time series
cby   2010/05/18, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      integer           n0rec
      integer           n0secday
      parameter        (n0rec=366) 
      parameter        (n0secday=86400) 
c index (array)
      integer           i0l
      integer           i0ldbg
      data              i0ldbg/27641/ 
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
c local
      integer           i0rec
      integer           i0rec2
      integer           i0recmax
      integer           i0pickup
      integer           i0lenin
c temporary
      real              r0tmp
      real,allocatable::r1tmp(:)
      character*128     c0tmp
c in
      real,allocatable::r2dat(:,:)
      character*128     c0in
c out
      real,allocatable::r1out(:)
      character*128     c0out
c
      character*128     c0idx
      real              r0thr
c function
      character*128     cgetfnt
      integer           igetday
      integer           iargc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.6)then
        write(*,*) 'Usage: htpercentile n0l c0bints c0bin'
        write(*,*) '                    i0yearmin i0yearmax THRESHOLD'
        write(*,*) 'THRESHOLD: percentile in (%)'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0in)
      call getarg(3,c0out)
      call getarg(4,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(5,c0tmp)
      read(c0tmp,*) i0yearmax
      call getarg(6,c0tmp)
      read(c0tmp,*) r0thr
c
      allocate(r1tmp(n0l))
      allocate(r1out(n0l))
      allocate(r2dat(n0l,n0rec))
c
      i0lenin=len_trim(c0in)
      c0idx=c0in(i0lenin-1:i0lenin)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.eq.'YR')then
        i0monmin=0
        i0monmax=0
      else
        i0monmin=1
        i0monmax=12
      end if
      i0rec=0
      do i0year=i0yearmin,i0yearmax
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'DY')then
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
          else
            i0daymin=0
            i0daymax=0
          end if
          do i0day=i0daymin,i0daymax
            call read_result(n0l,c0in,i0year,i0mon,i0day,
     $                       n0secday,n0secday,r1tmp)
            i0rec=i0rec+1
            do i0l=1,n0l
              r2dat(i0l,i0rec)=r1tmp(i0l)
            end do
          end do
        end do
      end do
      i0recmax=i0rec
d     write(*,*) 'htpercentile: i0recmax: ',i0recmax
c debug
d     do i0rec=1,i0recmax
d       write(*,*) 'htpecentile: before: ',i0rec,r2dat(i0ldbg,i0rec)
d     end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Sort
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        do i0rec=1,i0recmax
          do i0rec2=i0rec+1,i0recmax
            if(r2dat(i0l,i0rec2).gt.
     $           r2dat(i0l,i0rec))then
              r0tmp=r2dat(i0l,i0rec)
              r2dat(i0l,i0rec)=r2dat(i0l,i0rec2)
              r2dat(i0l,i0rec2)=r0tmp
            end if
          end do
        end do
      end do
c debug
d     do i0rec=1,i0recmax
d       write(*,*) 'htpercentile: after: ',i0rec,r2dat(i0ldbg,i0rec)
d     end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0pickup=max(int(i0recmax*r0thr/100),1)
      write(*,*) 'htpercentile: i0pickup ',i0pickup,'th record'
c
      do i0l=1,n0l
        r1out(i0l)=r2dat(i0l,i0pickup)
      end do
c
      call wrte_binary(n0l,r1out,c0out)
c
      end
