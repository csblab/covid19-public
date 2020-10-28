/* Michael's c_io.c consists of the following functions:-
 	c_io_open
	c_io_close
 	swap_long
	swap_short
	c_io_long
 	c_io_short
	c_io_char
*/


#include <stdio.h>
#include <stdlib.h>

/* Function Prototypes */

void c_io_open__ ( char *file_name, long *irw, long *iu );
void c_io_close__ ( long *iu );
void swap_long ( char *a );
void swap_short ( char *a );
void swap_long__ ( char *a );
void swap_short__ ( char *a );
void c_io_long__ ( long *n_long, long *c_long, 
                 long *irw, long *iu );
void c_io_short__ ( long *n_short, short *c_short, 
                  long *irw, long *iu );
void c_io_char__ ( long *n_char, char *c_char, 
		 long *irw, long *iu );

FILE *FilePtr[100];  /* Global file pointer */

/*                                            -----------
                                             | c_io_open |
                                              -----------
*/

void c_io_open__ ( char *file_name, long *irw, long *iu )

/* Open for reading or writing the named file */

{
  if ( *iu < 0 || *iu >= 100 ) { *irw = 0; return; }
 
  if ( *irw == 1 || *irw == -1 ) { 
    FilePtr[*iu] = fopen ( file_name, "rb" );
    if (  FilePtr[*iu] == NULL ) {
      *irw = 0;
      printf ("File '%s' was not opened for reading.\n", file_name );
    }
  }

/* if the file exists, it is opened and trucated to 
    zero bytes */

  if ( *irw == 2 || *irw == -2 ) { 
    FilePtr[*iu] = fopen ( file_name, "wb+" );
    if (  FilePtr[*iu] == NULL ) {
      *irw = 0;
      printf ("File '%s' was not opened for writing.\n", file_name );
    }
  }

}

/*                                            ------------
                                             | c_io_close |
                                              ------------
*/

void c_io_close__ ( long *iu )

/* Close the open file defined by  FilePtr[*iu] */

{ 
  if ( *iu < 0 || *iu >= 100 ) { return; }

  if (  FilePtr[*iu] != NULL ) fclose (  FilePtr[*iu] );
  FilePtr[*iu]  = NULL;
}

/*                                            -----------
                                             | swap_long |
                                              -----------
*/
void swap_long ( char *a )
	
{
  char temp;

/* byte order (1,2,3,4) becomes (4,3,2,1) */

  temp = *a;         
  *a = *(a+3); 
  *(a+3) = temp;

  temp = *(a+1); 
  *(a+1) = *(a+2); 
  *(a+2) = temp;
}

/*                                            ------------
                                             | swap_short |
                                              ------------
*/
void swap_short ( char *a )
	
{
  char temp;

/* byte order (1,2) becomes (2,1) */

  temp = *a; 
  *a = *(a+1); 
  *(a+1) = temp;
}



/*                                            -------------
                                             | swap_long__ |
                                              -------------
*/
void swap_long__ ( char *a )
	
{
  char temp;

/* byte order (1,2,3,4) becomes (4,3,2,1) */

  temp = *a;         
  *a = *(a+3); 
  *(a+3) = temp;

  temp = *(a+1); 
  *(a+1) = *(a+2); 
  *(a+2) = temp;
}

/*                                            --------------
                                             | swap_short__ |
                                              --------------
*/
void swap_short__ ( char *a )
	
{
  char temp;

/* byte order (1,2) becomes (2,1) */

  temp = *a; 
  *a = *(a+1); 
  *(a+1) = temp;
}

/*                                            -----------
                                             | c_io_long |
                                              -----------
*/

void c_io_long__ ( long *n_long, long *c_long, 
                   long *irw, long *iu )

/* Read or write n_long long words of c_long using irw 
    as a switch */

{ 
  long nbytes;
  int ierr, i;

  if ( *iu < 0 || *iu >= 100 ) { *irw = 100; return; }
  if ( FilePtr[*iu] == NULL ) { *irw = 101; return; }
  if ( *n_long <= 0 ) return;

  nbytes = (*n_long) * (sizeof *c_long);

/* read from file defined by  FilePtr[*iu] */
/* if irw < 0, then swap bytes before writing and 
    after reading */

  if ( *irw == 1 || *irw == -1 ) { 

    ierr = fread ( c_long, 1, nbytes, FilePtr[*iu] );

    if ( *irw == -1 ) { 
      for ( i = 0; i < *n_long; i++ ) 
	swap_long(&c_long[i]);
    }
  }

/* write to file defined by  FilePtr[*iu] */

  else if ( *irw == 2 || *irw == -2 ) { 

    if ( *irw == -2 ) { 
      for ( i = 0; i < *n_long; i++ ) 
        swap_long(&c_long[i]);
    }

    ierr = fwrite ( c_long, 1, nbytes, FilePtr[*iu] );

    if ( *irw == -2 ) { 
      for ( i = 0; i < *n_long; i++ ) 
	swap_long(&c_long[i]);
    }

  }

  if ( ierr == -1 || ierr != nbytes ) {
    printf ( " ierr = %d, nbytes = %d\n", ierr, nbytes );
  }

/*  printf ( "n_long = %5d, nbytes = %5d, irw = %d\n", *n_long, nbytes, *irw ); */

}

/*                                            ------------
                                             | c_io_short |
                                              ------------
*/

void c_io_short__ ( long *n_short, short *c_short, 
		    long *irw, long *iu )

/* Set n_short short words of c_short using irw as 
    a switch */

{ 
  long nbytes;
  int ierr, i;

  if ( *iu < 0 || *iu >= 100 ) { *irw = 100; return; }
  if ( FilePtr[*iu] == NULL ) { *irw = 101; return; }
  if ( *n_short <= 0 ) return;

  nbytes = (*n_short) * (sizeof *c_short);
	 
/* read from file defined by  FilePtr[*iu] */
/* if irw < 0, then swap bytes before writing and after reading */

  if ( *irw == 1 || *irw == -1 ) { 

    ierr = fread ( c_short, 1, nbytes, FilePtr[*iu] );

    if ( *irw == -1 ) { 
      for ( i = 0; i < *n_short; i++ ) 
	swap_short(&c_short[i]);
    }
  }

/* write to file defined by  FilePtr[*iu] */

  else if ( *irw == 2 || *irw == -2 ) { 

    if ( *irw == -2 ) { 
      for ( i = 0; i < *n_short; i++ ) 
	swap_short(&c_short[i]);
    }

    ierr = fwrite ( c_short, 1, nbytes, FilePtr[*iu] );

    if ( *irw == -2 ) { 
      for ( i = 0; i < *n_short; i++ ) 
	swap_short(&c_short[i]);
    }

  }

  if ( ierr == -1 || ierr != nbytes ) {
    printf ( " ierr = %d, nbytes = %d\n", ierr, nbytes );
  }

/*  printf ( "n_short = %5d, nbytes = %5d, irw = %d\n", *n_short, nbytes, *irw ); */

}

/*                                            -----------
                                             | c_io_char |
                                              -----------
*/

void c_io_char__ ( long *n_char, char *c_char, 
		   long *irw, long *iu )

/* Set n_char char words of c_char using *irw as a switch */

{ 
  long nbytes;
  int ierr;
	 
  if ( *iu < 0 || *iu >= 100 ) { *irw = 100; return; }
  if ( FilePtr[*iu] == NULL ) { *irw = 101; return; }
  if ( *n_char <= 0 ) return;

  nbytes = (*n_char) * (sizeof *c_char);

/* read from file defined by  FilePtr[*iu] */

  if ( *irw == 1 || *irw == -1 ) { 
    ierr = fread ( c_char, 1, nbytes, FilePtr[*iu] );
  }

/* write to file defined by  FilePtr[*iu] */

  else if ( *irw == 2 || *irw == -2 ) { 
    ierr = fwrite ( c_char, 1, nbytes, FilePtr[*iu] );
  }

  if ( ierr == -1 || ierr != nbytes ) {
    printf ( " ierr = %d, nbytes = %d\n", ierr, nbytes );
  }

/*  printf ( "n_char = %5d, nbytes = %5d, irw = %d\n", *n_char, nbytes, *irw ); */

}




/*                                            --------------
                                             | read_block__ |
                                              --------------x
*/

void read_block__ ( char *filename, int *nbyte, int *nread, 
char *in_byte, int *ierror )
  {
  static FILE *fp;
  static int start=0;
 
  if ( start == 0 || *nbyte == -1 ) { 
    fp = fopen ( filename, "r" ) ;
    if ( fp == NULL ) { 
      printf ( "Cannot open file '%s'. Please check the name.\n", filename );
      exit ( 0 );
    }
    start = 1;
  }
  
  *nread = fread ( in_byte, 1, *nbyte, fp );
  
  *ierror = feof ( fp ) ;
  return;
  
  }







