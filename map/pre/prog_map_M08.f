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
      program prog_map_M08
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare Monfreda et al., 2008
cby   2011/04/05, hanasaki, NIES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index
      integer           i0x
      integer           i0y
c in
      real              r2vhr(4320,2160)
      real              r2grdara(4320,2160)
      character*128     c0ifname
      character*128     c0grdara
c out
      real              r1vhr(9331200)
      real              r1one(64800)
      real              r1hlf(259200)
      character*128     c0ofname1
      character*128     c0ofname2
      character*128     c0ofname3
c local
      real              r0factor
      real              r2one(360,180)
      real              r2hlf(720,360)
      integer           i0mis
      integer           i1l2xone(64800)
      integer           i1l2yone(64800)
      integer           i1l2xhlf(259200)
      integer           i1l2yhlf(259200)
      integer           i1l2xvhr(9331200)
      integer           i1l2yvhr(9331200)
      character*128     c0l2xone
      character*128     c0l2yone
      character*128     c0l2xhlf
      character*128     c0l2yhlf
      character*128     c0l2xvhr
      character*128     c0l2yvhr
      character*128     c0opt
c temporary
      real              r0tmp
      real              r1tmp(9331200)
      character*128     c0tmp
      character*128     s0sum
      data              s0sum/'sum'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.13)then
        write(*,*) 'prog_map_M08 c0ifname'
        write(*,*) '             c0ofname1 c0ofname2 c0ofname3'
        write(*,*) '             c0l2xone c0l2yone c0l2xhlf c0l2yhlf'
        write(*,*) '             c0l2xvhr c0l2yvhr c0grdara c0opt i0mis'
        stop
      end if
c
      call getarg(1,c0ifname)
      call getarg(2,c0ofname1)
      call getarg(3,c0ofname2)
      call getarg(4,c0ofname3)
      call getarg(5,c0l2xone)
      call getarg(6,c0l2yone)
      call getarg(7,c0l2xhlf)
      call getarg(8,c0l2yhlf)
      call getarg(9,c0l2xvhr)
      call getarg(10,c0l2yvhr)
      call getarg(11,c0grdara)
      call getarg(12,c0opt)
      call getarg(13,c0tmp)
      read(c0tmp,*) i0mis
c
      call read_i1l2xy(  64800,c0l2xone,c0l2yone,i1l2xone,i1l2yone)
      call read_i1l2xy( 259200,c0l2xhlf,c0l2yhlf,i1l2xhlf,i1l2yhlf)
      call read_i1l2xy(9331200,c0l2xvhr,c0l2yvhr,i1l2xvhr,i1l2yvhr)
c
      if(c0opt.eq.'frc')then
        r0factor=1.0
      else if(c0opt.eq.'pct')then
        r0factor=0.01
      else
        write(*,*) 'c0opt: ',c0opt,' not supported.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
c - read data
c - grid area
c - check sum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r2vhr=real(i0mis)
      open(15,file=c0ifname,status='old')
      do i0y=1,2160
        read(15,*) (r2vhr(i0x,i0y),i0x=1,4320)
      end do
      close(15)
c
      call read_binary(9331200,c0grdara,r1tmp)
      call conv_r1tor2(9331200,4320,2160,i1l2xvhr,i1l2yvhr,
     $     r1tmp,r2grdara)
c
      r0tmp=0.0
      do i0y=1,2160
        do i0x=1,4320
          if(r2vhr(i0x,i0y).eq.real(i0mis))then
c            r2vhr(i0x,i0y)=p0mis
            r2vhr(i0x,i0y)=0.0
          else
            r2vhr(i0x,i0y)=r2vhr(i0x,i0y)*r2grdara(i0x,i0y)*r0factor
            r0tmp=r0tmp+r2vhr(i0x,i0y)
          end if
        end do
      end do
d     write(*,*) 'original data sum: ',r0tmp
d     write(*,*) 'Data at Thailand(3361,913):', r2vhr(3361,913)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Upscale (5min --> 1deg, 5min --> 0.5deg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        call calc_uscale(360,180,12,12,r2vhr,r2one,s0sum)
c
        r0tmp=0.0
        do i0y=1,180
          do i0x=1,360
            if(r2one(i0x,i0y).ne.p0mis)then
            r0tmp=r0tmp+r2one(i0x,i0y)
            end if
          end do
        end do
d       write(*,*) 'one deg data sum: ',r0tmp
d       write(*,*) 'Data at Thailand(281,77):',r2one(281,77)
c
        call calc_uscale(720,360,6,6,r2vhr,r2hlf,s0sum)
        r0tmp=0.0
        do i0y=1,360
          do i0x=1,720
            if(r2hlf(i0x,i0y).ne.p0mis)then
              r0tmp=r0tmp+r2hlf(i0x,i0y)
            end if
          end do
        end do
d       write(*,*) 'half deg data sum: ',r0tmp
d       write(*,*) 'Data at Thailand(561,153)',r2hlf(561,153)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        call conv_r2tor1(9331200,4320,2160,i1l2xvhr,i1l2yvhr,
     $       r2vhr,r1vhr)
        call wrte_binary(9331200,r1vhr,c0ofname1)
        call conv_r2tor1(64800,360,180,i1l2xone,i1l2yone,r2one,r1one)
        call wrte_binary(64800,r1one,c0ofname2)
        call conv_r2tor1(259200,720,360,i1l2xhlf,i1l2yhlf,r2hlf,r1hlf)
        call wrte_binary(259200,r1hlf,c0ofname3)
c
      end
