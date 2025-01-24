AUTOMAKE_OPTIONS = foreign
SUBDIRS = bench test
#SHELL = /bin/bash -x

# NOTE:  The space at the front of `ifeq` and its buddies below is required to
#        work around a GNU Automake bug.  Without the leading whitespace,
#        `automake` errors out, complaining that there's an `else` with no `if`
#        (and the same error again with `endif`).  Well, thank you, Captain
#        Obvious, but that's just not an error.  :-I
# See:  https://patchwork.kernel.org/project/intel-gfx/patch/1435845897-14001-1-git-send-email-damien.lespiau@intel.com/
#
 ifeq (/nhc,$(findstring /nhc,$(prefix)))
helperdir = $(libexecdir)
confdir = $(sysconfdir)
nhc_sysconfig = $(prefix)/sysconfig
 else
helperdir = $(libexecdir)/nhc
confdir = $(sysconfdir)/nhc
nhc_sysconfig = $(sysconfdir)/sysconfig
 endif

logrotatedir = $(sysconfdir)/logrotate.d

dist_sbin_SCRIPTS = nhc nhc-genconf nhc-wrapper
dist_conf_DATA = nhc.conf
dist_helper_SCRIPTS = helpers/node-mark-online helpers/node-mark-offline

nobase_dist_conf_DATA = scripts/lbnl_cmd.nhc scripts/common.nhc		\
                        scripts/lbnl_dmi.nhc scripts/lbnl_file.nhc	\
                        scripts/lbnl_fs.nhc  scripts/lbnl_hw.nhc	\
                        scripts/lbnl_job.nhc scripts/lbnl_moab.nhc	\
                        scripts/lbnl_net.nhc scripts/lbnl_nv.nhc	\
                        scripts/lbnl_ps.nhc  scripts/csc_nvidia_smi.nhc

MAINTAINERCLEANFILES = Makefile.in aclocal.m4 configure install-sh missing
DISTCLEANFILES =
CLEANFILES =
EXTRA_DIST = COPYING ChangeLog LICENSE autogen.sh nhc.logrotate		\
             nhc-test.conf lbnl-nhc.spec contrib/nhc.cron

install-data-local:
	$(MKDIR_P) '$(DESTDIR)$(logrotatedir)' '$(DESTDIR)$(localstatedir)/log' \
		'$(DESTDIR)$(localstatedir)/run/nhc' '$(DESTDIR)$(sysconfdir)/sysconfig' '$(DESTDIR)$(nhc_sysconfig)'
	$(INSTALL_DATA) $(srcdir)/nhc.logrotate '$(DESTDIR)$(logrotatedir)/nhc'

uninstall-local:
	-( cd '$(DESTDIR)$(logrotatedir)' && rm -f nhc )
	-rmdir '$(DESTDIR)$(localstatedir)/lib/nhc' '$(DESTDIR)$(localstatedir)/run/nhc'

install-exec-hook:
	if test -n '@NHC_VERSION@' && ! grep -q '^NHC_VERSION="@NHC_VERSION@"' $(DESTDIR)$(sbindir)/nhc; then \
	    sed -i -e 's,^NHC_VERSION=".*$$,NHC_VERSION="@NHC_VERSION@",' $(DESTDIR)$(sbindir)/nhc ; \
	fi

test:
	$(MAKE) -C test test

test-debug:
	$(MAKE) -C test test-debug

bench:
	$(MAKE) -C bench bench

.PHONY:  test bench
