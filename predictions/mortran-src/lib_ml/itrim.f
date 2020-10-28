      integer function itrim(line)
      implicit none
      integer itrim
      character *(*) line
      integer ln, i
      ln = len(line)
      i = ln
26731 if(i.lt.1.or.line(i:i).ne.' ')goto 26732
      i = i - 1
      goto 26731
26732 continue
      itrim = 1
      if ( i .ge. 1 ) itrim = i
      return
      end
