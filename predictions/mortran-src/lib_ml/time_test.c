/* time_test.f -- translated by f2c (version 20031025).
   You must link the resulting object file with libf2c:
	on Microsoft Windows system, link with libf2c.lib;
	on Linux or Unix systems, link with .../path/to/libf2c.a -lm
	or, if you install libf2c.a in a standard place, with -lf2c -lm
	-- in that order, at the end of the command line, as in
		cc *.o -lf2c -lm
	Source for libf2c is in /netlib/f2c/libf2c.zip, e.g.,

		http://www.netlib.org/f2c/libf2c.zip
*/

#include "f2c.h"

/* Table of constant values */

static integer c__1 = 1;
static integer c__0 = 0;

/* Main program */ int MAIN__(void)
{
    /* Format strings */
    static char fmt_1000[] = "(\002time = \002,f10.5)";
    static char fmt_1001[] = "(\002itime = \002,i15)";
    static char fmt_1002[] = "(\002date = \002,6i6)";

    /* Builtin functions */
    integer s_wsfe(cilist *), do_fio(integer *, char *, ftnlen), e_wsfe(void);
    /* Subroutine */ int s_stop(char *, ftnlen);

    /* Local variables */
    extern /* Subroutine */ int cpu_time__(real *);
    static integer sec, min__, mon;
    extern integer time_(integer *);
    static integer year, wday, hour;
    static real time4;
    static integer itime;
    extern /* Subroutine */ int ymdtime_(integer *, integer *, integer *, 
	    integer *, integer *, integer *);

    /* Fortran I/O blocks */
    static cilist io___2 = { 0, 6, 0, fmt_1000, 0 };
    static cilist io___4 = { 0, 6, 0, fmt_1001, 0 };
    static cilist io___11 = { 0, 6, 0, fmt_1002, 0 };


    cpu_time__(&time4);
    s_wsfe(&io___2);
    do_fio(&c__1, (char *)&time4, (ftnlen)sizeof(real));
    e_wsfe();
    itime = time_(&c__0);
    s_wsfe(&io___4);
    do_fio(&c__1, (char *)&itime, (ftnlen)sizeof(integer));
    e_wsfe();
    ymdtime_(&year, &mon, &wday, &hour, &min__, &sec);
    s_wsfe(&io___11);
    do_fio(&c__1, (char *)&year, (ftnlen)sizeof(integer));
    do_fio(&c__1, (char *)&mon, (ftnlen)sizeof(integer));
    do_fio(&c__1, (char *)&wday, (ftnlen)sizeof(integer));
    do_fio(&c__1, (char *)&hour, (ftnlen)sizeof(integer));
    do_fio(&c__1, (char *)&min__, (ftnlen)sizeof(integer));
    do_fio(&c__1, (char *)&sec, (ftnlen)sizeof(integer));
    e_wsfe();
    s_stop("", (ftnlen)0);
    return 0;
} /* MAIN__ */

/* Main program alias */ int time_test__ () { MAIN__ (); return 0; }
