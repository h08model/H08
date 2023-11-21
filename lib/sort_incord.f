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
      subroutine sort_incord(
     $     n0rec,
     $     r1dat,
     $     r1out,i1org2rnk,i1rnk2org)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   sort an array in increasing order
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0rec
c parameter (default)
      real              p0minini
      parameter        (p0minini=9.99E20) 
c in
      real              r1dat(n0rec)     !! original data
c out
      real              r1out(n0rec)
      integer           i1org2rnk(n0rec) !! original order --> rank
      integer           i1rnk2org(n0rec) !! rank --> original order
c local
      integer           i0rec            !! index of record
      integer           i0rnk            !! index of rank
      integer           i1flg(n0rec)
      real              r0min
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i1flg=0
      r0min=p0minini
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0rnk=1,n0rec
        do i0rec=1,n0rec
          if(i1flg(i0rec).eq.0)then
            r0min=min(r1dat(i0rec),r0min)
          end if
        end do
        do i0rec=1,n0rec
          if(r1dat(i0rec).eq.r0min)then
            r1out(i0rnk)=r1dat(i0rec)
            i1org2rnk(i0rec)=i0rnk
            i1rnk2org(i0rnk)=i0rec
            i1flg(i0rec)=1
            goto 55
          end if
        end do
 55     continue
        r0min=p0minini
      end do
c
      end
