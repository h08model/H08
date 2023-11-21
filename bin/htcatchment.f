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
      program htcatchment
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   mask the area upper the arbitral point
cby   2010/04/11, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
      real              p0lonmin
      real              p0latmin
      real              p0lonmax
      real              p0latmax
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
      integer           i0xnow
      integer           i0ynow
      integer           i0xtgt
      integer           i0ytgt
      integer           i0xnxt
      integer           i0ynxt
c temporary
      real,allocatable::r1tmp(:)
      character*128     c0tmp
      character*128     c0opt
c function
      integer           igeti0x
      integer           igeti0y
      integer           igetnxx !! function to get next x
      integer           igetnxy !! function to get next y
      real              rgetlon
      real              rgetlat
c in (map)
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128     c0l2x
      character*128     c0l2y
c in
      real              r0lon
      real              r0lat
      real,allocatable::r2flwdir(:,:)
      real,allocatable::r2rivseq(:,:)
      real,allocatable::r2rivnum(:,:)
      character*128     c0flwdir
      character*128     c0rivseq
      character*128     c0rivnum
c out
      real,allocatable::r2maskup(:,:)
      character*128     c0maskup
c local
      integer           i0dirnow
      integer           i0seqnow
      character*128     s0center
      data              s0center/'center'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.15.and.iargc().ne.16)then
        write(*,*) 'Usage: htcatchment n0l n0x n0y c0l2x c0l2y p0lonmin'
        write(*,*) '                   p0lonmax p0latmin p0latmax'
        write(*,*) '                   OPTION'
        write(*,*) 'OPTION:'
        write(*,*) '[{"l"      FLWDIR RIVSEQ RIVNUM c0bin i0l},'
        write(*,*) ' {"xy"     FLWDIR RIVSEQ RIVNUM c0bin i0x i0y},'
        write(*,*) ' {"lonlat" FLWDIR RIVSEQ RIVNUM c0bin r0lon r0lat}]'
        write(*,*) 'FLWDIR: Flow direction (map/dat/flw_dir_/)'
        write(*,*) 'RIVSEQ: River sequence (map/out/riv_seq_/)'
        write(*,*) 'RIVNUM: River number   (map/out/riv_num_/)'
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
      call getarg(10,c0opt)
      if(c0opt.eq.'l')then
        call getarg(11,c0flwdir)
        call getarg(12,c0rivseq)
        call getarg(13,c0rivnum)
        call getarg(14,c0maskup)
        call getarg(15,c0tmp)
        read (c0tmp,*) i0l
      else if(c0opt.eq.'xy')then
        call getarg(11,c0flwdir)
        call getarg(12,c0rivseq)
        call getarg(13,c0rivnum)
        call getarg(14,c0maskup)
        call getarg(15,c0tmp)
        read (c0tmp,*) i0x
        call getarg(16,c0tmp)
        read (c0tmp,*) i0y
      else if(c0opt.eq.'lonlat')then
        call getarg(11,c0flwdir)
        call getarg(12,c0rivseq)
        call getarg(13,c0rivnum)
        call getarg(14,c0maskup)
        call getarg(15,c0tmp)
        read (c0tmp,*) r0lon
        call getarg(16,c0tmp)
        read (c0tmp,*) r0lat
      end if
c
      allocate(r1tmp(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      allocate(r2flwdir(n0x,n0y))
      allocate(r2rivseq(n0x,n0y))
      allocate(r2rivnum(n0x,n0y))
      allocate(r2maskup(n0x,n0y))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
c
      if(c0opt.eq.'l')then
        r0lon=rgetlon(n0x,p0lonmin,p0lonmax,i1l2x(i0l),s0center)
        r0lat=rgetlat(n0y,p0latmin,p0latmax,i1l2y(i0l),s0center)
      else if (c0opt.eq.'xy')then
        r0lon=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0center)
        r0lat=rgetlat(n0y,p0latmin,p0latmax,i0y,s0center)
      end if
c
      i0xtgt=igeti0x(n0x,p0lonmin,p0lonmax,r0lon)
      i0ytgt=igeti0y(n0y,p0latmin,p0latmax,r0lat)
c
      call read_binary(n0l,c0flwdir,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2flwdir)
      call read_binary(n0l,c0rivseq,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2rivseq)
      call read_binary(n0l,c0rivnum,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2rivnum)
c
d      write(*,*) i0xtgt,i0ytgt
d      write(*,*) r2flwdir(i0xtgt,i0ytgt)
d      write(*,*) r2rivseq(i0xtgt,i0ytgt)
d      write(*,*) r2rivnum(i0xtgt,i0ytgt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c maskout other basins
      do i0y=1,n0y
        do i0x=1,n0x
          if(int(r2rivnum(i0x,i0y)).ne.int(r2rivnum(i0xtgt,i0ytgt)))then
            r2flwdir(i0x,i0y)=0.0
          end if
        end do
      end do
c
      do i0y=1,n0y
        do i0x=1,n0x
          if (r2flwdir(i0x,i0y).ne.0.0)then
            i0xnow=i0x
            i0ynow=i0y
 10         i0seqnow=r2rivseq(i0xnow,i0ynow)
            i0dirnow=int(r2flwdir(i0xnow,i0ynow))
c     
            if (i0dirnow.ne.0)then
              i0xnxt=igetnxx(n0x,i0xnow,i0dirnow)
              i0ynxt=igetnxy(n0y,i0ynow,i0dirnow)
              if ((i0xnxt.eq.i0xtgt).and.(i0ynxt.eq.i0ytgt))then
                r2maskup(i0x,i0y)=1.0
d               write(*,101) i0xnow,i0ynow,i0xnxt,i0ynxt,
d    $               ' = ',i0xtgt,i0ytgt,' Find target'
d               write(*,*) i0x,i0y,' r2maskup(i0x,i0y) =',
d    $               r2maskup(i0x,i0y),' Reach to the Point'
              else
d               write(*,102) i0xnow,i0ynow,i0xnxt,i0ynxt,
d    $               ' ne',i0xtgt,i0ytgt,int(r2flwdir(i0xnow,i0ynow)),
d    $               int(r2rivseq(i0xnow,i0ynow)),' Search lower'
                i0xnow=i0xnxt
                i0ynow=i0ynxt             
                if ((i0xnow.eq.0).and.(i0ynow.eq.0))then
                  r2maskup(i0x,i0y)=0.0
d                 write(*,*) i0x,i0y,' r2maskup(i0x,i0y) =',
d    $                 r2maskup(i0x,i0y),
d    $                 ' Reach to the Sea'
                else
                  go to 10
                endif 
              endif 
            endif
c
          else 
            r2maskup(i0x,i0y)=0.0
          endif 
        enddo 
      enddo
c
      r2maskup(i0xtgt,i0ytgt)=1
d     write(*,*) i0xtgt,i0ytgt,r2maskup(i0xtgt,i0ytgt)
c
 101  format ("At",2i5," Next",2i5,a3,2i5,a11)
 102  format ("At",2i5," Next",2i5,a3,2i5,'  Flw=',i2,' Seq=',i3,a11)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,r2maskup,r1tmp)
      call wrte_binary(n0l,r1tmp,c0maskup)
c
      end


