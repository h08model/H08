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
      program prog_map_C05_nat
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
      integer           i1gpw2unsd(400)
      character*128     c0ifname
      character*128     c0cod
c
      real              r1one(64800)
      real              r1hlf(259200)
      real              r1gl5(9331200)
      real              r1gl2(37324800)
      character*128     c0ofname1
      character*128     c0ofname2
      character*128     c0ofname3
      character*128     c0ofname4
c
      integer           i0gpw
      integer           i0unsd
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
c temporary
      real              r0tmp
      character*128     c0tmp
      character*128     s0frq
      data              s0frq/'frq'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.14)then
        write(*,*) 'prog_map_C05 c0ifname c0cod'
        write(*,*) '             c0ofname1 c0ofname2 c0ofname3 4'
        write(*,*) '             c0l2xone c0l2yone c0l2xhlf c0l2yhlf'
        write(*,*) '             c0l2xgl5 c0l2ygl5 c0l2xgl2 c0l2ygl2'
        stop
      end if
c
      call getarg(1,c0ifname)
      call getarg(2,c0cod)
      call getarg(3,c0ofname1)
      call getarg(4,c0ofname2)
      call getarg(5,c0ofname3)
      call getarg(6,c0ofname4)
      call getarg(7,c0l2xone)
      call getarg(8,c0l2yone)
      call getarg(9,c0l2xhlf)
      call getarg(10,c0l2yhlf)
      call getarg(11,c0l2xgl5)
      call getarg(12,c0l2ygl5)
      call getarg(13,c0l2xgl2)
      call getarg(14,c0l2ygl2)
c
      call read_i1l2xy(64800,c0l2xone,c0l2yone,i1l2xone,i1l2yone)
      call read_i1l2xy(259200,c0l2xhlf,c0l2yhlf,i1l2xhlf,i1l2yhlf)
      call read_i1l2xy(9331200,c0l2xgl5,c0l2ygl5,i1l2xgl5,i1l2ygl5)
      call read_i1l2xy(37324800,c0l2xgl2,c0l2ygl2,i1l2xgl2,i1l2ygl2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
c - read code
c - read data
c - convert code (gpw to unsd)
c - check sum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i1gpw2unsd=0
      open(15,file=c0cod,status='old')
 10   read(15,*,end=20) i0gpw,c0tmp,c0tmp,i0unsd,c0tmp
      write(*,*) i0gpw,c0tmp,c0tmp,i0unsd,c0tmp
      i1gpw2unsd(i0gpw)=i0unsd
      goto 10
 20   close(15)
c
      r2gl2=-9999.00
      open(15,file=c0ifname,status='old')
      do i0y=121,3552
        read(15,*) (r2gl2(i0x,i0y),i0x=1,8640)
      end do
      close(15)
c
      do i0y=1,4320
        do i0x=1,8640
          if(int(r2gl2(i0x,i0y)).eq.-9999)then
            r2gl2(i0x,i0y)=0.0
          else
            r2gl2(i0x,i0y)=real(i1gpw2unsd(int(r2gl2(i0x,i0y))))
          end if
        end do
      end do
c
      r0tmp=0.0
      do i0y=1,4320
        do i0x=1,8640
          r0tmp=r0tmp+r2gl2(i0x,i0y)
        end do
      end do
d     write(*,*) 'original data sum: ',r0tmp
d     write(*,*) 'Data at Thailand(6721,1825):', r2gl2(6721,1825)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Upscale (2.5min --> 5min, 2.5min --> 1deg, 2.5min --> 0.5deg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        call calc_uscale(4320,2160,2,2,r2gl2,r2gl5,s0frq)
        r0tmp=0.0
        do i0y=1,2160
          do i0x=1,4320
            r0tmp=r0tmp+r2gl5(i0x,i0y)
          end do
        end do
        write(*,*) 'five min data sum: ',r0tmp
        write(*,*) 'Data at Thailand(3361,913):',r2gl5(3361,913)
c
        call calc_uscale(360,180,24,24,r2gl2,r2one,s0frq)
        r0tmp=0.0
        do i0y=1,180
          do i0x=1,360
            r0tmp=r0tmp+r2one(i0x,i0y)
          end do
        end do
d       write(*,*) 'one deg data sum: ',r0tmp
d       write(*,*) 'Data at Thailand(281,77):',r2one(281,77)
c
        call calc_uscale(720,360,12,12,r2gl2,r2hlf,s0frq)
        r0tmp=0.0
        do i0y=1,360
          do i0x=1,720
            r0tmp=r0tmp+r2hlf(i0x,i0y)
          end do
        end do
d       write(*,*) 'half deg data sum: ',r0tmp
d       write(*,*) 'Data at Thailand(561,153)',r2hlf(561,153)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        call conv_r2tor1(37324800,8640,4320,i1l2xgl2,i1l2ygl2,
     $       r2gl2,r1gl2)
        call wrte_binary(37324800,r1gl2,c0ofname1)
        call conv_r2tor1(64800,360,180,i1l2xone,i1l2yone,r2one,r1one)
        call wrte_binary(64800,r1one,c0ofname2)
        call conv_r2tor1(259200,720,360,i1l2xhlf,i1l2yhlf,r2hlf,r1hlf)
        call wrte_binary(259200,r1hlf,c0ofname3)
        call conv_r2tor1(9331200,4320,2160,i1l2xgl5,i1l2ygl5,
     $       r2gl5,r1gl5)
        call wrte_binary(9331200,r1gl5,c0ofname4)
c
      end
