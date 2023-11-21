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
      subroutine calc_uscale(
     $     i0x1max,i0y1max,i0x2max,i0y2max,r2vhr,r2out,c0opt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index
      integer           i0x
      integer           i0y
      integer           i0x1     !! i0x for output array
      integer           i0x1max  !! i0x for output array
      integer           i0x2     !! i0x for integrating array
      integer           i0x2max  !! i0x for integrating array
      integer           i0y1     !! i0x for output array
      integer           i0y1max  !! i0x for output array
      integer           i0y2     !! i0x for integrating array
      integer           i0y2max  !! i0x for integrating array
      integer           i0rec
      integer           i0recmax
c in
      real              r2vhr(i0x1max*i0x2max,i0y1max*i0y2max)
      character*128     c0opt    !! avg for average, frq for frequency
c out
      real              r2out(i0x1max,i0y1max)
c local
      integer           i0flg
      integer           i1org2rnk(i0x2max*i0y2max)
      integer           i1rnk2org(i0x2max*i0y2max)
      real              r1dat(i0x2max*i0y2max)
      real              r1his(i0x2max*i0y2max)
      real              r0sum
      integer           i0cnt
c temporary
      real              r0dat
      real              r1tmp(i0x2max*i0y2max)
      integer           i0dbg
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0opt.eq.'frq')then
        do i0y1=1,i0y1max
          do i0x1=1,i0x1max

            r1dat=0.0
            r1his=0.0
            i0recmax=0

            do i0y2=1,i0y2max
              do i0x2=1,i0x2max
                i0x=(i0x1-1)*i0x2max+i0x2
                i0y=(i0y1-1)*i0y2max+i0y2
                r0dat=r2vhr(i0x,i0y)

                if(i0recmax.ne.0)then
                  i0flg=0
                  do i0rec=1,i0recmax
                    if(r1dat(i0rec).eq.r0dat)then
                      r1his(i0rec)=r1his(i0rec)+1
                      i0flg=1
                    end if
                  end do
                end if
                if(i0flg.eq.0.or.i0recmax.eq.0)then
                  r1dat(i0recmax+1)=r2vhr(i0x,i0y)
                  r1his(i0recmax+1)=1.0
                  i0recmax=i0recmax+1
                end if
              end do
            end do
            call sort_decord(
     $           i0x2max*i0y2max,r1his,r1tmp,i1org2rnk,i1rnk2org)
            r2out(i0x1,i0y1)=r1dat(i1rnk2org(1))

          end do
        end do
      end if
c
      if(c0opt.eq.'avg'.or.c0opt.eq.'sum')then
        do i0y1=1,i0y1max
          do i0x1=1,i0x1max

            r0sum=0.0
            i0cnt=0

            do i0y2=1,i0y2max
              do i0x2=1,i0x2max
                i0x=(i0x1-1)*i0x2max+i0x2
                i0y=(i0y1-1)*i0y2max+i0y2
                r0dat=r2vhr(i0x,i0y)

                if(r0dat.ne.p0mis)then
                  r0sum=r0sum+r0dat
                  i0cnt=i0cnt+1
                end if

              end do
            end do

            if(c0opt.eq.'avg')then
              if(i0cnt.gt.0)then
                r2out(i0x1,i0y1)=r0sum/real(i0cnt)
              else
                r2out(i0x1,i0y1)=p0mis
              end if
            else
              if(i0cnt.gt.0)then
                r2out(i0x1,i0y1)=r0sum
              else
                r2out(i0x1,i0y1)=p0mis
              end if
            end if

          end do
        end do
      end if
c
      end
