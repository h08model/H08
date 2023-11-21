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
      subroutine calc_resope(
     $     i0secint, i0damid_,
     $     i0flgkrls,r0knorm, 
     $     c0optkrls,c0optdamrls,c0optdamwbc,
     $     r0anudis, r0damcap,r0damsrf,
     $     r0daminf, r0damdem,r0damdemfix,
     $     r0damrls,
     $     r0krls,   r0damsto)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate reservoir operation
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c
c     c0optdamrls='nokrls':constant release (=mean annual discharge)
c     c0optdamrls='nodem': no water demand
c     c0optdamrls='H06':   Hanasaki et al. 2006
c     c0optdamrls='M98':   Meigh et al. 1998, Doell et al. 2003
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (physical)
      integer           n0secday
      parameter        (n0secday=86400)
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20)
c index(time)
      integer           i0secint
c function
      integer           igetday
c in (set)
      integer           i0damid_      !! dam id
      integer           i0flgkrls     !! flag for krls
      real              r0knorm       !! normal year coefficient [kg/s]
      character*128     c0optkrls     !! option for krls
      character*128     c0optdamrls   !! option for dam release
      character*128     c0optdamwbc   !! option for water balance calculation
c in (map)
      real              r0anudis       !! mean annual discharge [kg/s]
      real              r0damcap       !! sotrage capacity [kg]
      real              r0damsrf       !! dam surface area [m2]      
c in (flux)
      real              r0daminf       !! inflow  [kg/s]
      real              r0damdem       !! dam demand
      real              r0damdemfix    !! dam demand (annual mean)
c out
      real              r0damrls       !! release [kg/s]
c statevariables
      real              r0krls         !! release coefficient [-]
      real              r0damsto       !! storage [kg]
c local
      real              r0coverd       !! Capacity over Discharge
      real              r0actsto       !! active storage of Meigh et al. 1998
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r0coverd=0.0
      r0actsto=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c   Module 1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optkrls.eq.'yes') then
        if(i0flgkrls.eq.1)then
          r0krls=r0damsto/(r0knorm*r0damcap)
          write(*,*) 'calc_resope: r0krls:  ',r0krls
          write(*,*) 'calc_resope: r0damsto:',r0damsto
          write(*,*) 'calc_resope: r0knorm: ',r0knorm
          write(*,*) 'calc_resope: r0damcap:',r0damcap
          i0flgkrls=0
        end if
      else
        r0krls=1.0
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c   Module 2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optdamrls.eq.'nokrls') then
        r0damrls=max(r0anudis,0.0)
      else if(c0optdamrls.eq.'nodem') then
        r0daminf=r0daminf
        if(r0anudis.ne.0.0)then
          r0coverd=r0damcap/(r0anudis*365*n0secday)
        else
          r0coverd=1.0
        end if
        if(r0coverd.lt.0.5)then
          r0damrls=(r0coverd/0.5)**2*r0krls*r0anudis
     $         +(1-(r0coverd/0.5)**2)*r0daminf
        else
          r0damrls=r0krls*r0anudis
        end if
      else if(c0optdamrls.eq.'H06simple') then
        r0daminf=r0daminf
        r0damdem=r0damdem
d       write(*,*) 'calc_resope: r0damdem:   ',r0damdem
        r0damrls=max(r0damdem,0.5*r0anudis)
        r0damrls=min(r0damrls,2.0*r0anudis)
d       write(*,*) 'calc_resope: r0damrls:   ',r0damrls
        if(r0anudis.ne.0.0)then
          r0coverd=r0damcap/(r0anudis*365*n0secday)
        else
          r0coverd=1.0
        end if
d       write(*,*) 'calc_resope: r0coverd: ',r0coverd
        if(r0coverd.lt.0.5)then
          r0damrls=(r0coverd/0.5)**2*r0krls*r0damrls
     $         +(1-(r0coverd/0.5)**2)*r0daminf
        else
          r0damrls=r0krls*r0damrls
        end if
      else if(c0optdamrls.eq.'H06') then
        r0daminf=r0daminf
        r0damdem=r0damdem
d       write(*,*) 'calc_resope: before:   ',r0damdem
        if(r0anudis.ne.0.0)then
            if(r0damdemfix.lt.r0anudis*0.5)then
              r0damrls=r0anudis+r0damdem-r0damdemfix
            else
              r0damrls=r0anudis*0.5+r0anudis*0.5*r0damdem/r0damdemfix
            end if
        else
          write(*,*) 'calc_resope: error:'
          write(*,*) 'calc_resope: r0anudis: ',r0anudis
          write(*,*) 'calc_resope: i0damid_: ',i0damid_
          stop          
        end if
d       write(*,*) 'calc_resope: after:    ',r0damrls
        if(r0anudis.ne.0.0)then
          r0coverd=r0damcap/(r0anudis*365*n0secday)
        else
          r0coverd=1.0
        end if
d       write(*,*) 'calc_resope: r0coverd: ',r0coverd
        if(r0coverd.lt.0.5)then
          r0damrls=(r0coverd/0.5)**2*r0krls*r0damrls
     $         +(1-(r0coverd/0.5)**2)*r0daminf
        else
          r0damrls=r0krls*r0damrls
        end if
      else if(c0optdamrls.eq.'M98') then
        if(r0damsrf.gt.0)then
          r0actsto=r0damsto-(r0damcap-r0damsrf*5.0*1000)
          if(r0actsto.gt.0.0.and.r0damsrf.gt.0.0)then
            r0damrls=0.01
     $           *r0actsto/real(n0secday)
     $           *(r0actsto/(r0damsrf*5.0*1000))**1.5
          else
            r0damrls=0.0
          end if
          write(*,*) 'calc_resope: r0actsto:         ',r0actsto
          write(*,*) 'calc_resope: r0actcap:         ',r0damsrf*5*1000
          write(*,*) 'calc_resope: r0damrls(before): ',r0damrls
          write(*,*) 'calc_resope: r0damsto(before): ',r0damsto
        else
          r0damrls=p0mis
        end if
      else
        write(*,*) 'calc_resope: c0optdamrls',c0optdamrls,
     $       'not supported. Abort.'
        stop
      end if      
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Module 3
c - storage
c - when storage exceed reservoir capacity
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optdamwbc.eq.'yes')then
        if(r0damrls.ne.p0mis)then
c
          r0damsto=r0damsto+(r0daminf-r0damrls)*i0secint
c
          if(r0damsto.gt.r0damcap)then
            r0damrls=r0damrls+(r0damsto-r0damcap)/i0secint
            r0damsto=r0damcap
          else if(r0damsto.lt.0.0)then
            r0damrls=r0damrls+r0damsto/i0secint
            r0damsto=0.0
          end if
          write(*,*) 'calc_resope: r0damrls(after): ',r0damrls
          write(*,*) 'calc_resope: r0damsto(after): ',r0damsto
        else
          r0damsto=p0mis
        end if
      end if
c
      end

