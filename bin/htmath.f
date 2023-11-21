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
      program htmath
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate binary files
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c parameter (default)
      integer           n0if
      integer           n0of
      real              p0mis
      parameter        (n0if=15) 
      parameter        (n0of=16) 
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c temporary
      character*128     c0tmp
      real              r0tmp
c function
      integer           is_char
c in (set)
      character*128     c0opt
c in (file)
      real,allocatable::r1dat1(:)
      real,allocatable::r1dat2(:)
      character*128     c0ifname1
      character*128     c0ifname2
c out
      real,allocatable::r1out(:)
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get File Names
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.5) then
        write(6,*) 'Usage: htmath n0l OPTION c0bin IN c0bin'
        write(*,*) 'OPTION: ["add","sub","mul","div"]'
        write(*,*) 'IN:     [c0bin,r0dat]'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0opt)
      call getarg(3,c0ifname1)
      call getarg(4,c0ifname2)
      call getarg(5,c0ofname)
c
      allocate(r1dat1(n0l))
      allocate(r1dat2(n0l))
      allocate(r1out(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0ifname1,r1dat1)
c
      if(is_char(c0ifname2).eq.1)then
        call read_binary(n0l,c0ifname2,r1dat2)
      else
        read(c0ifname2,*) r0tmp
        do i0l=1,n0l
          r1dat2(i0l)=r0tmp
        end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'add')then
        do i0l=1,n0l
          if(r1dat1(i0l).ne.p0mis.and.r1dat2(i0l).ne.p0mis)then
            r1out(i0l)=r1dat1(i0l)+r1dat2(i0l)
          else
            r1out(i0l)=p0mis
          end if
        end do
      else if(c0opt.eq.'sub')then
        do i0l=1,n0l
          if(r1dat1(i0l).ne.p0mis.and.r1dat2(i0l).ne.p0mis)then
            r1out(i0l)=r1dat1(i0l)-r1dat2(i0l)
          else
            r1out(i0l)=p0mis
          end if
        end do
      else if(c0opt.eq.'mul')then
        do i0l=1,n0l
          if(r1dat1(i0l).ne.p0mis.and.r1dat2(i0l).ne.p0mis)then
            r1out(i0l)=r1dat1(i0l)*r1dat2(i0l)
          else
            r1out(i0l)=p0mis
          end if
        end do
      else if(c0opt.eq.'div')then
        do i0l=1,n0l
          if(r1dat1(i0l).ne.p0mis.and.r1dat2(i0l).ne.p0mis.and.
     $       r1dat2(i0l).ne.0.0)then
            r1out(i0l)=r1dat1(i0l)/r1dat2(i0l)
          else
            r1out(i0l)=p0mis
          end if
        end do
      else
        write(*,*) 'c0opt: ', c0opt, ' not supported. Stop.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1out,c0ofname)
c
      end














