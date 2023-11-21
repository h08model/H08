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
      subroutine calc_ts_nxt(
     $     n0l,  i0ldbg,
     $     i0cnt,i1flgcal,r1engbal,
     $     r1avgsurft)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   set avgsurft
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c index
      integer           i0l
c in (set)
      integer           i0ldbg
      integer           i0cnt
      integer           i1flgcal(n0l)
c in (state)
      real              r1engbal(n0l)
c in/out (state)
      real              r1avgsurft(n0l)
c local
      real              r1factor(n0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1factor=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
d     write(*,*) 'calc_ts_nxt: i0cnt:      ',i0cnt
d     write(*,*) 'calc_ts_nxt: i1flgcal:   ',i1flgcal(i0ldbg)
d     write(*,*) 'calc_ts_nxt: r1avgsurft: ',r1avgsurft(i0ldbg)
c
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(i0cnt.le.100)then
            r1factor(i0l)=1.0
          else if(i0cnt.le.250)then
            r1factor(i0l)=0.5
          else if(i0cnt.le.500)then
            r1factor(i0l)=0.1
          else
            r1factor(i0l)=0.05
          end if
        end if
      end do
c
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1engbal(i0l).ge.100)then
            r1avgsurft(i0l)=r1avgsurft(i0l)+2.0*r1factor(i0l)
          else if(r1engbal(i0l).ge.50)then
            r1avgsurft(i0l)=r1avgsurft(i0l)+1.0*r1factor(i0l)
          else if(r1engbal(i0l).ge.20)then
            r1avgsurft(i0l)=r1avgsurft(i0l)+0.3*r1factor(i0l)
          else if(r1engbal(i0l).ge.10)then
            r1avgsurft(i0l)=r1avgsurft(i0l)+0.2*r1factor(i0l)
          else if(r1engbal(i0l).ge.5)then
            r1avgsurft(i0l)=r1avgsurft(i0l)+0.1*r1factor(i0l)
          else if(r1engbal(i0l).ge.1)then
            r1avgsurft(i0l)=r1avgsurft(i0l)+0.02*r1factor(i0l)
          else if(r1engbal(i0l).ge.0.5)then
            r1avgsurft(i0l)=r1avgsurft(i0l)+0.01*r1factor(i0l)
          else if(r1engbal(i0l).ge.0.1)then
            r1avgsurft(i0l)=r1avgsurft(i0l)+0.005*r1factor(i0l)
          else if(r1engbal(i0l).le.-100)then
            r1avgsurft(i0l)=r1avgsurft(i0l)-2.41*r1factor(i0l)
          else if(r1engbal(i0l).le.-50)then
            r1avgsurft(i0l)=r1avgsurft(i0l)-1.201*r1factor(i0l)
          else if(r1engbal(i0l).le.-20)then
            r1avgsurft(i0l)=r1avgsurft(i0l)-0.36001*r1factor(i0l)
          else if(r1engbal(i0l).le.-10)then
            r1avgsurft(i0l)=r1avgsurft(i0l)-0.24001*r1factor(i0l)
          else if(r1engbal(i0l).le.-5)then
            r1avgsurft(i0l)=r1avgsurft(i0l)-0.120001*r1factor(i0l)
          else if(r1engbal(i0l).le.-1)then
            r1avgsurft(i0l)=r1avgsurft(i0l)-0.02400001*r1factor(i0l)
          else if(r1engbal(i0l).le.-0.1)then
            r1avgsurft(i0l)=r1avgsurft(i0l)-0.006000001*r1factor(i0l)
          end if
        end if
      end do
d     write(*,*) 'calc_ts_nxt: r1avgsurft: ',r1avgsurft(i0ldbg)
c        
      end
