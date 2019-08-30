AUTOMAKE_OPTIONS = foreign
SUBDIRS = bench test

helperdir = $(libexecdir)/nhc
confdir = $(sysconfdir)/nhc
logrotatedir = $(sysconfdir)/logrotate.d

dist_sbin_SCRIPTS = nhc nhc-genconf nhc-wrapper
dist_conf_DATA = nhc.conf
dist_helper_SCRIPTS = helpers/node-mark-online helpers/node-mark-offline helpers/slack

nobase_dist_conf_DATA = scripts/lbnl_cmd.nhc scripts/common.nhc		\
                        scripts/lbnl_dmi.nhc scripts/lbnl_file.nhc	\
                        scripts/lbnl_fs.nhc  scripts/lbnl_hw.nhc	\
                        scripts/lbnl_job.nhc scripts/lbnl_moab.nhc	\
                        scripts/lbnl_net.nhc scripts/lbnl_nv.nhc	\
                        scripts/lbnl_ps.nhc

MAINTAINERCLEANFILES = Makefile.in aclocal.m4 configure install-sh missing
DISTCLEANFILES = 
CLEANFILES = 
EXTRA_DIST = COPYING ChangeLog LICENSE autogen.sh nhc.logrotate		\
             nhc-test.conf lbnl-nhc.spec contrib/nhc.cron

install-data-local:
	$(MKDIR_P) '$(DESTDIR)$(logrotatedir)' '$(DESTDIR)$(localstatedir)/lib/nhc' '$(DESTDIR)$(localstatedir)/run/nhc'
	$(INSTALL_DATA) $(srcdir)/nhc.logrotate '$(DESTDIR)$(logrotatedir)/nhc'

uninstall-local:
	-( cd '$(DESTDIR)$(logrotatedir)' && rm -f nhc )
	-rmdir '$(DESTDIR)$(localstatedir)/lib/nhc' '$(DESTDIR)$(localstatedir)/run/nhc'

test:
	$(MAKE) -C test test

test-debug:
	$(MAKE) -C test test-debug

bench:
	$(MAKE) -C bench bench

.PHONY:  test bench
