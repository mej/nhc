# $Id$

AUTOMAKE_OPTIONS = foreign
SUBDIRS = bench test

helperdir = $(libexecdir)/nhc
confdir = $(sysconfdir)/nhc

dist_sbin_SCRIPTS = nhc
dist_conf_DATA = nhc.conf
nobase_dist_conf_DATA = scripts/common.nhc scripts/ww_fs.nhc \
    scripts/ww_hw.nhc scripts/ww_job.nhc scripts/ww_ps.nhc
dist_helper_SCRIPTS = helpers/node-mark-online helpers/node-mark-offline

MAINTAINERCLEANFILES = Makefile.in aclocal.m4 configure install-sh missing
DISTCLEANFILES = 
CLEANFILES = 
EXTRA_DIST = ChangeLog autogen.sh warewulf-nhc.spec

test:
	$(MAKE) -C test test

bench:
	$(MAKE) -C bench bench

.PHONY:  test bench
