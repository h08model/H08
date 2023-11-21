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
      program prog_map_pop_KYUSYU
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   prepare population data
cby   hanasaki
c
c    Japan: 122-149,24-46 
c    Kyushu:129-132,31-34
c
c    in 1km: 45sec x 30 sec (longitude x latitude)
c    Japan in 1km: 2160*2640=27*80 * 22*120
c    Top-left (Northeastern) Edge of Kyushu: 7*80+1=561,12*120+1=1441
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c
      character*128 c0x
      character*128 c0y
      integer       n0x       !! Japan in 1 km
      integer       n0y       !! Japan in 1 km
      real          p0mis
      parameter    (p0mis=1.0E20)
c
      character*128 c0x_1m
      character*128 c0y_1m
      character*128 c0x_3rd
      character*128 c0y_3rd
      character*128 c0x_15s
      character*128 c0y_15s
      integer       n0x_1m    !! kyushu in 1 min
      integer       n0y_1m    !! kyushu in 1 min
      integer       n0x_3rd   !! kyushu in 1 km
      integer       n0y_3rd   !! kyushu in 1 km
      integer       n0x_15s   !! kyushu in 15 sec
      integer       n0y_15s   !! kyushu in 15 sec
c
      character*128 c0x_edge
      character*128 c0y_edge
      integer       n0x_edge  !! Top-left edge of kyushu
      integer       n0y_edge  !! Top-left edge of kyushu
c index
      integer       i0x,i0y,i0l,i0xx,i0yy
c temporary
      real          r0tmp
c in
      real,allocatable::r1pop(:)  !! Japan in 1 km
      real,allocatable::r2pop(:,:)  !! Japan in 1 km
      character*128 c0ifname
c out
      real,allocatable::r21m(:,:)   !! Kyushu in 1 min
      character*128 c0ofname
c local
      real,allocatable::r23rd(:,:)  !! Kyushu in 1 km
      real,allocatable::r215s(:,:)  !! Kyushu in 15 sec
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.12)then
         write(*,*)'input data was bad '
         stop
      end if
      call getarg(1,c0x)
      call getarg(2,c0y)
      call getarg(3,c0x_1m)
      call getarg(4,c0y_1m)
      call getarg(5,c0x_3rd)
      call getarg(6,c0y_3rd)
      call getarg(7,c0x_15s)
      call getarg(8,c0y_15s)
      call getarg(9,c0x_edge)
      call getarg(10,c0y_edge)
      call getarg(11,c0ifname)
      call getarg(12,c0ofname)
      read(c0x,*)n0x
      read(c0y,*)n0y
      read(c0x_1m,*)n0x_1m
      read(c0y_1m,*)n0y_1m
      read(c0x_3rd,*)n0x_3rd
      read(c0y_3rd,*)n0y_3rd
      read(c0x_15s,*)n0x_15s
      read(c0y_15s,*)n0y_15s
      read(c0x_edge,*)n0x_edge
      read(c0y_edge,*)n0y_edge
c      write(*,*) n0x,n0y,n0x_1m,n0y_1m,n0x_3rd,n0y_3rd,n0x_15s,n0y_15s
c      write(*,*) n0x_edge,n0y_edge,c0ifname,c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      allocate(r1pop(n0x*n0y))
      allocate(r2pop(n0x,n0y))
      allocate(r21m(n0x_1m,n0y_1m))
      allocate(r23rd(n0x_3rd,n0y_3rd))
      allocate(r215s(n0x_15s,n0y_15s))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c open original 3rd mesh
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(15,file=c0ifname,status='old')
      read(15,*) (r1pop(i0l),i0l=1,n0x*n0y)
      close(15)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c check sum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0tmp=0.0
      do i0l=1,n0x*n0y
        if(r1pop(i0l).ne.p0mis)then
          r0tmp=r0tmp+r1pop(i0l)
        end if
      end do
      write(*,*) 'Japan total population ',r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c convert into 2d mesh
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0l=1
      do i0y=1,n0y
        do i0x=1,n0x
          r2pop(i0x,i0y)=r1pop(i0l)
          i0l=i0l+1
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c extract (3rd mesh)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0y=1,n0y_3rd
        do i0x=1,n0x_3rd
          r23rd(i0x,i0y)=r2pop(i0x+n0x_edge,i0y+n0y_edge)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c check sum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0tmp=0.0
      do i0x=1,n0x_3rd
        do i0y=1,n0y_3rd
          if(r23rd(i0x,i0y).ne.p0mis)then
            r0tmp=r0tmp+r23rd(i0x,i0y)
          end if
        end do
      end do
      write(*,*) 'Kyushu total population ',r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c convert into 15sec mesh
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0y=1,n0y_3rd
        do i0x=1,n0x_3rd
          if (r23rd(i0x,i0y).ne.p0mis)then
            r215s((i0x-1)*3+1,(i0y-1)*2+1)=r23rd(i0x,i0y)/6
            r215s((i0x-1)*3+2,(i0y-1)*2+1)=r23rd(i0x,i0y)/6
            r215s((i0x-1)*3+3,(i0y-1)*2+1)=r23rd(i0x,i0y)/6
            r215s((i0x-1)*3+1,(i0y-1)*2+2)=r23rd(i0x,i0y)/6
            r215s((i0x-1)*3+2,(i0y-1)*2+2)=r23rd(i0x,i0y)/6
            r215s((i0x-1)*3+3,(i0y-1)*2+2)=r23rd(i0x,i0y)/6
          else
            r215s((i0x-1)*3+1,(i0y-1)*2+1)=p0mis
            r215s((i0x-1)*3+2,(i0y-1)*2+1)=p0mis
            r215s((i0x-1)*3+3,(i0y-1)*2+1)=p0mis
            r215s((i0x-1)*3+1,(i0y-1)*2+2)=p0mis
            r215s((i0x-1)*3+2,(i0y-1)*2+2)=p0mis
            r215s((i0x-1)*3+3,(i0y-1)*2+2)=p0mis
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c check sum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0tmp=0.0
      do i0x=1,n0x_15s
        do i0y=1,n0y_15s
          if(r215s(i0x,i0y).ne.p0mis)then
            r0tmp=r0tmp+r215s(i0x,i0y)
          end if
        end do
      end do
      write(*,*) 'Kyushu total population [r215s] ',r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c convert into 1min meh
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r21m=0.0
      do i0y=1,n0y_1m
        do i0x=1,n0x_1m
            do i0yy=1,4
              do i0xx=1,4
                if(r215s((i0x-1)*4+i0xx,(i0y-1)*4+i0yy).ne.p0mis)then
                  r21m(i0x,i0y)=r21m(i0x,i0y)
     &                         +r215s((i0x-1)*4+i0xx,(i0y-1)*4+i0yy)
                end if
              end do
            end do
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c check sum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0tmp=0.0
      do i0x=1,n0x_1m
        do i0y=1,n0y_1m
          if(r21m(i0x,i0y).ne.p0mis)then
            r0tmp=r0tmp+r21m(i0x,i0y)
          end if
        end do
      end do
      write(*,*) 'Kyushu total population [r21m] ',r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c write 1m mesh
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(15,file=c0ofname,access='direct',recl=4*n0x_1m)
      do i0y=1,n0y_1m
        write(15,rec=i0y) (r21m(i0x,i0y),i0x=1,n0x_1m)
      end do
      close(15)
c
      end
