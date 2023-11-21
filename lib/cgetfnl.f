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
      character*128 function cgetfnl(
     $     c0in,i0id)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   get file name (local) 
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c function
      integer           len_trim
c in
      character*128     c0in
      integer           i0id
c local
      character*128     c0dir
      character*128     c0prj
      character*128     c0run
      character*128     c0suf
      character*128     c0len
      character*128     c0idx
      character*128     c0out
      integer           i0len
      integer           i0in
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize local variables
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      c0dir=''
      c0prj=''
      c0run=''
      c0suf=''
      c0len=''
      c0idx=''
      c0out=''
      i0len=0
      i0in=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Basic info
c - get total number of charcter of c0in
c - get Index (final two character) of c0in
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0in=len_trim(c0in)
c
      c0idx=c0in(i0in-1:i0in)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c File name
c - FX: fixed
c - ID: id
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.eq.'FX')then
        c0out=c0in(1:i0in-2)        
        i0len=len_trim(c0out)
        write(c0len,*) i0len
        write(cgetfnl,'(a'//c0len//')') c0out
      else if(c0idx.eq.'ID')then
        c0suf=c0in(i0in-5:i0in-2)
        c0run=c0in(i0in-9:i0in-6)
        c0prj=c0in(i0in-13:i0in-10)
        c0dir=c0in(1:i0in-14)
        i0len=len_trim(c0dir)
        write(c0len,*) i0len
        write(cgetfnl,'(a'//c0len//',a4,a4,i8.8,a4)')
     $       c0dir,c0prj,c0run,i0id,c0suf
      else
        write(*,*) 'cgetfnl: Error'
        write(*,*) 'cgetfnl: c0idx: ',c0idx
        write(*,*) 'cgetfnl: c0in:  ',c0in
        write(*,*) 'cgetfnl: c0idx unrecognized. Abort.'
        stop
      end if
c
      end
