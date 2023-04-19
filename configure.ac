m4_define([nhc_pkgname], [lbnl-nhc])
m4_define([nhc_version], [1.5])
m4_define([nhc_address], [nhc-devel@lbl.gov])

AC_PREREQ(2.59)
AC_INIT(defn([nhc_pkgname]), defn([nhc_version]), defn([nhc_address]))
AC_CONFIG_SRCDIR([.])
AM_INIT_AUTOMAKE([foreign tar-pax])

dnl# AC_CANONICAL_HOST
#case $host_os in
#  *cygwin* ) CYGWIN=yes;;
#         * ) CYGWIN=no;;
#esac

AC_PROG_INSTALL
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
GITRELEASE=m4_esyscmd(<<git describe --tags HEAD | grep -Eq "^>>nhc_version<<" >&/dev/null && echo -n 1. || echo -n 0. ; git describe --abbrev=4 --always --tags --long --match '[[:digit:]][[:alnum:].]*[[:alnum:]]' --dirty=.1 | cut -d- -f 2- | tr '-' '.'>>)
changequote([, ])dnl

if test -n "$GITRELEASE" ; then
    AC_MSG_RESULT([$GITRELEASE])
else
    GITRELEASE=0.g0000
    AC_MSG_RESULT([unknown, using default $GITRELEASE])
fi
AC_SUBST([GITRELEASE])

AC_OUTPUT([
   Makefile
   bench/Makefile
   test/Makefile
   lbnl-nhc.spec
])
