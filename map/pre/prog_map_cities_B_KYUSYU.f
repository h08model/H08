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
      program prog_mesh
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   convert 1km gridded data into 1 arcmin by frequency
cby   hanasaki
c
c     Gridded data of approximately 1km spatial resolution is called
c     "Level-3 (in Japanese 3rd) mesh".
c     Each grid cell has 45 sec for meridional, 30 sec for longitudinal extent.
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c
      integer n0xthird          !! # of horizontal grid cells 1km data
      integer n0ythird          !! # of vertical   grid cells 1km data
      integer n0xone            !! # of horizontal grid cells 1 min data
      integer n0yone            !! # of vertical   grid cells 1 min data
      integer n0xquart          !! # of horizontal grid cells 0.25 min data (15 sec)
      integer n0yquart          !! # of vertical   grid cells 0.25 min data (15 sec)
c
      integer i0x
      integer i0y
      integer i0xx            !! temporary x
      integer i0yy            !! temporary y
      integer i0rec
      integer i0recmax
c in
      real,allocatable::r2third(:,:)  !! input in 1 km
      character*128 c0third
c out
      real,allocatable::r2one(:,:)  !! output in 1 arcmin
      character*128 c0one
c function
      real r0freq
c local
      real,allocatable::r2quart(:,:)
      real r1dat(16)
      real r0dat
      character*128 c0temp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call getarg(1,c0temp)
      read(c0temp,*)n0xone
      call getarg(2,c0temp)
      read(c0temp,*)n0yone
      call getarg(3,c0temp)
      read(c0temp,*)n0xthird
      call getarg(4,c0temp)
      read(c0temp,*)n0ythird
      call getarg(5,c0temp)
      read(c0temp,*)n0xquart
      call getarg(6,c0temp)
      read(c0temp,*)n0yquart
      call getarg(7,c0third)
      call getarg(8,c0one)
cccc
      allocate(r2third(n0xthird,n0ythird))
      allocate(r2one(n0xone,n0yone))
      allocate(r2quart(n0xquart,n0yquart))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c read data (lon:45", lat30")
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0rec=1
      open(15,file=c0third)
 10   read(15,*,end=20) r0dat,i0y,i0x
      if(i0x.ge.1.and.i0x.le.n0xthird.and.
     $   i0y.ge.1.and.i0y.le.n0ythird)then
        r2third(i0x,i0y)=r0dat
      end if
      i0rec=i0rec+1
      goto 10
 20   close(15)
      i0recmax=i0rec-1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c copy data (lon 15", lat 15")
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0y=0,n0ythird-1
        do i0x=0,n0xthird-1
          do i0xx=1,3
            do i0yy=1,2
              r2quart(i0x*3+i0xx,i0y*2+i0yy)=r2third(i0x+1,i0y+1)
            end do
          end do
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c extract the most frequent data (lon 1', lat 1')
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0y=0,n0yone-1
        do i0x=0,n0xone-1
          r1dat=-9999
          do i0xx=1,4
            do i0yy=1,4
              r1dat((i0yy-1)*4+i0xx)=r2quart(i0x*4+i0xx,i0y*4+i0yy)
            end do
          end do
          r2one(i0x+1,i0y+1)=r0freq(r1dat)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(16,file=c0one,access='direct',recl=n0xone*4)
      do i0y=1,n0yone
        write(16,rec=i0y) (r2one(i0x,i0y),i0x=1,n0xone)
      end do
      close(16)
c
      end
c    
      real function r0freq(r1dat)
c
      implicit none
c in
      real r1dat(16)
c local
      real r1unique(16)
      integer i1count(16)
      integer i0l
      integer i0flg
      integer i0ll
      integer i0filled
      integer i0countmax
c initialize
      r1unique=-9999
      i1count=0
c
      r1unique(1)=r1dat(1)
      i1count(1)=1
      i0filled=1
      do i0l=2,16
        i0flg=0
        do i0ll=1,i0filled
c        write(*,*) i0l,i0ll
          if(r1dat(i0l).eq.r1unique(i0ll))then
            i1count(i0ll)=i1count(i0ll)+1
            i0flg=1
          end if
        end do
        if(i0flg.eq.0)then
          r1unique(i0filled+1)=r1dat(i0l)
          i1count(i0filled+1)=1
          i0filled=i0filled+1
          i0flg=0
        end if
      end do
c
      i0countmax=-9999
      do i0l=1,i0filled
        if(i1count(i0l).gt.i0countmax)then
          i0countmax=i1count(i0l)
          r0freq=r1unique(i0l)
        end if
      end do
c
      end
