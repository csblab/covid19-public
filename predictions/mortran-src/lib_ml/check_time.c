/* check_time.f -- translated by f2c (version 20031025).
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

/* Subroutine */ int check_time__(void)
{
    /* Initialized data */

    static char time_string__[10] = "31 12 2003";

    /* Format strings */
    static char fmt_23030[] = "(\002Program expired. Contact Michael Levitt "
	    "at Stanford\002)";
    static char fmt_23070[] = "(\002 This version has \002,i6,\002 days left"
	    " before expiration.\002)";

    /* Builtin functions */
    integer s_rsfi(icilist *), do_fio(integer *, char *, ftnlen), e_rsfi(void)
	    , s_wsfe(cilist *), e_wsfe(void);
    /* Subroutine */ int s_stop(char *, ftnlen);

    /* Local variables */
    static integer secs_now__, secs_left__, days_left__, day_expiry__, day1, 
	    mon1, secs_expiry__, year_expiry__;
    extern integer time_(void);
    static integer days, month_expiry__, years, hours, months;

    /* Fortran I/O blocks */
    static icilist io___2 = { 0, time_string__, 0, "(i2,1x,i2,1x,i4)", 10, 1 }
	    ;
    static cilist io___16 = { 0, 6, 0, fmt_23030, 0 };
    static cilist io___17 = { 0, 6, 0, fmt_23070, 0 };


    s_rsfi(&io___2);
    do_fio(&c__1, (char *)&day_expiry__, (ftnlen)sizeof(integer));
    do_fio(&c__1, (char *)&month_expiry__, (ftnlen)sizeof(integer));
    do_fio(&c__1, (char *)&year_expiry__, (ftnlen)sizeof(integer));
    e_rsfi();
    secs_expiry__ = (year_expiry__ - 1970) * 365.25f * 24 * 3600 + (
	    month_expiry__ - 1) * 365.25f * 24 * 3600 / 12.f + (day_expiry__ 
	    - 1) * 86400;
    secs_now__ = time_();
    hours = secs_now__ / 3600;
    days = hours / 24;
    months = days / 30.4375f;
    years = months / 12;
    mon1 = months - years * 12;
    day1 = days - months * 30.4375f;
    secs_left__ = secs_expiry__ - secs_now__;
    days_left__ = secs_left__ / 86400;
    if (secs_now__ <= secs_expiry__) {
	goto L23021;
    }
    s_wsfe(&io___16);
    e_wsfe();
    s_stop("", (ftnlen)0);
    goto L23061;
L23021:
    s_wsfe(&io___17);
    do_fio(&c__1, (char *)&days_left__, (ftnlen)sizeof(integer));
    e_wsfe();
L23061:
/* L23011: */
    return 0;
} /* check_time__ */

