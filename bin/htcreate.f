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
      program htcreate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   create a binary file
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (default)
      integer           n0of
      parameter        (n0of=16) 
c index (array)
      integer           i0l
c temporary
      character*128     c0tmp
c function
      integer           iargc
c in
      real              r0dat
c out
      real,allocatable::r1out(:)
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.3)then
        write(*,*) 'Usage: htcreate n0l'
        write(*,*) '                r0dat c0bin'
        stop
      end if 
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) r0dat
      call getarg(3,c0ofname)
c
      allocate(r1out(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c fill binary
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        r1out(i0l)=r0dat
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c write file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call wrte_binary(n0l,r1out,c0ofname)
c
      end
