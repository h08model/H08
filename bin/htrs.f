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
      program htrs
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert Precipitation into Rain and Snow
cby   2013/02/20,hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      real              p0mis
      parameter        (p0mis=1.0E20) 
c
      integer           n0l
c index
      integer           i0l
c temp
      character*128     c0tmp
c in
      real,allocatable::r1prcp(:)
      real,allocatable::r1psurf(:)
      real,allocatable::r1qair(:)
      real,allocatable::r1tair(:)
      character*128     c0prcp
      character*128     c0psurf
      character*128     c0qair
      character*128     c0tair

c out
      real,allocatable::r1rainf(:)
      real,allocatable::r1snowf(:)
      character*128     c0rainf
      character*128     c0snowf
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.7)then
        write(*,*) 'htrs n0l c0prcp c0psurf c0qair c0tair'
        write(*,*) '     c0rainf c0snowf'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0prcp)
      call getarg(3,c0psurf)
      call getarg(4,c0qair)
      call getarg(5,c0tair)
      call getarg(6,c0rainf)
      call getarg(7,c0snowf)
c
      allocate(r1prcp(n0l))
      allocate(r1psurf(n0l))
      allocate(r1qair(n0l))
      allocate(r1tair(n0l))
      allocate(r1rainf(n0l))
      allocate(r1snowf(n0l))
c
      r1prcp=0.0
      r1psurf=0.0
      r1qair=0.0
      r1tair=0.0
      r1snowf=0.0
      r1rainf=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c in
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0prcp,r1prcp)
      call read_binary(n0l,c0psurf,r1psurf)
      call read_binary(n0l,c0qair,r1qair)
      call read_binary(n0l,c0tair,r1tair)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        r1rainf(i0l)=r1prcp(i0l)
      end do
c
c      write(*,*) r1rainf(110001)
c      write(*,*) r1snowf(110001)
c      write(*,*) r1prcp(110001)
c      write(*,*) r1psurf(110001)
c      write(*,*) r1qair(110001)
c      write(*,*) r1tair(110001)
      call conv_rstors(
     $     n0l,
     $     r1rainf,r1snowf,r1psurf,r1qair,r1tair)
c      write(*,*) r1rainf(110001)
c      write(*,*) r1snowf(110001)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1rainf,c0rainf)
      call wrte_binary(n0l,r1snowf,c0snowf)
c
      end
