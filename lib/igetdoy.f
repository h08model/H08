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
      integer function igetdoy(i0year,i0mon,i0day)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   get Day Of Year
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c function
      integer           igetday
c in
      integer           i0year
      integer           i0mon
      integer           i0day
c local
      integer           i0m
      integer           i0d
      integer           i0dmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      igetdoy=0         !! do we need this initialization?
      i0m=0
      i0d=0
      i0dmax=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0m=1,i0mon
        if(i0m.eq.i0mon)then
          i0dmax=i0day
        else
          i0dmax=igetday(i0year,i0m)
        end if
        do i0d=1,i0dmax
          igetdoy=igetdoy+1
        end do
      end do
c
      end
