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
      program prog_hlf2one
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c index
      integer           i0x
      integer           i0y
c in
      real              r1dat(259200)
      real              r2dat(720,360)
      character*128     c0dat
c out
      real              r1out(64800)
      real              r2out(360,180)
      character*128     c0out
c
      character*128     c0l2xone
      character*128     c0l2yone
      integer           i1l2xone(64800)
      integer           i1l2yone(64800)
      character*128     c0l2xhlf
      character*128     c0l2yhlf
      integer           i1l2xhlf(259200)
      integer           i1l2yhlf(259200)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call getarg(1,c0l2xhlf)
      call getarg(2,c0l2yhlf)
      call getarg(3,c0l2xone)
      call getarg(4,c0l2yone)
      call getarg(5,c0dat)
      call getarg(6,c0out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      write(*,*) c0dat
      call read_binary(259200,c0dat,r1dat)
      call read_i1l2xy(259200,c0l2xhlf,c0l2yhlf,i1l2xhlf,i1l2yhlf)
      call conv_r1tor2(259200,720,360,i1l2xhlf,i1l2yhlf,r1dat,r2dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0y=1,180
        do i0x=1,360
          r2out(i0x,i0y)=r2dat(2*i0x-1,2*i0y-1)+r2dat(2*i0x,2*i0y-1)
     $                  +r2dat(2*i0x-1,2*i0y  )+r2dat(2*i0x,2*i0y)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(64800,c0l2xone,c0l2yone,i1l2xone,i1l2yone)
      call conv_r2tor1(64800,360,180,i1l2xone,i1l2yone,r2out,r1out)
      call wrte_binary(64800,r1out,c0out)
c
      end
