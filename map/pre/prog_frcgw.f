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
      program prog_frcgw
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      real              p0mis
      integer           n0recdat
      integer           n0reccod
      integer           n0recout
      parameter        (p0mis=1.0E20) 
      parameter        (n0recdat=2000) 
      parameter        (n0reccod=2000) 
      parameter        (n0recout=2000) 
c index
      integer           i0rec
      integer           i0recdbg
ctemp
      character*128     c0tmp
c in
      real              r1rgn(n0recout)
      real              r1agrg(n0recout)
      real              r1indg(n0recout)
      real              r1domg(n0recout)
      real              r1agrt(n0recout)
      real              r1indt(n0recout)
      real              r1domt(n0recout)
      character*128     c0cod
      character*128     c0rgn
      character*128     c0agrg
      character*128     c0indg
      character*128     c0domg
      character*128     c0agrt
      character*128     c0indt
      character*128     c0domt
c out
      real              r1agrr(n0recout)
      real              r1indr(n0recout)
      real              r1domr(n0recout)
      character*128     c0agrr
      character*128     c0indr
      character*128     c0domr
c local
      integer        i1rgn2rep(22)
      data           i1rgn2rep/404,178,818,710,686,840,484,388,76,1007,
     $                         156,356,764,792,348,826,380,276,36,0,
     $                           0,  0/
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.12)then
        write(*,*) 'prog_ratgw c0cod  c0rgn'
        write(*,*) '           c0agrg c0indg c0domg'
        write(*,*) '           c0agrt c0indt c0domt'
        write(*,*) '           c0agrr c0indr c0domr'
        write(*,*) '           i0recdbg'
        write(*,*) iargc()
        stop
      end if

      call getarg(1,c0cod)
      call getarg(2,c0rgn)
      call getarg(3,c0agrg)
      call getarg(4,c0indg)
      call getarg(5,c0domg)
      call getarg(6,c0agrt)
      call getarg(7,c0indt)
      call getarg(8,c0domt)
      call getarg(9,c0agrr)
      call getarg(10,c0indr)
      call getarg(11,c0domr)
      call getarg(12,c0tmp)
      read(c0tmp,*) i0recdbg
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1agrg=p0mis
      r1indg=p0mis
      r1domg=p0mis
      r1agrt=p0mis
      r1indt=p0mis
      r1domt=p0mis
      r1agrr=p0mis
      r1indr=p0mis
      r1domr=p0mis
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c in
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_ascii2(n0recdat,n0reccod,n0recout,c0rgn, c0cod,r1rgn)
c
      call read_ascii2(n0recdat,n0reccod,n0recout,c0agrg,c0cod,r1agrg)
      call read_ascii2(n0recdat,n0reccod,n0recout,c0indg,c0cod,r1indg)
      call read_ascii2(n0recdat,n0reccod,n0recout,c0domg,c0cod,r1domg)
      call read_ascii2(n0recdat,n0reccod,n0recout,c0agrt,c0cod,r1agrt)
      call read_ascii2(n0recdat,n0reccod,n0recout,c0indt,c0cod,r1indt)
      call read_ascii2(n0recdat,n0reccod,n0recout,c0domt,c0cod,r1domt)
c
      write(*,*) 'GW  for Agr: ',r1agrg(i0recdbg),' km3/yr'
      write(*,*) 'GW  for Ind: ',r1indg(i0recdbg),' km3/yr'
      write(*,*) 'GW  for Dom: ',r1domg(i0recdbg),' km3/yr'
      write(*,*) 'Tot for Agr: ',r1agrt(i0recdbg),' km3/yr'
      write(*,*) 'Tot for Ind: ',r1indt(i0recdbg),' km3/yr'
      write(*,*) 'Tot for Dom: ',r1domt(i0recdbg),' km3/yr'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0rec=1,n0recout
c
        if(r1agrg(i0rec).ne.p0mis.and.r1agrt(i0rec).ne.p0mis)then
          if(r1agrt(i0rec).ne.0.0)then
             r1agrr(i0rec)=r1agrg(i0rec)/r1agrt(i0rec)
          end if
        else
          r1agrr(i0rec)=p0mis
        end if
c
        if(r1indg(i0rec).ne.p0mis.and.r1indt(i0rec).ne.p0mis)then
          if(r1indt(i0rec).ne.0.0)then
             r1indr(i0rec)=r1indg(i0rec)/r1indt(i0rec)
          end if
        else
          r1indr(i0rec)=p0mis
        end if
c
        if(r1domg(i0rec).ne.p0mis.and.r1domt(i0rec).ne.p0mis)then
          if(r1domt(i0rec).ne.0.0)then
             r1domr(i0rec)=r1domg(i0rec)/r1domt(i0rec)
          end if
        else
          r1domr(i0rec)=p0mis
        end if
c
      end do
c
      write(*,*) 'GW/Tot  for Agr: ',r1agrr(i0recdbg)
      write(*,*) 'GW/Tot  for Ind: ',r1indr(i0recdbg)
      write(*,*) 'GW/Tot  for Dom: ',r1domr(i0recdbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0rec=1,n0recout
c
        if(r1agrr(i0rec).ne.p0mis.and.r1agrr(i0rec).gt.1.0)then
          write(*,*) 'Correction,agr,',i0rec,'from',r1agrr(i0rec),'to 1'
          r1agrr(i0rec)=1.0

        end if
c
        if(r1indr(i0rec).ne.p0mis.and.r1indr(i0rec).gt.1.0)then
          write(*,*) 'Correction,ind,',i0rec,'from',r1indr(i0rec),'to 1'
          r1indr(i0rec)=1.0

        end if
c
        if(r1domr(i0rec).ne.p0mis.and.r1domr(i0rec).gt.1.0)then
          write(*,*) 'Correction,dom,',i0rec,'from',r1domr(i0rec),'to 1'
          r1domr(i0rec)=1.0
        end if
c
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0rec=1,n0recout
c
        if(r1rgn(i0rec).ne.p0mis)then
          if(r1agrr(i0rec).eq.p0mis)then
            if(i1rgn2rep(int(r1rgn(i0rec))).eq.0)then
              r1agrr(i0rec)=0.0
            else
              r1agrr(i0rec)=r1agrr(i1rgn2rep(int(r1rgn(i0rec))))
            end if
            write(*,*) 'Borrowing,agr,',i0rec,'from ',int(r1rgn(i0rec))
          end if
          if(r1indr(i0rec).eq.p0mis)then
            if(i1rgn2rep(int(r1rgn(i0rec))).eq.0)then
              r1agrr(i0rec)=0.0
            else
              r1indr(i0rec)=r1indr(i1rgn2rep(int(r1rgn(i0rec))))
            end if
            write(*,*) 'Borrowing,ind,',i0rec,'from ',int(r1rgn(i0rec))
          end if
          if(r1domr(i0rec).eq.p0mis)then
            if(i1rgn2rep(int(r1rgn(i0rec))).eq.0)then
              r1agrr(i0rec)=0.0
            else
              r1domr(i0rec)=r1domr(i1rgn2rep(int(r1rgn(i0rec))))
            end if
            write(*,*) 'Borrowing,dom,',i0rec,'from ',int(r1rgn(i0rec))
          end if
        end if
c
      end do
c
      write(*,*) 'GW/Tot  for Agr: ',r1agrr(i0recdbg)
      write(*,*) 'GW/Tot  for Ind: ',r1indr(i0recdbg)
      write(*,*) 'GW/Tot  for Dom: ',r1domr(i0recdbg)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_ascii2(n0recout,n0reccod,r1agrr,c0cod,c0agrr)
      call wrte_ascii2(n0recout,n0reccod,r1indr,c0cod,c0indr)
      call wrte_ascii2(n0recout,n0reccod,r1domr,c0cod,c0domr)
c
      end




