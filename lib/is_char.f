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
      integer function is_char(c0tmp)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   judge the argument is character (1) or not (0)
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c in
      character*128     c0tmp
c local
      character*1       c0tmp_first
      character*1       c0tmp_second
      integer           i0tmp
      integer           i0tmp_first
      integer           i0tmp_second
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialization
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      c0tmp_first=''
      c0tmp_second=''
      i0tmp=0
      i0tmp_first=0
      i0tmp_second=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      c0tmp_first=c0tmp(1:1)
      i0tmp_first=iachar(c0tmp_first)
      if(i0tmp_first.ge.48.and.i0tmp_first.le.57)then
        is_char=0
      else
        is_char=1
      end if
c
      if(len_trim(c0tmp).ge.2)then
        c0tmp_second=c0tmp(2:2)
        i0tmp_second=iachar(c0tmp_second)
        if(i0tmp_first.eq.45.and.
     $       i0tmp_second.ge.48.and.i0tmp_second.le.57)then
          is_char=0
        end if
      end if
c
      end
