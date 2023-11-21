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
      program prog_figure
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           i0doy
      integer           i0pltdoy
      integer           i1crpday(365)
      integer           i1crpdaybt(365)
      integer           i1flg(365)
      real              r0sum
      integer           i0tmp
      real              r1tair(730)
      character*128     c0ifname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call getarg(1,c0ifname)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i1flg=0
      i1crpday=0
      i1crpdaybt=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0ifname)
      do i0doy=1,365
        read(15,*) i0tmp,i0tmp,i0tmp,r1tair(i0doy)
      end do
      close(15)
      do i0doy=1,365
        r1tair(i0doy+365)=r1tair(i0doy)
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0pltdoy=1,365
        r0sum=0.0
        do i0doy=i0pltdoy,730
          r0sum=r0sum+r1tair(i0doy)-273.15
          if(r0sum.gt.1500)then
            i1crpday(i0pltdoy)=i0doy-i0pltdoy+1
            goto 10
          end if
        end do
 10     continue
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0pltdoy=1,365
        r0sum=0.0
        do i0doy=i0pltdoy,730
          r0sum=r0sum+r1tair(i0doy)-273.15-10.0
          if(r1tair(i0doy)-273.15.lt.10.0)then
            i1flg(i0pltdoy)=1
          end if
          if(r0sum.gt.1500)then
            i1crpdaybt(i0pltdoy)=i0doy-i0pltdoy+1
            goto 20
          end if
        end do
 20     write(*,*) i0pltdoy,r1tair(i0pltdoy)-273.15,
     $             i1crpday(i0pltdoy),
     $             i1crpdaybt(i0pltdoy),i1flg(i0pltdoy)
      end do
c
      end
