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
      program htmettxt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate metrix
cby   2011/05/20, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c index (parameter)
      integer           n0yearmin
      integer           n0yearmax
      integer           n0mis
      real              p0mis
      real              p0maxini
      parameter        (n0yearmin=1800) 
      parameter        (n0yearmax=2300) 
      parameter        (n0mis=-9999)
      parameter        (p0mis=1.0E20) 
      parameter        (p0maxini=-9.9E20) 
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
c in
      real              r3sim(0:n0yearmax-n0yearmin+1,0:12,0:31)
      real              r3obs(0:n0yearmax-n0yearmin+1,0:12,0:31)
      character*128     c0sim
      character*128     c0obs
c out
      real              r0avesim      
      real              r0aveobs
      real              r0aveerr
      real              r0aveerr2
      real              r0bias
      real              r0biasabs
      real              r0cc
      real              r0delay
      real              r0rmse
      real              r0nrmse
      real              r0nse
c local
      integer           i0cnt      !!
      integer           i0cntdelay !!   
      integer           i0sumdelay !!
      integer           i0maxsim   !!
      integer           i0maxobs   !!
      real              r0sumsim   !!
      real              r0sumobs   !!
      real              r0sumerr   !!
      real              r0sumerr2  !!
      real              r0varsim   !!
      real              r0varobs   !!
      real              r0cov      !!
      real              r0maxsim   !!
      real              r0maxobs   !!
      real              r3err(0:n0yearmax-n0yearmin+1,0:12,0:31)
      integer           i0yearminout
      integer           i0yearmaxout
c temporary
      integer           i0tmp
      real              r0tmp
      character*128     c0tmp
      character*128     c0opt
      character*128     c0idx
c system
      integer           iargc
      integer           igetday
      integer           igetdoy
      integer           i0in
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.5)then
        write(*,*) 'Usage: htmettxt OPTION c0ascts(sim) c0ascts(obs)'
        write(*,*) '       i0yearmin i0yearmax'
        write(*,*) 'OPTION: [bias,biasabs,cc,delay,(n)rmse, nse]'
        write(*,*) '  bias    for bias'
        write(*,*) '  biasabs for absolute bias'
        write(*,*) '  cc      for correlation coefficient'
        write(*,*) '  delay   for delay in peak'
        write(*,*) '  rmse    for rmse'
        write(*,*) '  nrmse   for normalized rmse'
        write(*,*) '  nse     for Nash-Sutcliffe efficiency'
        stop
      end if
c
      call getarg(1,c0opt)
      call getarg(2,c0sim)
      call getarg(3,c0obs)
      call getarg(4,c0tmp)
      read(c0tmp,*) i0yearminout
      call getarg(5,c0tmp)
      read(c0tmp,*) i0yearmaxout
c
      i0in=len_trim(c0sim)
      c0idx=c0sim(i0in-1:i0in)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r0sumerr=0.0
      r0sumerr2=0.0
      r0sumsim=0.0
      r0sumobs=0.0
      i0cnt=0
      i0cntdelay=0
      i0sumdelay=0
      r0cov=0.0
      r0varsim=0.0
      r0varobs=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read data
c - simulation
c - observation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_ascii4(c0sim,r3sim,i0yearmin,i0yearmax)
      call read_ascii4(c0obs,r3obs,i0yearmin,i0yearmax)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0year=i0yearminout,i0yearmaxout
        r0maxsim=p0maxini
        r0maxobs=p0maxini
        i0maxsim=0
        i0maxobs=0
        if(c0idx.eq.'YR')then
          i0monmin=0
          i0monmax=0
        else
          i0monmin=1
          i0monmax=12
        end if
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'DY')then
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
          else
            i0daymin=0
            i0daymax=0
          end if
          do i0day=i0daymin,i0daymax
            if(r3sim(i0year-n0yearmin+1,i0mon,i0day).ne.p0mis.and.
     $         r3obs(i0year-n0yearmin+1,i0mon,i0day).ne.p0mis)then
              r3err(i0year-n0yearmin+1,i0mon,i0day)
     $             =r3sim(i0year-n0yearmin+1,i0mon,i0day)
     $             -r3obs(i0year-n0yearmin+1,i0mon,i0day)
              r0sumerr=r0sumerr
     $             +r3err(i0year-n0yearmin+1,i0mon,i0day)
              r0sumerr2=r0sumerr2
     $             +r3err(i0year-n0yearmin+1,i0mon,i0day)**2
              r0sumsim=r0sumsim+r3sim(i0year-n0yearmin+1,i0mon,i0day)
              r0sumobs=r0sumobs+r3obs(i0year-n0yearmin+1,i0mon,i0day)
c
              if(r0maxsim.lt.r3sim(i0year-n0yearmin+1,i0mon,i0day))then
                r0maxsim=r3sim(i0year-n0yearmin+1,i0mon,i0day)
                if(c0idx.eq.'DY')then
                  i0maxsim=igetdoy(i0year,i0mon,i0day)
                else
                  i0maxsim=i0mon
                end if
              end if
              if(r0maxobs.lt.r3obs(i0year-n0yearmin+1,i0mon,i0day))then
                r0maxobs=r3obs(i0year-n0yearmin+1,i0mon,i0day)
                if(c0idx.eq.'DY')then
                  i0maxobs=igetdoy(i0year,i0mon,i0day)
                else
                  i0maxobs=i0mon
                end if
              end if
c              
              i0cnt=i0cnt+1            
            end if
          end do
        end do
c
c       write(*,*) 'htmettxt: r0maxobs/i0maxobs: ',r0maxobs,i0maxobs
c       write(*,*) 'htmettxt: r0maxsim/i0maxsim: ',r0maxsim,i0maxsim
c
        if(r0maxsim.ne.p0maxini.and.r0maxobs.ne.p0maxini.and.
     $     i0maxsim.ne.0.and.i0maxobs.ne.0)then
          if(c0idx.eq.'MO')then
            if(i0maxsim-i0maxobs.ge.0)then
              i0sumdelay=i0sumdelay+min(i0maxsim-i0maxobs,
     $                                  12-i0maxsim+i0maxobs)
            else
              i0sumdelay=i0sumdelay+min(i0maxobs-i0maxsim,
     $                                  12-i0maxobs+i0maxsim)
            end if
          else if(c0idx.eq.'DY')then
            if(i0maxsim-i0maxobs.ge.0)then
              i0sumdelay=i0sumdelay
     $             +min(i0maxsim-i0maxobs,
     $                  igetday(i0year,0)-i0maxsim+i0maxobs)
            else
              i0sumdelay=i0sumdelay
     $             +min(i0maxobs-i0maxsim,
     $                  igetday(i0year,0)-i0maxobs+i0maxsim)
            end if
          end if
          i0cntdelay=i0cntdelay+1
        end if

      end do
c
      if(i0cnt.ne.0)then
        r0aveerr=r0sumerr/real(i0cnt)
      else
        r0aveerr=p0mis
      end if
      if(i0cnt.ne.0)then
        r0aveerr2=r0sumerr2/real(i0cnt)
      else
        r0aveerr2=p0mis
      end if
      if(i0cnt.ne.0)then
        r0avesim=r0sumsim/real(i0cnt)
      else
        r0avesim=p0mis
      end if
      if(i0cnt.ne.0)then
        r0aveobs=r0sumobs/real(i0cnt)
      else
        r0aveobs=p0mis
      end if
      if(r0aveerr.ne.p0mis.and.r0aveobs.ne.p0mis)then
        r0bias=r0aveerr/r0aveobs
      else
        r0bias=p0mis
      end if
      if(r0bias.ne.p0mis)then
        r0biasabs=abs(r0bias)
      else
        r0biasabs=p0mis
      end if
      if(i0cntdelay.ne.0)then
        r0delay=real(i0sumdelay)/real(i0cntdelay)
      else
        r0delay=p0mis
      end if      
      if(i0cnt.ne.0)then
        r0rmse=r0aveerr2**0.5
      else
        r0rmse=p0mis
      end if      
      if(i0cnt.ne.0)then
        r0nrmse=r0aveerr2**0.5/(r0sumobs/real(i0cnt))
      else
        r0nrmse=p0mis
      end if      
c
d     write(*,*) 'htmettxt: average sim:       ',r0avesim
d     write(*,*) 'htmettxt: average obs:       ',r0aveobs
d     write(*,*) 'htmettxt: bias:              ',r0bias
d     write(*,*) 'htmettxt: bias absolute:     ',r0biasabs
d     write(*,*) 'htmettxt: delay:             ',r0delay
d     write(*,*) 'htmettxt: rmse:              ',r0rmse
d     write(*,*) 'htmettxt: normalized rmse:   ',r0nrmse
c
      do i0year=i0yearminout,i0yearmaxout
        if(c0idx.eq.'YR')then
          i0monmin=0
          i0monmax=0
        else
          i0monmin=1
          i0monmax=12
        end if
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'DY')then
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
          else
            i0daymin=0
            i0daymax=0
          end if
          do i0day=i0daymin,i0daymax
            if(r3sim(i0year-n0yearmin+1,i0mon,i0day).ne.p0mis.and.
     $         r3obs(i0year-n0yearmin+1,i0mon,i0day).ne.p0mis)then
              r0cov=r0cov
     $             +(r3sim(i0year-n0yearmin+1,i0mon,i0day)-r0avesim)
     $             *(r3obs(i0year-n0yearmin+1,i0mon,i0day)-r0aveobs)
              r0varsim=r0varsim
     $             +(r3sim(i0year-n0yearmin+1,i0mon,i0day)-r0avesim)
     $             *(r3sim(i0year-n0yearmin+1,i0mon,i0day)-r0avesim)
              r0varobs=r0varobs
     $             +(r3obs(i0year-n0yearmin+1,i0mon,i0day)-r0aveobs)
     $             *(r3obs(i0year-n0yearmin+1,i0mon,i0day)-r0aveobs)
            end if
          end do
        end do
      end do
c
      if(r0varsim.ne.0.0.and.r0varobs.ne.0.0)then
        r0cc=r0cov/sqrt(r0varsim)/sqrt(r0varobs)
      else
        r0cc=p0mis
      end if
      if(r0varobs.ne.0.0)then
        r0nse=1.0-r0sumerr2/r0varobs
      else
        r0nse=p0mis
      end if
d     write(*,*) 'htmettxt: correlation coeff :',r0cc
d     write(*,*) 'htmettxt: NSE               :',r0nse
d     write(*,*) 'htmettxt: counter           :',i0cnt
d     write(*,*) 'htmettxt: counter for delay :',i0cntdelay
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if  (c0opt.eq.'bias')then
        r0tmp=r0bias
        i0tmp=i0cnt
      else if(c0opt.eq.'biasabs')then
        r0tmp=r0biasabs
        i0tmp=i0cnt
      else if(c0opt.eq.'cc')then
        r0tmp=r0cc
        i0tmp=i0cnt
      else if(c0opt.eq.'delay')then
        r0tmp=r0delay
        i0tmp=i0cntdelay
      else if(c0opt.eq.'rmse')then
        r0tmp=r0rmse
        i0tmp=i0cnt
      else if(c0opt.eq.'nrmse')then
        r0tmp=r0nrmse
        i0tmp=i0cnt
      else if(c0opt.eq.'nse')then
        r0tmp=r0nse
        i0tmp=i0cnt
      else
        write(*,*) 'c0opt: ',c0opt,' not supported.'
        stop
      end if
      write(*,'(es16.8,1x,i8)') r0tmp,i0tmp

c
      end
