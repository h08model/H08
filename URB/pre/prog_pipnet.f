      program prog_pipnet
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c
      integer              n0l
      real                 p0mis
      parameter           (p0mis=1.0E20)
c
      integer              i0l
      character*128        c0tmp
c in
      real,allocatable::   r1ctymsk(:)
      real,allocatable::   r1ctyprf(:)
      real,allocatable::   r1ctyswg(:)
      real,allocatable::   r1demdomorg(:)
      real,allocatable::   r1demindorg(:)
      real,allocatable::   r1rivout(:)
      real,allocatable::   r1rivnum(:)
      real,allocatable::   r1rivara(:)
      character*128        c0ctymsk
      character*128        c0ctyprf
      character*128        c0ctyswg
      character*128        c0demdomorg
      character*128        c0demindorg
      character*128        c0rivout
      character*128        c0rivnum
      character*128        c0rivara
      real,allocatable::   r1frcgwi(:)
      real,allocatable::   r1frcgwd(:)
      character*128        c0frcgwi
      character*128        c0frcgwd
      character*128        c0opt
c out      
      real,allocatable::   r1demdomnew(:)
      real,allocatable::   r1demindnew(:)
      real,allocatable::   r1ctydrn(:)
      character*128        c0demdomnew
      character*128        c0demindnew
      character*128        c0ctydrn
      real,allocatable::   r1frcgwinew(:)
      real,allocatable::   r1frcgwdnew(:)
      character*128        c0frcgwinew
      character*128        c0frcgwdnew
c internal
      integer              i0flg
      real                 r0demdom
      real                 r0demind
      real                 r0rivout
      integer              i0ctyswg
      integer,allocatable::i1num2drn(:)
      integer              i0num
      integer              i0nummax
      real,allocatable::   r1maxara(:)
      real,allocatable::   r1maxpnt(:)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.18)then
         write(*,*) 'Usage: n0l         c0ctymsk    c0ctyprf c0ctyswg'
         write(*,*) '       c0demdomorg c0demindorg c0rivout c0rivnum'
         write(*,*) '       c0rivara    c0frcgwd    c0frcgwi i0nummax'
         write(*,*) '       c0demdomnew c0demindnew c0ctydrn'
         write(*,*) '       c0frcgwdnew c0frcgwinew c0opt'
         stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0ctymsk)
      call getarg(3,c0ctyprf)
      call getarg(4,c0ctyswg)
      call getarg(5,c0demdomorg)
      call getarg(6,c0demindorg)
      call getarg(7,c0rivout)
      call getarg(8,c0rivnum)
      call getarg(9,c0rivara)
      call getarg(10,c0frcgwd)
      call getarg(11,c0frcgwi)
      call getarg(12,c0tmp)
      read(c0tmp,*) i0nummax
      call getarg(13,c0demdomnew)
      call getarg(14,c0demindnew)
      call getarg(15,c0ctydrn)
      call getarg(16,c0frcgwdnew)
      call getarg(17,c0frcgwinew)
      call getarg(18,c0opt)
c
      allocate(r1ctymsk(n0l))
      allocate(r1ctyprf(n0l))
      allocate(r1ctyswg(n0l))
      allocate(r1demdomorg(n0l))
      allocate(r1demindorg(n0l))
      allocate(r1rivout(n0l))
      allocate(r1rivnum(n0l))
      allocate(r1rivara(n0l))
      allocate(r1demdomnew(n0l))
      allocate(r1demindnew(n0l))
      allocate(r1ctydrn(n0l))
      allocate(i1num2drn(n0l))
      allocate(r1maxara(n0l))
      allocate(r1maxpnt(n0l))
      allocate(r1frcgwi(n0l))
      allocate(r1frcgwd(n0l))
      allocate(r1frcgwinew(n0l))
      allocate(r1frcgwdnew(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c read files
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0ctymsk,r1ctymsk)
      call read_binary(n0l,c0ctyprf,r1ctyprf)
      call read_binary(n0l,c0ctyswg,r1ctyswg)
      call read_binary(n0l,c0demdomorg,r1demdomorg)
      call read_binary(n0l,c0demindorg,r1demindorg)
      call read_binary(n0l,c0rivout,r1rivout)
      call read_binary(n0l,c0rivnum,r1rivnum)
      call read_binary(n0l,c0rivara,r1rivara)
      call read_binary(n0l,c0frcgwd,r1frcgwd)
      call read_binary(n0l,c0frcgwi,r1frcgwi)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c calcluate the total water demand
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0demdom=0.0
      r0demind=0.0
c
c domestic water demand in the urban area
c
      if(c0opt.eq.'separate')then
         do i0l=1,n0l
            if(r1demdomorg(i0l).ne.p0mis)then
               if(r1ctymsk(i0l).eq.1)then
                  r0demdom=r0demdom+r1demdomorg(i0l)*(1.0-r1frcgwd(i0l))
               end if            
            end if
         end do
      else if(c0opt.eq.'combine')then
         do i0l=1,n0l
            if(r1demdomorg(i0l).ne.p0mis)then
               if(r1ctymsk(i0l).eq.1)then
                  r0demdom=r0demdom+r1demdomorg(i0l)
               end if            
            end if
         end do
      end if
c      
c industial water demand in the urban area
c
      if(c0opt.eq.'separate')then
         do i0l=1,n0l
            if(r1demindorg(i0l).ne.p0mis)then
               if(r1ctymsk(i0l).eq.1)then
                  r0demind=r0demind+r1demindorg(i0l)*(1.0-r1frcgwi(i0l))
               end if
            end if
         end do
      else if(c0opt.eq.'combine')then
         do i0l=1,n0l
            if(r1demindorg(i0l).ne.p0mis)then
               if(r1ctymsk(i0l).eq.1)then
                  r0demind=r0demind+r1demindorg(i0l)
               end if
            end if
         end do
      end if
c
c total riv discharge at water purification plants
c
      do i0l=1,n0l
         if(r1rivout(i0l).ne.p0mis)then
            if(r1ctyprf(i0l).eq.1)then
               r0rivout=r0rivout+r1rivout(i0l)
            end if
         end if
      end do
      write(*,*) r0rivout
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c assign urban water demand to the water purification plant
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc      
      r1demdomnew=0.0
      r1demindnew=0.0
c      
      do i0l=1,n0l
         if(r1ctymsk(i0l).eq.1)then
            if(c0opt.eq.'separate')then
               if(r1ctyprf(i0l).eq.1)then
                  r1demdomnew(i0l)=r0demdom*r1rivout(i0l)/r0rivout
     &                         +r1demdomorg(i0l)*r1frcgwd(i0l)
                  r1demindnew(i0l)=r0demind*r1rivout(i0l)/r0rivout
     &                         +r1demindorg(i0l)*r1frcgwi(i0l)
                  write(*,*) i0l, r1rivout(i0l)/r0rivout,r1rivout(i0l)
                  r1frcgwdnew(i0l)=0.0
                  r1frcgwinew(i0l)=0.0
               else
                  r1demdomnew(i0l)=r1demdomorg(i0l)*r1frcgwd(i0l)
                  r1demindnew(i0l)=r1demindorg(i0l)*r1frcgwi(i0l)
                  r1frcgwdnew(i0l)=1.0
                  r1frcgwinew(i0l)=1.0
               end if
            else if (c0opt.eq.'combine')then
               if(r1ctyprf(i0l).eq.1)then
                  r1demdomnew(i0l)=r0demdom*r1rivout(i0l)/r0rivout
                  r1demindnew(i0l)=r0demind*r1rivout(i0l)/r0rivout
                  write(*,*) i0l, r1rivout(i0l)/r0rivout,r1rivout(i0l)
                  r1frcgwdnew(i0l)=r1frcgwd(i0l)
                  r1frcgwinew(i0l)=r1frcgwi(i0l)
               else
                  r1demdomnew(i0l)=0.0
                  r1demindnew(i0l)=0.0
                  r1frcgwdnew(i0l)=r1frcgwd(i0l)
                  r1frcgwinew(i0l)=r1frcgwi(i0l)
               end if
            end if
         else
            r1demdomnew(i0l)=r1demdomorg(i0l)
            r1demindnew(i0l)=r1demindorg(i0l)
            r1frcgwdnew(i0l)=r1frcgwd(i0l)
            r1frcgwinew(i0l)=r1frcgwi(i0l)
         end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c drainage
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc      
      do i0num=1,i0nummax
        do i0l=1,n0l
          if(r1ctymsk(i0l).eq.1.and.int(r1rivnum(i0l)).eq.i0num)then
            if(r1ctyswg(i0l).eq.1)then
               i1num2drn(i0num)=i0l
            end if
          end if
        end do
      end do
c
      r1maxara=0.0
      do i0l=1,n0l
        r1ctydrn(i0l)=i0l
        if(r1ctymsk(i0l).eq.1)then
          i0flg=0
          do i0num=1,i0nummax
            if(int(r1rivnum(i0l)).eq.i0num)then
              r1ctydrn(i0l)=i1num2drn(i0num)
              i0flg=1 
            end if
          end do
          if(i0flg.eq.0)then
            if(r1rivara(i0l).gt.r1maxara(int(r1rivnum(i0l))))then
              r1maxara(int(r1rivnum(i0l)))=r1rivara(i0l)
              r1maxpnt(int(r1rivnum(i0l)))=real(i0l)
            end if
            write(*,*) 'urban not drained:',i0l,r1rivnum(i0l),
     &           r1rivara(i0l),r1maxara(int(r1rivnum(i0l))),
     &           r1maxpnt(int(r1rivnum(i0l)))       
          end if
        end if
      end do
c
      do i0l=1,n0l
        if(r1ctymsk(i0l).eq.1)then
          i0flg=0
          do i0num=1,i0nummax
            if(int(r1rivnum(i0l)).eq.i0num)then
              i0flg=1 
            end if
          end do
          if(i0flg.eq.0)then
            r1ctydrn(i0l)=r1maxpnt(int(r1rivnum(i0l)))
            write(*,*) 'urban drained:',i0l,r1rivnum(i0l),
     &            r1ctydrn(i0l)
          end if
        end if
      end do      
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call wrte_binary(n0l,r1demdomnew,c0demdomnew)
      call wrte_binary(n0l,r1demindnew,c0demindnew)
      call wrte_binary(n0l,r1ctydrn,   c0ctydrn)
      call wrte_binary(n0l,r1frcgwinew,c0frcgwinew)
      call wrte_binary(n0l,r1frcgwdnew,c0frcgwdnew)
c      
      end
