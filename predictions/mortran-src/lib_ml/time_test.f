      program time_test

      integer time, itime
      integer year, mon, wday, hour, min, sec
      real *4 time4

      call cpu_time ( time4 )
      write (6,1000) time4
1000  format ( 'time = ',f10.5)

      itime = time ( 0 )
      write (6,1001) itime
1001  format ( 'itime = ',i15)

      call ymdtime ( year, mon, wday, hour, min, sec )
      write (6,1002) year, mon, wday, hour, min, sec
1002  format ( 'date = ',6i6)

      stop
      end


