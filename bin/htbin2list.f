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
      program htbin2list
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert binary file <2d map> into list file <location,data>
cby   2010/08/23, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (default)
      integer              n0mis
      real                 p0mis
      parameter           (n0mis=-9999) 
      parameter           (p0mis=1.0E20) 
c parameter (array)
      integer              n0l
      integer              n0reccod        !! max record of code
      integer              n0codmax        !! max number of code
      parameter           (n0reccod=1000) 
      parameter           (n0codmax=10000) 
c index (array)
      integer              i0l
      integer              i0reccod
      integer              i0reccodmax
c function
      integer              iargc
c temporary
      integer              i0tmp
      real                 r0tmp
      character*128        c0tmp
      real,allocatable::   r1tmp(:)
c in (set)
      character*128        c0opt            !! option for weighting
c in (map)
      integer,allocatable::i1msk(:)         !! mask file
      real,allocatable::   r1dat(:)         !! data in data file
      real,allocatable::   r1wgt(:)         !! weighting factor
      character*128        c1cod(n0reccod)  !! country in code file
      integer              i1cod(n0reccod)  !! code in code file
      character*128        c0msk            !! mask file name
      character*128        c0dat            !! input file name
      character*128        c0wgt            !! weighting file name
      character*128        c0cod            !! code file name
c out
      real                 r1out(0:n0reccod)  !! out file
      character*128        c0out            !! output file name
c local
      integer              i1flg(0:n0reccod)  !! code in code file
      integer              i1cod2rec(0:n0codmax)  !! code to record conv.
      real                 r1wgttot(0:n0reccod)!! sum of weihght
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.6.and.iargc().ne.7) then
        write(*,*) 'Usage: htbin2list n0l c0bin c0msk c0cod clst '
        write(*,*) '                  OPTION'
        write(*,*) 'OPTION: [{"sum"},'
        write(*,*) '         {"pergrid"},'
        write(*,*) '         {"weight" c0wgt}]'
        write(*,*) '  sum     for suming up for each region'
        write(*,*) '  pergrid for per grid value'
        write(*,*) '  weight  for weighting for each grid'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0dat)
      call getarg(3,c0msk)
      call getarg(4,c0cod)
      call getarg(5,c0out)
      call getarg(6,c0opt)
      if(iargc().eq.7)then
        call getarg(7,c0wgt)
      end if
c
      allocate(r1tmp(n0l))
      allocate(r1dat(n0l))
      allocate(i1msk(n0l))
      allocate(r1wgt(n0l))
c
      if(c0opt.ne.'sum'.and.c0opt.ne.'pergrid'.and.
     $   c0opt.ne.'weight')then
        write(*,*) 'c0opt= ',c0opt,' not supported. Stop.'
        stop
      end if
c
      i1cod2rec=n0mis
      i1cod2rec(0)=0      !! added 2012/11/1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
c - Read data file (binary)
c - Read code file (ascii)
c - Read mask file (binary)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0dat,r1dat)
c
c      r0tmp=0
c      do i0l=1,n0l
c        r0tmp=max(r1dat(i0l),r0tmp)
c      end do
c      write(*,*) 'max',r0tmp
c      r0tmp=9999999
c      do i0l=1,n0l
c        r0tmp=min(r1dat(i0l),r0tmp)
c      end do
c      write(*,*) 'min',r0tmp
c
      i0reccod=1
      open(15,file=c0cod,access='sequential',status='old')
 30   read(15,*,end=40) c1cod(i0reccod),i1cod(i0reccod)
c 30   read(15,*,end=40)  i1cod(i0reccod),c1cod(i0reccod)
c      write(*,*) c1cod(i0reccod),i1cod(i0reccod)
      if(i1cod2rec(i1cod(i0reccod)).eq.n0mis)then
         i1cod2rec(i1cod(i0reccod))=i0reccod
      end if
      i0reccod=i0reccod+1
      goto 30
 40   close(15)
      i0reccodmax=i0reccod-1
c
c      i0tmp=0
c      do i0reccod=1,i0reccodmax
c        i0tmp=max(i1cod(i0reccod),i0tmp)
c        if(i0tmp.eq.i1cod(i0reccod))then
c          write(*,*) i0reccod
c        end if
c      end do
c      write(*,*) 'max',i0tmp
c      r0tmp=9999999
c      do i0reccod=1,i0reccodmax
c        i0tmp=min(i1cod(i0reccod),i0tmp)
c      end do
c      write(*,*) 'min',i0tmp
c
      call read_binary(n0l,c0msk,r1tmp)
      do i0l=1,n0l
        if(r1tmp(i0l).ne.p0mis)then
          i1msk(i0l)=int(r1tmp(i0l))
        else
          i1msk(i0l)=n0mis
        end if
      end do
c
c      i0tmp=0
c      do i0l=1,n0l
c        i0tmp=max(i1msk(i0l),i0tmp)
c      end do
c      write(*,*) 'max',i0tmp
c      i0tmp=999999
c      do i0l=1,n0l
c        i0tmp=min(i1msk(i0l),i0tmp)
c      end do
c      write(*,*) 'min',i0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Weighting
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'weight')then
        call read_binary(n0l,c0wgt,r1wgt)
      else
        r1wgt=1.0
      end if
c
      r1wgttot=0.0
      if(c0opt.eq.'weight'.or.c0opt.eq.'pergrid')then
        do i0l=1,n0l
          if(r1wgt(i0l).ne.p0mis)then
            i0reccod=i1cod2rec(i1msk(i0l))
            r1wgttot(i0reccod)=r1wgttot(i0reccod)+r1wgt(i0l)
          end if
        end do
      else
        do i0reccod=0,n0reccod
          r1wgttot(i0reccod)=1.0
        end do
      end if
c
      r1out=0.0
      do i0l=1,n0l
        if(i1msk(i0l).ne.n0mis)then
        i0reccod=i1cod2rec(i1msk(i0l))
        if(i0reccod.ne.n0mis.and.
     $       r1dat(i0l).ne.p0mis.and.r1wgt(i0l).ne.p0mis)then
          r1out(i0reccod)=r1out(i0reccod)+r1dat(i0l)*r1wgt(i0l)
          if(i1flg(i0reccod).eq.0)then
            i1flg(i0reccod)=1
          end if
        end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(16,file=c0out)
      do i0reccod=1,i0reccodmax
        if(i1flg(i0reccod).eq.1)then
          if(r1wgttot(i0reccod).ne.0.0)then
            write(16,'(a,es12.3,es12.3)') c1cod(i0reccod),
     $           r1out(i0reccod)/r1wgttot(i0reccod),
     $           r1wgttot(i0reccod)
          else
            write(16,'(a,es12.3,es12.3)') c1cod(i0reccod),
     $           real(n0mis),
     $           r1wgttot(i0reccod)            
          end if
        end if
      end do
      close(16)
c
      end
