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
      program htpointts
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   point time series data of binary
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer              n0l
      integer              n0x
      integer              n0y
      real                 p0lonmin
      real                 p0lonmax
      real                 p0latmin
      real                 p0latmax
c parameter (physical)
      integer              n0secday
      parameter           (n0secday=86400) 
c parameter (default)
      real              p0mis
      integer           n0mis
      parameter        (p0mis=1.0E20)
      parameter        (n0mis=-9999) 
c index (array)
      integer              i0l
      integer              i0x
      integer              i0y
c index (time)
      integer              i0year
      integer              i0yearmin
      integer              i0yearmax
      integer              i0yearout
      integer              i0mon
      integer              i0monmin
      integer              i0monmax
      integer              i0monout
      integer              i0day
      integer              i0daymin
      integer              i0daymax
      integer              i0dayout
      integer              i0hour
      integer              i0sec
      integer              i0secint
c temporary
      character*128        c0tmp             !! dummy
c function
      integer              iargc
      integer              igeti0l
      integer              igeti0x
      integer              igeti0y
      integer              igetday
c in (set)
      real                 r0lon            !! longitude
      real                 r0lat            !! latitude
      real                 r0factor         !! factor
      character*128        c0opt
c in (map)
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128        c0l2x
      character*128        c0l2y
c in (flux)
      real,allocatable::   r1dat(:)         !! 
      character*128        c0in             !!
c local
      integer              i0lenin
      character*128        c0idx
      character*128        c0ifname          !! Input File NAME
      real                 r1lon(4000)
      real                 r1lat(4000)
      character*128        c1ofname(4000)
      character*128        c0ofname
      character*128        c0lst
      integer              i0pnt
      integer              i0pntmax
      integer              i1ini(4000)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().lt.13) then
        write(*,*) 'Usage: htpointts n0l n0x n0y c0l2x c0l2y'
        write(*,*) '       p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '       OPTION'
        write(*,*) 'OPTION:'
        write(*,*) '{"l"      c0bints i0yearmin i0yearmax i0l}'
        write(*,*) '{"xy"     c0bints i0yearmin i0yearmax i0x i0y}'
        write(*,*) '{"lonlat" c0bints i0yearmin i0yearmax r0lon r0lat}'
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
      call getarg(11,c0in)
      call getarg(12,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(13,c0tmp)
      read(c0tmp,*) i0yearmax
c
      i0pntmax=1
c      
      if(c0opt.eq.'l')then
        if(iargc().ne.14.and.iargc().ne.15) then
          write(*,*) 'Usage: htpointts n0l n0x n0y c0l2x c0l2y'
          write(*,*) '       p0lonmin p0lonmax p0latmin p0latmax'
          write(*,*) '       c0opt c0in i0yearmin i0yearmax i0l'
          stop
        else
          call getarg(14,c0tmp)
          read(c0tmp,*) i0l
          if(iargc().eq.15)then
            call getarg(15,c0tmp)
            read(c0tmp,*) r0factor
          else
            r0factor=1.0
          end if
        end if
      else if(c0opt.eq.'xy')then
        if(iargc().ne.15.and.iargc().ne.16) then
          write(*,*) 'Usage: htpointts n0l n0x n0y c0l2x c0l2y'
          write(*,*) '       p0lonmin p0lonmax p0latmin p0latmax'
          write(*,*) '       c0opt c0in i0yearmin i0yearmax i0x i0y'
          stop
        else
          call getarg(14,c0tmp)
          read(c0tmp,*) i0x
          call getarg(15,c0tmp)
          read(c0tmp,*) i0y
          if(iargc().eq.16)then
            call getarg(16,c0tmp)
            read(c0tmp,*) r0factor
          else
            r0factor=1.0
          end if
        end if
      else if(c0opt.eq.'lonlat')then
        if(iargc().ne.15.and.iargc().ne.16) then
          write(*,*) 'Usage: htpointts n0l n0x n0y c0l2x c0l2y'
          write(*,*) '       p0lonmin p0lonmax p0latmin p0latmax' 
          write(*,*) '       c0opt c0in i0yearmin i0yearmax r0lon r0lat'
          stop
        else
          call getarg(14,c0tmp)
          read(c0tmp,*) r0lon
          call getarg(15,c0tmp)
          read(c0tmp,*) r0lat
          if(iargc().eq.16)then
            call getarg(16,c0tmp)
            read(c0tmp,*) r0factor
          else
            r0factor=1.0
          end if
        end if
      else if(c0opt.eq.'list')then
        if(iargc().ne.14.and.iargc().ne.15) then
          write(*,*) 'Usage: htpointts n0l n0x n0y c0l2x c0l2y'
          write(*,*) '       p0lonmin p0lonmax p0latmin p0latmax' 
          write(*,*) '       c0opt c0in i0yearmin i0yearmax c0lst'
          stop
        else
          call getarg(14,c0lst)
          if(iargc().eq.15)then
            call getarg(15,c0tmp)
            read(c0tmp,*) r0factor
          else
            r0factor=1.0
          end if
c
          open(15,file=c0lst,status='old')
 55       read(15,*,end=99) i0pnt,r0lon,r0lat,c0ofname
          r1lon(i0pnt)=r0lon
          r1lat(i0pnt)=r0lat
          c1ofname(i0pnt)=c0ofname
          i0pntmax=i0pnt
          goto 55
 99       close(15)
c          
        end if
      else
        write(*,*) 'Your typed option ',c0opt,' not supported. Abort.'
        stop
      end if
c
      allocate(r1dat(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
c
      i1ini=1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
c
      i0lenin=len_trim(c0in)
      c0idx=c0in(i0lenin-1:i0lenin)
c
      do i0year=i0yearmin,i0yearmax
        if(c0idx.eq.'YR')then
          i0monmin=0
          i0monmax=0
        else
          i0monmin=1
          i0monmax=12
        end if
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'YR'.or.c0idx.eq.'MO')then
            i0daymin=0
            i0daymax=0
          else if(c0idx.eq.'DL')then
            i0daymin=1
            i0daymax=igetday(0,i0mon)
          else
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
          end if
          do i0day=i0daymin,i0daymax
            if(c0idx.eq.'YR'.or.c0idx.eq.'MO'.or.
     $         c0idx.eq.'DY'.or.c0idx.eq.'DL')then
              i0secint=86400
            else if(c0idx.eq.'6H')then
              i0secint=21600
            else if(c0idx.eq.'3H')then
              i0secint=10800
            else if(c0idx.eq.'HR')then
              i0secint=3600
            else
              write(*,*) 'htpointts: c0idx: ',c0idx,' not supported.'
              stop
            end if
            do i0sec=i0secint,n0secday,i0secint
c              write(*,*) i0year,i0mon,i0day,i0sec
              call read_result(
     $             n0l,
     $             c0in,i0year,i0mon,i0day,i0sec,i0secint,
     $             r1dat)
              do i0pnt=1,i0pntmax
                if(c0opt.eq.'xy')then
                  i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
                else if(c0opt.eq.'lonlat')then
                  i0x=igeti0x(n0x,p0lonmin,p0lonmax,r0lon)
                  i0y=igeti0y(n0y,p0latmin,p0latmax,r0lat)
                  i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
                else if(c0opt.eq.'list')then
                  i0x=igeti0x(n0x,p0lonmin,p0lonmax,r1lon(i0pnt))
                  i0y=igeti0y(n0y,p0latmin,p0latmax,r1lat(i0pnt))
                  i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)             
                end if
                if(c0idx.eq.'YR'.or.c0idx.eq.'MO'.or.
     $               c0idx.eq.'DY'.or.c0idx.eq.'DL')then
                  if(c0opt.eq.'list')then
                    if(i1ini(i0pnt).eq.1)then
                      open(15,file=c1ofname(i0pnt),status='replace')
                      write(*,*) c1ofname(i0pnt),'replaced!.'
                      write(15,*) i0year,i0mon,i0day,r1dat(i0l)*r0factor
                      close(15)
                    else
                      open(15,file=c1ofname(i0pnt),status='old',
     $                     position='append')
                      write(15,*) i0year,i0mon,i0day,r1dat(i0l)*r0factor
                      close(15)
                    end if
c                    if(r1dat(i0l).ne.p0mis)then
c                      write(*,*) i0year,i0mon,i0day,r1dat(i0l)*r0factor
c                    else
c                      write(*,*) i0year,i0mon,i0day,real(n0mis)
c                    end if
                  else
                    if(r1dat(i0l).ne.p0mis)then
                      write(*,*) i0year,i0mon,i0day,r1dat(i0l)*r0factor
                    else
                      write(*,*) i0year,i0mon,i0day,real(n0mis)
                    end if
                  end if
                  i1ini(i0pnt)=0
                else 
                  i0hour=i0sec/3600
                  i0dayout=i0day
                  i0monout=i0mon
                  i0yearout=i0year
                  if(i0hour.eq.24)then
                    i0dayout=i0day+1
                    i0hour=0
                    if(i0dayout.gt.igetday(i0year,i0mon))then
                      i0dayout=1
                      i0monout=i0mon+1
                      if(i0monout.gt.12)then
                        i0monout=1
                        i0yearout=i0year+1
                      end if
                    end if
                  end if
                  if(c0opt.eq.'list')then
                    if(i0pnt.eq.1)then
                      open(15,file=c1ofname(i0pnt))
                      write(15,*) i0year,i0mon,i0day,r1dat(i0l)*r0factor
                      close(15)
                    else
                      open(15,file=c1ofname(i0pnt),status='old',
     $                     position='append')
                      write(15,*) i0year,i0mon,i0day,r1dat(i0l)*r0factor
                      close(15)
                    end if
                  else
                    if(r1dat(i0l).ne.p0mis)then
                      write(*,*) i0yearout,i0monout,i0dayout,i0hour,
     $                     r1dat(i0l)*r0factor
                    else
                      write(*,*) i0yearout,i0monout,i0dayout,i0hour,
     $                     real(n0mis)
                    end if
                  end if
                  i1ini(i0pnt)=0
                end if
              end do
            end do
          end do
        end do
      end do
c
      end

