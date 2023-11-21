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
      program htmask
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   pickup data from an array if the corresponding mask meet the condition
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
      real              p0lonmin
      real              p0lonmax
      real              p0latmin
      real              p0latmax
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
c temporary
      character*128     c0tmp
c function
      integer           iargc
      real              rgetlon
      real              rgetlat
c in (set)
      real              r0dat
      character*128     c0sgn      !! sign
      character*128     c0opt   !! display option
      data              c0opt/'summary'/ 
c in (map)
      integer,allocatable :: i1l2x(:)
      integer,allocatable :: i1l2y(:)
      real,allocatable::r1msk(:)
      character*128     c0l2x      !! l2x
      character*128     c0l2y      !! l2y
      character*128     c0mfname   !! Mask FILE
c in (flux)
      real,allocatable::r1dat(:)
      character*128     c0ifname   !! Input FILE
c out
      real,allocatable::r1out(:)
      character*128     c0ofname   !! Output FILE
c local
      integer           i0cnt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.14.and.iargc().ne.15) then
        write(*,*) 'Usage: htmask n0l n0x n0y c0l2x c0l2y'
        write(*,*) '              p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '              c0bin c0msk SIGN r0dat c0bin [OPTION]'
        write(*,*) 'SIGN:   [eq ne lt le gt ge isnan]'
        write(*,*) 'OPTION: [long short] (default is short)'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) n0x
      call getarg(3,c0tmp)
      read(c0tmp,*) n0y
      call getarg(4,c0l2x)
      call getarg(5,c0l2y)
      call getarg(6,c0tmp)
      read(c0tmp,*) p0lonmin
      call getarg(7,c0tmp)
      read(c0tmp,*) p0lonmax
      call getarg(8,c0tmp)
      read(c0tmp,*) p0latmin
      call getarg(9,c0tmp)
      read(c0tmp,*) p0latmax
      call getarg(10,c0ifname)
      call getarg(11,c0mfname)
      call getarg(12,c0sgn)
      call getarg(13,c0tmp)
      read(c0tmp,*) r0dat
      call getarg(14,c0ofname)
      if(iargc().eq.15)then
      call getarg(15,c0opt)
      end if
c
      allocate(r1dat(n0l))
      allocate(r1msk(n0l))
      allocate(r1out(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read Dat1 & Dat2  
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0mfname,r1msk)
      call read_binary(n0l,c0ifname,r1dat)
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write pickuped dat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r1out=p0mis
      i0cnt=0
c
      if(c0sgn.eq.'lt')then
        do i0l=1,n0l
          if(r1msk(i0l).lt.r0dat.and.r1dat(i0l).ne.p0mis) then
            r1out(i0l)=r1dat(i0l)
            i0cnt=i0cnt+1
            if(c0opt.eq.'long')then
              c0tmp='none'
              write(*,*)
     $             rgetlon(n0x,p0lonmin,p0lonmax,i1l2x(i0l),c0tmp),
     $             rgetlat(n0y,p0latmin,p0latmax,i1l2y(i0l),c0tmp),
     $             i0l,
     $             r1dat(i0l)
            end if
          end if
        end do
        if(c0opt.eq.'short'.or.c0opt.eq.'long')then
          write(*,*) i0cnt,' data_less_than ',r0dat
        end if
      else if(c0sgn.eq.'le')then
        do i0l=1,n0l
          if(r1msk(i0l).le.r0dat.and.r1dat(i0l).ne.p0mis) then
            r1out(i0l)=r1dat(i0l)
            i0cnt=i0cnt+1
            if(c0opt.eq.'long')then
              c0tmp='none'
              write(*,*)
     $             rgetlon(n0x,p0lonmin,p0lonmax,i1l2x(i0l),c0tmp),
     $             rgetlat(n0y,p0latmin,p0latmax,i1l2y(i0l),c0tmp),
     $             i0l,
     $             r1dat(i0l)
            end if
          end if
        end do
        if(c0opt.eq.'short'.or.c0opt.eq.'long')then
          write(*,*) i0cnt,' data_less_than_or_equal_to ',r0dat
        end if
      else if(c0sgn.eq.'gt')then
        do i0l=1,n0l
          if(r1msk(i0l).gt.r0dat.and.r1dat(i0l).ne.p0mis) then
            r1out(i0l)=r1dat(i0l)
            i0cnt=i0cnt+1
            if(c0opt.eq.'long')then
              c0tmp='none'
              write(*,*)
     $             rgetlon(n0x,p0lonmin,p0lonmax,i1l2x(i0l),c0tmp),
     $             rgetlat(n0y,p0latmin,p0latmax,i1l2y(i0l),c0tmp),
     $             i0l,
     $             r1dat(i0l)
            end if
          end if
        end do
        if(c0opt.eq.'short'.or.c0opt.eq.'long')then
          write(*,*) i0cnt,' data_greater_than ',r0dat
        end if
      else if(c0sgn.eq.'ge')then
        do i0l=1,n0l
          if(r1msk(i0l).ge.r0dat.and.r1dat(i0l).ne.p0mis) then
            r1out(i0l)=r1dat(i0l)
            i0cnt=i0cnt+1
            if(c0opt.eq.'long')then
              c0tmp='none'
              write(*,*)
     $             rgetlon(n0x,p0lonmin,p0lonmax,i1l2x(i0l),c0tmp),
     $             rgetlat(n0y,p0latmin,p0latmax,i1l2y(i0l),c0tmp),
     $             i0l,
     $             r1dat(i0l)
            end if
          end if
        end do
        if(c0opt.eq.'short'.or.c0opt.eq.'long')then
          write(*,*) i0cnt,' data_greater_than_or_equal_to ',r0dat
        end if
      else if(c0sgn.eq.'ne')then
        do i0l=1,n0l
          if(r1msk(i0l).ne.r0dat.and.r1dat(i0l).ne.p0mis) then
            r1out(i0l)=r1dat(i0l)
            i0cnt=i0cnt+1
            if(c0opt.eq.'long')then
              c0tmp='none'
              write(*,*)
     $             rgetlon(n0x,p0lonmin,p0lonmax,i1l2x(i0l),c0tmp),
     $             rgetlat(n0y,p0latmin,p0latmax,i1l2y(i0l),c0tmp),
     $             i0l,
     $             r1dat(i0l)
            end if
          end if
        end do
        if(c0opt.eq.'short'.or.c0opt.eq.'long')then
          write(*,*) i0cnt,' data_not_equal_to ',r0dat
        end if
      else if(c0sgn.eq.'eq')then
        do i0l=1,n0l
          if(r1msk(i0l).eq.r0dat.and.r1dat(i0l).ne.p0mis) then
            r1out(i0l)=r1dat(i0l)
            i0cnt=i0cnt+1
            if(c0opt.eq.'long')then
              c0tmp='none'
              write(*,*)
     $             rgetlon(n0x,p0lonmin,p0lonmax,i1l2x(i0l),c0tmp),
     $             rgetlat(n0y,p0latmin,p0latmax,i1l2y(i0l),c0tmp),
     $             i0l,
     $             r1dat(i0l)
            end if
          end if
        end do
        if(c0opt.eq.'short'.or.c0opt.eq.'long')then
          write(*,*) i0cnt,' data_equal_to ',r0dat
        end if
      else if(c0sgn.eq.'isnan')then
        do i0l=1,n0l
          if(isnan(r1msk(i0l))) then
            r1out(i0l)=r1dat(i0l)
            i0cnt=i0cnt+1
            if(c0opt.eq.'long')then
              c0tmp='none'
              write(*,*)
     $             rgetlon(n0x,p0lonmin,p0lonmax,i1l2x(i0l),c0tmp),
     $             rgetlat(n0y,p0latmin,p0latmax,i1l2y(i0l),c0tmp),
     $             i0l,
     $             r1dat(i0l)
            end if
          end if
        end do
        if(c0opt.eq.'short'.or.c0opt.eq.'long')then
          write(*,*) i0cnt,' data_is NaN '
        end if
      else
        write(*,*) 'sign ',c0sgn,' invalid. abort.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1out,c0ofname)
c      
      end
