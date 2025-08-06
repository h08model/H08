      program prog_rivnum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c
      integer              n0l
c in
      real,allocatable::   r1rivnxl(:)
      character*128        c0rivnxl
c internal
      real,allocatable::   r1rivmth(:)
      character*128        c0rivmth
      real,allocatable::   r1rivcnt(:)
      integer,allocatable::i1org2rnk(:)
      integer,allocatable::i1rnk2org(:)
c out
      real,allocatable::   r1rivnum(:)
      real,allocatable::   r1rivnumsrt(:)
      character*128        c0rivnum
c temp
      character*128        c0tmp
      real,allocatable::r1tmp(:)
c     index
      integer           i0l
      integer           i0l2
      integer           i0prl
      integer           i0nxl
      integer           i0rivnum

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c argument, allocation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.4)then
         write(*,*) 'prog_rivnum n0l c0rivnxl c0rivnum'
         stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0rivnxl)
      call getarg(3,c0rivnum)
      call getarg(4,c0rivmth)
c
      allocate(r1rivnxl(n0l))
      allocate(r1rivnum(n0l))
      allocate(r1rivnumsrt(n0l))
      allocate(r1rivmth(n0l))
      allocate(r1rivcnt(n0l))
      allocate(i1rnk2org(n0l))
      allocate(i1org2rnk(n0l))
      allocate(r1tmp(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c read input file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0rivnxl,r1rivnxl)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
c     if(r1rivnxl(i0l).ne.0.0)then
        if(r1rivnxl(i0l).gt.0.0)then
          i0prl=int(i0l)               !! present L
 10       i0nxl=int(r1rivnxl(i0prl))   !! downstream (next) L
          write(*,*) i0l,i0prl,i0nxl
          if(i0nxl.ne.0.0.and.i0nxl.ne.i0prl)then
            i0prl=i0nxl
            goto 10 
          end if
          r1rivmth(i0l)=real(i0nxl)
          write(*,*) i0l,r1rivmth(i0l)
        end if
      end do 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0rivnum=1
      do i0l=1,n0l
        if(r1rivmth(i0l).ne.0.0.and.r1rivnum(i0l).eq.0.0)then
           r1rivnum(i0l)=real(i0rivnum)
           r1rivcnt(i0rivnum)=r1rivcnt(i0rivnum)+1.0
           write(*,*) i0rivnum,i0l
          do i0l2=1,n0l 
             if(r1rivnum(i0l2).eq.0.0.and.
     &          r1rivmth(i0l2).eq.r1rivmth(i0l))then
                r1rivnum(i0l2)=real(i0rivnum)
                r1rivcnt(i0rivnum)=r1rivcnt(i0rivnum)+1.0
                write(*,*) i0rivnum,i0l2
             end if
          end do
          i0rivnum=i0rivnum+1
        end if
      end do
c debug 
      do i0rivnum=1,i0rivnum-1
        write(*,*) i0rivnum,r1rivcnt(i0rivnum)
      end do
c
      call sort_decord(n0l,r1rivcnt,r1tmp,i1org2rnk,i1rnk2org)
c debug
      do i0rivnum=1,i0rivnum-1
         write(*,*) r1rivcnt(i0rivnum),r1tmp(i0rivnum),
     &              i1org2rnk(i0rivnum),i1rnk2org(i0rivnum)
      end do
c
      do i0l=1,n0l
         if(r1rivnum(i0l).ne.0.0)then
c            write(*,*) i0l,int(r1rivnum(i0l)),
c     & real(i1org2rnk(int(r1rivnum(i0l))))
         r1rivnumsrt(i0l)=real(i1org2rnk(int(r1rivnum(i0l))))
         end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call wrte_binary(n0l,r1rivnumsrt,c0rivnum)
      call wrte_binary(n0l,r1rivmth,c0rivmth)
c     
      end
