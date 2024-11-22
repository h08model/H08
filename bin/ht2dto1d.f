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
      program ht2dto1d
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert 2d file (w/ ocean) to 1d file (w/o ocean)
cby   2024/04/30, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer              n0lall
      integer              n0x
      integer              n0y
      real                 p0mis
      parameter           (p0mis=1.0E20)
c     parameter (default)
      integer              n0of
      parameter           (n0of=16)
c index (array)
      integer              i0lall
      integer              i0llnd
      integer              i0x
      integer              i0y
c temporary
      character*128        c0tmp
c function
      integer              iargc
c in
      real,allocatable::r1lndmsk(:)
      real,allocatable::   r1dat(:)
      real,allocatable::   r1out(:)
      character*128        c0lndmsk
      character*128        c0dat
      character*128        c0out
      character*128        c0opt
c out
      real,allocatable::   r1l2x(:)
      real,allocatable::   r1l2y(:)
      character*128        c0l2x
      character*128        c0l2y
c local
      integer              i0llndmax
      character*128        c0l
      integer,allocatable::i1l2d2l1d(:)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.6.and.iargc().ne.8.and.iargc().ne.9)then
        write(*,*) 'Usage: ht2dto1d n0lall n0x n0y'
        write(*,*) '                c0dat c0lndmsk c0out'
        write(*,*) '(option)        c0l2x c0l2y'
        write(*,*) '(option)        c0opt'
        write(*,*) 'c0opt yes to convert l in 2d to l in 1d'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0lall
      call getarg(2,c0tmp)
      read(c0tmp,*) n0x
      call getarg(3,c0tmp)
      read(c0tmp,*) n0y
      call getarg(4,c0dat)
      call getarg(5,c0lndmsk)
      call getarg(6,c0out)
      if(iargc().eq.8.or.iargc().eq.9)then
        call getarg(7,c0l2x)
        call getarg(8,c0l2y)
      end if
      if(iargc().eq.9)then
        call getarg(9,c0opt)
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(r1lndmsk(n0lall))
      allocate(r1dat(n0lall))
      allocate(i1l2d2l1d(n0lall))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0lall,c0lndmsk,r1lndmsk)
      call read_binary(n0lall,c0dat,r1dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0lall=1
      i0llnd=1
      do i0y=1,n0y
        do i0x=1,n0x
          if(int(r1lndmsk(i0lall)).eq.1)then
            i0llnd=i0llnd+1
          end if
          i0lall=i0lall+1
       end do
      end do
      i0llndmax=i0llnd-1
      write(c0l,*) i0llndmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      allocate(r1out(i0llndmax))
      allocate(r1l2x(i0llndmax))
      allocate(r1l2y(i0llndmax))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0lall=1
      i0llnd=1
      do i0y=1,n0y
        do i0x=1,n0x
          if(int(r1lndmsk(i0lall)).eq.1)then
            r1out(i0llnd)=r1dat(i0lall)
            r1l2x(i0llnd)=real(i0x)
            r1l2y(i0llnd)=real(i0y)
            i1l2d2l1d(i0x+(i0y-1)*n0x)=i0llnd
            i0llnd=i0llnd+1
          end if
          i0lall=min(i0lall+1,n0lall)
        end do
      end do
c
      if(c0opt.eq.'yes')then
         do i0llnd=1,i0llndmax
c            write(*,*) i0llnd
c            write(*,*) r1out(i0llnd)
            if(r1out(i0llnd).ne.0.0.and.r1out(i0llnd).ne.p0mis)then
               r1out(i0llnd)=real(i1l2d2l1d(r1out(i0llnd)))
            end if
         end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call wrte_binary(i0llndmax,r1out,c0out)
      if(iargc().eq.8)then
        open(n0of,file=c0l2x)
        write(n0of,'('//c0l//'f6.0)') (r1l2x(i0llnd),i0llnd=1,i0llndmax)
        close(n0of)
c
        open(n0of,file=c0l2y)
        write(n0of,'('//c0l//'f6.0)') (r1l2y(i0llnd),i0llnd=1,i0llndmax)
        close(n0of)
      end if
c     
      end
