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
      program htidw
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   interpolate in inverse distance weighting
cby   2011/01/31, hanasaki: H08 ver1.0
c
c   -->x
c   |
c   v   A(i0x-1,i0y-1)-----B(i0x,i0y-1)----C(i0x+1,i0y-1)----D(i0x+2,i0y-1)
c   y   |                  |               |                 |
c       |                  |               |                 |
c       E(i0x-1,i0y)-------F(i0x,i0y)------G(i0x+1,i0y)------H(i0x+2,i0y)
c       |                  |               |                 |
c       |                  |               |                 |
c       I(i0x-1,i0y+1)-----J(i0x,i0y+1)----K(i0x+1,i0y+1)----L(i0x+2,i0y+1)
c       |                  |               |                 |
c       |                  |               |                 |
c       M(i0x-1,i0y+2)-----N(i0x,i0y+2)----O(i0x+1,i0y+2)----P(i0x+2,i0y+2)
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
      real              p0thr         !! threshold (minimum distance)
      real              p0pow         !! power 
      parameter        (p0mis=1.0E20) 
      parameter        (p0thr=1.0) 
c      parameter        (p0pow=2.0) 
c      parameter        (p0pow=1.0) 
      integer           n0rec
      integer           n0rnk
c      parameter        (n0rec=16)     !! Evaluating 16 surrounding points
c      parameter        (n0rnk=10)     !! number of points to include
      parameter        (n0rec=16)     !! Evaluating 16 surrounding points
c      parameter        (n0rnk=4)     !! number of points to include
c index (array)
      integer           i0x1
      integer           i0y1
      integer           i0x2
      integer           i0y2
      integer           i0x3
      integer           i0y3
      integer           i0rec
      integer           i0rnk
      integer           n0rng         !! range: # of cells to smooth
c function
      real              rgetlon
      real              rgetlat
      real              rgetlen
      integer           igeti0x
      integer           igeti0y
c temporary
      integer           i0cnt
      character*128     c0tmp
      character*128     s0center
      data              s0center/'center'/ 
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
      real,allocatable::r2outsmt(:,:)
      character*128     c0ofname
c local
      real              r0lon2        !! longitude of point
      real              r0lat2        !! latitude of point
      real              r0lonA        !! longitude of point A
      real              r0lonB        !! longitude of point B
      real              r0lonC        !! longitude of point C
      real              r0lonD        !! longitude of point D
      real              r0lonE        !! longitude of point E
      real              r0lonF        !! longitude of point F
      real              r0lonG        !! longitude of point G
      real              r0lonH        !! longitude of point H
      real              r0lonI        !! longitude of point I
      real              r0lonJ        !! longitude of point J
      real              r0lonK        !! longitude of point K
      real              r0lonL        !! longitude of point L
      real              r0lonM        !! longitude of point M
      real              r0lonN        !! longitude of point N
      real              r0lonO        !! longitude of point O
      real              r0lonP        !! longitude of point P
      real              r0latA        !! latitude of point A
      real              r0latB        !! latitude of point B
      real              r0latC        !! latitude of point C
      real              r0latD        !! latitude of point D
      real              r0latE        !! latitude of point E
      real              r0latF        !! latitude of point F
      real              r0latG        !! latitude of point G
      real              r0latH        !! latitude of point H
      real              r0latI        !! latitude of point I
      real              r0latJ        !! latitude of point J
      real              r0latK        !! latitude of point K
      real              r0latL        !! latitude of point L
      real              r0latM        !! latitude of point M
      real              r0latN        !! latitude of point N
      real              r0latO        !! latitude of point O
      real              r0latP        !! latitude of point P
      real              r1val(n0rec)  !! data of point i0rec
      real              r1dis(n0rec)  !! distance to point i0rec
      real              r1wgt(n0rec)  !! weight of point i0rec
      real              r1dissrt(n0rec)
      integer           i1org2rnk(n0rec)
      integer           i1rnk2org(n0rec)
      integer           i0xA        !! distance to point A
      integer           i0xB        !! distance to point B
      integer           i0xC        !! distance to point C
      integer           i0xD        !! distance to point D
      integer           i0xE        !! distance to point E
      integer           i0xF        !! distance to point F
      integer           i0xG        !! distance to point G
      integer           i0xH        !! distance to point H
      integer           i0xI        !! distance to point I
      integer           i0xJ        !! distance to point J
      integer           i0xK        !! distance to point K
      integer           i0xL        !! distance to point L
      integer           i0xM        !! distance to point M
      integer           i0xN        !! distance to point N
      integer           i0xO        !! distance to point O
      integer           i0xP        !! distance to point P      
      integer           i0yA        !! distance to point A
      integer           i0yB        !! distance to point B
      integer           i0yC        !! distance to point C
      integer           i0yD        !! distance to point D
      integer           i0yE        !! distance to point E
      integer           i0yF        !! distance to point F
      integer           i0yG        !! distance to point G
      integer           i0yH        !! distance to point H
      integer           i0yI        !! distance to point I
      integer           i0yJ        !! distance to point J
      integer           i0yK        !! distance to point K
      integer           i0yL        !! distance to point L
      integer           i0yM        !! distance to point M
      integer           i0yN        !! distance to point N
      integer           i0yO        !! distance to point O
      integer           i0yP        !! distance to point P      
c 
      integer           i0flg         !! flag
      real              r0sum      !! summation of weights
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c      if(iargc().ne.20.and.iargc().ne.22)then
      if(iargc().ne.23.and.iargc().ne.25)then
        write(*,*) 'Usage: htidw n0l n0x n0y c0l2x c0l2y'
        write(*,*) '             p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '             n0l n0x n0y c0l2x c0l2y'
        write(*,*) '             p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '             c0bin c0bin'
        write(*,*) '             p0pow n0rnk n0rng'
        write(*,*) '            [i0x2dbg i0y2dbg]'
        write(*,*) 'p0pow: power of inverse distance. e.g. 2.0'
        write(*,*) 'n0rnk: number of cells to use.Min=1,Max=16. e.g. 10'
        write(*,*) 'n0rng: distance to smooth. 0 for no smooth. e.g. 2'
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
      call getarg(21,c0tmp)
      read(c0tmp,*) p0pow
      call getarg(22,c0tmp)
      read(c0tmp,*) n0rnk
      call getarg(23,c0tmp)
      read(c0tmp,*) n0rng
c
c      if(iargc().eq.22)then
      if(iargc().eq.25)then
        call getarg(24,c0tmp)
        read(c0tmp,*) i0x2dbg
        call getarg(25,c0tmp)
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
      allocate(r2outsmt(n0x2,n0y2))
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
            write(*,*) 'htidw: i0x2,i0y2 : ',i0x2,i0y2
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get longitude/latitude of new array 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          r0lon2=rgetlon(n0x2,p0lonmin2,p0lonmax2,i0x2,  s0center)
          r0lat2=rgetlat(n0y2,p0latmin2,p0latmax2,i0y2,  s0center)
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htidw: r0lon2,r0lat2: ',r0lon2,r0lat2
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get corresponding x/y of original array
c We can get x/y of point F because igeti0x/i0y disregards fractions
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          i0x1=igeti0x(n0x1,p0lonmin1,p0lonmax1,r0lon2)
          i0y1=igeti0y(n0y1,p0latmin1,p0latmax1,r0lat2)
c bugfix start
          r0lonF=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1  ,s0center)
          r0latF=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1  ,s0center)
          if(r0lon2.lt.r0lonF)then
            i0x1=i0x1-1
          end if
          if(r0lat2.gt.r0latF)then
            i0y1=i0y1-1
          end if
c bugfix end
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htidw: i0x1,i0y1: ',i0x1,i0y1
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get lon of Point A,B,C,D
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0x1.eq.1)then
            r0lonA=rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,s0center)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,s0center)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,1+1   ,s0center)
          else if(i0x1.eq.0)then
            r0lonA=rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,s0center)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,s0center)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,1+2   ,s0center)
          else
            r0lonA=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1-1,s0center)
          end if
c
          if(i0x1.eq.0)then
            r0lonB=rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,s0center)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,1     ,s0center)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,1+1   ,s0center)
          else
            r0lonB=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1  ,s0center)
          end if
c
          if(i0x1.eq.n0x1)then
            r0lonC=rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,s0center)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,s0center)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1-1,s0center)
          else
            r0lonC=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1+1,s0center)
          end if
c
          if(i0x1.eq.n0x1-1)then
            r0lonD=rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,s0center)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,s0center)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1-1,s0center)
          else if(i0x1.eq.n0x1)then
            r0lonD=rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,s0center)
     $            +rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1  ,s0center)
     $            -rgetlon(n0x1,p0lonmin1,p0lonmax1,n0x1-2,s0center)
          else
            r0lonD=rgetlon(n0x1,p0lonmin1,p0lonmax1,i0x1+2,s0center)
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get lat of A,E,I,M
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0y1.eq.1)then
            r0latA=rgetlat(n0y1,p0latmin1,p0latmax1,1     ,s0center)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,1     ,s0center)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,1+1   ,s0center)
          else if(i0y1.eq.0)then
            r0latA=rgetlat(n0y1,p0latmin1,p0latmax1,1     ,s0center)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,1     ,s0center)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,1+2   ,s0center)
          else
            r0latA=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1-1,s0center)
          end if
c
          if(i0y1.eq.0)then
            r0latE=rgetlat(n0y1,p0latmin1,p0latmax1,1  , s0center)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,1  , s0center)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,1+1, s0center)
          else
            r0latE=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1,s0center)
          end if
c
          if(i0y1.eq.n0y1)then
            r0latI=rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,s0center)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,s0center)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,n0y1-1,s0center)
          else
            r0latI=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1+1,s0center)
          end if
c
          if(i0y1.eq.n0y1-1)then
            r0latM=rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,s0center)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,s0center)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,n0y1-1,s0center)
          else if(i0y1.eq.n0y1)then
            r0latM=rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,s0center)
     $            +rgetlat(n0y1,p0latmin1,p0latmax1,n0y1  ,s0center)
     $            -rgetlat(n0y1,p0latmin1,p0latmax1,n0y1-2,s0center)
          else
            r0latM=rgetlat(n0y1,p0latmin1,p0latmax1,i0y1+2,s0center)
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get x of A,B,C,D
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0x1.eq.1)then
            i0xA=n0x1
          else if(i0x1.eq.0)then
            i0xA=n0x1-1
          else
            i0xA=i0x1-1
          end if
c
          if(i0x1.eq.0)then
            i0xB=n0x1
          else
            i0xB=i0x1
          end if
c
          if(i0x1.eq.n0x1)then
            i0xC=1
          else
            i0xC=i0x1+1
          end if
c
          if(i0x1.eq.n0x1-1)then
            i0xD=1
          else if(i0x1.eq.n0x1)then
            i0xD=2
          else
            i0xD=i0x1+2
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get y of A,E,I,M
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0y1.eq.1)then
            i0yA=1
          else if(i0y1.eq.0)then
            i0yA=1
          else
            i0yA=i0y1-1
          end if
c
          if(i0y1.eq.0)then
            i0yE=1
          else
            i0yE=i0y1
          end if
c
          if(i0y1.eq.n0y1)then
            i0yI=n0y1
          else
            i0yI=i0y1+1
          end if
c
          if(i0y1.eq.n0y1-1)then
            i0yM=n0y1
          else if(i0y1.eq.n0y1)then
            i0yM=n0y1
          else
            i0yM=i0y1+2
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get lon/lat/dat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          r0lonA=r0lonA
          r0lonB=r0lonB
          r0lonC=r0lonC
          r0lonD=r0lonD
          r0lonE=r0lonA
          r0lonF=r0lonB
          r0lonG=r0lonC
          r0lonH=r0lonD
          r0lonI=r0lonA
          r0lonJ=r0lonB
          r0lonK=r0lonC
          r0lonL=r0lonD
          r0lonM=r0lonA
          r0lonN=r0lonB
          r0lonO=r0lonC
          r0lonP=r0lonD
c
          r0latA=r0latA
          r0latB=r0latA
          r0latC=r0latA
          r0latD=r0latA
          r0latE=r0latE
          r0latF=r0latE
          r0latG=r0latE
          r0latH=r0latE
          r0latI=r0latI
          r0latJ=r0latI
          r0latK=r0latI
          r0latL=r0latI
          r0latM=r0latM
          r0latN=r0latM
          r0latO=r0latM
          r0latP=r0latM
c
          r1val(1)=r2dat(i0xA,i0yA)
          r1val(2)=r2dat(i0xB,i0yA)
          r1val(3)=r2dat(i0xC,i0yA)
          r1val(4)=r2dat(i0xD,i0yA)
          r1val(5)=r2dat(i0xA,i0yE)
          r1val(6)=r2dat(i0xB,i0yE)
          r1val(7)=r2dat(i0xC,i0yE)
          r1val(8)=r2dat(i0xD,i0yE)
          r1val(9)=r2dat(i0xA,i0yI)
          r1val(10)=r2dat(i0xB,i0yI)
          r1val(11)=r2dat(i0xC,i0yI)
          r1val(12)=r2dat(i0xD,i0yI)
          r1val(13)=r2dat(i0xA,i0yM)
          r1val(14)=r2dat(i0xB,i0yM)
          r1val(15)=r2dat(i0xC,i0yM)
          r1val(16)=r2dat(i0xD,i0yM)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
          write(*,*) 'htidw: r0lon/lat/datA: ',r0lonA,r0latA,r1val(1)
          write(*,*) 'htidw: r0lon/lat/datB: ',r0lonB,r0latB,r1val(2)
          write(*,*) 'htidw: r0lon/lat/datC: ',r0lonC,r0latC,r1val(3)
          write(*,*) 'htidw: r0lon/lat/datD: ',r0lonD,r0latD,r1val(4)
          write(*,*) 'htidw: r0lon/lat/datE: ',r0lonE,r0latE,r1val(5)
          write(*,*) 'htidw: r0lon/lat/datF: ',r0lonF,r0latF,r1val(6)
          write(*,*) 'htidw: r0lon/lat/datG: ',r0lonG,r0latG,r1val(7)
          write(*,*) 'htidw: r0lon/lat/datH: ',r0lonH,r0latH,r1val(8)
          write(*,*) 'htidw: r0lon/lat/datI: ',r0lonI,r0latI,r1val(9)
          write(*,*) 'htidw: r0lon/lat/datJ: ',r0lonJ,r0latJ,r1val(10)
          write(*,*) 'htidw: r0lon/lat/datK: ',r0lonK,r0latK,r1val(11)
          write(*,*) 'htidw: r0lon/lat/datL: ',r0lonL,r0latL,r1val(12)
          write(*,*) 'htidw: r0lon/lat/datM: ',r0lonM,r0latM,r1val(13)
          write(*,*) 'htidw: r0lon/lat/datN: ',r0lonN,r0latN,r1val(14)
          write(*,*) 'htidw: r0lon/lat/datO: ',r0lonO,r0latO,r1val(15)
          write(*,*) 'htidw: r0lon/lat/datP: ',r0lonP,r0latP,r1val(16)
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Estimate the distance from A,B,C,D
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          r1dis(1)=rgetlen(r0lon2,r0lonA,r0lat2,r0latA)
          r1dis(2)=rgetlen(r0lon2,r0lonB,r0lat2,r0latB)
          r1dis(3)=rgetlen(r0lon2,r0lonC,r0lat2,r0latC)
          r1dis(4)=rgetlen(r0lon2,r0lonD,r0lat2,r0latD)
          r1dis(5)=rgetlen(r0lon2,r0lonE,r0lat2,r0latE)
          r1dis(6)=rgetlen(r0lon2,r0lonF,r0lat2,r0latF)
          r1dis(7)=rgetlen(r0lon2,r0lonG,r0lat2,r0latG)
          r1dis(8)=rgetlen(r0lon2,r0lonH,r0lat2,r0latH)
          r1dis(9)=rgetlen(r0lon2,r0lonI,r0lat2,r0latI)
          r1dis(10)=rgetlen(r0lon2,r0lonJ,r0lat2,r0latJ)
          r1dis(11)=rgetlen(r0lon2,r0lonK,r0lat2,r0latK)
          r1dis(12)=rgetlen(r0lon2,r0lonL,r0lat2,r0latL)
          r1dis(13)=rgetlen(r0lon2,r0lonM,r0lat2,r0latM)
          r1dis(14)=rgetlen(r0lon2,r0lonN,r0lat2,r0latN)
          r1dis(15)=rgetlen(r0lon2,r0lonO,r0lat2,r0latO)
          r1dis(16)=rgetlen(r0lon2,r0lonP,r0lat2,r0latP)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c If the distance from A,B,C,D is less than threshold, raise flag.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          i0flg=0
          if(r1dis(6).le.p0thr)then
            i0flg=1
          else if(r1dis(7).le.p0thr)then
            i0flg=2
          else if(r1dis(10).le.p0thr)then
            i0flg=3
          else if(r1dis(11).le.p0thr)then
            i0flg=4
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          call sort_incord(n0rec,r1dis,r1dissrt,i1org2rnk,i1rnk2org)
c
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            do i0rec=1,n0rec
              write(*,*) 'htidw: incord:         ',r1dis(i0rec),
     $             r1dissrt(i0rec),i1org2rnk(i0rec),i1rnk2org(i0rec)
            end do
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Weight
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0flg.eq.0)then
            do i0rnk=1,n0rnk
              if(r1val(i1rnk2org(i0rnk)).ne.p0mis)then
                r1wgt(i1rnk2org(i0rnk))=(1.0/r1dissrt(i0rnk))**p0pow
              else
                r1wgt(i1rnk2org(i0rnk))=0.0
              end if
            end do
            if(n0rnk.le.15)then
              do i0rnk=n0rnk+1,16
                r1wgt(i1rnk2org(i0rnk))=0.0
              end do
            end if
          else
            r1wgt=0.0
          end if
c
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            do i0rec=1,n0rec
              write(*,*) 'htidw: r1wgt:         ',i0rec,r1wgt(i0rec)
            end do
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Summation of inverse distance weighting
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          r0sum=0
          if(i0flg.eq.0)then
            do i0rec=1,16
              r0sum=r0sum+r1wgt(i0rec)
            end do
          else
            r0sum=1.0
          end if
c
          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htidw: r0sum:         ',r0sum
          end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
          if(i0flg.eq.0)then
            do i0rec=1,n0rec
              if(r1val(i0rec).ne.p0mis)then
                r2out(i0x2,i0y2)=r2out(i0x2,i0y2)
     $               +r1val(i0rec)*r1wgt(i0rec)/r0sum
              end if
            end do
          else if(i0flg.eq.1)then
            r2out(i0x2,i0y2)=r1val(6)
          else if(i0flg.eq.2)then
            r2out(i0x2,i0y2)=r1val(7)
          else if(i0flg.eq.3)then
            r2out(i0x2,i0y2)=r1val(10)
          else if(i0flg.eq.4)then
            r2out(i0x2,i0y2)=r1val(11)
          end if

          if(i0x2.eq.i0x2dbg.and.i0y2.eq.i0y2dbg)then
            write(*,*) 'htidw: r2out:         ',r2out(i0x2,i0y2)
            do i0rec=1,n0rec
              write(*,*) 'htidw: distance to',i0rec,r1dis(i0rec),
     $             i1org2rnk(i0rec)
            end do
            if(r0sum.ne.0.0)then
              do i0rec=1,n0rec
                write(*,*) 'htidw: ',i0rec,int(r1wgt(i0rec)/r0sum*100)
              end do
            end if
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Smoothing
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r2outsmt=r2out
c
      if(n0rng.ge.1)then
        if(n0y2.ge.n0rng*2+1.and.n0x2.ge.n0rng*2+1)then
          do i0y2=1+n0rng,n0y2-n0rng
            do i0x2=1+n0rng,n0x2-n0rng
              r2outsmt(i0x2,i0y2)=0.0
              i0cnt=0
              do i0y3=-1*n0rng,n0rng
                do i0x3=-1*n0rng,n0rng
                  if(r2out(i0x2+i0x3,i0y2+i0y3).ne.p0mis)then
                    r2outsmt(i0x2,i0y2)
     $                   =r2outsmt(i0x2,i0y2)
     $                   +r2out(i0x2+i0x3,i0y2+i0y3)
                    i0cnt=i0cnt+1
                  end if
                end do
              end do
              r2outsmt(i0x2,i0y2)=r2outsmt(i0x2,i0y2)/real(i0cnt)
            end do
          end do
        else
          write(*,*) 'htidw Smoothing failed. No somoothed output'
        end if
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call conv_r2tor1(n0l2,n0x2,n0y2,i1l2x2,i1l2y2,r2outsmt,r1out)
      call wrte_binary(n0l2,r1out,c0ofname)
c
      end
