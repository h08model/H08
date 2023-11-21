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
      program prog_gwr_fp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare parameter for permafrost/glacier
cby   2015/12/14, hanasaki
c
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index
      integer           i0l
c temporary
      character*128     c0tmp
c in
      real,allocatable::r1prm(:)        !! permafrost extent by NSIDC
      character*128     c0prm        
c out
      real,allocatable::r1fp(:)         !! 
      character*128     c0fp
c local
      real              r1optfp(0:25)
      data              r1optfp/1.00,
     $     0.05,0.30,0.70,0.95,0.05,0.30,0.70,0.95,0.05,0.30,
     $     0.70,0.95,0.05,0.30,0.70,0.95,0.05,0.30,0.70,0.95,
     $     0.00,1.00,1.00,1.00,1.00/
      integer           i0ldbg
c bug      data              i0ldbg/79112/
      data              i0ldbg/1/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.3) then
        write(6,*) 'Usage: prog_gwr_fp n0l c0prm c0fp'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0prm)
      call getarg(3,c0fp)
c
      allocate(r1prm(n0l))
      allocate(r1fp(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      write(*,*) '[prog_gwr_fp] c0prm:',c0prm
      call read_binary(n0l,c0prm,r1prm)
c
      write(*,*) '[prog_gwr_fp] r1prm(i0l):',r1prm(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c convert
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1prm(i0l).ne.p0mis)then
          r1fp(i0l)=real(r1optfp(int(r1prm(i0l))))
        else
          r1fp(i0l)=0.0
        end if
      end do
c
      write(*,*) '[prog_gwr_fp] r1fp(i0l):    ',r1fp(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1fp,c0fp)
c
      end
