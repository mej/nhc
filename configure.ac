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

dnl# The following uses m4's esyscmd macro so that the command below runs at
dnl# "autoconf" time, when we're sure to have a Git repo, rather than configure
dnl# time.  We have to change the m4 quote characters due to the regex we use.
AC_MSG_CHECKING([for Git version description])
changequote(<<, >>)dnl
GITVERSION=m4_esyscmd(<<git describe --dirty | tr -d '\012' | sed -e 's/^[^-]*-//;s/-/./g;s/dirty/1/'>>)
changequote([, ])dnl

if test -n "$GITVERSION" ; then
    AC_MSG_RESULT([$GITVERSION])
else
    GITVERSION=0.g0000000
    AC_MSG_RESULT([unknown, using default $GITVERSION])
fi
AC_SUBST([GITVERSION])
AC_SUBST([libexecdir])
AC_SUBST([exec_prefix])
AC_SUBST([sbindir])
AC_SUBST([bindir])
AC_SUBST([prefix])
AC_SUBST([sysconfdir])

#AC_CONFIG_FILES([nhc nhc-genconf nhc-wrapper])

AC_OUTPUT([
   Makefile
   bench/Makefile
   test/Makefile
   lbnl-nhc.spec
])
