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
      program htlist2bin
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert list file <location,data> into binary file <2d map>
cby   2010/08/23, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c There are three files
c - Data file (Text file. 1st column contains Label and 2nd does Value)
c - Code file (Text file. 1st column contains Label and 2nd does ID)
c - Mask file (Binary file. Array of ID for the study domain)
c
c - i1cod2dat: Argument is ID of code file, Value is record ID of data file.
c - i1msk2dat: Argument is ID of mask file, Value is record ID of data file.
c - i1dat2cod: Argument is record ID of data file, Value is ID of code file.
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer              n0l
      integer              n0recdat        !! max record of data
      integer              n0reccod        !! max record of code
      integer              i0mis
      real                 p0mis
      parameter           (n0recdat=10000)
      parameter           (n0reccod=1000)
c      parameter           (n0recdat=50000)  # setting for .ks1
c      parameter           (n0reccod=50000)
      parameter           (i0mis=-9999) 
      parameter           (p0mis=1.0E20) 
c index (array)
      integer              i0l
      integer              i0recdat
      integer              i0recdatmax
      integer              i0reccod
      integer              i0reccodmax
c function
      integer              iargc
c temporary
      character*128        c0tmp
      real,allocatable::   r1tmp(:)
c in (set)
      character*128        c0opt            !! option for weighting
c in (map)
      integer,allocatable::i1msk(:)         !! mask file
      character*128        c1dat(n0recdat)  !! country in data file
      real                 r1dat(n0recdat)  !! data in data file
      character*128        c1cod(n0reccod)  !! country in code file
      real                 r1cod(n0reccod)  !! code in code file
      real,allocatable::   r1wgt(:)         !! weighting factor
      character*128        c0msk            !! mask file name
      character*128        c0dat            !! input file name
      character*128        c0cod            !! code file name
      character*128        c0wgt            !! weighting file name
c out
      real,allocatable::   r1out(:)         !! out file
      character*128        c0out            !! output file name
c local
      integer              i0status         !! flag
      integer              i0cntmis         !! counter
      integer              i0cntmismax      !! counter 
      integer              i1cod2dat(n0recdat)   !! code-->data lookup table
      integer              i1dat2cod(n0recdat)   !! data-->code lookup table
      integer              i1msk2dat(n0recdat)
      real                 r1nattot(n0recdat)
      real,allocatable::   r1raw(:)         !! weighting (raw data)
      character*128        c1mis(n0recdat)  !! missing country
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.6.and.iargc().ne.7) then
        write(*,*) 'Usage: htlist2bin n0l c0lst c0msk c0cod c0bin'
        write(*,*) '                  OPTION'
        write(*,*) 'OPTION: [{"perarea"},'
        write(*,*) '         {"conserve"},'
        write(*,*) '         {"weight"   c0bin}]'
        write(*,*) '  perarea  for per area data such as rainfall'
        write(*,*) '  conserve for data such as population '
        write(*,*) '  weight   for conserve weighted by c0bin'
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
      allocate(r1out(n0l))
      allocate(i1msk(n0l))
      allocate(r1raw(n0l))
      allocate(r1wgt(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
c - Read data file (ascii)
c - Read code file (ascii)
c - Read mask file (binary)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0recdat=1
      open(15,file=c0dat,access='sequential',status='old')
 10   read(15,*,end=20) c1dat(i0recdat),r1dat(i0recdat)
      i0recdat=i0recdat+1
      goto 10
 20   close(15)
      i0recdatmax=i0recdat-1
c
      i0reccod=1
      open(15,file=c0cod,access='sequential',status='old')
 30   read(15,*,end=40) c1cod(i0reccod),r1cod(i0reccod)
c 30   read(15,*,end=40)  r1cod(i0reccod),c1cod(i0reccod)
      i0reccod=i0reccod+1
      goto 30
 40   close(15)
      i0reccodmax=i0reccod-1
c
      call read_binary(n0l,c0msk,r1tmp)
      do i0l=1,n0l
        if(r1tmp(i0l).ne.p0mis)then
          i1msk(i0l)=int(r1tmp(i0l))
        else
          i1msk(i0l)=i0mis
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Convert
c - create code <--> data lookup table 
c - create mask <--> data lookup table
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0cntmis=0
      do i0recdat=1,i0recdatmax
        i0status=0
        do i0reccod=1,i0reccodmax
          if(c1dat(i0recdat).eq.c1cod(i0reccod))then
            i1cod2dat(i0reccod)=i0recdat
            i1dat2cod(i0recdat)=i0reccod
            i0status=1
          end if
        end do
        if(i0status.eq.0)then
          i0cntmis=i0cntmis+1
          c1mis(i0cntmis)=c1dat(i0recdat)
        end if
      end do
      i0cntmismax=i0cntmis
c
      do i0reccod=1,i0reccodmax
        if(i1cod2dat(i0reccod).ne.0)then
          i1msk2dat(int(r1cod(i0reccod)))=i1cod2dat(i0reccod)
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Weighting
c - 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'weight')then
        call read_binary(n0l,c0wgt,r1raw)
      else
        do i0l=1,n0l
          r1raw(i0l)=1.0
        end do
      end if
c
      if(c0opt.eq.'conserve'.or.c0opt.eq.'weight')then
        do i0recdat=1,i0recdatmax
          if(i1dat2cod(i0recdat).ne.0)then
          do i0l=1,n0l
            if(i1msk(i0l).eq.int(r1cod(i1dat2cod(i0recdat))))then
              if(r1raw(i0l).ne.p0mis)then
                r1nattot(i0recdat)=r1nattot(i0recdat)+r1raw(i0l)
              end if
            end if
          end do
          end if
        end do
c     
        do i0recdat=1,i0recdatmax
          if(i1dat2cod(i0recdat).ne.0)then
          do i0l=1,n0l
            if(i1msk(i0l).eq.int(r1cod(i1dat2cod(i0recdat))))then
              if(r1raw(i0l).ne.p0mis.and.r1nattot(i0recdat).gt.0.0)then
                r1wgt(i0l)=r1raw(i0l)/r1nattot(i0recdat)
              else
                r1wgt(i0l)=0.0
              end if
            end if
          end do
          end if
        end do
      else
        do i0l=1,n0l
          r1wgt(i0l)=1.0
        end do        
      end if
c debug
c      write(*,*) rwgt(281,77)
c      call wrte_binmat(rwgt,nx,ny,15,'temp.wgt.one')
c      do iy=1,ny
c        do ix=1,nx
c          if(rwgt(ix,iy).gt.0)then
c            write(*,*) ix,iy,rwgt(ix,iy),imsk(ix,iy)
c          end if
c        end do
c      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1out=p0mis
      do i0l=1,n0l
        if(i1msk(i0l).gt.0)then
          if(i1msk2dat(i1msk(i0l)).gt.0)then
            if(r1dat(i1msk2dat(i1msk(i0l))).ne.real(i0mis))then
              r1out(i0l)=r1dat(i1msk2dat(i1msk(i0l)))*r1wgt(i0l)
            end if
          end if
        end if
      end do
c
      call wrte_binary(n0l,r1out,c0out)
c
      if(i0cntmismax.eq.0)then
        write(*,*) 'htlist2bin: All records transfered successfully.'
      else
        write(*,*) 'htlist2bin: The records below failed in transfer.'
        do i0cntmis=1,i0cntmismax
          write(*,*) c1mis(i0cntmis)
        end do
        write(*,*) 'htlist2bin: Add the above label to the code list.'
      end if
c
      end
