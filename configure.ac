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

dnl# Try to get SVN revision
if test -d .git ; then
    GITREV=`git show -s --pretty=format:%h`
    SVNVERSION=`git svn find-rev $GITREV`
    if test -z "$SVNVERSION" ; then
        for REV in 1 2 3 4 5 6 7 8 9 10 ; do
            SVNVERSION=`git svn find-rev HEAD~$REV`
            test -n "$SVNVERSION" && break
        done
    fi
    if test -z "$SVNVERSION" ; then
        SVNVERSION="0000"
    fi
    git diff --no-ext-diff --quiet --exit-code || SVNVERSION="${SVNVERSION}M"
else
    SVNVERSION=`svnversion 2>/dev/null | sed 's/^.*://;s/[^0-9M]//g' | grep '^[0-9][0-9]*[M]*$'`
    case "$SVNVERSION" in
        [0-9]*) : ;;
        *) SVNVERSION=0000 ;;
    esac
fi
AC_SUBST(SVNVERSION)

AC_OUTPUT([
   Makefile
   bench/Makefile
   test/Makefile
   lbnl-nhc.spec
])
