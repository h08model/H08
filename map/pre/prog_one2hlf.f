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
      program prog_WATCH_Albedo
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer           n0lin
      integer           n0xin
      integer           n0yin
      integer           n0lout
      integer           n0xout
      integer           n0yout
      parameter        (n0lin=64800) 
      parameter        (n0xin=360) 
      parameter        (n0yin=180) 
      parameter        (n0lout=259200) 
      parameter        (n0xout=720) 
      parameter        (n0yout=360) 
c
      character*128     c0l2xin
      character*128     c0l2yin
      integer           i1l2xin(n0lin)
      integer           i1l2yin(n0lin)
      character*128     c0l2xout
      character*128     c0l2yout
      integer           i1l2xout(n0lout)
      integer           i1l2yout(n0lout)
c index
      integer           i0l
      integer           i0x
      integer           i0y
c in    
      real              r1dat(n0lin)
      real              r2dat(n0xin,n0yin)
      character*128     c0dat
c out
      real              r1out(n0lout)
      real              r2out(n0xout,n0yout)
      character*128     c0out
c local
      real              r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.6)then
        write(*,*) 'prog_WATCH_Albedo c0l2xin c0l2yin c0l2xout c0l2yout'
        write(*,*) '                  c0dat   c0out'
        stop
      end if
c
      call getarg(1,c0l2xin)
      call getarg(2,c0l2yin)
      call getarg(3,c0l2xout)
      call getarg(4,c0l2yout)
      call getarg(5,c0dat)
      call getarg(6,c0out)
c
      call read_i1l2xy(
     $     n0lin,
     $     c0l2xin,c0l2yin,
     $     i1l2xin,i1l2yin)
      call read_i1l2xy(
     $     n0lout,
     $     c0l2xout,c0l2yout,
     $     i1l2xout,i1l2yout)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0lin,c0dat,r1dat)
c
      do i0l=1,n0lin
        if(r1dat(i0l).eq.1.0E20)then
          r1dat(i0l)=0.0
        end if
      end do
c
      call conv_r1tor2(
     $     n0lin,n0xin,n0yin,i1l2xin,i1l2yin,
     $     r1dat,
     $     r2dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0y=1,n0yin
        do i0x=1,n0xin
          r2out(i0x*2,  i0y*2  )=r2dat(i0x,i0y)
          r2out(i0x*2-1,i0y*2  )=r2dat(i0x,i0y)
          r2out(i0x*2,  i0y*2-1)=r2dat(i0x,i0y)
          r2out(i0x*2-1,i0y*2-1)=r2dat(i0x,i0y)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call conv_r2tor1(
     $     n0lout,n0xout,n0yout,i1l2xout,i1l2yout,
     $     r2out,
     $     r1out)        
      call wrte_binary(n0lout,r1out,c0out)
c
      end
