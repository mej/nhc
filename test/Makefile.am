AUTOMAKE_OPTIONS = foreign

MAINTAINERCLEANFILES = Makefile.in
DISTCLEANFILES = 
CLEANFILES = 

EXTRA_DIST = nhc-test shut.inc.sh test_lbnl_cmd.nhc test_common.nhc	\
	     test_lbnl_dmi.nhc test_lbnl_file.nhc test_lbnl_fs.nhc		\
	     test_lbnl_hw.nhc test_lbnl_job.nhc test_lbnl_moab.nhc		\
	     test_lbnl_net.nhc test_lbnl_nv.nhc test_lbnl_ps.nhc

test:
	@./nhc-test $(srcdir) $(top_srcdir)

test-debug:
	@$(SHELL) -x ./nhc-test $(srcdir) $(top_srcdir) 2>&1

.PHONY: test
