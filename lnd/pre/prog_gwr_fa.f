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
      program prog_gwr_ft
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
c     Algorithm by Doll and Fiedler (2008, HESS)
c     Geological data by Geological Survey of Canada (GSC)
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      real              p0mis
      real              p0frzpnt
      parameter        (p0mis=1.0E20) 
      parameter        (p0frzpnt=273.15) 
c index
      integer           i0l
c temporary
      character*128     c0tmp
c in
      real,allocatable::r1geolog(:)     !! geological type by GSC 
      real,allocatable::r1tair(:) !! mean air temperature [kg/m2/s]
      real,allocatable::r1prcp(:) !! mean precipitation [kg/m2/s]
      character*128     c0geolog        
      character*128     c0tair
      character*128     c0prcp
c out
      real,allocatable::r1fa(:)         !! 
      character*128     c0fa
c local
      integer,allocatable::i1id(:)
c 
      integer           i1c2d(3)
      data              i1c2d/1,2,3/
      real              r1optfa1(3)
      data              r1optfa1/1.0,0.7,0.5/
      real              r1optfa2(3)
      data              r1optfa2/1.0,0.8,0.7/
      integer           i0ldbg
c bug      data              i0ldbg/79112/
      data              i0ldbg/1/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.5) then
        write(6,*) 'Usage: prog_gwr_fa n0l  c0geolog c0tair c0prcp'
        write(*,*) '                   c0fa'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0geolog)
      call getarg(3,c0tair)
      call getarg(4,c0prcp)
      call getarg(5,c0fa)
c
      allocate(r1geolog(n0l))
      allocate(r1tair(n0l))
      allocate(r1prcp(n0l))
      allocate(r1fa(n0l))
      allocate(i1id(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0geolog,r1geolog)
      call read_binary(n0l,c0tair,r1tair)
      call read_binary(n0l,c0prcp,r1prcp)
c
      write(*,*) '[prog_gwr_fa] r1geolog(i0l):',r1geolog(i0ldbg)
      write(*,*) '[prog_gwr_fa] r1tair(i0l):  ',r1tair(i0ldbg)-p0frzpnt
      write(*,*) '[prog_gwr_fa] r1prcp(i0l):  ',r1prcp(i0ldbg)
     $                                          *86400.0*365.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c convert
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        i1id(i0l)=real(i1c2d(int(r1geolog(i0l))))
c bug  
        r1fa(i0l)=r1optfa1(i1id(i0l))
        if(r1tair(i0l).gt.15.0+p0frzpnt.and.
     $     r1prcp(i0l)*86400.0*365.0.gt.1000.0)then
          r1fa(i0l)=r1optfa2(i1id(i0l))
        end if
      end do
c
      write(*,*) '[prog_gwr_fa] i1id(i0l):    ',i1id(i0ldbg)
      write(*,*) '[prog_gwr_fa] r1fa(i0l):    ',r1fa(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1fa,c0fa)
c
      end
