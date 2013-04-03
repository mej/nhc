# $Id$

AUTOMAKE_OPTIONS = foreign

MAINTAINERCLEANFILES = Makefile.in
DISTCLEANFILES = 
CLEANFILES = 

EXTRA_DIST = nhc-test shut.inc.sh test_common.nhc test_ww_dmi.nhc	\
	     test_ww_file.nhc test_ww_fs.nhc test_ww_hw.nhc		\
	     test_ww_job.nhc test_ww_nv.nhc test_ww_ps.nhc

test:
	@./nhc-test $(srcdir) $(top_srcdir)

.PHONY: test
