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
      program prog_ind2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert data
cby   hanasaki, 2020/11/30
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c 
      integer           n0if               !! device number
      integer           n0of               !! device number
      integer           n0id               !! municipality id
      integer           n0ind              !! industry id
      integer           n0rec
      parameter        (n0if=15) 
      parameter        (n0of=16) 
      parameter        (n0ind=33) 
      parameter        (n0id=50000) 
      parameter        (n0rec=21000) 
      real              p0mis
      parameter        (p0mis=1.0E20) 
c in
      real              r1dat(n0rec)
      character*128     c0ifname            !! input file name
c out
      real              r1outdat1(n0rec)
      real              r1outdat2(n0id)
      character*128     c0ofname1           !! output file name
      character*128     c0ofname2           !! output file name      
c index
      integer           i0id
      integer           i0ind
c temporary
      real              r0tmp
c local
      integer           i1cnt2cnt1(n0rec)
      integer           i1id(n0rec)
      integer           i1id1(n0rec)
      integer           i1ind(n0rec)
      integer           i0cnt               !! counter
      integer           i0cnt1              !! counter for output 1
      integer           i0cnt2              !! counter for output 2
      integer           i0cntmax            !! counter max
      integer           i0cntmax1           !! counter max for output 1
      integer           i0cntmax2           !! counter max for output 2
      real              r0dat               !! data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.3)then
        write(*,*) 'stop'
        stop
      end if
c
      call getarg(1,c0ifname)
      call getarg(2,c0ofname1)
      call getarg(3,c0ofname2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
      i1id=0
      r1dat=0.0
      i1ind=0
c
      i0cnt=1
      open(n0if,file=c0ifname,status='old')
 100  read(n0if,*,end=101) i0id,r0dat,r0tmp,i0ind
      i1id(i0cnt)=i0id
      r1dat(i0cnt)=r0dat
      i1ind(i0cnt)=i0ind
      i0cnt=i0cnt+1
      goto 100
 101  close(n0if)
      i0cntmax=i0cnt-1
      write(*,*) 'total lines in the input data:',i0cntmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1outdat1=0.0
      r1outdat2=p0mis
c
      i0cnt1=1
      do i0cnt=1,i0cntmax
        if(i1ind(i0cnt).eq.0)then
          r1outdat1(i0cnt1)=r1dat(i0cnt)
          i1cnt2cnt1(i0cnt)=i0cnt1
          i1id1(i0cnt1)=i1id(i0cnt)
          i0cnt1=i0cnt1+1
        else
          if(r1outdat2(i1id(i0cnt)).eq.p0mis)then
            r1outdat2(i1id(i0cnt))=r1dat(i0cnt)
          else
            r1outdat2(i1id(i0cnt))=r1outdat2(i1id(i0cnt))+r1dat(i0cnt)
          end if
        end if
      end do
      i0cntmax1=i0cnt1-1
      write(*,*) 'num of municipality 1',i0cntmax1
c
      do i0cnt=1,i0cntmax
        if(r1outdat2(i1id(i0cnt)).eq.p0mis.and.
     $     i1cnt2cnt1(i0cnt).ne.0)then
           r1outdat2(i1id(i0cnt))=r1outdat1(i1cnt2cnt1(i0cnt))
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(n0of,file=c0ofname1)
      do i0cnt1=1,i0cntmax1
        write(n0of,*) i1id1(i0cnt1),r1outdat1(i0cnt1)
      end do
      close(n0of)
c
      open(n0of,file=c0ofname2)
      i0cnt2=0
      do i0id=1,n0id
        if(r1outdat2(i0id).ne.p0mis)then
          write(n0of,*) i0id,r1outdat2(i0id)
          i0cnt2=i0cnt2+1
        end if
      end do
      i0cntmax2=i0cnt2
      close(n0of)
      write(*,*) 'num of municipality 2',i0cntmax2
c
      end


