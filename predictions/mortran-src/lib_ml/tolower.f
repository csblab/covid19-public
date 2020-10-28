C mortran 2.0 macros for .lc to FORTRAN (M.Levitt May 1986)              
      subroutine tolower(str)
      implicit none
      character*(*) str
      integer k, l
      do 23011 k = 1, len(str)
      l = ichar( str(k:k) )
      if ( l .ge. ichar('A') .and. l .le. ichar('Z') ) str(k:k) = char( 
     &l + 32 )
23011 continue
23012 continue
      return
      end
