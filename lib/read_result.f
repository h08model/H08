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
      subroutine read_result(
     $     n0l,
     $     c0in,  i0year,i0mon,
     $     i0day, i0sec, i0secint,
     $     r1out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   read time series binary
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (physical)
      integer           n0secday        
      parameter        (n0secday=86400) 
c parameter (default)
      integer           n0if
      parameter        (n0if=15) 
c index (array)
      integer           i0l
c function
      integer           len_trim
      integer           igetday
c in
      character*128     c0in
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0sec
      integer           i0secint
c out
      real              r1out(n0l)
c local
      character*128     c0ifname
      character*128     c0dir
      character*128     c0prj
      character*128     c0run
      character*128     c0suf
      character*128     c0idx
      character*128     c0lendir   !! length of directory
      integer           i0lendir   !! length of directory
      integer           i0lenin    !! length of in
      integer           i0year_dummy
      integer           i0mon_dummy
      integer           i0day_dummy
      integer           i0hour_dummy
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      c0ifname=''
      c0dir=''
      c0prj=''
      c0run=''
      c0suf=''
      c0idx=''
      c0lendir=''
      i0lendir=0
      i0lenin=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Decode c0in
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0lenin=len_trim(c0in)
      c0idx=c0in(i0lenin-1:i0lenin)
      if(c0idx.ne.'FX')then
        c0suf=c0in(i0lenin-5:i0lenin-2)
        c0run=c0in(i0lenin-9:i0lenin-6)
        c0prj=c0in(i0lenin-13:i0lenin-10)
        c0dir=c0in(1:i0lenin-14)
        i0lendir=len_trim(c0dir)
        write(c0lendir,*) i0lendir
      else
        c0ifname=c0in(1:i0lenin-2)
      end if
c
      if(c0idx.ne.'DY'.and.c0idx.ne.'MO'.and.c0idx.ne.'YR'.and.
     $   c0idx.ne.'MD'.and.c0idx.ne.'MM'.and.c0idx.ne.'MY'.and.
     $   c0idx.ne.'HR'.and.c0idx.ne.'3H'.and.c0idx.ne.'6H'.and.
     $   c0idx.ne.'FX'.and.c0idx.ne.'DL')then
        write(*,*) 'read_result: c0idx',c0idx,'not supported. Abort.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read (daily, monthly, yearly)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.eq.'DY'.or.c0idx.eq.'DL')then
        write(c0ifname,'(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $       c0dir,c0prj,c0run,i0year,i0mon,i0day,c0suf
        call read_binary(n0l,c0ifname,r1out)
      end if
c
      if(c0idx.eq.'MD')then
        write(c0ifname,'(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $       c0dir,c0prj,c0run,0,i0mon,i0day,c0suf
        call read_binary(n0l,c0ifname,r1out)
      end if
c
      if(c0idx.eq.'MO')then
        write(c0ifname,'(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $       c0dir,c0prj,c0run,i0year,i0mon,0,c0suf
        call read_binary(n0l,c0ifname,r1out)
      end if
c
      if(c0idx.eq.'MM')then
        write(c0ifname,'(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $       c0dir,c0prj,c0run,0,i0mon,0,c0suf
        call read_binary(n0l,c0ifname,r1out)
      end if
c
      if(c0idx.eq.'YR')then
        write(c0ifname,
     $       '(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $       c0dir,c0prj,c0run,i0year,0,0,c0suf
        call read_binary(n0l,c0ifname,r1out)
      end if
c
      if(c0idx.eq.'MY')then
        write(c0ifname,
     $       '(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,a4)')
     $       c0dir,c0prj,c0run,0,0,0,c0suf
        call read_binary(n0l,c0ifname,r1out)
      end if
c
      if(c0idx.eq.'FX')then
        call read_binary(n0l,c0ifname,r1out)
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read (hourly, 3-hourly, 6-hourly)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.eq.'HR'.or.c0idx.eq.'3H'.or.c0idx.eq.'6H')then
        if(c0idx.eq.'HR')then
          i0hour_dummy=(i0sec-mod(i0sec,3600))/3600
        else if(c0idx.eq.'3H')then
          i0hour_dummy=(i0sec-mod(i0sec,10800))/3600
        else if(c0idx.eq.'6H')then
          i0hour_dummy=(i0sec-mod(i0sec,21600))/3600
        end if
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
        write(c0ifname,
     $       '(a'//c0lendir//',a4,a4,i4.4,i2.2,i2.2,i2.2,a4)')
     $       c0dir,c0prj,c0run,
     $       i0year_dummy,i0mon_dummy,i0day_dummy,i0hour_dummy,c0suf
        call read_binary(n0l,c0ifname,r1out)
      end if
c
c     write(*,*)'read_result: n0l:       ',n0l
c     write(*,*)'read_result: c0in:      ',c0in
c     write(*,*)'read_result: yyyymmdd:  ',i0year,i0mon,i0day
c     write(*,*)'read_result: sec,secint:',i0sec,i0secint
c     write(*,*)'read_result: c0ifname:  ',c0ifname
c
      end
