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
      program prog_riv_WATCH
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare flow direction
cby   2010/09/20, hanasaki, NIES:
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer           n0l
      integer           n0x
      parameter        (n0l=259200) 
      parameter        (n0x=720) 
c index
      integer           i0l
      integer           i0x
      integer           i0y
c in
      real              r1dat(n0l)
      character*128     c0ifname
c out
      real              r1out(n0l)
      character*128     c0ofname
c local
      integer           i0cnt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.2)then
        write(*,*) 'prog_flwdir_WATCH'
        stop
      end if
c
      call getarg(1,c0ifname)
      call getarg(2,c0ofname)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        r1dat(i0l)=-9999.0
      end do
c 
      open(15,file=c0ifname)
      do i0y=13,292
        read(15,*) (r1dat((i0y-1)*n0x+i0x),i0x=1,n0x)
      end do
      close(15)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0cnt=0
      do i0l=1,n0l
        if(r1dat(i0l).eq.0)then
          r1out(i0l)=9.0
          i0cnt=i0cnt+1
        else if(r1dat(i0l).ge.1.and.r1dat(i0l).le.6)then
          r1out(i0l)=r1dat(i0l)+2.0
          i0cnt=i0cnt+1
        else if(r1dat(i0l).ge.7.and.r1dat(i0l).le.8)then
          r1out(i0l)=r1dat(i0l)-6.0
          i0cnt=i0cnt+1
        else if(r1dat(i0l).eq.9)then
          r1out(i0l)=9.0
          i0cnt=i0cnt+1
        else
          r1out(i0l)=0.0
        end if
      end do
      write(*,*) i0cnt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1out,c0ofname)
c
      end
