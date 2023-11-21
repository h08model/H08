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
      program htcal
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   get number of days in a month
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c in (set)
      integer           i0year
      integer           i0mon
c temporary
      character*128     c0tmp
c function
      integer           igetday
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.2)then
        write(*,*) 'Usage: htcal i0year i0mon'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) i0year
      call getarg(2,c0tmp)
      read(c0tmp,*) i0mon
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      write(*,*) igetday(i0year,i0mon)
c
      end
