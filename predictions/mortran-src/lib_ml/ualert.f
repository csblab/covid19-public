C mortran 2.0 macros for .lc to FORTRAN (M.Levitt May 1986)              
      subroutine ualert(str)
      implicit none
      character*(*) str
      integer itrim
      write(6,23010)str(1:itrim(str))
23010 format (' ALERT: ',a)
      return
      end
