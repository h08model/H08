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
        subroutine calc_flgcrp(
     $       n0l,n0c,
     $       i0year,i0mon,i0day,
     $       i0ldbg,i0dayadvirg,
     $       i2pltdoy, i2hvsdoy,
     $       i2flgcul, i2flgirg,r2target,
     $       c0opthvsdoy)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate cropping and irrigation flag
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0c
c index (array)
      integer           i0l
      integer           i0c
c index (time)
      integer           i0doy
c function
      integer           igetdoy
c in (set)
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0ldbg
      integer           i0dayadvirg       !! advance irrigation
      character*128     c0opthvsdoy
c in (map)
      integer           i2pltdoy(n0l,n0c) !! planting date of year
      integer           i2hvsdoy(n0l,n0c) !! harvesting date of year
c out
      integer           i2flgcul(n0l,n0c) !! cultivation flag
      integer           i2flgirg(n0l,n0c) !! irrigation flag
      real              r2target(n0l,n0c) !! target SoilMoist
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get day of year
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        i0doy=igetdoy(i0year,i0mon,i0day)
        write(*,*) 'calc_flgcrp: i0doy',i0doy
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Harvesting (tentative)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        if(c0opthvsdoy.eq.'fix')then
          do i0c=1,n0c
            do i0l=1,n0l
              if(i0doy.eq.i2hvsdoy(i0l,i0c))then
                i2flgcul(i0l,i0c)=0
              end if
            end do
          end do    
        else if(c0opthvsdoy.eq.'free')then
          continue
        else
          write(*,*) 'calc_flgcrp: c0opthvsdoy: option must be'
          write(*,*) '             fix or free. Abort.'
          stop
        end if
c       write(*,*) 'calc_flgcrp: i2flgcul(1):',i2flgcul(i0ldbg,1)
c       write(*,*) 'calc_flgcrp: i2flgcul(2):',i2flgcul(i0ldbg,2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Reset target
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        do i0c=1,n0c
          do i0l=1,n0l
            if(i2flgcul(i0l,i0c).eq.0)then
              i2flgirg(i0l,i0c)=0
              r2target(i0l,i0c)=0.0
            end if
          end do
        end do
c       write(*,*) 'calc_flgcrp: i2flgirg(1):',i2flgirg(i0ldbg,1)
c       write(*,*) 'calc_flgcrp: i2flgirg(2):',i2flgirg(i0ldbg,2)
c       write(*,*) 'calc_flgcrp: r2target(1):',r2target(i0ldbg,1)
c       write(*,*) 'calc_flgcrp: r2target(2):',r2target(i0ldbg,2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Raise flag of cultivation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cbug        do i0c=1,n0c
          do i0l=1,n0l
            if(i0doy.eq.i2pltdoy(i0l,1))then
              if(i2flgcul(i0l,2).eq.0)then
                i2flgcul(i0l,1)=1
                i2flgirg(i0l,1)=1
                r2target(i0l,1)=1.0
              end if
cbug              i2flgcul(i0l,i0c)=1
cbug              i2flgirg(i0l,i0c)=1
cbug              r2target(i0l,i0c)=1.0
            else if(i0doy.eq.i2pltdoy(i0l,2))then
              if(i2flgcul(i0l,1).eq.0)then
                i2flgcul(i0l,2)=1
                i2flgirg(i0l,2)=1
                r2target(i0l,2)=1.0
              end if
cbug              i2flgcul(i0l,i0c)=1
cbug              i2flgirg(i0l,i0c)=1
cbug              r2target(i0l,i0c)=1.0
            end if
          end do
cbug        end do
d       write(*,*) 'calc_flgcrp: i2flgcul(1):',i2flgcul(i0ldbg,1)
d       write(*,*) 'calc_flgcrp: i2flgcul(2):',i2flgcul(i0ldbg,2)
d       write(*,*) 'calc_flgcrp: i2flgirg(1):',i2flgirg(i0ldbg,1)
d       write(*,*) 'calc_flgcrp: i2flgirg(2):',i2flgirg(i0ldbg,2)
d       write(*,*) 'calc_flgcrp: r2target(1):',r2target(i0ldbg,1)
d       write(*,*) 'calc_flgcrp: r2target(2):',r2target(i0ldbg,2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Raise flag of advance irrigation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        do i0c=1,n0c
          do i0l=1,n0l
            if(i2pltdoy(i0l,i0c).ge.i0dayadvirg+1)then
              if(i0doy.ge.i2pltdoy(i0l,i0c)-i0dayadvirg.and.
     $             i0doy.le.i2pltdoy(i0l,i0c))then
                i2flgirg(i0l,i0c)=1
                r2target(i0l,i0c)
     $               =real(i0doy-(i2pltdoy(i0l,i0c)-i0dayadvirg))
     $               /real(i0dayadvirg)
              end if
            else if(i2pltdoy(i0l,i0c).ge.1.and.
     $             i2pltdoy(i0l,i0c).le.i0dayadvirg)then
              if(i0doy.ge.1.and.i0doy.le.i0dayadvirg)then
                if(i0doy.ge.i2pltdoy(i0l,i0c)-i0dayadvirg.and.
     $               i0doy.le.i2pltdoy(i0l,i0c))then
                  i2flgirg(i0l,i0c)=1
                  r2target(i0l,i0c)
     $                 =real(i0doy-(i2pltdoy(i0l,i0c)-i0dayadvirg))
     $                 /real(i0dayadvirg)
                end if
              else
                if(i0doy-365.ge.i2pltdoy(i0l,i0c)-i0dayadvirg.and.
     $               i0doy-365.le.i2pltdoy(i0l,i0c))then
                  i2flgirg(i0l,i0c)=1
                  r2target(i0l,i0c)
     $                 =real(i0doy-365-(i2pltdoy(i0l,i0c)-i0dayadvirg))
     $                 /real(i0dayadvirg)
                end if
              end if
            end if
          end do
        end do
d       write(*,*) 'calc_flgcrp: i2pltdoy(1):',i2pltdoy(i0ldbg,1)
d       write(*,*) 'calc_flgcrp: i2pltdoy(2):',i2pltdoy(i0ldbg,2)
d       write(*,*) 'calc_flgcrp: r2target(1):',r2target(i0ldbg,1)
d       write(*,*) 'calc_flgcrp: r2target(2):',r2target(i0ldbg,2)
d       write(*,*) 'calc_flgcrp: i0dayadvirg:',i0dayadvirg

c
        end
