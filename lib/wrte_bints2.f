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
      subroutine wrte_bints2(
     $     n0l,n0t,
     $     r1dat,r2dat,
     $     c0out,i0year,i0mon,i0day,i0sec,i0secint,
     $     c0opt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   write binary (time series, for array dimension of 2)
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
      integer           n0t
c parameter (physical)
      integer           n0secday        
      parameter        (n0secday=86400) 
c parameter (default)
      integer           n0of
      real              p0mis
      parameter        (n0of=16) 
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c temporary
      real              r1tmp(n0l)
c function
      integer           len_trim
      integer           igetday
c in
      real              r1dat(n0l)
      real              r2dat(n0l,0:n0t)
c out
      character*128     c0out     !! out (dir+prj+run+suf+idx)
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0sec
      integer           i0secint
      character*128     c0opt
c local
      character*128     c0ofname
      character*128     c0dir
      character*128     c0prj
      character*128     c0run
      character*128     c0suf
      character*128     c0idx
      character*128     c0lendir   !! length of directory
      integer           i0lendir   !! length of directory
      integer           i0lenout   !! length of out
      integer           i0year_dummy
      integer           i0mon_dummy
      integer           i0day_dummy
      integer           i0hour_dummy
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      c0ofname=''
      c0dir=''
      c0prj=''
      c0run=''
      c0suf=''
      c0idx=''
      c0lendir=''
      i0lendir=0
      i0lenout=0
      i0year_dummy=0
      i0mon_dummy=0
      i0day_dummy=0
      i0hour_dummy=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(i0sec.eq.i0secint)then
        do i0l=1,n0l
          r2dat(i0l,1)=0.0
        end do
        if(i0day.eq.1)then
          do i0l=1,n0l
            r2dat(i0l,2)=0.0
          end do
          if(i0mon.eq.1)then
            do i0l=1,n0l
              r2dat(i0l,3)=0.0
            end do
          end if
        end if
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c copy
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.ne.'spn')then
        do i0l=1,n0l
          r2dat(i0l,0)=r1dat(i0l)
        end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'max')then
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r2dat(i0l,1)=max(r2dat(i0l,1),r1dat(i0l))
            r2dat(i0l,2)=max(r2dat(i0l,2),r1dat(i0l))
            r2dat(i0l,3)=max(r2dat(i0l,3),r1dat(i0l))
          end if
        end do
      else if(c0opt.eq.'min')then
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r2dat(i0l,1)=min(r2dat(i0l,1),r1dat(i0l))
            r2dat(i0l,2)=min(r2dat(i0l,2),r1dat(i0l))
            r2dat(i0l,3)=min(r2dat(i0l,3),r1dat(i0l))
          end if
        end do
      else if(c0opt.eq.'ave')then
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r2dat(i0l,1)=r2dat(i0l,1)+r1dat(i0l)
c          r2dat(i0l,2)=r2dat(i0l,2)+r1dat(i0l)  !! old
c          r2dat(i0l,3)=r2dat(i0l,3)+r1dat(i0l)  !! old
          end if
        end do
      else if(c0opt.eq.'sta')then
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r2dat(i0l,1)=r1dat(i0l)
            r2dat(i0l,2)=r1dat(i0l)
            r2dat(i0l,3)=r1dat(i0l)
          end if
        end do
      else if(c0opt.eq.'spn')then
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r2dat(i0l,1)=r2dat(i0l,0)
            r2dat(i0l,2)=r2dat(i0l,0)
            r2dat(i0l,3)=r2dat(i0l,0)
          end if
        end do
      end if
c
      if(c0opt.eq.'ave')then
        if(i0sec.eq.n0secday)then
          do i0l=1,n0l
            r2dat(i0l,1)=r2dat(i0l,1)
     $           /real(n0secday/i0secint)
            r2dat(i0l,2)=r2dat(i0l,2)+r2dat(i0l,1) !! new
            r2dat(i0l,3)=r2dat(i0l,3)+r2dat(i0l,1) !! new
          end do
          if(i0day.eq.igetday(i0year,i0mon))then
            do i0l=1,n0l
              r2dat(i0l,2)=r2dat(i0l,2)
     $             /real(igetday(i0year,i0mon))
            end do
            if(i0mon.eq.12)then
              do i0l=1,n0l              
                r2dat(i0l,3)=r2dat(i0l,3)
     $               /real(igetday(i0year,0))
              end do
            end if
          end if
        end if
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get index
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0lenout=len_trim(c0out)
      c0idx=c0out(i0lenout-1:i0lenout)
      if(c0idx.ne.'NO')then
        c0suf=c0out(i0lenout-5:i0lenout-2)
        c0run=c0out(i0lenout-9:i0lenout-6)
        c0prj=c0out(i0lenout-13:i0lenout-10)
        c0dir=c0out(1:i0lenout-14)
        i0lendir=len_trim(c0dir)
        write(c0lendir,*) i0lendir
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write (daily, monthly, yearly)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(i0sec.eq.n0secday)then
        if(c0idx.eq.'DY'.or.
     $     c0idx.eq.'6H'.or.c0idx.eq.'3H'.or.c0idx.eq.'HR')then
          write(c0ofname,'(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $         c0dir,c0prj,c0run,i0year,i0mon,i0day,c0suf
          do i0l=1,n0l
            r1tmp(i0l)=r2dat(i0l,1)
          end do
          call wrte_binary(n0l,r1tmp,c0ofname)
        end if
        if(i0day.eq.igetday(i0year,i0mon))then
          if(c0idx.eq.'MO'.or.c0idx.eq.'DY'.or.
     $       c0idx.eq.'6H'.or.c0idx.eq.'3H'.or.c0idx.eq.'HR')then
            write(c0ofname,'(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $           c0dir,c0prj,c0run,i0year,i0mon,0,c0suf
            do i0l=1,n0l
              r1tmp(i0l)=r2dat(i0l,2)
            end do
            call wrte_binary(n0l,r1tmp,c0ofname)
          end if
          if(i0mon.eq.12)then
            if(c0idx.eq.'YR'.or.c0idx.eq.'MO'.or.c0idx.eq.'DY'.or.
     $         c0idx.eq.'6H'.or.c0idx.eq.'3H'.or.c0idx.eq.'HR')then
              write(c0ofname,
     $             '(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $             c0dir,c0prj,c0run,i0year,0,0,c0suf
              do i0l=1,n0l
                r1tmp(i0l)=r2dat(i0l,3)
              end do
              call wrte_binary(n0l,r1tmp,c0ofname)
            end if
          end if
        end if
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write (hourly, 3-hourly, 6-hourly)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.eq.'HR'.and.mod(i0sec,3600).eq.0.or.
     $   c0idx.eq.'3H'.and.mod(i0sec,10800).eq.0.or.
     $   c0idx.eq.'6H'.and.mod(i0sec,21600).eq.0)then
        i0hour_dummy=i0sec/3600
        i0day_dummy=i0day
        i0mon_dummy=i0mon
        i0year_dummy=i0year
        if(i0hour_dummy.eq.24)then
          i0hour_dummy=0
          i0day_dummy=i0day+1
          if(i0day_dummy.gt.igetday(i0year,i0mon))then
            i0day_dummy=1
            i0mon_dummy=i0mon+1
            if(i0mon_dummy.gt.12)then
              i0mon_dummy=1
              i0year_dummy=i0year+1
            end if
          end if
        end if
        write(c0ofname,
     $       '(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,i2.2,a4)')
     $       c0dir,c0prj,c0run,
     $       i0year_dummy,i0mon_dummy,i0day_dummy,i0hour_dummy,c0suf
        call wrte_binary(n0l,r1dat,c0ofname)
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c reset
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c      if(c0opt.ne.'sta')then
c        do i0l=1,n0l
c          r1dat(i0l)=0.0
c        end do
c      end if
c
      end
