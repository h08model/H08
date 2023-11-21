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
      program htranktxt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   sort time series data and show as a ranking table
cby   2010/05/18, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0yearmin
      integer           n0yearmax
      integer           n0rec
      parameter        (n0yearmin=1800)
      parameter        (n0yearmax=2300)
c      parameter        (n0rec=366*100) 
      parameter        (n0rec=1000) 
      integer           n0mis
      real              p0mis
      parameter        (n0mis=-9999) 
      parameter        (p0mis=1.0E20)
c index (array)
      integer           i0rec
      integer           i0recmax
c index (time)
      integer           i0year
      integer           i0yearmin
      integer           i0yearmax
      integer           i0mon
      integer           i0monmin
      integer           i0monmax
      integer           i0day
      integer           i0daymin
      integer           i0daymax
c temporary
      integer           i0tmp
      character*128     c0tmp
c function
      integer           igetday
      integer           iargc
c in
      real              r1dat(n0rec)
      character*128     c0in
      character*128     c0opt
c out
      real              r1out(n0rec)
c local
      integer           i0inc
      integer           i1rnk2org(n0rec)           
      integer           i1org2rnk(n0rec)           
      integer           i1year(n0rec)           
      integer           i1mon(n0rec)           
      integer           i1day(n0rec)           
      integer           i0lenin
      real              r3dat(0:n0yearmax-n0yearmin+1,0:12,0:31)
      character*128     c0idx
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.4)then
        write(*,*) 'Usage: htranktxt OPTION c0ascts i0yearmin i0yearmax'
        write(*,*) 'OPTION:["largest10","smallest10","decord","incord"]'
        write(*,*) '  largest10  to show 10 largest records'
        write(*,*) '  smallest10 to show 10 smallest records'
        write(*,*) '  decord     to show records in decreasing order'
        write(*,*) '  incord     to show records in increasing order'
        stop
      end if
c
      call getarg(1,c0opt)
      call getarg(2,c0in)
      call getarg(3,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(4,c0tmp)
      read(c0tmp,*) i0yearmax
c
      i0lenin=len_trim(c0in)
      c0idx=c0in(i0lenin-1:i0lenin)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_ascii4(
     $     c0in,
     $     r3dat,
     $     i0tmp,i0tmp)
c
      if(c0idx.eq.'YR')then
        i0monmin=0
        i0monmax=0
      else
        i0monmin=1
        i0monmax=12
      end if
      i0rec=0
      do i0year=i0yearmin,i0yearmax
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'DY')then
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
          else
            i0daymin=0
            i0daymax=0
          end if
          do i0day=i0daymin,i0daymax
            i0rec=i0rec+1
            if(i0year.ne.0)then
              r1dat(i0rec)=r3dat(i0year-n0yearmin+1,i0mon,i0day)
            else
              r1dat(i0rec)=r3dat(0,i0mon,i0day)
            end if
            i1year(i0rec)=i0year
            i1mon(i0rec)=i0mon
            i1day(i0rec)=i0day
          end do
        end do
      end do
      i0recmax=i0rec
      if(i0recmax.gt.n0rec)then
        write(*,*) 'htranktxt: overflow. Increase n0rec.'
        stop
      end if
c      write(*,*) 'htranktxt: i0recmax: ',i0recmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Sort
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call sort_decord(
     $     n0rec,
     $     r1dat,
     $     r1out,i1org2rnk,i1rnk2org)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0opt.eq.'largest10')then
        i0inc=0
        do i0rec=1,10
          if((i0rec+i0inc).le.i0recmax)then
 10         if(r1out(i0rec+i0inc).eq.p0mis)then
              if(i0inc.gt.100)then
                write(*,*) 'htranktxt: data contains too many miss val.'
                stop
              else
                write(*,*)
     $               i1year(i1rnk2org(i0rec+i0inc)),
     $               i1mon(i1rnk2org(i0rec+i0inc)),
     $               i1day(i1rnk2org(i0rec+i0inc)),
     $               n0mis,real(n0mis)
                i0inc=i0inc+1
                goto 10
              end if
            else
              write(*,*) 
     $             i1year(i1rnk2org(i0rec+i0inc)),
     $             i1mon(i1rnk2org(i0rec+i0inc)),
     $             i1day(i1rnk2org(i0rec+i0inc)),
     $             i0rec,r1out(i0rec+i0inc)
            end if
          end if
        end do
      else if(c0opt.eq.'decord')then
        i0inc=0
        do i0rec=1,i0recmax
          if((i0rec+i0inc).le.i0recmax)then
 20         if(r1out(i0rec+i0inc).eq.p0mis)then
              if(i0inc.gt.100)then
                write(*,*) 'htranktxt: data contains too many miss val.'
                stop
              else
                write(*,*)
     $               i1year(i1rnk2org(i0rec+i0inc)),
     $               i1mon(i1rnk2org(i0rec+i0inc)),
     $               i1day(i1rnk2org(i0rec+i0inc)),
     $               n0mis,real(n0mis)
                i0inc=i0inc+1
                goto 20
              end if
            else
              write(*,*) 
     $             i1year(i1rnk2org(i0rec+i0inc)),
     $             i1mon(i1rnk2org(i0rec+i0inc)),
     $             i1day(i1rnk2org(i0rec+i0inc)),
     $             i0rec,r1out(i0rec+i0inc)
            end if
          end if
        end do
      else if(c0opt.eq.'smallest10')then
        i0inc=0
        do i0rec=i0recmax,i0recmax-9,-1
          if((i0rec+i0inc).ge.1)then
 30         if(r1out(i0rec+i0inc).eq.p0mis)then
              if(i0inc.lt.-100)then
                write(*,*) 'htranktxt: data contains too many miss val.'
                stop
              else
                write(*,*)
     $               i1year(i1rnk2org(i0rec+i0inc)),
     $               i1mon(i1rnk2org(i0rec+i0inc)),
     $               i1day(i1rnk2org(i0rec+i0inc)),
     $               n0mis,real(n0mis)
                i0inc=i0inc-1
                if((i0rec+i0inc).ge.1)then
                  goto 30
                end if
              end if
            else
              write(*,*) 
     $             i1year(i1rnk2org(i0rec+i0inc)),
     $             i1mon(i1rnk2org(i0rec+i0inc)),
     $             i1day(i1rnk2org(i0rec+i0inc)),
     $             i0recmax-i0rec+1,r1out(i0rec+i0inc)
            end if
          end if
        end do
      else if(c0opt.eq.'incord')then
        i0inc=0
        do i0rec=i0recmax,1,-1
          if((i0rec+i0inc).ge.1)then
 40         if(r1out(i0rec+i0inc).eq.p0mis)then
              if(i0inc.lt.-100)then
                write(*,*) 'htranktxt: data contains too many miss val.'
                stop
              else
                write(*,*)
     $               i1year(i1rnk2org(i0rec+i0inc)),
     $               i1mon(i1rnk2org(i0rec+i0inc)),
     $               i1day(i1rnk2org(i0rec+i0inc)),
     $               n0mis,real(n0mis)
                i0inc=i0inc-1
                if((i0rec+i0inc).ge.1)then
                  goto 40
                end if
              end if
            else
              write(*,*) 
     $             i1year(i1rnk2org(i0rec+i0inc)),
     $             i1mon(i1rnk2org(i0rec+i0inc)),
     $             i1day(i1rnk2org(i0rec+i0inc)),
     $             i0recmax-i0rec+1,r1out(i0rec+i0inc)
            end if
          end if
        end do
      else
        write(*,*) 'htranktxt: c0opt: ',c0opt,' not supported.'
      end if
c
      end
