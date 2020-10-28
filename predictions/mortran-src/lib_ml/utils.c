/* Michael's utils.c consists of the following functions:-
 	rand_
	srand_
	clock_
*/


#include <stdlib.h>

/* Function Prototypes */

double rand_ ( void );
void srand_ ( long *iseed );

/*                                            -------
                                             | rand_ |
                                              -------
*/

double rand_ ( void )

/* Interface to c random number generator 
   to return a 8 byte floating point random
   number between 0 and 1 
*/

{
  return ( ( (double) rand ( ) ) / ( (double) RAND_MAX ) );
}

/*                                            --------
                                             | srand_ |
                                              --------
*/

void srand_ ( long *iseed )

/* Interface to the C routine srand to set the random
   number seed 
*/

{ 
  int iseed_int;

  iseed_int = *iseed;

  srand ( iseed_int);
}

#include <time.h>

/*                                            ------------
                                             | cpu_time__ |
                                              ------------
*/

void cpu_time__ ( float *time )

/* Interface to c clock routine that returns cpu time in seconds
  (to accuracy of 1/100 sec)
*/

{
  *time = ( ( (double) clock ( ) ) / ( (double) CLOCKS_PER_SEC ) );
}

#include <stdio.h>

/*                                            ---------------
                                             | char_stderr__ |
                                              ---------------
*/

void char_stderr__ ( char *str )

/* Print single character to stderr */

{
  fprintf ( stderr, "%c", str[0] );
}

/*                                            -----------------
                                             | string_stderr__ |
                                              -----------------
*/
void string_stderr__ ( char *str )

/* Print null-terminated single to stderr */

{
  fprintf ( stderr, "%s", str );
}

