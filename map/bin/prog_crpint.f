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
      program prog_crpint
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare crop interval file
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c index (array)
      integer           i0l
c temporary
      character*128     c0tmp
c in
      real,allocatable::r1crpint(:)
      character*128     c0crpint
c out
      real,allocatable::r1crpint1st(:)
      real,allocatable::r1crpint2nd(:)
      character*128     c0crpint1st
      character*128     c0crpint2nd
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.4)then
        write(*,*) 'Usage: prog_crpint n0l '
        write(*,*) '                   c0crpint c0crpint1st c0crpint2nd'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0crpint)
      call getarg(3,c0crpint1st)
      call getarg(4,c0crpint2nd)
c
      allocate(r1crpint(n0l))
      allocate(r1crpint1st(n0l))
      allocate(r1crpint2nd(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1crpint1st=0.0
      r1crpint2nd=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0crpint,r1crpint)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1crpint(i0l).gt.1.0)then
          r1crpint1st(i0l)=1.0
        else
          r1crpint1st(i0l)=r1crpint(i0l)
        end if
      end do
c
      do i0l=1,n0l
        if(r1crpint1st(i0l).eq.1.0)then
          r1crpint2nd(i0l)=r1crpint(i0l)-r1crpint1st(i0l)
        else
          r1crpint2nd(i0l)=0.0
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1crpint1st,c0crpint1st)
      call wrte_binary(n0l,r1crpint2nd,c0crpint2nd)
c
      end
