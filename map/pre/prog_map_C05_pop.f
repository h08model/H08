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
      program prog_map_C05
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare CIESIN GPW ver3
cby   2011/03/31, hanasaki, NIES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c index
      integer           i0x
      integer           i0y
c in
      real              r2one(360,180)
      real              r2hlf(720,360)
      real              r2gl5(4320,2160)
      real              r2gl2(8640,4320)
      character*128     c0ifname
c
      real              r1one(64800)
      real              r1hlf(259200)
      real              r1gl5(9331200)
      real              r1gl2(37324800)
      character*128     c0ofname
c
      integer           i1l2xone(64800)
      integer           i1l2yone(64800)
      integer           i1l2xhlf(259200)
      integer           i1l2yhlf(259200)
      integer           i1l2xgl5(9331200)
      integer           i1l2ygl5(9331200)
      integer           i1l2xgl2(37324800)
      integer           i1l2ygl2(37324800)
      character*128     c0l2xone
      character*128     c0l2yone
      character*128     c0l2xhlf
      character*128     c0l2yhlf
      character*128     c0l2xgl5
      character*128     c0l2ygl5
      character*128     c0l2xgl2
      character*128     c0l2ygl2
c local
      character*128     c0opt
      character*128     s0sum
      data              s0sum/'sum'/ 
c temporary
      real              r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.11)then
        write(*,*) 'prog_map_C05 c0ifname c0ofname c0opt'
        write(*,*) '             c0l2xone c0l2yone c0l2xhlf c0l2yhlf'
        write(*,*) '             c0l2xgl5 c0l2ygl5 c0l2xgl2 c0l2ygl2'
        stop
      end if
c
      call getarg(1,c0ifname)
      call getarg(2,c0ofname)
      call getarg(3,c0opt)
      call getarg(4,c0l2xone)
      call getarg(5,c0l2yone)
      call getarg(6,c0l2xhlf)
      call getarg(7,c0l2yhlf)
      call getarg(8,c0l2xgl5)
      call getarg(9,c0l2ygl5)
      call getarg(10,c0l2xgl2)
      call getarg(11,c0l2ygl2)
c
      call read_i1l2xy(64800,c0l2xone,c0l2yone,i1l2xone,i1l2yone)
      call read_i1l2xy(259200,c0l2xhlf,c0l2yhlf,i1l2xhlf,i1l2yhlf)
      call read_i1l2xy(9331200,c0l2xgl5,c0l2ygl5,i1l2xgl5,i1l2ygl5)
      call read_i1l2xy(37324800,c0l2xgl2,c0l2ygl2,i1l2xgl2,i1l2ygl2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'one00'.or.c0opt.eq.'one90')then
        r2one=0.0
        open(15,file=c0ifname,status='old')
        do i0y=6,148
          read(15,*) (r2one(i0x,i0y),i0x=1,360)
        end do
        close(15)
        call conv_r2tor1(64800,360,180,i1l2xone,i1l2yone,r2one,r1one)
        call wrte_binary(64800,r1one,c0ofname)
      else if(c0opt.eq.'half00'.or.c0opt.eq.'half90')then
        r2hlf=0.0
        open(15,file=c0ifname,status='old')
        do i0y=11,296
          read(15,*) (r2hlf(i0x,i0y),i0x=1,720)
        end do
        close(15)
        call conv_r2tor1(259200,720,360,i1l2xhlf,i1l2yhlf,r2hlf,r1hlf)
        call wrte_binary(259200,r1hlf,c0ofname)
      else if(c0opt.eq.'gl500')then
        r2gl2=0.0
        open(15,file=c0ifname,status='old')
        do i0y=121,3552
          read(15,*) (r2gl2(i0x,i0y),i0x=1,8640)
        end do
        close(15)
        call calc_uscale(4320,2160,2,2,r2gl2,r2gl5,s0sum)
        call conv_r2tor1(9331200,4320,2160,i1l2xgl5,i1l2ygl5,
     $       r2gl5,r1gl5)
        call wrte_binary(9331200,r1gl5,c0ofname)
      else
        write(*,*) 'prog_map_C05_pop: c0opt:',c0opt
        write(*,*) 'Not supported. No output'
      end if
c
      end

