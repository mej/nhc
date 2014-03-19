# $Id$

AUTOMAKE_OPTIONS = foreign
SUBDIRS = bench test

helperdir = $(libexecdir)/nhc
confdir = $(sysconfdir)/nhc
logrotatedir = $(sysconfdir)/logrotate.d

dist_sbin_SCRIPTS = nhc
dist_conf_DATA = nhc.conf
dist_helper_SCRIPTS = helpers/node-mark-online helpers/node-mark-offline

nobase_dist_conf_DATA = scripts/common.nhc scripts/ww_dmi.nhc	\
                        scripts/ww_file.nhc scripts/ww_fs.nhc	\
                        scripts/ww_hw.nhc scripts/ww_job.nhc	\
                        scripts/ww_nv.nhc scripts/ww_ps.nhc

MAINTAINERCLEANFILES = Makefile.in aclocal.m4 configure install-sh missing
DISTCLEANFILES = 
CLEANFILES = 
EXTRA_DIST = COPYING ChangeLog LICENSE autogen.sh nhc.logrotate	\
             nhc-test.conf warewulf-nhc.spec contrib/nhc.cron

install-data-local:
	$(MKDIR_P) '$(DESTDIR)$(logrotatedir)' '$(DESTDIR)$(localstatedir)/lib/nhc' '$(DESTDIR)$(localstatedir)/run/nhc'
	$(INSTALL_DATA) $(srcdir)/nhc.logrotate '$(DESTDIR)$(logrotatedir)/nhc'

uninstall-local:
	-( cd '$(DESTDIR)$(logrotatedir)' && rm -f nhc )
	-rm -f '$(DESTDIR)$(localstatedir)/lib/nhc'

test:
	$(MAKE) -C test test

test-debug:
	$(MAKE) -C test test-debug

bench:
	$(MAKE) -C bench bench

.PHONY:  test bench
