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
      integer function igetday(i0year,i0mon)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   count number of days in a month
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c in
      integer           i0year
      integer           i0mon
c local
      integer           i0feb
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0feb=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation for months except February
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(i0mon.eq.4.or.i0mon.eq.6.or.i0mon.eq.9.or.i0mon.eq.11)then
        igetday=30
      else
        igetday=31
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation for February
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(i0mon.eq.2.or.i0mon.eq.0)then
        if(mod(i0year,4).eq.0)then
          i0feb=29
          if(mod(i0year,100).eq.0)then
            i0feb=28
            if(mod(i0year,400).eq.0)then
              i0feb=29
            end if
          end if
        else
          i0feb=28
        end if
      end if
c fix
      if(i0year.eq.0)then
        i0feb=28
      end if
c fix
      if(i0mon.eq.2)then
        igetday=i0feb
      else if(i0mon.eq.0)then
        igetday=i0feb+337
      end if
c
      end
