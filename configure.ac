AC_PREREQ(2.59)
AC_INIT([lbnl-nhc], [1.4.2], [nhc-devel@lbl.gov])
AC_CONFIG_SRCDIR([.])

AC_PROG_INSTALL
AM_INIT_AUTOMAKE([foreign])

m4_ifdef([AC_PROG_MKDIR_P], [
  AC_PROG_MKDIR_P
], [
  AM_PROG_MKDIR_P
  MKDIR_P=${mkdir_p}
  AC_SUBST([MKDIR_P])
])#m4_ifdef

AC_OUTPUT([
   Makefile
   bench/Makefile
   test/Makefile
   lbnl-nhc.spec
])
