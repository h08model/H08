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
      integer function len_trim(c0tmp)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   count the number of character
cby   2010/03/31, hanasaki, NIES: H08ver1.0
c     len_trim is a bulit-in function of some fortran compilers
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c in
      character*(*)     c0tmp
c local
      integer           i
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i=1,len(c0tmp)
        if(c0tmp(i:i).eq.' ')then
          len_trim=i-1
          return
        end if
      end do
      len_trim=len(c0tmp)
c
      end
