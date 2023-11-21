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
      program htlinear
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   interpolate
cby   2010/03/31, hanasaki: H08 ver1.0
c
c   -->x
c   |
c   v   (i0x,i0y)A-----B(i0x+1,i0y)
c   y            |     |
c                |     |
c     (i0x,i0y+1)C-----D(i0x+1,i0y+1)
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l1          !! original array size (l)
      integer           n0x1          !! original array size (x)
      integer           n0y1          !! original array size (y)
      integer           n0l2          !! new array size (l)
      integer           n0x2          !! new array size (x)
      integer           n0y2          !! new array size (y)
      real              p0lonmin1     !! original array lon min
      real              p0lonmax1     !! original array lon max
      real              p0latmin1     !! original array lat min
      real              p0latmax1     !! original array lat max
      real              p0lonmin2     !! new array lon min
      real              p0lonmax2     !! new array lon max
      real              p0latmin2     !! new array lat min
      real              p0latmax2     !! new array lat max
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0x1
      integer           i0y1
      integer           i0x2
      integer           i0y2
      integer           i0xint
      integer           i0yint
c function
      real              rgetlon
      real              rgetlat
      integer           igeti0x
      integer           igeti0y
c temporary
      character*128     c0tmp
      character*128     c0opt
c in (set)
      integer           i0x2dbg
      integer           i0y2dbg
c in (map)
      integer,allocatable::i1l2x1(:)  !! land --> x converter for original
      integer,allocatable::i1l2x2(:)  !! land --> x converter for original
      integer,allocatable::i1l2y1(:)  !! land --> x converter for original
      integer,allocatable::i1l2y2(:)  !! land --> x converter for original
      character*128     c0l2x1        !! land --> x converter for original
      character*128     c0l2x2        !! land --> x converter for new
      character*128     c0l2y1        !! land --> y converter for original
      character*128     c0l2y2        !! land --> y converter for new
c in (flux)
      real,allocatable::r1dat(:)
      real,allocatable::r2dat(:,:)
      character*128     c0ifname
c out
      real,allocatable::r1out(:)
      real,allocatable::r2out(:,:)
      character*128     c0ofname
c local
      real              r0lon2        !! longitude of point
      real              r0lat2        !! latitude of point
      real              r0lonA        !! longitude of point A
      real              r0lonB        !! longitude of point A
      real              r0lonC        !! longitude of point A
      real              r0lonD        !! longitude of point A
      real              r0latA        !! latitude of point A
      real              r0latB        !! latitude of point A
      real              r0latC        !! latitude of point A
      real              r0latD        !! latitude of point A
      real              r0datA        !! data of point A
      real              r0datB        !! data of point B
      real              r0datC        !! data of point C
      real              r0datD        !! data of point D
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.20.and.iargc().ne.22)then
        write(*,*) 'Usage: htlinear n0l n0x n0y c0l2x c0l2y'
        write(*,*) '                p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '                n0l n0x n0y c0l2x c0l2y'
        write(*,*) '                p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '                c0bin c0bin'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l1
      call getarg(2,c0tmp)
      read(c0tmp,*) n0x1
      call getarg(3,c0tmp)
      read(c0tmp,*) n0y1
      call getarg(4,c0l2x1)
      call getarg(5,c0l2y1)
      call getarg(6,c0tmp)
      read(c0tmp,*) p0lonmin1
      call getarg(7,c0tmp)
      read(c0tmp,*) p0lonmax1
      call getarg(8,c0tmp)
      read(c0tmp,*) p0latmin1
      call getarg(9,c0tmp)
      read(c0tmp,*) p0latmax1
c
      call getarg(10,c0tmp)
      read(c0tmp,*) n0l2
      call getarg(11,c0tmp)
      read(c0tmp,*) n0x2
      call getarg(12,c0tmp)
      read(c0tmp,*) n0y2
      call getarg(13,c0l2x2)
      call getarg(14,c0l2y2)
      call getarg(15,c0tmp)
      read(c0tmp,*) p0lonmin2
      call getarg(16,c0tmp)
      read(c0tmp,*) p0lonmax2
      call getarg(17,c0tmp)
      read(c0tmp,*) p0latmin2
      call getarg(18,c0tmp)
      read(c0tmp,*) p0latmax2
c
      call getarg(19,c0ifname)
      call getarg(20,c0ofname)
c
      if(iargc().eq.22)then
        call getarg(21,c0tmp)
        read(c0tmp,*) i0x2dbg
        call getarg(22,c0tmp)
        read(c0tmp,*) i0y2dbg
      end if
c
      allocate(i1l2x1(n0l1))
      allocate(i1l2x2(n0l2))
      allocate(i1l2y1(n0l1))
      allocate(i1l2y2(n0l2))
      allocate(r1dat(n0l1))
      allocate(r2dat(n0x1,n0y1))
      allocate(r1out(n0l2))
      allocate(r2out(n0x2,n0y2))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read l2x,l2y lookup table
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(n0l1,c0l2x1,c0l2y1,i1l2x1,i1l2y1)
      call read_i1l2xy(n0l2,c0l2x2,c0l2y2,i1l2x2,i1l2y2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read original array
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l1,c0ifname,r1dat)
      call conv_r1tor2(n0l1,n0x1,n0y1,i1l2x1,i1l2y1,r1dat,r2dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Loop start 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0y2=1,n0y2
        do i0x2=1,n0x2
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htlinear: i0x2,i0y2 : ',i0x2,i0y2
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get longitude/latitude of new array 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          c0opt='center'
          r0lon2=rgetlon(n0x2,p0lonmin2,p0lonmax2,i0x2,  c0opt)
          r0lat2=rgetlat(n0y2,p0latmin2,p0latmax2,i0y2,  c0opt)
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htlinear: r0lon2,r0lat2: ',r0lon2,r0lat2
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get corresponding x/y of original array
c We can get x/y of point A because igeti0x/i0y disregards fractions
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          i0x1=igeti0x(n0x1,p0lonmin1,p0lonmax1,r0lon2)
          i0y1=igeti0y(n0y1,p0latmin1,p0latmax1,r0lat2)
c bugfix start
          r0lonA=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1  ,c0opt)
          r0latA=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1  ,c0opt)
          if(r0lon2.lt.r0lonA)then
            i0x1=i0x1-1
          end if
          if(r0lat2.gt.r0latA)then
            i0y1=i0y1-1
          end if
c bugfix end
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htlinear: i0x1,i0y1: ',i0x1,i0y1
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get lon/lat and data of Point A
c If statements in case of i0x/i0y=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0x1.eq.0)then
            r0lonA=rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,c0opt)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,c0opt)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,1+1   ,c0opt)
          else
            r0lonA=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1  ,c0opt)
          end if
c
          if(i0y1.eq.0)then
            r0latA=rgetlat(n0y1,p0latmin1,p0latmax1,1     ,c0opt)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,1     ,c0opt)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,1+1   ,c0opt)
          else
            r0latA=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1  ,c0opt)
          end if
c
          r0datA=r2dat(max(1,i0x1),max(1,i0y1))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get lon/lat and data of Point B
c If statements in case of i0x/i0y=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0x1.eq.n0x1)then
            r0lonB=rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,c0opt)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,c0opt)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1-1,c0opt)
          else
            r0lonB=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1+1,c0opt)
          end if
c
          if(i0y1.eq.0)then
            r0latB=rgetlat(n0y1,p0latmin1,p0latmax1,1     ,c0opt)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,1     ,c0opt)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,1+1   ,c0opt)
          else
            r0latB=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1  ,c0opt)
          end if
c
          if(i0x1.eq.n0x1)then
            r0datB=r2dat(1,max(1,i0y1))
          else
            r0datB=r2dat(i0x1+1,max(1,i0y1))
          end if
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get lon/lat and data of Point C
c If statements in case of i0x/i0y=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0x1.eq.0)then
            r0lonC=rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,c0opt)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,c0opt)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,1+1   ,c0opt)
          else
            r0lonC=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1  ,c0opt)
          end if
c
          if(i0y1+1.gt.n0y1)then
            r0latC=rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,c0opt)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,c0opt)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,n0y1-1,c0opt)
          else
            r0latC=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1+1,c0opt)
          end if
c
          if(i0y1.eq.n0y1)then
            r0datC=r2dat(max(1,i0x1),i0y1)
          else
            r0datC=r2dat(max(1,i0x1),i0y1+1)
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get lon/lat and data of Point D
c If statements in case of i0x/i0y=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0x1.eq.n0x1)then
            r0lonD=rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,c0opt)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,c0opt)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1-1,c0opt)
          else
            r0lonD=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1+1,c0opt)
          end if
c
          if(i0y1.eq.n0y1)then
            r0latD=rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,c0opt)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,c0opt)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,n0y1-1,c0opt)
          else
            r0latD=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1+1,c0opt)
          end if
c
          if(     i0x1.eq.n0x1.and.i0y1.eq.n0y1)then
            r0datD=r2dat(1,i0y1)
          else if(i0x1.eq.n0x1.and.i0y1.lt.n0y1)then
            r0datD=r2dat(1,i0y1+1)
          else if(i0x1.lt.n0x1.and.i0y1.eq.n0y1)then
            r0datD=r2dat(i0x1+1,i0y1)
          else
            r0datD=r2dat(i0x1+1,i0y1+1)
          end if
c
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htlinear: r0lon/lat/datA: ',r0lonA,r0latA,r0datA
            write(*,*) 'htlinear: r0lon/lat/datB: ',r0lonB,r0latB,r0datB
            write(*,*) 'htlinear: r0lon/lat/datC: ',r0lonC,r0latC,r0datC
            write(*,*) 'htlinear: r0lon/lat/datD: ',r0lonD,r0latD,r0datD
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(r0datA.ne.p0mis.and.r0datB.ne.p0mis.and.
     $       r0datC.ne.p0mis.and.r0datD.ne.p0mis)then
            r2out(i0x2,i0y2)
     $              =(( (r0datA*(r0lonB-r0lon2)+r0datB*(r0lon2-r0lonA))
     $                 /
     $                  (r0lonB-r0lonA)
     $                )*(r0lat2-r0latD)
     $               +( (r0datC*(r0lonD-r0lon2)+r0datD*(r0lon2-r0lonC))
     $                 /
     $                  (r0lonD-r0lonC)
     $                )*(r0latB-r0lat2)
     $               )
     $               /
     $               (r0latB-r0latD)
          else
            r2out(i0x2,i0y2)=p0mis
          end if
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htlinear: r2out: ',r2out(i0x2,i0y2)
            write(*,*) (r0lonB-r0lon2)/(r0lonB-r0lonA)
     $                *(r0lat2-r0latD)/(r0latB-r0latD)
            write(*,*) (r0lon2-r0lonA)/(r0lonB-r0lonA)
     $                *(r0lat2-r0latD)/(r0latB-r0latD)
            write(*,*) (r0lonD-r0lon2)/(r0lonD-r0lonC)
     $                *(r0latB-r0lat2)/(r0latB-r0latD)
            write(*,*) (r0lon2-r0lonC)/(r0lonD-r0lonC)
     $                *(r0latB-r0lat2)/(r0latB-r0latD)
            write(*,*) (r0lonB-r0lon2),(r0lonB-r0lonA)
     $                ,(r0lat2-r0latD),(r0latB-r0latD)
            write(*,*) (r0lon2-r0lonA),(r0lonB-r0lonA)
     $                ,(r0lat2-r0latD),(r0latB-r0latD)
            write(*,*) (r0lonD-r0lon2),(r0lonD-r0lonC)
     $                ,(r0latB-r0lat2),(r0latB-r0latD)
            write(*,*) (r0lon2-r0lonC),(r0lonD-r0lonC)
     $                ,(r0latB-r0lat2),(r0latB-r0latD)
          end if
        end do
      end do
c
      call conv_r2tor1(n0l2,n0x2,n0y2,i1l2x2,i1l2y2,r2out,r1out)
      call wrte_binary(n0l2,r1out,c0ofname)
c
      end
