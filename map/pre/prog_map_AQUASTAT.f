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
      program prog_map_AQUASTAT
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare AQUASTAT data
cby   2011/04/04, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0yearmin
      integer           n0yearmax
      integer           n0yearint
      integer           n0rec
      integer           n0mis
      parameter        (n0yearmin=1960) 
      parameter        (n0yearmax=2010) 
      parameter        (n0yearint=5) 
      parameter        (n0rec=500) 
      parameter        (n0mis=-9999) 
c index
      integer           i0year
      integer           i0rec
      integer           i0recmax
c temporary
      character*128     c0tmp
      integer           i0yeardummy
c in
      integer           i0yearout
      real              r2dat(n0yearmin:n0yearmax,n0rec)
      character*128     c1dat(n0rec)
      character*128     c0ifname
      character*128     c0opt
c out      
      real              r1out(n0rec)
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.4)then
        write(*,*) 'prog_map_AQUASTAT'
        stop
      end if
c
      call getarg(1,c0ifname)
      call getarg(2,c0ofname)
      call getarg(3,c0tmp)
      read(c0tmp,*) i0yearout
      call getarg(4,c0opt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0rec=1
      open(15,file=c0ifname,status='old')
      read(15,*)
 10   read(15,*,end=20) c1dat(i0rec),(r2dat(i0year,i0rec),
     $     i0year=n0yearmin,n0yearmax,n0yearint)
      i0rec=i0rec+1
      goto 10
 20   close(15)
      i0recmax=i0rec-1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'exact')then
        i0yeardummy=i0yearout
      else if(c0opt.eq.'latest')then
        i0yeardummy=n0yearmin
      else
        write(*,*) 'prog_map_AQUASTAT: c0opt: ',c0opt,' not supported.'
        stop
      end if
c
      r1out=real(n0mis)
      do i0rec=1,i0recmax
        do i0year=i0yeardummy,i0yearout,n0yearint
            if(r2dat(i0year,i0rec).ne.real(n0mis))then
              r1out(i0rec)=r2dat(i0year,i0rec)
            end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(16,file=c0ofname)
      do i0rec=1,i0recmax
        write(16,'(a64,f12.4)') c1dat(i0rec), r1out(i0rec)
      end do
      close(16)
c
      end
