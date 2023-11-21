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
      integer function igetymd(i0year,i0doy,c0opt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   get yyyymmdd from DOY
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c index (time)
      integer           i0mon
      integer           i0day
c function
      integer           igetday
c in
      integer           i0year
      integer           i0doy
      character*128     c0opt
c local
      integer           i0cnt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0cnt=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0mon=1,12
        do i0day=1,igetday(i0year,i0mon)
          i0cnt=i0cnt+1
          if(i0cnt.eq.i0doy)then
            goto 52
          end if
        end do
      end do
 52   continue
      if(c0opt.eq.'mon')then
        igetymd=i0mon
      else if(c0opt.eq.'day')then
        igetymd=i0day
      end if
c
      end
