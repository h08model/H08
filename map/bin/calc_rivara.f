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
      program calc_rivara
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate river area
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c     Copyright (C) 2010,2011 Naota Hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer              n0l                 !! total cells
c parameter (default)
      real                 p0mis
      real                 p0maxini
      parameter           (p0mis=1.0E20) 
      parameter           (p0maxini=-9.9E20) 
c index (array)
      integer              i0l
      integer              i0rivseq
c temporary
      real,allocatable::   r1tmp(:)            !! temporary
      character*128        c0tmp               !! temporary
      character*128        c0opt               !! option
c function
      real                 rgetlon
      real                 rgetlat
c in
      integer,allocatable::i1nxl(:)            !! river sequence
      integer,allocatable::i1rivseq(:)         !! river sequence
      real,allocatable::   r1lndara(:)         !! grid area
      character*128        c0nxl
      character*128        c0rivseq
      character*128        c0lndara
c out
      real,allocatable::   r1rivara(:)         !! river area
      character*128        c0rivara
c local
      integer              i0rivseqmax
      real                 r0rivaramax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.5)then
        write(*,*) 'calc_rivara n0l'
        write(*,*) '            c0lndara c0rivseq c0nxl c0rivara'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0lndara)
      call getarg(3,c0rivseq)
      call getarg(4,c0nxl)
      call getarg(5,c0rivara)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      allocate(r1tmp(n0l))
      allocate(r1lndara(n0l))
      allocate(i1nxl(n0l))
      allocate(i1rivseq(n0l))
      allocate(r1rivara(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
      r1rivara=0.0
c local
      i0rivseqmax=0
      r0rivaramax=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read files
c - nxl or downstream l
c - rivseq or river sequence file
c - maximum value of river sequence file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0lndara,r1lndara)
c
      call read_binary(n0l,c0nxl,r1tmp)
      do i0l=1,n0l
        i1nxl(i0l)=int(r1tmp(i0l))
      end do
c
      call read_binary(n0l,c0rivseq,r1tmp)
      do i0l=1,n0l
        i1rivseq(i0l)=int(r1tmp(i0l))
      end do
c
      i0rivseqmax=0
      do i0l=1,n0l
        i0rivseqmax=max(i1rivseq(i0l),i0rivseqmax)
      end do
      write(*,*) 'calc_rivara: i0rivseqmax:',i0rivseqmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        r1rivara(i0l)=r1lndara(i0l)
      end do
c
      r0rivaramax=p0maxini
      do i0rivseq=1,i0rivseqmax
        do i0l=1,n0l
          if (i1rivseq(i0l).eq.i0rivseq.and.
     $        r1rivara(i0l).ne.p0mis.and.
     $        i1nxl(i0l).ne.i0l)then
            r1rivara(i1nxl(i0l))=r1rivara(i1nxl(i0l))+r1rivara(i0l)
            r0rivaramax=max(r0rivaramax,r1rivara(i1nxl(i0l)))
          end if
        end do
      end do
c debug
      write(*,*) 'calc_rivara: r0rivaramax:',r0rivaramax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write files
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call wrte_binary(n0l,r1rivara,c0rivara)
c
      end
