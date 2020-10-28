/* Michael's utils.c consists of the following functions:-
 	call cpu_time ( time )
	time4 = time (0)
        call ytdtime ( year, mon, wday, hour, min, sec )
*/

#include <time.h>

/*                                            ----------
                                             | cputime_ |
                                              ----------
*/

void cputime_ ( float *time )

/* Interface to c clock routine that returns cpu time in seconds
  (to accuracy of 1/100 sec)
*/

{
  *time = ( ( (double) clock ( ) ) / ( (double) CLOCKS_PER_SEC ) );
}

#include <time.h>

/*                                            -------
                                             | time_ |
                                              -------
*/

int time_ ( void )

/* Interface to c time routine that returns seconds since 1/1/1971
*/

{
  return ( time(0) );
}

#include <time.h>

/*                                            ----------
                                             | ytdtime_ |
                                              ----------
*/

void ymdtime_ ( int *year, int *mon, int *wday, int *hour, int *min, int *sec )

/* Interface to c time routine that returns seconds since 1/1/1971
*/

{
  time_t tvalue, time();
  struct tm *ts;

  tvalue = time(NULL);
  ts = localtime ( &tvalue );

/*
  printf ("ctime = %s", ctime(&tvalue) );
  printf ("tm  = %d %d %d %d %d %d\n ", ts->tm_year, ts->tm_mon, ts->tm_wday, ts->tm_hour, ts->tm_min, ts->tm_sec );
  */

  *year = ts->tm_year;
  *mon =  ts->tm_mon;
  *wday = ts->tm_wday;
  *hour = ts->tm_hour;
  *min =  ts->tm_min;
  *sec =  ts->tm_sec;
  
}





