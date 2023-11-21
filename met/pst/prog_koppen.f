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
      program calc_koppen
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate Koppen's climate map
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (physics)
      integer           n0secday
      real              p0icepnt
      parameter        (n0secday=86400) 
      parameter        (p0icepnt=273.15) 
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c index (time)
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0hour
c temporary
      integer           i0cnt         !! counter
      real,allocatable::r1tmp(:)      !! temporary
      character*128     c0tmp
      character*128     c0ifname
c function
      integer           igetday
      character*128     cgetfnt
c in (set)
      integer           i0ldbg        !! debugging point
c in (met)
      real,allocatable::r2tair(:,:)   !! air temperature
      real,allocatable::r2prcp(:,:)   !! precipitation
      character*128     c0tair
      character*128     c0prcp
c out
      real,allocatable::r1koppen(:)   !! Koppen's climate classification
      real,allocatable::r1simple(:)   !! Simplified Koppen's class
      character*128     c0koppen
      character*128     c0simple
c local
      real,allocatable::r1ard(:)            !! aridity index
      real,allocatable::r1wsf(:)            !! w-s-f classification index
      integer,allocatable::i1tpt(:)         !! temperature pattern
      integer,allocatable::i1montairmin(:)  !! the month of min Tair
      integer,allocatable::i1montairmax(:)  !! the month of max Tair
      integer,allocatable::i1monprcpmin(:)  !! the month of min Prcp
      integer,allocatable::i1monprcpmax(:)  !! the month of max Prcp
      real,allocatable::r1tairmin(:)        !! min Tair
      real,allocatable::r1tairmax(:)        !! max Tair
      real,allocatable::r1prcpmin(:)        !! min Prcp
      real,allocatable::r1prcpmax(:)        !! max Prcp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.7)then
        write(*,*) 'prog_koppen n0l    i0ldbg  i0year '
        write(*,*) '            c0tair c0prcp  c0koppen c0simple'
        stop 
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) i0ldbg
      call getarg(3,c0tmp)
      read(c0tmp,*) i0year
      call getarg(4,c0tair)
      call getarg(5,c0prcp)
      call getarg(6,c0koppen)
      call getarg(7,c0simple)
c
      allocate(r1tmp(n0l))
      allocate(r2tair(n0l,0:12))
      allocate(r2prcp(n0l,0:12))
      allocate(r1koppen(n0l))
      allocate(r1simple(n0l))
      allocate(r1ard(n0l))
      allocate(r1wsf(n0l))
      allocate(i1tpt(n0l))
      allocate(i1montairmin(n0l))
      allocate(i1montairmax(n0l))
      allocate(i1monprcpmin(n0l))
      allocate(i1monprcpmax(n0l))
      allocate(r1tairmin(n0l))
      allocate(r1tairmax(n0l))
      allocate(r1prcpmin(n0l))
      allocate(r1prcpmax(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0day=0
      i0hour=0
      do i0mon=0,12
        c0ifname=cgetfnt(c0tair,i0year,i0mon,i0day,i0hour)
        call read_binary(n0l,c0ifname,r1tmp)
c
        do i0l=1,n0l
          if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).gt.0.0)then
            r2tair(i0l,i0mon)=r1tmp(i0l)-p0icepnt          
          end if
        end do
      end do
c
      do i0mon=0,12
        c0ifname=cgetfnt(c0prcp,i0year,i0mon,i0day,i0hour)
        call read_binary(n0l,c0ifname,r1tmp)
c
        do i0l=1,n0l
          if(r1tmp(i0l).ne.p0mis)then
            r2prcp(i0l,i0mon)=r1tmp(i0l)
     $           *real(igetday(i0year,i0mon))*real(n0secday)
          end if
        end do
      end do
c debug
      do i0mon=0,12
        write(*,*) 'prog_koppen: Tair&Prcp: ',
     $       r2tair(i0ldbg,i0mon),r2prcp(i0ldbg,i0mon)
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c min/max
c - initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1prcpmax=-1.0E20
      r1prcpmin=1.0E20
      i1monprcpmax=0
      i1monprcpmin=0
      r1tairmax=-1.0E20
      r1tairmin=1.0E20
      i1montairmax=0
      i1montairmin=0
c     
      do i0mon=1,12
        do i0l=1,n0l
          if(r1prcpmax(i0l).lt.r2prcp(i0l,i0mon))then
            r1prcpmax(i0l)=r2prcp(i0l,i0mon)
            i1monprcpmax(i0l)=i0mon
          end if
          if(r1tairmax(i0l).lt.r2tair(i0l,i0mon))then
            r1tairmax(i0l)=r2tair(i0l,i0mon)            
            i1montairmax(i0l)=i0mon
          end if
          if(r1prcpmin(i0l).gt.r2prcp(i0l,i0mon))then
            r1prcpmin(i0l)=r2prcp(i0l,i0mon)
            i1monprcpmin(i0l)=i0mon
          end if
          if(r1tairmin(i0l).gt.r2tair(i0l,i0mon))then
            r1tairmin(i0l)=r2tair(i0l,i0mon)            
            i1montairmin(i0l)=i0mon
          end if
        end do
      end do
c
      write(*,*) 'prog_koppen: Prcp_max: ',
     $     r1prcpmax(i0ldbg),i1monprcpmax(i0ldbg)
      write(*,*) 'prog_koppen: Prcp_min: ',
     $     r1prcpmin(i0ldbg),i1monprcpmin(i0ldbg)
      write(*,*) 'prog_koppen: Tair_max: ',
     $     r1tairmax(i0ldbg),i1montairmax(i0ldbg)
      write(*,*) 'prog_koppen: Tair_min: ',
     $     r1tairmin(i0ldbg),i1montairmin(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c w-s-f classification index (wsf)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(r2tair(i0l,i1monprcpmax(i0l)).gt.r2tair(i0l,0).and.
     $       10.0*r1prcpmin(i0l).lt.r1prcpmax(i0l))then
          r1wsf(i0l)=14
c
        else if(r2tair(i0l,i1monprcpmax(i0l)).lt.r2tair(i0l,0).and.
     $         3.0*r1prcpmin(i0l).lt.r1prcpmax(i0l).and.
     $         r1prcpmin(i0l).lt.30.0)then
          r1wsf(i0l)=0
c     
        else
          r1wsf(i0l)=7
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c temperature patern (tpt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        i0cnt=0
        do i0mon=1,12
          if(r2tair(i0l,i0mon).ge.10)then
            i0cnt=i0cnt+1
          end if
        end do
        if(i0cnt.ge.4)then
          i1tpt(i0l)=1
        else
          i1tpt(i0l)=0
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c aridity index (ard)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        r1ard(i0l)=20*(r2tair(i0l,0)+r1wsf(i0l))
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c B ( BW:21, BS:22)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(r2prcp(i0l,0).lt.0.5*r1ard(i0l))then
          r1koppen(i0l)=21
        else if(r2prcp(i0l,0).lt.r1ard(i0l))then
          r1koppen(i0l)=22
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c E ( ET=51, EF=52)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r2prcp(i0l,0).ge.r1ard(i0l))then
          if(r1tairmax(i0l).ge.0.and.r1tairmax(i0l).lt.10)then
            r1koppen(i0l)=51
          elseif(r1tairmax(i0l).lt.0)then
            r1koppen(i0l)=52
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c A ( Af=11, Am=12, Aw=13 )
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r2prcp(i0l,0).ge.r1ard(i0l))then
          if(r1tairmin(i0l).ge.18)then
            if(r1prcpmin(i0l).ge.60)then
              r1koppen(i0l)=11
            else if(r1prcpmin(i0l).lt.60.and.
     $             r1prcpmin(i0l).ge.(100-0.04*r2prcp(i0l,0)))then
              r1koppen(i0l)=12
            else if(r1prcpmin(i0l).lt.60.and.
     $             r1prcpmin(i0l).lt.(100-0.04*r2prcp(i0l,0)))then
              r1koppen(i0l)=13
            end if
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c C ( Ca=31, Cb=32, Cc=33 )
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r2prcp(i0l,0).ge.r1ard(i0l))then
          if(r1tairmin(i0l).ge.-3.and.r1tairmin(i0l).lt.18.and.
     $         r1tairmax(i0l).ge.10)then
            if(r1tairmax(i0l).ge.22)then
              r1koppen(i0l)=31
            else if(r1tairmax(i0l).ge.10.and.
     $             r1tairmax(i0l).lt.22.and.
     $             i1tpt(i0l).eq.1)then
              r1koppen(i0l)=32
            else if(r1tairmax(i0l).ge.10.and.
     $             r1tairmax(i0l).lt.22.and.
     $             i1tpt(i0l).eq.0)then
              r1koppen(i0l)=33            
            end if
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c D ( Da=41, Db=42, Dc=43 )
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r2prcp(i0l,0).ge.r1ard(i0l))then
          if(r1tairmin(i0l).lt.-3.and.r1tairmin(i0l).lt.18.and.
     $         r1tairmax(i0l).ge.10)then
            if(r1tairmax(i0l).ge.22)then
              r1koppen(i0l)=41
            else if(r1tairmax(i0l).ge.10.and.
     $             r1tairmax(i0l).lt.22.and.
     $             i1tpt(i0l).eq.1)then
              r1koppen(i0l)=42
            else if(r1tairmax(i0l).ge.10.and.
     $             r1tairmax(i0l).lt.22.and.
     $             i1tpt(i0l).eq.0)then
              r1koppen(i0l)=43            
            end if
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c simplification
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r2tair(i0l,0).eq.p0mis.or.r2tair(i0l,0).eq.0)then
          r1koppen(i0l)=0.0
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c simple
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1koppen(i0l).gt.50.0)then
          r1simple(i0l)=5.0
        else if(r1koppen(i0l).gt.40.0)then
          r1simple(i0l)=4.0
        else if(r1koppen(i0l).gt.30.0)then
          r1simple(i0l)=3.0
        else if(r1koppen(i0l).gt.20.0)then
          r1simple(i0l)=2.0
        else if(r1koppen(i0l).gt.10.0)then
          r1simple(i0l)=1.0
        else
          r1simple(i0l)=0.0
        end if
      end do      
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1koppen,c0koppen)
      call wrte_binary(n0l,r1simple,c0simple)
c
      write(*,*) r1koppen(i0ldbg)
      write(*,*) r1simple(i0ldbg)
c
      end 
