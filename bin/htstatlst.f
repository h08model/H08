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
      program htstatlst
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   read ascii list and calculate statistics
cby   2015/10/6, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0recdat
      parameter        (n0recdat=10000) 
c parameter (default)
      integer           n0if
      integer           n0mis
      real              p0mis
      parameter        (n0if=15) 
      parameter        (n0mis=-9999) 
      parameter        (p0mis=1.0E20) 
      real              p0inimin
      real              p0inimax
      parameter        (p0inimin=9.9E20)
      parameter        (p0inimax=-9.9E20)
c index
      integer           i0rec
      integer           i0recmax
      integer           i0cnt
      integer           i0cntmax
c in
      real              r1dat(n0recdat)
      character*128     c1dat(n0recdat)
      character*128     c0dat
c out

c local (output)
      real              r0sum
      real              r0ave
      real              r0var
      real              r0std
      real              r0max
      real              r0min
      character*128     c0max
      character*128     c0min
c local (intermediate)
      real              r0dif2
      real              r0sumdif2
c
      character*128     c0opt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.2)then
        write(*,*) 'htstatlst OPTION c0dat'
        write(*,*) 'OPTION: ["min","max","sum","ave","std","var"]'
        stop
      end if
c
      call getarg(1,c0opt)
      call getarg(2,c0dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r0sum=0.0
      i0cnt=0
      r0max=p0inimax
      r0min=p0inimin
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(n0if,file=c0dat,status='old')
      i0rec=1
 11   read(n0if,*,end=21) c1dat(i0rec),r1dat(i0rec)
      i0rec=i0rec+1
      goto 11
 21   close(n0if)
      i0recmax=i0rec-1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Job
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0rec=1,i0recmax
        if(r1dat(i0rec).ne.p0mis)then
          r0sum=r0sum+r1dat(i0rec)
          i0cnt=i0cnt+1
          if(r1dat(i0rec).lt.r0min)then
            r0min=r1dat(i0rec)
            c0min=c1dat(i0rec)
          end if
          if(r1dat(i0rec).gt.r0max)then
            r0max=r1dat(i0rec)
            c0max=c1dat(i0rec)
          end if
        end if
      end do
c
      if(i0cnt.ne.0)then
        r0ave=r0sum/real(i0cnt)
      else
        r0ave=p0mis
      end if
c
      do i0rec=1,i0recmax
        if(r1dat(i0rec).ne.p0mis)then
          r0sum=r0sum+r1dat(i0rec)
          i0cnt=i0cnt+1
          if(r1dat(i0rec).ne.p0mis.and.r0ave.ne.p0mis)then
            r0dif2=(r1dat(i0rec)-r0ave)**2
            r0sumdif2=r0sumdif2+r0dif2
          end if
        end if
      end do
c
      if(i0cnt.ne.0)then
        r0var=r0sumdif2/real(i0cnt)
        r0std=r0var**0.5
      else
        r0var=p0mis
        r0std=p0mis
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0opt.eq.'max')then
        write(*,*) r0max,c0max
      else if(c0opt.eq.'min')then
        write(*,*) r0min,c0min
      else if(c0opt.eq.'sum')then
        write(*,*) r0sum
      else if(c0opt.eq.'ave')then
        write(*,*) r0ave
      else if(c0opt.eq.'var')then
        write(*,*) r0var
      else if(c0opt.eq.'std')then
        write(*,*) r0std
      end if
c
      end
      
