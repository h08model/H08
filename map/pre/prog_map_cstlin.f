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
      program prog_map_cstlin
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      integer           n0x
      integer           n0y
      parameter        (n0l=259200) 
      parameter        (n0x=720) 
      parameter        (n0y=360) 
c index
      integer           i0x
      integer           i0y
      integer           i0x2
      integer           i0y2
      integer           i0xsur
      integer           i0ysur
c 
      integer           i1l2x(n0l)
      integer           i1l2y(n0l)
      character*128     c0l2x
      character*128     c0l2y
c temp
      real              r1tmp(n0l)
      character*128     c0tmp
c in
      real              r2lndmsk(n0x,n0y)
      character*128     c0lndmsk
      real              r2natmsk(n0x,n0y)
      real              r2natwat(n0x,n0y)
      character*128     c0natmsk
      character*128     c0natwat
      real              r2elvmin(n0x,n0y)
      character*128     c0elvmin
c out
      real              r2cstlin(n0x,n0y)
      character*128     c0cstlin
c local
      integer           i0flg
      integer           i0opt
      real              r0elvmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.9)then
        write(*,*) 'prog_map_cstlin L2X L2Y LNDMSK NATMSK NATWAT CSTLIN'
        write(*,*) '                OPT ELVMIN ELVMAX'
        stop
      end if
c
      call getarg(1,c0l2x)
      call getarg(2,c0l2y)
      call getarg(3,c0lndmsk)
      call getarg(4,c0natmsk)
      call getarg(5,c0natwat)
      call getarg(6,c0cstlin)
      call getarg(7,c0tmp)
      read(c0tmp,*) i0opt
      call getarg(8,c0elvmin)
      call getarg(9,c0tmp)
      read(c0tmp,*) r0elvmax
c
      write(*,*) c0lndmsk
      write(*,*) c0cstlin
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
c
      call read_binary(n0l,c0lndmsk,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2lndmsk)
c
      call read_binary(n0l,c0natmsk,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2natmsk)
      call read_binary(n0l,c0natwat,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2natwat)
      call read_binary(n0l,c0elvmin,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2elvmin)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r2cstlin=0.0
c
      do i0y=1,n0y
        do i0x=1,n0x
          if(r2lndmsk(i0x,i0y).eq.1.0)then
            i0flg=0
            do i0ysur=-1*i0opt,i0opt
              do i0xsur=-1*i0opt,i0opt
                i0x2=i0x+i0xsur
                i0y2=i0y+i0ysur
                if(i0x2.ge.1.and.i0x2.le.n0x.and.
     $             i0y2.ge.1.and.i0y2.le.n0y)then
                  if(r2lndmsk(i0x2,i0y2).eq.0.and.
     $               r2natmsk(i0x,i0y).eq.r2natwat(i0x2,i0y2).and.
     $               r2elvmin(i0x,i0y).lt.r0elvmax)then
                    i0flg=1
                  end if
                end if
              end do
            end do
            if(i0flg.eq.1)then
              r2cstlin(i0x,i0y)=1.0
            end if
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r2cstlin,r1tmp)
      call wrte_binary(n0l,r1tmp,c0cstlin)
c
      end
