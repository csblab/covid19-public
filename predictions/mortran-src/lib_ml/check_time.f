      subroutine check_time
      integer secs_now, secs_expiry
      integer hours, days, months, years, mon1, day1
      integer year_expiry, month_expiry, day_expiry
      integer time
      integer secs_left, days_left
      character *10 time_string
      external time
      data time_string/'31 12 2003'/
      read ( time_string,'(i2,1x,i2,1x,i4)' ) day_expiry, month_expiry, 
     &year_expiry
      secs_expiry = ( year_expiry - 1970 ) * 365.25 * 24 * 3600 + ( mont
     &h_expiry - 1 ) * 365.25 * 24 * 3600 / 12.0 + ( day_expiry - 1 ) * 
     &24 * 3600
      secs_now = time()
      hours = secs_now / 3600
      days = hours / 24
      months = days/(365.25/12)
      years = months/12
      mon1 = months - years * 12
      day1 = days - months * ( 365.25/12 )
      secs_left = secs_expiry - secs_now
      days_left = secs_left / ( 24 * 3600 )
      if(secs_now.le.secs_expiry)goto 23021
      write(6,23030)
23030  format ('Program expired. Contact Michael Levitt at Stanford')
      stop
      goto 23061
23021  continue
      write(6,23070)days_left
23070  format (' This version has ', i6, ' days left before expiration.' 
     &)
23061   continue
23011    continue
      return
      end
