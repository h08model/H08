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
      program htlsmtxt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate Least Square Method's a and b (y=ax+b)
cby   2010/05/20, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0rec
      parameter        (n0rec=1000) 
c index
      integer           i0rec
      integer           i0recmaxx
      integer           i0recmaxy
c in
      real              r1x(n0rec)
      real              r1y(n0rec)
      character*128     c0x
      character*128     c0y
      character*128     c0opt
c out
      real              r0a
      real              r0b
c local
      real              r0xsum
      real              r0ysum
      real              r0xysum
      real              r0x2sum
      real              r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.3)then
        write(*,*) 'Usage: htlsmtxt c0ascts(X) c0ascts(Y) OPTION'
        write(*,*) 'OPTION: ["a" or "b"]'
        write(*,*) '  a for a of y=ax+b'
        write(*,*) '  b for b of y=ax+b'
        stop
      end if
c
      call getarg(1,c0x)
      call getarg(2,c0y)
      call getarg(3,c0opt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0rec=1
      open(15,file=c0x)
 10   read(15,*,end=20,err=20) r0tmp,r0tmp,r0tmp,r1x(i0rec)
      i0rec=i0rec+1
      goto 10
 20   close(15)
      i0recmaxx=i0rec-1
c
      i0rec=1
      open(15,file=c0y)
 11   read(15,*,end=21,err=21) r0tmp,r0tmp,r0tmp,r1y(i0rec)
      i0rec=i0rec+1
      goto 11
 21   close(15)
      i0recmaxy=i0rec-1
c
      if(i0recmaxx.ne.i0recmaxy)then
        write(*,*) 'record number of X and Y does not match.'
        write(*,*) 'i0recmaxx: ',i0recmaxx
        write(*,*) 'i0recmaxy: ',i0recmaxy
        stop
      end if
c
      if(i0recmaxx.gt.n0rec)then
        write(*,*) 'Please increase n0rec in the source code.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc       
c total and average
      do i0rec=1,i0recmaxx
        r0xsum=r0xsum+r1x(i0rec)
        r0ysum=r0ysum+r1y(i0rec)
        r0xysum=r0xysum+r1x(i0rec)*r1y(i0rec)
        r0x2sum=r0x2sum+r1x(i0rec)*r1x(i0rec)
      end do
c correlation coefficient
      r0a=(i0recmaxx*r0xysum-r0xsum*r0ysum)/
     $   (i0recmaxx*r0x2sum-r0xsum**2)
      r0b=(r0x2sum*r0ysum-r0xysum*r0xsum)/
     $   (i0recmaxx*r0x2sum-r0xsum**2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write result
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'a')then
        write(*,'(f8.2)') r0a
      else if(c0opt.eq.'b')then
        write(*,'(f8.2)') r0b
      else
        write(*,*) 'c0opt: ',c0opt,' not supported.'
        stop
      end if
c
      end 
    
