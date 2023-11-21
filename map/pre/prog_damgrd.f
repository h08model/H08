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
      program conv_lstbin
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   convert dam list to binary
cby   2010/09/30, hanasaki, NIES: H08ver0.5
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
      real              p0lonmin
      real              p0latmin
      real              p0lonmax
      real              p0latmax
      integer           n0rec
      parameter        (n0rec=10000)
c index (array)
      integer           i0l
      integer           i0ldbg
      integer           i0x
      integer           i0y
      integer           i0rec
c index (time)
      integer           i0year
c temporary
      integer           i0tmp
      real,allocatable::r1tmp(:)
      character*128     c0tmp
c function
      integer           iargc
      integer           igeti0x
      integer           igeti0y
      integer           igeti0l
c in (list)
      integer           i1lstid_(n0rec)  !! ID number on the list
      integer           i1lstyr_(n0rec)  !! Completer year
c      integer           i1lstcap(n0rec)  !! Total storage
      real              r1lstcap(n0rec)  !! Total storage
      integer           i1lstcat(n0rec)  !! Catchment area
      integer           i1lsthyd(n0rec)  !! Purpose: Hydro power
      integer           i1lstsup(n0rec)  !! Purpose: Supply
      integer           i1lstfld(n0rec)  !! Purpose: Flood control
      integer           i1lstirg(n0rec)  !! Purpose: Irrigation supply
      integer           i1lstnav(n0rec)  !! Purpose: Navigation
      integer           i1lstoth(n0rec)  !! Purpose: Other
      real              r1lstlon(n0rec)  !! Longitude
      real              r1lstlat(n0rec)  !! Latitude
      real              r1lstsrf(n0rec)  !! Surface Area
      character*4       c1lststa(n0rec)  !! Status
      character*32      c1lstnam(n0rec)  !! Name of dam
      character*128     c0lst
c in (map)
      integer,allocatable::i1lndmsk(:)
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128     c0lndmsk
      character*128     c0l2x
      character*128     c0l2y
c out
      real,allocatable::r1damnum(:)    !! Num of dams in a grid
      real,allocatable::r1damcap(:)    !! Dam capacity in a grid
      real,allocatable::r1damcat(:)    !! Dam catchment
      real,allocatable::r1damid_(:)    !! Representative dam's ID
      real,allocatable::r1damyr_(:)    !! Representative dam's ID
      real,allocatable::r1damprp(:)    !! Irrigation priority
      real,allocatable::r1damsrf(:)    !! Surface area
      character*128     c0damnum
      character*128     c0damcap
      character*128     c0damcat
      character*128     c0damid_
      character*128     c0damyr_
      character*128     c0damprp
      character*128     c0damsrf
c local
      integer           i0cnthyd         !! num of hydro dam
      integer           i0cntsup         !! num of supply dam
      integer           i0cntfld         !! num of flood dam
      integer           i0cntirg         !! num of irrigation dam
      integer           i0cntnav         !! num of navigation dam
      integer           i0cntoth         !! num of other dam
      integer           i0notyet         !! counter not yet constructed
      integer           i0notloc         !! counter not located
      integer           i0recmax         !! 
      real              r0damnum         !!
      real              r0damcap         !!
      real,allocatable::r1damcapmax(:) !! Maximum capacity
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.20)then
        write(*,*) 'prog_damgrd n0l n0x n0y c0l2x c0l2y'
        write(*,*) '            p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '            c0lst    c0damnum c0damcap c0damcat'
        write(*,*) '            c0damid_ c0damprp c0damsrf c0damyr_'
        write(*,*) '            i0year   c0lndmsk i0ldbg'
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
      call getarg(10,c0lst)
      call getarg(11,c0damnum)
      call getarg(12,c0damcap)
      call getarg(13,c0damcat)
      call getarg(14,c0damid_)
      call getarg(15,c0damprp)
      call getarg(16,c0damsrf)
      call getarg(17,c0damyr_)
      call getarg(18,c0tmp)
      read(c0tmp,*) i0year
      call getarg(19,c0lndmsk)
      call getarg(20,c0tmp)
      read(c0tmp,*) i0ldbg
c
      allocate(i1lndmsk(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      allocate(r1damnum(n0l))
      allocate(r1damcap(n0l))
      allocate(r1damcat(n0l))
      allocate(r1damid_(n0l))
      allocate(r1damyr_(n0l))
      allocate(r1damprp(n0l))
      allocate(r1damsrf(n0l))
      allocate(r1damcapmax(n0l))
      allocate(r1tmp(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
      r1damnum=0.0
      r1damcap=0.0
      r1damcat=0.0
      r1damid_=0.0
      r1damyr_=0.0
      r1damprp=0.0
      r1damsrf=0.0
c local
      i0cnthyd=0
      i0cntsup=0
      i0cntfld=0
      i0cntirg=0
      i0cntnav=0
      i0cntoth=0
      i0notyet=0
      i0notloc=0
      i0recmax=0
      r0damnum=0.0
      r0damcap=0.0
      r1damcapmax=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_i1l2xy(
     $     n0l,
     $     c0l2x,c0l2y,
     $     i1l2x,i1l2y)
c
      call read_binary(n0l,c0lndmsk,r1tmp)
      do i0l=1,n0l
        i1lndmsk(i0l)=int(r1tmp(i0l))
      end do
c
      i0rec=1
      open(15,file=c0lst,status='old')
 10   read(15,*,end=20)
     &     r1lstlon(i0rec),  r1lstlat(i0rec),  i1lstid_(i0rec),
     $     c1lststa(i0rec),  c1lstnam(i0rec),  c0tmp,
     $     i1lstyr_(i0rec),  c0tmp,            c0tmp,
c     &     i1lstcap(i0rec),  i1lstcat(i0rec),  i1lsthyd(i0rec),
     &     r1lstcap(i0rec),  i1lstcat(i0rec),  i1lsthyd(i0rec),
     &     i1lstsup(i0rec),  i1lstfld(i0rec),  i1lstirg(i0rec), 
     &     i1lstnav(i0rec),  i1lstoth(i0rec)
      i0rec=i0rec+1
      goto 10
 20   close(15)
      i0recmax=i0rec-1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Number of dams in one grid
c - referesh
c - 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r1damnum=0.0
      r1damcap=0.0
      r1damcat=0.0
      r1damid_=0.0
      r1damprp=0.0
      r1damsrf=0.0
      r1damyr_=0.0
      r1damcapmax=0.0
c
      do i0rec=1,i0recmax
        if(r1lstlon(i0rec).eq.-9999)then
          write(*,*) 'prog_damgrd: Warning: ',i1lstid_(i0rec),
     $         ' was skipped because lon/lat info was missing.'
          i0notloc=i0notloc+1
        else if(i1lstyr_(i0rec).le.i0year)then
          i0x=igeti0x(n0x,p0lonmin,p0lonmax,r1lstlon(i0rec))
          i0y=igeti0y(n0y,p0latmin,p0latmax,r1lstlat(i0rec))
          i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
          if(i1lndmsk(i0l).eq.1)then
            r1damnum(i0l)=r1damnum(i0l)+1.0
c            r1damcap(i0l)=r1damcap(i0l)+real(i1lstcap(i0rec))
            r1damcap(i0l)=r1damcap(i0l)+r1lstcap(i0rec)
            r1damcat(i0l)=r1damcat(i0l)+real(i1lstcat(i0rec))
            r1damsrf(i0l)=r1damsrf(i0l)+r1lstsrf(i0rec)
c            if(real(i1lstcap(i0rec)).gt.r1damcapmax(i0l))then
            if(r1lstcap(i0rec).gt.r1damcapmax(i0l))then
c              r1damcapmax(i0l)=real(i1lstcap(i0rec))
              r1damcapmax(i0l)=r1lstcap(i0rec)
              r1damid_(i0l)=real(i1lstid_(i0rec))
              r1damyr_(i0l)=real(i1lstyr_(i0rec))
              if(     i1lsthyd(i0rec).eq.1)then
                r1damprp(i0l)=1.0
              else if(i1lstsup(i0rec).eq.1)then
                r1damprp(i0l)=2.0
              else if(i1lstfld(i0rec).eq.1)then
                r1damprp(i0l)=3.0
              else if(i1lstirg(i0rec).eq.1)then
                r1damprp(i0l)=4.0
              else if(i1lstnav(i0rec).eq.1)then
                r1damprp(i0l)=5.0
              else
                r1damprp(i0l)=6.0
              end if
            end if
          else
            write(*,*) 'prog_damgrd: Warning: ',i1lstid_(i0rec),
     $           ' was skipped because it was in a sea cell.'
            i0notloc=i0notloc+1
          end if
        else
          write(*,*) 'prog_damgrd: Warning: ',i1lstid_(i0rec),
     $         ' was skipped because it was not constructed.'
          i0notyet=i0notyet+1
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write damnum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call wrte_binary(n0l,r1damnum,c0damnum)
c
      r0damnum=0.0
      do i0l=1,n0l
        r0damnum=r0damnum+r1damnum(i0l)
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write damcap
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        r1damcap(i0l)=r1damcap(i0l)*1000.0*1000.0*1000.0
      end do
c
      call wrte_binary(n0l,r1damcap,c0damcap)
c
      do i0l=1,n0l
        r1damcat(i0l)=r1damcat(i0l)*1000.0*1000.0
      end do
c
      call wrte_binary(n0l,r1damcat,c0damcat)
c
      r0damcap=0.0
      do i0l=1,n0l
        r0damcap=r0damcap+r1damcap(i0l)
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write damid_ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1damid_,c0damid_)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write damprp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1damprp,c0damprp)
      do i0l=1,n0l
        if(     int(r1damprp(i0l)).eq.1)then
          i0cnthyd=i0cnthyd+1
        else if(int(r1damprp(i0l)).eq.2)then
          i0cntsup=i0cntsup+1
        else if(int(r1damprp(i0l)).eq.3)then
          i0cntfld=i0cntfld+1
        else if(int(r1damprp(i0l)).eq.4)then
          i0cntirg=i0cntirg+1
        else if(int(r1damprp(i0l)).eq.5)then
          i0cntnav=i0cntnav+1
        else if(int(r1damprp(i0l)).eq.6)then
          i0cntoth=i0cntoth+1
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write surface area
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        r1damsrf(i0l)=r1damsrf(i0l)*1000.0*1000.0
      end do
      call wrte_binary(n0l,r1damsrf,c0damsrf)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write dam constructed year
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1damyr_,c0damyr_)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Check
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      write(*,*) '##################################################'
      write(*,*) 'Debugging point: [ ',i0ldbg,' ]'
      write(*,*) '##################################################'
      write(*,*) 'Num of res. in the grid ',r1damnum(i0ldbg)
      write(*,*) 'Sto capacity of the grid',r1damcap(i0ldbg)
      write(*,*) 'Representative dam_s ID ',r1damid_(i0ldbg)
      write(*,*) 'Irrigation res.?        ',r1damprp(i0ldbg)
      write(*,*) '##################################################'
      write(*,*) 'Global summary'
      write(*,*) '##################################################'
      write(*,*) 'Num of res. in the original list',i0recmax
      write(*,*) 'Num of res. not located         ',i0notloc
      write(*,*) 'Num of res. not yet constructed ',i0notyet
      write(*,*) 'Num of res. in the binary       ',r0damnum
      write(*,*) 'Total storage capacity globally ',r0damcap
      write(*,*) 'Num of hydro pow  res. globally ', i0cnthyd
      write(*,*) 'Num of supply     res. globally ', i0cntsup
      write(*,*) 'Num of flood ctrl res. globally ', i0cntfld
      write(*,*) 'Num of irrigation res. globally ', i0cntirg
      write(*,*) 'Num of navigation res. globally ', i0cntnav
      write(*,*) 'Num of other      res. globally ', i0cntoth
c
      end
