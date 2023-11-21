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
      program prog_map_lcan
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare a map of canal water intake
cby   2014/05/09, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      integer           n0x
      integer           n0y
      integer           n0recmax
      real              p0lonmin
      real              p0lonmax
      real              p0latmin
      real              p0latmax
c     parameter        (n0recmax=10)
      parameter        (n0recmax=20) 
c index
      integer           i0l
      integer           i0x
      integer           i0y
      integer           i0x2
      integer           i0y2
      integer           i0optmax
      integer           i0rec
      integer           i0flg
c temporary
      integer           i0tmp
      character*128     c0optlim
      character*128     c0tmp
      real,allocatable::r1tmp(:)
      real              r0tmp
c in
      real,allocatable::r2elvmin(:,:)
      real,allocatable::r2rivnum(:,:)
      real,allocatable::r2rivara(:,:)
      real,allocatable::r2rivseq(:,:)
      real,allocatable::r2rivnxl(:,:)
      character*128     c0elvmin
      character*128     c0rivnum
      character*128     c0rivara
      character*128     c0rivseq
      character*128     c0rivnxl
c in (map)
      integer,dimension(:),allocatable :: i1l2x
      integer,dimension(:),allocatable :: i1l2y
      character*128     c0l2x
      character*128     c0l2y
c out
      real,allocatable::r2xrivint(:,:) !! X of the cell water originate
      real,allocatable::r2yrivint(:,:) !! Y of the cell water originate
      real,allocatable::r2sco(:,:)     !! score
      real,allocatable::r2cnt(:,:)     !! No of cells to deliver
      real,allocatable::r2out(:,:)     !! output of what? 
      character*128     c0lrivint
      character*128     c0xrivint
      character*128     c0yrivint
      character*128     c0sco
      character*128     c0cnt
      character*128     c0out
c local
      real              r0lon       !! longitude of the cell of interest
      real              r0lat       !! latitude  of the cell of interest
      real              r0num       !! river id of the cell of interest
      real              r0lon2      !! longitude of surrounding cells
      real              r0lat2      !! longitude of surrounding cells
      real              r0num2      !! river id of surrounding cells
      real              r0elvdif    !! difference in elevation
      real              r0ararat    !! areal ratio
      real              r0dismet    !! distance between cells (in meter)
      real              r0discel    !! distance between cells (in cells)
      integer           i0sco       !! score
      integer           i0scomax    !! maximum score
      real,allocatable::r1lrivint(:) !! L of the cell water originate
      real,allocatable::r1xrivint(:) !! X of the cell water originate
      real,allocatable::r1yrivint(:) !! Y of the cell water originate
      integer           i0cntorg
      integer           i0cntdes
c function
      integer           isco        !! local function
      integer           igeti0l
      real              rgetlen
      real              rgetlon
      real              rgetlat
c
      character*128     s0cen
      data              s0cen/'center'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.22)then
        write(*,*) 'prog_rivint n0l n0x n0y c0l2x c0l2y'
        write(*,*) '            p0lonmin  p0lonmax  p0latmin p0latmax'
        write(*,*) '            c0elvmin  c0rivnum  c0rivara c0rivseq'
        write(*,*) '            c0rivnxl  c0lrivint c0xrivint c0yrivint'
        write(*,*) '            c0sco     c0cnt     i0optmax c0optlim'
        write(*,*) '            c0out'
        write(*,*) 'you typed ',iargc(),' arguments. 22 required.'
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
      call getarg(10,c0elvmin)
      call getarg(11,c0rivnum)
      call getarg(12,c0rivara)
      call getarg(13,c0rivseq)
      call getarg(14,c0rivnxl)
      call getarg(15,c0lrivint)      
      call getarg(16,c0xrivint)      
      call getarg(17,c0yrivint)      
      call getarg(18,c0sco)      
      call getarg(19,c0cnt)      
      call getarg(20,c0tmp)
      read(c0tmp,*) i0optmax
      call getarg(21,c0optlim)
      call getarg(22,c0out)
c
      allocate(r1tmp(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
c
      allocate(r2elvmin(n0x,n0y))
      allocate(r2rivnum(n0x,n0y))
      allocate(r2rivara(n0x,n0y))
      allocate(r2rivseq(n0x,n0y))
      allocate(r2rivnxl(n0x,n0y))
      allocate(r2xrivint(n0x,n0y))
      allocate(r2yrivint(n0x,n0y))
      allocate(r1xrivint(n0l))
      allocate(r1yrivint(n0l))
      allocate(r1lrivint(n0l))
      allocate(r2sco(n0x,n0y))
      allocate(r2cnt(n0x,n0y))
      allocate(r2out(n0x*n0y,n0recmax))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0elvmin,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2elvmin)
      call read_binary(n0l,c0rivara,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2rivara)
      call read_binary(n0l,c0rivseq,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2rivseq)
      call read_binary(n0l,c0rivnum,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2rivnum)
      call read_binary(n0l,c0rivnxl,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2rivnxl)
c
c [option] withdrawal limit to the same basin
c
      if(c0optlim.eq.'nolimit')then
        do i0y=1,n0y
          do i0x=1,n0x
            if(r2rivnum(i0x,i0y).ge.1.0)then
               r2rivnum(i0x,i0y)=1.0
            end if
          end do
        end do
      else if(c0optlim.eq.'within')then
        continue        
      else
        write(*,*) 'error: c0optlim: ',c0optlim,' not supported.'
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calc
c
c - water must be withdrawn 
c         from a grid cell with less than i0optmax cells distance
c         from a grid cell with higher elevation
c         from a grid cell with larger catchment area
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r2yrivint=0.0
      r2xrivint=0.0
      r1yrivint=0.0
      r1xrivint=0.0
      r1lrivint=0.0
      r2sco=0.0
      r2cnt=0.0
c
      do i0y=1,n0y                             !! x of destination
        do i0x=1,n0x                           !! y of destination
          r0lon=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0cen)
          r0lat=rgetlat(n0y,p0latmin,p0latmax,i0y,s0cen)
          r0num=r2rivnum(i0x,i0y)
          i0sco=0
          i0scomax=0
          if(r2rivara(i0x,i0y).gt.0.0)then
            do i0y2=i0optmax*(-1),i0optmax     !! cells nearby
              do i0x2=i0optmax*(-1),i0optmax   !! cells nearby
                if(i0x+i0x2.gt.0.and.i0x+i0x2.lt.n0x.and.
     $             i0y+i0y2.gt.0.and.i0y+i0y2.lt.n0y)then
c
c geography of potential origin
c
          r0lon2=rgetlon(n0x,p0lonmin,p0lonmax,i0x+i0x2,s0cen)
          r0lat2=rgetlat(n0y,p0latmin,p0latmax,i0y+i0y2,s0cen)
          r0num2=r2rivnum(i0x+i0x2,i0y+i0y2)
          r0discel=(i0y2**2+i0x2**2)**0.5
          r0dismet=rgetlen(r0lon,r0lon2,r0lat,r0lat2)
          r0ararat=r2rivara(i0x+i0x2,i0y+i0y2)/r2rivara(i0x,i0y)
          i0l=(i0x+i0x2)+(i0y+i0y2-1)*n0x
c
c calculating score
c
          if(i0x.eq.558.and.i0y.eq.149)then
            write(*,*) i0x2,i0y2,int(r2rivnxl(i0x,i0y)),i0l
          end if
          if(r0num.eq.r0num2)then
            if(r2elvmin(i0x+i0x2,i0y+i0y2).gt.r2elvmin(i0x,i0y).and.
     $         r2rivseq(i0x+i0x2,i0y+i0y2).gt.r2rivseq(i0x,i0y).and.
     $         int(r2rivnxl(i0x,i0y)).ne.i0l)then
              r0elvdif=r2elvmin(i0x+i0x2,i0y+i0y2)-r2elvmin(i0x,i0y)
              if(r2rivara(i0x+i0x2,i0y+i0y2).gt.r2rivara(i0x,i0y))then
                i0sco=isco(r0discel,r0dismet,r0elvdif,r0ararat)
              end if
            end if
          end if

                  if(i0sco.gt.i0scomax)then
                    r2yrivint(i0x,i0y)=real(i0y+i0y2)
                    r2xrivint(i0x,i0y)=real(i0x+i0x2)
                    r2sco(i0x,i0y)=real(i0sco)
                    i0scomax=i0sco
                  end if

                end if
              end do
            end do
            if(i0scomax.ne.0)then
              r2cnt(int(r2xrivint(i0x,i0y)),int(r2yrivint(i0x,i0y)))
     $       =r2cnt(int(r2xrivint(i0x,i0y)),int(r2yrivint(i0x,i0y)))+1
            end if
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,r2xrivint,r1xrivint)
      call wrte_binary(n0l,r1xrivint,c0xrivint)
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,r2yrivint,r1yrivint)
      call wrte_binary(n0l,r1yrivint,c0yrivint)
c
      i0cntorg=0
      i0cntdes=0
      r2out=0.0
      write(*,*) 'xy --> l conversion start'
      do i0l=1,n0l                         !! l of destination
        i0x=int(r1xrivint(i0l))            !! x of origin
        i0y=int(r1yrivint(i0l))            !! y of origin
        if(i0x.ne.0.and.i0y.ne.0)then
          i0tmp=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
          r1lrivint(i0l)=real(i0tmp)       !! l of origin
          i0cntorg=i0cntorg+1
          i0flg=0
          do i0rec=1,n0recmax
            if(r2out(i0tmp,i0rec).eq.0.0.and.i0flg.eq.0)then
              r2out(i0tmp,i0rec)=real(i0l)
              i0flg=1
              i0cntdes=i0cntdes+1
            end if
          end do
          if(i0flg.eq.0)then
            write(*,*) 'writing failed. stop.'
            stop
          end if
        end if
      end do
      write(*,*) 'xy --> l conversion end'
      write(*,*) 'No of origin      : ',i0cntorg
      write(*,*) 'No of destination : ',i0cntdes
      call wrte_binary(n0l,r1lrivint,c0lrivint)
c
      open(16,file=c0out,access='DIRECT',recl=n0l*4)
      do i0rec=1,n0recmax
        write(16,rec=i0rec)(r2out(i0l,i0rec),i0l=1,n0l)
      end do
      close(16)
c
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,r2sco,r1tmp)
      call wrte_binary(n0l,r1tmp,c0sco)
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,r2cnt,r1tmp)
      call wrte_binary(n0l,r1tmp,c0cnt)
c
      end
c
c
c
c
c
c
c
c
      integer function isco(r0discel,r0dismet,r0elvdif,r0ararat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      real              r0discel    !! distance (no of cells)
      real              r0dismet    !! distance (in meter)
      real              r0elvdif    !! difference in elevation
      real              r0ararat    !! areal ratio
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
      isco=0
c distance (nearer is better)
      if(r0discel.le.1)then
        isco=isco+3
      else if(r0discel.le.2)then
        isco=isco+2
      else
        isco=isco+1
      end if
c slope (steeper is better)
      if(r0elvdif/r0dismet.ge.0.0010)then
        isco=isco+3
      else if(r0elvdif/r0dismet.ge.0.0002)then
        isco=isco+2
      else
        isco=isco+1
      end if
c area (greater is better)
      if(r0ararat.ge.10)then
        isco=isco+3
      else if(r0ararat.ge.2)then
        isco=isco+2
      else
        isco=isco+1
      end if
c
      end
      
