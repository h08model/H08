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
      program htcat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   concatenate more than two files
cby   2011/06/08, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0recdat
      integer           n0reccod
      integer           n0recary
      parameter        (n0recdat=10000)
      parameter        (n0reccod=1000) 
      parameter        (n0recary=1100) 
c parameter
      integer           n0if
      real              p0mis
      parameter        (n0if=15)
      parameter        (p0mis=1.0E20) 
c index
      integer           i0reccod
      integer           i0recary
c temporary
      integer           i0tmp
c
      real              r1dat1(n0recary)
      real              r1dat2(n0recary)
      character*128     c1cod(n0reccod)
      integer           i1cod(n0recary)
      character*128     c0dat1
      character*128     c0dat2
      character*128     c0cod
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.3)then
        write(*,*) 'Usage: htcat c0lst1 c0lst2 c0cod'
        stop
      end if
c
      call getarg(1,c0dat1)
      call getarg(2,c0dat2)
      call getarg(3,c0cod)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read code
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(n0if,file=c0cod,status='old')
      i0reccod=1
 10   read(n0if,*,end=20) c1cod(i0reccod),i0tmp
      i1cod(i0tmp)=i0reccod
      i0reccod=i0reccod+1
      goto 10
 20   close(n0if)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_ascii2(
     $     n0recdat,n0reccod,n0recary,
     $     c0dat1,  c0cod,
     $     r1dat1)
c
      call read_ascii2(
     $     n0recdat,n0reccod,n0recary,
     $     c0dat2,  c0cod,
     $     r1dat2)
c      do i0recary=1,n0recary
c        write(*,*) i0recary,r1dat1(i0recary),r1dat2(i0recary)
c      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0recary=1,n0recary
        if(r1dat1(i0recary).ne.p0mis.or.r1dat2(i0recary).ne.p0mis)then
          write(*,'(a48,es16.8,es16.8)')
     $         c1cod(i1cod(i0recary)),r1dat1(i0recary),r1dat2(i0recary)
        end if
      end do
c
      end
