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
      program prog_WDD
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare EU-WATCH Driving Data
cby   2010/09/11, hanasaki, NIES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer           n0l
      integer           n0t
      parameter        (n0t=3) 
c parameter
      integer           n0secday
      real              p0mis
      parameter        (n0secday=86400)
      parameter        (p0mis=1.0E20) 
c index 
      integer           i0l
c index
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0sec
c temporary
      real              r0tmp
      real,allocatable::r1tmp(:)
      real,allocatable::r2tmp(:,:)
      character*128     c0tmp
c function
      integer           igetday
c in
      integer           n0rec
      integer,allocatable::i1lndmsk(:)           
      real,allocatable::r1dat(:)
      character*128     c0dat
      character*128     c0lndmsk
c out
      character*128     c0out
c local
      integer           i0rec
      character*128     s0ave
      data              s0ave/'ave'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.6)then
        write(*,*) 'prog_WDD n0l n0rec c0dat c0out i0year c0lndmsk'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) n0rec
      call getarg(3,c0dat)
      call getarg(4,c0out)
      call getarg(5,c0tmp)
      read(c0tmp,*) i0year
      call getarg(6,c0lndmsk)
c
      allocate(r1dat(n0l*n0rec))
      allocate(r1tmp(n0l))
      allocate(r2tmp(n0l,0:n0t))
      allocate(i1lndmsk(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0lndmsk,r1tmp)
      do i0l=1,n0l
        i1lndmsk(i0l)=int(r1tmp(i0l))
      end do
c
      call read_asciiu(n0l*n0rec,c0dat,r1dat)
c
      i0rec=0
      do i0mon=1,12
        do i0day=1,igetday(i0year,i0mon)   !! is it ok??
          do i0sec=n0secday,n0secday,n0secday
c
            do i0l=1,n0l
              if(i1lndmsk(i0l).eq.1)then
                r1tmp(i0l)=r1dat(i0rec*n0l+i0l)
              else
                r1tmp(i0l)=p0mis
              end if
            end do
c
            call wrte_bints2(
     $           n0l,n0t,
     $           r1tmp,r2tmp,
     $           c0out,i0year,i0mon,i0day,i0sec,n0secday,
     $           s0ave)
c
            i0rec=i0rec+1
          end do
        end do
      end do
c
      end
