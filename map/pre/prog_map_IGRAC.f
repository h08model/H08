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
      program prog_full2alp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert full country name into Alpha3
cby   2016/12/20, hanasaki 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer           n0id
      integer           n0rec
      parameter        (n0id=1200) 
      parameter        (n0rec=10) 
c index
      integer           i0id
      integer           i0rec
c in      
      character*128     c2lstful(n0id,n0rec)
      character*128     c0lstful
      character*128     c1lstalp(n0id)
      character*128     c0lstalp
      real              r0dat
      character*128     c0dat
c local
      integer           i0flg
      character*128     c0tmp
      character*128     c0ifname
      character*128     c0alp

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.3)then
        write(*,*) 'prog_read lstful lstalp dat'
        stop
      end if
c
      call getarg(1,c0lstful)
      call getarg(2,c0lstalp)
      call getarg(3,c0dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      c2lstful=''
      c1lstalp=''
c
      open(15,file=c0lstful)
 777  read(15,*,end=999) c0tmp,i0id
      i0flg=0
      if(i0id.ne.999)then
        do i0rec=1,n0rec
          if(i0flg.eq.0.and.c2lstful(i0id,i0rec).eq.'')then
            c2lstful(i0id,i0rec)=c0tmp
            i0flg=1
          end if
        end do
      end if
      goto 777
 999  close(15)
c
      open(15,file=c0lstalp)
 77   read(15,*,end=99) c0tmp,i0id
      c1lstalp(i0id)=c0tmp
      goto 77
 99   close(15)
c
      open(15,file=c0dat)
 7777 read(15,*,end=9999) c0tmp,r0dat
      c0alp='NA'
      do i0rec=1,n0rec
        do i0id=1,n0id
          if(c2lstful(i0id,i0rec).eq.c0tmp)then
            c0alp=c1lstalp(i0id)
            if(c0alp.eq.'')then
              c0alp='NA'
            end if
c            write(*,*) c2lstful(i0id,i0rec),i0id,i0rec
          end if
        end do
      end do
      write(*,'(a5,f24.8)') c0alp,r0dat
      goto 7777
 9999 close(15)
c
      end
