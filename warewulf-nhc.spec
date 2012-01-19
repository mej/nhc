%{!?_rel:%{expand:%%global _rel 0.r%(svnversion | sed 's/[^0-9].*$//' | grep '^[0-9][0-9]*$' || echo 0000)}}

%{!?sname:%global sname nhc}
%{!?nhc_script_dir:%global nhc_script_dir %{_sysconfdir}/%{sname}/scripts}
%{!?nhc_helper_dir:%global nhc_helper_dir %{_libexecdir}/%{sname}}

Summary: Warewulf Node Health Check System
Name: warewulf-%{sname}
Version: 1.1.3
Release: %{_rel}
License: BSD
Group: Applications/System
URL: http://warewulf.lbl.gov/
Source: %{name}.tar.gz
Packager: %{?_packager:%{_packager}}%{!?_packager:Michael Jennings <mej@lbl.gov>}
Vendor: %{?_vendorinfo:%{_vendorinfo}}%{!?_vendorinfo:Warewulf Project (http://warewulf.lbl.gov/)}
Distribution: %{?_distribution:%{_distribution}}%{!?_distribution:%{_vendor}}
#BuildSuggests: docbook-style-dsssl
Requires: bash
BuildArch: noarch
BuildRoot: %{?_tmppath}%{!?_tmppath:/tmp}/%{name}-%{version}-root

%description
This package contains the Warewulf Node Health Check system.

TORQUE (and other resource managers) allow for the execution of a
script to determine if a node is "healthy" or "unhealthy" and
potentially mark unhealthy nodes as unavailable.  The scripts
contained in this package provide a flexible, extensible mechanism for
collecting health checks to be run on your cluster and specifying
which checks should be run on which nodes.

%prep
%setup -n %{name} -T -c -a 0

%install
%{__mkdir_p} $RPM_BUILD_ROOT%{_sbindir} $RPM_BUILD_ROOT%{_sysconfdir}/%{sname}
%{__mkdir_p} $RPM_BUILD_ROOT%{nhc_script_dir} $RPM_BUILD_ROOT%{nhc_helper_dir}

%{__install} -m 0755 nhc $RPM_BUILD_ROOT%{_sbindir}/%{sname}
#%{__install} -m 0755 nhc-run $RPM_BUILD_ROOT%{_sbindir}/
%{__install} -m 0644 nhc.conf $RPM_BUILD_ROOT%{_sysconfdir}/%{sname}/%{sname}.conf
%{__install} -m 0644 scripts/* $RPM_BUILD_ROOT%{nhc_script_dir}/
%{__install} -m 0755 helpers/* $RPM_BUILD_ROOT%{nhc_helper_dir}/

%clean
test "$RPM_BUILD_ROOT" != "/" && %{__rm} -rf $RPM_BUILD_ROOT

%files
%defattr(-, root, root)
%dir %{_sysconfdir}/%{sname}/
%config(noreplace) %{_sysconfdir}/%{sname}/%{sname}.conf
%{_sbindir}/%{sname}
%{nhc_script_dir}/
%{nhc_helper_dir}/
