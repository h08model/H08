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
c The explicit code was developed and provided by Naho Yoden.
c We thank her for her kindness.
c For more details, please see the following paper.
c Yoden, N., Yamazaki, D., and Hanasaki, N.: Improving river routing algorithms to efficiently implement canal water diversion schemes in global hydrological models, Hydrological Research Letters, 18, 7-13, 10.3178/hrl.18.7, 2024.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine calc_humact_ftcs(
     $     n0l,         i0ldbg,
     $     i0secint,    
     $     r1nxtgrd,    r1lndara,    r1paramc,
     $     r1rivstopre, r1qtot,
     $     r1rivsto,    r1rivinf,    r1rivout,
     $     r1damsto,    r1daminf,    r1damout,
     $     r1demagrs,   r1deminds,   r1demdoms,
     $     r1demagrg,   r1demindg,   r1demdomg,
     $     r1supagrs,   r1supinds,   r1supdoms,
     $     r1supagrg,   r1supindg,   r1supdomg,
     $     r1supagrriv, r1supindriv, r1supdomriv,
     $     r1supagrcan, r1supindcan, r1supdomcan,
     $     r1supagrrgw, r1supindrgw, r1supdomrgw,
     $     r1supagrpnd, r1supindpnd, r1supdompnd,
     $     r1supagrnnbsw, r1supindnnbsw, r1supdomnnbsw,
     $     r1supagrnnbgw, r1supindnnbgw, r1supdomnnbgw,
     $     r1supagrdes, r1supinddes, r1supdomdes,
     $     r1supagrrcl, r1supindrcl, r1supdomrcl,
     $     r1supagrdef, r1supinddef, r1supdomdef,
     $     r1frcgwagr,  r1frcgwind,  r1frcgwdom,
     $     c0optnnbs,   c0optnnbg,   c0optriv,
     $     c0optrgw,    c0optdes,    c0optrcl,
     $     i2lcan,      n0rec,       i1despot,    i1rclpot,
     $     r1envflw,    
     $     i1damid_,    r1damcap,    r1pndcap,
     $     r1pndsto,    r1pndinf,    r1pndout,
     $     r1pndafc,    r1rgw)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate river flows taking into account human activities
cby   2010/09/30, hanasaki, NIES, modified on 2014/05/09
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
      integer           n0rec
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
      integer           i0rec
      integer           i0lcan           !! river --> canal diversion point
c in (set)
      integer           i0ldbg
c in (fixed field)
      integer           i0secint         !! interval [s]
      real              r1nxtgrd(n0l)    !! downstream grid [-]
      real              r1lndara(n0l)    !! land area [m2]
      real              r1paramc(n0l)    !! parameter c
      real              r1damcap(n0l)
      real              r1pndcap(n0l)
      real              r1pndafc(n0l)    !! areal fraction of MSR
      integer           i1damid_(n0l)
      integer           i2lcan(n0l,n0rec)
      integer           i1despot(n0l)
      integer           i1rclpot(n0l)
c in
      real              r1rivstopre(n0l) !! storage of current time step
c in/out
      real              r1damsto(n0l)    !! dam storage of the grid [kg]
      real              r1pndsto(n0l)    !! medium sized reservoir storage
      real              r1rgw(n0l)       !! groundwater storage [kg m-2]
c in (flux)
      real              r1qtot(n0l)      !! runoff of the grid [kg/s]
      real              r1damout(n0l)    !! medium sized reservoir outflow
      real              r1demind(n0l)    !! demand (industrial water)
      real              r1demdom(n0l)    !! demand (domestic water)
      real              r1envflw(n0l)    !! environmental flow requirement
c in (set)
      character*128     c0optnnbs        !! 
      character*128     c0optnnbg        !! 
      character*128     c0optriv         !! option of river
      character*128     c0optrgw         !! option of groundwater
      character*128     c0optdes         !! option of desalinated water
      character*128     c0optrcl         !! option of rclycled water
c out (flux)
      real              r1rivinf(n0l)    !! river inflow of the grid  [kg/s]
      real              r1rivsto(n0l)    !! river storage of the grid [kg]
      real              r1rivout(n0l)    !! river outflow of the grid [kg/s]
      real              r1pndinf(n0l)    !! medium sized reservoir inflow
      real              r1pndout(n0l)    !! medium sized reservoir outflow
      real              r1daminf(n0l)    !! medium sized reservoir inflow
      real              r1supind(n0l)    !! supply (industrial water)
      real              r1supdom(n0l)    !! supply (domestic water)
      real              r1supagrriv(n0l) !! supply from river
      real              r1supindriv(n0l) !! supply from river
      real              r1supdomriv(n0l) !! supply from river
      real              r1supagrcan(n0l) !! supply from canal (distant source)
      real              r1supindcan(n0l) !! supply from canal (distant source)
      real              r1supdomcan(n0l) !! supply from canal (distant source)
      real              r1supagrrgw(n0l) !! supply from groundwater
      real              r1supindrgw(n0l) !! supply from groundwater
      real              r1supdomrgw(n0l) !! supply from groundwater
      real              r1supagrpnd(n0l) !! supply from medium sized reservoir
      real              r1supindpnd(n0l) !! supply from medium sized reservoir
      real              r1supdompnd(n0l) !! supply from medium sized reservoir
      real              r1supagrnnbgw(n0l) !! supply from non-non blue water
      real              r1supindnnbgw(n0l) !! supply from non-non blue water
      real              r1supdomnnbgw(n0l) !! supply from non-non blue water
      real              r1supagrnnbsw(n0l) !! supply from non-non blue water
      real              r1supindnnbsw(n0l) !! supply from non-non blue water
      real              r1supdomnnbsw(n0l) !! supply from non-non blue water
      real              r1supagrdes(n0l)  !! supply from desalinated water
      real              r1supinddes(n0l)  !! supply from desalinated water
      real              r1supdomdes(n0l)  !! supply from desalinated water
      real              r1supagrrcl(n0l)  !! supply from recycled water
      real              r1supindrcl(n0l)  !! supply from recycled water
      real              r1supdomrcl(n0l)  !! supply from recycled water
      real              r1supagrdef(n0l)  !! supply impossible (deficit)
      real              r1supinddef(n0l)  !! supply impossible (deficit)
      real              r1supdomdef(n0l)  !! supply impossible (deficit)
      real              r1frcgwagr(n0l)   !! fraction of gw
      real              r1frcgwind(n0l)   !! fraction of gw
      real              r1frcgwdom(n0l)   !! fraction of gw
c local
      real              r1qtotmod(n0l)  !! 
      real              r1supagrg(n0l)  !! agr supply assigned to gw
      real              r1supindg(n0l)  !! ind supply assigned to gw
      real              r1supdomg(n0l)  !! dom supply assigned to gw
      real              r1supagrs(n0l)  !! agr supply assigned to sw
      real              r1supinds(n0l)  !! ind supply assigned to sw
      real              r1supdoms(n0l)  !! dom supply assigned to sw
      real              r1demagrg(n0l)  !! agr demand assigned to gw
      real              r1demindg(n0l)  !! ind demand assigned to gw
      real              r1demdomg(n0l)  !! dom demand assigned to gw
      real              r1demagrs(n0l)  !! agr demand assigned to sw
      real              r1deminds(n0l)  !! ind demand assigned to sw
      real              r1demdoms(n0l)  !! dom demand assigned to sw
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c out
      r1rivout=0.0
      r1pndinf=0.0
      r1pndout=0.0
      r1daminf=0.0
      r1supind=0.0
      r1supdom=0.0
      r1supagrriv=0.0
      r1supindriv=0.0
      r1supdomriv=0.0
      r1supagrcan=0.0
      r1supindcan=0.0
      r1supdomcan=0.0
      r1supagrrgw=0.0
      r1supindrgw=0.0
      r1supdomrgw=0.0
      r1supagrpnd=0.0
      r1supindpnd=0.0
      r1supdompnd=0.0
      r1supagrnnbgw=0.0
      r1supindnnbgw=0.0
      r1supdomnnbgw=0.0
      r1supagrnnbsw=0.0
      r1supindnnbsw=0.0
      r1supdomnnbsw=0.0
      r1supagrdes=0.0
      r1supinddes=0.0
      r1supdomdes=0.0
      r1supagrrcl=0.0
      r1supindrcl=0.0
      r1supdomrcl=0.0
      r1supagrdef=0.0
      r1supinddef=0.0
      r1supdomdef=0.0
c local
      r1qtotmod=0.0
      r1supagrg=0.0
      r1supindg=0.0
      r1supdomg=0.0
      r1supagrs=0.0
      r1supinds=0.0
      r1supdoms=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
c - optional supply from desalinated water
c - loop starts (from upper stream to lower stream)
c - medium sized reservoir (Hanasaki et al. 2010)
c - inflow of each grid
c - storage (See Eq.4 in Oki et al. 1999)
c - outflow (See Eq.2 in Oki et al. 1999)
c - reservoir operation
c - flowing into the lower stream
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c supply from desalinated water (conservative)
      if(c0optdes.eq.'H16')then
        call calc_supdes(n0l,r1demdoms,r1supdoms,i1despot,
     $       r1supdomdes)
        call calc_supdes(n0l,r1deminds,r1supinds,i1despot,
     $       r1supinddes)
      else if (c0optdes.eq.'Conservative')then
        continue
      else
        write(*,*) 'calc_humact: desalination option',c0optdes,
     $             ' not supported.'
        stop
      end if
c river process
      do i0l=1,n0l
c river process - runoff
            if(r1qtot(i0l).gt.0.0)then
              r1pndinf(i0l)=r1qtot(i0l)*r1lndara(i0l)*r1pndafc(i0l)
              r1pndsto(i0l)=r1pndsto(i0l)+r1pndinf(i0l)*real(i0secint)
              if(r1pndsto(i0l).gt.r1pndcap(i0l))then
                r1qtotmod(i0l)
     $               =( r1qtot(i0l)*r1lndara(i0l)*(1.0-r1pndafc(i0l))
     $                 +(r1pndsto(i0l)-r1pndcap(i0l))/real(i0secint))
     $                / r1lndara(i0l)
                r1pndsto(i0l)=r1pndcap(i0l)
              else
                r1qtotmod(i0l)
     $               =( r1qtot(i0l)*r1lndara(i0l)*(1.0-r1pndafc(i0l)))
     $                / r1lndara(i0l)
              end if
            else
              r1qtotmod(i0l)=r1qtot(i0l)
            end if
d           if(i0l.eq.i0ldbg)then
d             write(*,*) 'calc_humact: r1qtot   [mm/d]',
d    $             r1qtot(i0ldbg)*real(i0secint)
d             write(*,*) 'calc_humact: r1qtotmod[mm/d]',
d    $             r1qtotmod(i0ldbg)*real(i0secint)
d           end if
c river process - inflow
            if(r1lndara(i0l).ne.p0mis)then
              r1rivinf(i0l)=r1rivinf(i0l)+r1qtotmod(i0l)*r1lndara(i0l)
            end if
d           if(i0l.eq.i0ldbg)then
d             write(*,*) 'calc_humact: r1rivinf [m3/s]',
d    $             r1rivinf(i0ldbg)/1000.0
d           end if
c river process - rivout ftcs
            if (r1paramc(i0l).ne.p0mis) then
              r1rivout(i0l)
     $             = r1rivstopre(i0l)*r1paramc(i0l)
              r1rivout(i0l)
     $        = min(r1rivstopre(i0l)/real(i0secint),r1rivout(i0l))	!! avoid negative storage when param c is over 1 or river mouth
              r1rivstopre(i0l)
     $             =r1rivstopre(i0l)
     $             -r1rivout(i0l)*real(i0secint)
            end if
d           if(i0l.eq.i0ldbg)then
d             write(*,*) 'calc_humact: r1rivout before withdrw[m3/s]',
d    $             r1rivout(i0ldbg)/1000.0
d           end if
c river process - dam    
            if(i1damid_(i0l).ne.0)then
              r1daminf(i0l)=r1rivout(i0l)
              r1damsto(i0l)=r1damsto(i0l)
     $             +(r1daminf(i0l)-r1damout(i0l))*real(i0secint)
              if(r1damsto(i0l).gt.r1damcap(i0l))then
                r1damout(i0l)=r1damout(i0l)
     $               +(r1damsto(i0l)-r1damcap(i0l))/real(i0secint)
                r1damsto(i0l)=r1damcap(i0l)
              else if(r1damsto(i0l).lt.0.0)then
                r1damout(i0l)=r1damout(i0l)
     $               +r1damsto(i0l)/real(i0secint)
                r1damsto(i0l)=0.0
              end if
              r1rivout(i0l)=r1damout(i0l)
d             if(i0l.eq.i0ldbg)then
d               write(*,*) 'calc_humact: r1damout',r1damout(i0ldbg)
d               write(*,*) 'calc_humact: r1damsto',r1damsto(i0ldbg)
d             end if
            end if
c supply from river
d           if(i0l.eq.i0ldbg)then
d             write(*,*) 'calc_humact r1supagrrgw',r1supagrriv(i0ldbg)
d             write(*,*) 'calc_humact r1demagrs  ',r1demagrs(i0ldbg)
d             write(*,*) 'calc_humact r1supagrs  ',r1supagrs(i0ldbg)
d             write(*,*) 'calc_humact r1rivout   ',r1rivout(i0ldbg)
d             write(*,*) 'calc_humact r1envflw   ',r1envflw(i0ldbg)
d           end if
c
            if(c0optriv.eq.'yes')then
              call calc_supriv(r1demdoms(i0l),r1supdoms(i0l),
     $                         r1rivout(i0l),r1envflw(i0l),
     $                         r1supdomriv(i0l))
              call calc_supriv(r1deminds(i0l),r1supinds(i0l),
     $                         r1rivout(i0l),r1envflw(i0l),
     $                         r1supindriv(i0l))
              call calc_supriv(r1demagrs(i0l),r1supagrs(i0l),
     $                         r1rivout(i0l),r1envflw(i0l),
     $                         r1supagrriv(i0l))
            end if
c
d           if(i0l.eq.i0ldbg)then
d             write(*,*) 'calc_humact r1supagrrgw',r1supagrriv(i0ldbg)
d             write(*,*) 'calc_humact r1demagrs  ',r1demagrs(i0ldbg)
d             write(*,*) 'calc_humact r1supagrs  ',r1supagrs(i0ldbg)
d             write(*,*) 'calc_humact r1rivout   ',r1rivout(i0ldbg)
d             write(*,*) 'calc_humact r1envflw   ',r1envflw(i0ldbg)
d           end if
      end do
c supply from canal
      do i0l=1,n0l
            if(i2lcan(i0l,1).ne.0)then
              do i0rec=1,n0rec
                i0lcan=i2lcan(i0l,i0rec)
                if(i0lcan.ne.0)then
                  call calc_supcan(i0lcan,r1demdoms(i0lcan),
     $                           r1supdoms(i0lcan),
     $                           r1rivout(i0l),r1envflw(i0l),
     $                           r1supdomcan(i0lcan))
                  call calc_supcan(i0lcan,r1deminds(i0lcan),
     $                           r1supinds(i0lcan),
     $                           r1rivout(i0l),r1envflw(i0l),
     $                           r1supindcan(i0lcan))
                  call calc_supcan(i0lcan,r1demagrs(i0lcan),
     $                           r1supagrs(i0lcan),
     $                           r1rivout(i0l),r1envflw(i0l),
     $                           r1supagrcan(i0lcan))
                end if
              end do
            end if
d           if(i0l.eq.i0ldbg)then
d             write(*,*) 'calc_humact: r1rivout after withdrw[m3/s]',
d    $             r1rivout(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1demagrs [m3/s]',
d    $             r1demagrs(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1deminds [m3/s]',
d    $             r1deminds(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1demdoms [m3/s]',
d    $             r1demdoms(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supagrs [m3/s]',
d    $             r1supagrs(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supinds [m3/s]',
d    $             r1supinds(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supdoms [m3/s]',
d    $             r1supdoms(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supagrriv [m3/s]',
d    $             r1supagrriv(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supindriv [m3/s]',
d    $             r1supindriv(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supdomriv [m3/s]',
d    $             r1supdomriv(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supagrcan [m3/s]',
d    $             r1supagrcan(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supindcan [m3/s]',
d    $             r1supindcan(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supdomcan [m3/s]',
d    $             r1supdomcan(i0ldbg)/1000.0
d           end if
c 
            if (r1paramc(i0l).ne.p0mis) then
              if (r1nxtgrd(i0l).ne.p0mis.and.r1nxtgrd(i0l).ne.0.0
     $         .and.r1nxtgrd(i0l).ne.i0l)then	!! flowing into the lower stream except termination or sea
                r1rivinf(int(r1nxtgrd(i0l)))
     $               =r1rivinf(int(r1nxtgrd(i0l)))
     $               +r1rivout(i0l)
              end if
            end if
d           if(i0l.eq.i0ldbg)then
d             write(*,*) 'calc_humact: r1rivout after withdrw[m3/s]',
d    $             r1rivout(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1demagrs [m3/s]',
d    $             r1demagrs(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1deminds [m3/s]',
d    $             r1deminds(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1demdoms [m3/s]',
d    $             r1demdoms(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supagrs [m3/s]',
d    $             r1supagrs(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supinds [m3/s]',
d    $             r1supinds(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supdoms [m3/s]',
d    $             r1supdoms(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supagrriv [m3/s]',
d    $             r1supagrriv(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supindriv [m3/s]',
d    $             r1supindriv(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supdomriv [m3/s]',
d    $             r1supdomriv(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supagrcan [m3/s]',
d    $             r1supagrcan(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supindcan [m3/s]',
d    $             r1supindcan(i0ldbg)/1000.0
d             write(*,*) 'calc_humact: r1supdomcan [m3/s]',
d    $             r1supdomcan(i0ldbg)/1000.0
d           end if
        end do
c river process - inflow, storage ftcs
      do i0l=1,n0l
        if (r1paramc(i0l).ne.p0mis) then	!! not calculate at the river network termination
          if(i0l.eq.i0ldbg)then
             write(*,*) 'calc_humact: r1rivinf[m3/s]',
     $             r1rivinf(i0ldbg)/1000.0
          end if
          r1rivsto(i0l)
     $             =r1rivstopre(i0l)
     $             +r1rivinf(i0l)*real(i0secint)	!! calculate storage at the next timestep
        end if
        if(i0l.eq.i0ldbg)then
             write(*,*) 'calc_humact: r1rivsto[m3/s]',
     $             r1rivsto(i0ldbg)/1000.0
            write(*,*) 'calc_humact: r1rivout[m3/s]',
     $             r1rivout(i0ldbg)/1000.0
        end if
      end do
c supply from groundwater
      if(c0optrgw.eq.'yes')then
        call calc_suprgw(n0l,r1demdomg,r1supdomg,r1rgw,r1lndara,
     $                  i0secint,r1supdomrgw)
        call calc_suprgw(n0l,r1demindg,r1supindg,r1rgw,r1lndara,
     $                  i0secint,r1supindrgw)
        call calc_suprgw(n0l,r1demagrg,r1supagrg,r1rgw,r1lndara,
     $                  i0secint,r1supagrrgw)
      end if
d     write(*,*) 'calc_humact r1supagrs   ',r1supagrs(i0ldbg)
d     write(*,*) 'calc_humact r1supagrrgw ',r1supagrrgw(i0ldbg)
d     write(*,*) 'calc_humact r1demagrs   ',r1demagrs(i0ldbg)
d     write(*,*) 'calc_humact r1supagrs   ',r1supagrs(i0ldbg)
c supply from medium sized reservoir
      call calc_suppnd(n0l,r1demdoms,r1supdoms,r1pndsto,i0secint,
     $     r1supdompnd)
      call calc_suppnd(n0l,r1deminds,r1supinds,r1pndsto,i0secint,
     $     r1supindpnd)
      call calc_suppnd(n0l,r1demagrs,r1supagrs,r1pndsto,i0secint,
     $     r1supagrpnd)
d     write(*,*) 'calc_humact r1supagrpnd  ',r1supagrpnd(i0ldbg)
d     write(*,*) 'calc_humact r1demagrs  ',r1demagrs(i0ldbg)
d     write(*,*) 'calc_humact r1supagrs  ',r1supagrs(i0ldbg)
c supply from desalinated water (conservative)
      if(c0optdes.eq.'Conservative')then
        call calc_supdes(n0l,r1demdoms,r1supdoms,i1despot,
     $       r1supdomdes)
        call calc_supdes(n0l,r1deminds,r1supinds,i1despot,
     $       r1supinddes)
      end if
c supply from recycled water
      if(c0optrcl.eq.'yes')then
        call calc_suprcl(n0l,r1demdoms,r1supdoms,i1rclpot,
     $       r1supdomrcl)
        call calc_suprcl(n0l,r1deminds,r1supinds,i1rclpot,
     $       r1supindrcl)
      end if
c supply from NNBW (Surface Water)
      if(c0optnnbs.eq.'yes')then
        call calc_supnnb(n0l,r1demdoms,r1supdoms,r1supdomnnbsw)
        call calc_supnnb(n0l,r1deminds,r1supinds,r1supindnnbsw)
        call calc_supnnb(n0l,r1demagrs,r1supagrs,r1supagrnnbsw)
      end if
d     write(*,*) 'calc_humact r1supagrnnbsw',r1supagrnnbsw(i0ldbg)
d     write(*,*) 'calc_humact r1demagrs  ',r1demagrs(i0ldbg)
d     write(*,*) 'calc_humact r1supagrs  ',r1supagrs(i0ldbg)
c supply from NNBW (Groundwater)
      if(c0optnnbg.eq.'yes')then
        call calc_supnnb(n0l,r1demdomg,r1supdomg,r1supdomnnbgw)
        call calc_supnnb(n0l,r1demindg,r1supindg,r1supindnnbgw)
        call calc_supnnb(n0l,r1demagrg,r1supagrg,r1supagrnnbgw)
      end if
d     write(*,*) 'calc_humact r1supagrnnbgw',r1supagrnnbgw(i0ldbg)
d     write(*,*) 'calc_humact r1demagrg  ',r1demagrg(i0ldbg)
d     write(*,*) 'calc_humact r1supagrg  ',r1supagrg(i0ldbg)
c deficit
      call calc_supdef(n0l,r1demdoms,r1demdomg,
     $                     r1supdoms,r1supdomg,r1supdomdef)
      call calc_supdef(n0l,r1deminds,r1demindg,
     $                     r1supinds,r1supindg,r1supinddef)
      call calc_supdef(n0l,r1demagrs,r1demagrg,
     $                     r1supagrs,r1supagrg,r1supagrdef)
c
      end
c
      subroutine calc_supdef(n0l,r1dems,r1demg,r1sups,r1supg,r1supdef)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c input
      integer           n0l
      real              r1dems(n0l)
      real              r1demg(n0l)
      real              r1sups(n0l)
      real              r1supg(n0l)
c output
      real              r1supdef(n0l)
c local
      integer           i0l
c
      do i0l=1,n0l
        if(r1dems(i0l).ne.p0mis)then
          r1supdef(i0l)=r1dems(i0l)+r1demg(i0l)-r1sups(i0l)-r1supg(i0l)
        end if
      end do
c
      end
c
      subroutine calc_supnnb(n0l,r1dem,r1sup,r1supnnb)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c input
      integer           n0l
      real              r1dem(n0l)
      real              r1sup(n0l)
c output
      real              r1supnnb(n0l)
c local
      integer           i0l
c
      do i0l=1,n0l
        if(r1dem(i0l).ne.p0mis)then
          if(r1dem(i0l)-r1sup(i0l).gt.0.0)then
            r1supnnb(i0l)=r1dem(i0l)-r1sup(i0l)
            r1sup(i0l)=r1sup(i0l)+r1supnnb(i0l)
          else
            r1supnnb(i0l)=0.0
          end if
        end if
      end do
c
      end
c
      subroutine calc_supdes(n0l,r1dem,r1sup,i1despot,r1supdes)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c input
      integer           n0l
      real              r1dem(n0l)
      real              r1sup(n0l)
      integer           i1despot(n0l)
c output
      real              r1supdes(n0l)
c local
      integer           i0l
c
      do i0l=1,n0l
        if(r1dem(i0l).ne.p0mis)then
          if(i1despot(i0l).eq.1)then
            if(r1dem(i0l)-r1sup(i0l).gt.0.0)then
              r1supdes(i0l)=r1dem(i0l)-r1sup(i0l)
              r1sup(i0l)=r1sup(i0l)+r1supdes(i0l)
            else
              r1supdes(i0l)=0.0
            end if
          end if
        end if
      end do
c
      end
c
      subroutine calc_suprcl(n0l,r1dem,r1sup,i1rclpot,r1suprcl)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c input
      integer           n0l
      real              r1dem(n0l)
      real              r1sup(n0l)
      integer           i1rclpot(n0l)
c output
      real              r1suprcl(n0l)
c local
      integer           i0l
c
      do i0l=1,n0l
        if(r1dem(i0l).ne.p0mis)then
          if(i1rclpot(i0l).eq.1)then
            if(r1dem(i0l)-r1sup(i0l).gt.0.0)then
              r1suprcl(i0l)=r1dem(i0l)-r1sup(i0l)
              r1sup(i0l)=r1sup(i0l)+r1suprcl(i0l)
            else
              r1suprcl(i0l)=0.0
            end if
          end if
        end if
      end do
c
      end
c
      subroutine calc_suppnd(n0l,r1dem,r1sup,r1pndsto,i0secint,
     $     r1suppnd)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c input
      integer           n0l
      real              r1dem(n0l)
      real              r1sup(n0l)
      real              r1pndsto(n0l)
      integer           i0secint
c output
      real              r1suppnd(n0l)
c local
      integer           i0l
c
      do i0l=1,n0l
        if(r1dem(i0l).ne.p0mis)then
          if(r1dem(i0l)-r1sup(i0l).gt.0.0)then
            if((r1dem(i0l)-r1sup(i0l)).lt.
     $           r1pndsto(i0l)/real(i0secint))then
              r1suppnd(i0l)=r1dem(i0l)-r1sup(i0l)
            else
              r1suppnd(i0l)=r1pndsto(i0l)/real(i0secint)
            end if
            r1sup(i0l)=r1sup(i0l)+r1suppnd(i0l)
            r1pndsto(i0l)
     $           =r1pndsto(i0l)-r1suppnd(i0l)*real(i0secint)
          else
            r1suppnd(i0l)=0.0
          end if
        end if
      end do
c
      end
c
      subroutine calc_suprgw(n0l,r1dem,r1sup,r1rgw,r1lndara,i0secint,
     $     r1suprgw)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c input
      integer           n0l
      real              r1dem(n0l)
      real              r1sup(n0l)
      real              r1rgw(n0l)
      real              r1lndara(n0l)
      integer           i0secint
c output
      real              r1suprgw(n0l)
c local
      integer           i0l
c
      do i0l=1,n0l
        if(r1dem(i0l).ne.p0mis)then
          if(r1dem(i0l)-r1sup(i0l).gt.0.0.and.
     $         r1rgw(i0l).gt.0.0)then
            if((r1dem(i0l)-r1sup(i0l)).lt.
     $           r1rgw(i0l)*r1lndara(i0l)/real(i0secint))then
              r1suprgw(i0l)=r1dem(i0l)-r1sup(i0l)
            else
              r1suprgw(i0l)=r1rgw(i0l)*r1lndara(i0l)/real(i0secint)
            end if
            r1sup(i0l)=r1sup(i0l)+r1suprgw(i0l)
            r1rgw(i0l)=r1rgw(i0l)
     $           -r1suprgw(i0l)*real(i0secint)/r1lndara(i0l)
          else
            r1suprgw(i0l)=0.0
          end if
        end if
      end do
c
      end
c
      subroutine calc_supriv(r0dem,r0sup,r0rivout,r0envflw,r0supriv)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c input
      real              r0dem
      real              r0sup
      real              r0rivout
      real              r0envflw
c output
      real              r0supriv
c
      if(r0dem.ne.p0mis)then
        if(r0rivout-r0envflw.gt.r0dem)then
          r0supriv=r0dem
        else
          r0supriv=max(r0rivout-r0envflw,0.0)
        end if
        r0rivout=r0rivout-r0supriv
        r0sup=r0sup+r0supriv
      end if
c
      end
c
      subroutine calc_supcan(i0lcan,r0dem,r0sup,r0rivout,r0envflw,
     $     r0supcan)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c input
      integer           i0lcan
      real              r0dem
      real              r0sup
      real              r0rivout
      real              r0envflw
c output
      real              r0supcan
c
      if(i0lcan.ne.0)then
        if(r0dem.ne.p0mis)then
          if(r0dem-r0sup.gt.0.0)then
            if((r0dem-r0sup).lt.(r0rivout-r0envflw))then
              r0supcan=r0dem-r0sup
            else
              r0supcan=max(r0rivout-r0envflw,0.0)
            end if
            r0sup=r0sup+r0supcan
            r0rivout=r0rivout-r0supcan
          end if
        end if
      end if
c
      end
