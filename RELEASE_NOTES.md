# LBNL Node Health Check Release Notes

## Version 1.5
Significant development time and effort has gone into this new release.  And the truth is, not everything was ready to go out the door by the time the deadline rolled around for 1.5 to finally make it out the door.  So development on 1.5.1 has already started.  Additionally, there will undoubtedly be things I've missed that get caught during the first few days after a new release.  I hope to do a better job of making regular releases and preventing myself from getting too caught up in the notion of getting it "finished" before releasing it.  As we all know, there's no such thing in the software world.

**BREAKING CHANGE (COMPATIBILITY)**:  NHC now requires at least Bash version 4.2 or higher!

### New Features:
- New command-line options:
  - `-V` - Display version information; may be specified multiple times for increasing detail
  - `-j` - Use JSON object format for `syslog()` payload
  - `-m`_`host`_ - Masquerade as _`host`_; i.e., force use of _`host`_ as the hostname rather than the canonical hostname.
  - `-p` - Permanently offline nodes; nodes taken offline will be ignored by future `nhc` runs and will require admin intervention to return to service
  - `-r`_`resmgr`_ - Specify _`resmgr`_ as the resource manager (e.g., `slurm`) or "`none`" for standalone operation.
- Several new checks are available out-of-the-box, including ones for NVIDIA GPUs via SMI and DCGM, Kubernetes, and more!
- `nhc-wrapper` can now wrap co-located executables that need not be in the default/current `$PATH`.
- Default permissions have been adjusted in the RPM specfile to allow normal users to access the `scripts` directory and the check modules within.  This is build-time configurable (via `rpmbuild --without useraccess ...`).
- The subprocess management and watchdog timer subsystems have been completely revamped to provide reliable and consistent oversight of child processes and to fix a timer conflict bug in previous versions.
- By popular demand, concurrency handling via a runtime process ID (PID) file has been implemented.  PID files are context-specific and stored in `${RUNDIR}/nhc/NHC.context.pid` by default.  (The value for `$RUNDIR` is automatically detected.)
- When running in "verbose" mode (`-v`, `VERBOSE=1`), check numbers and totals are displayed as each check is run.
- `check_file_stat()` now supports the "birth timestamp" if available (via `-B`/`-b`) as well as the SELinux context (via `-c`, only available on Linux and when enabled).
- NHC's configuration file, specified via `-c` or the `$CONFFILE` setting, no longer needs to point to a regular file; valid values now include named pipes/FIFOs, `AF_UNIX` sockets, PTYs/TTYs, process substitutions, etc.  (Example:  `nhc -avl- -c <( egrep -hv '^[[:space:]]*(#|$)' /etc/nhc/nhc*.conf )`)
- Support was added for taking certain directory/path settings from namespaced environment variables:
  - High-Level Settings
    - `NHC_CFG_GLOBAL` - The complete path- and filename to a global settings file, used instead of `/etc/sysconfig/nhc`
    - `NHC_CFG_PREFIX` - Assume `autoconf`-style layout with `--prefix=<value>`
    - `NHC_HOST` - Override default `$HOSTNAME` value (`/etc/hostname` or `/proc/sys/kernel/hostname`)
  - Individual Directories
    - `NHC_CFG_CONFDIR` - Override default `CONFDIR` value (`/etc/nhc`)
    - `NHC_CFG_INCDIR` - Override default `INCDIR` value (`$CONFDIR/scripts`)
    - `NHC_CFG_HELPERDIR` - Override default `HELPERDIR` value (`$LIBEXECDIR/nhc`)
    - `NHC_CFG_LIBEXECDIR` - Override default `LIBEXECDIR` value (OS-dependent)
    - `NHC_CFG_LOGDIR` - Override default `LOGDIR` value (`$STATEDIR/log`)
    - `NHC_CFG_RUNDIR` - Override default `RUNDIR` value (`$STATEDIR/run/nhc`)
    - `NHC_CFG_STATEDIR` - Override default `STATEDIR` value (OS-dependent)
    - `NHC_CFG_SYSCONFIGDIR` - Override default `SYSCONFIGDIR` value (OS-dependent)
- `check_cmd_output()` and `check_file_contents()` now support conditionals, additional expressions that can be used to fine-tune or supplement match strings, along with a whole slew of other new options.  See [README file](README.md) for details.

### Fixes/Improvements:
- Resource consumption checks now differentiate between system and non-system users.
- Improved handling for Slurm node states and transitions
- Logs successful completion, not just failure
- More informative and customizable `syslog()` labeling and tagging
- Hardware checks reading from `procfs`/`sysfs` files have been refactored to allow immensely greater flexibility as well as to address performance issues on some systems (e.g., many-core Knights Landing CPUs).  Data sources are now completely user-configurable and can be cached copies, files in other locations, or even subcommands/pipelines.
- Node online/offline helpers are now invoked in a subshell for greater data integrity protection.
- **BREAKING CHANGE**:  `check_file_stat()` now uses 2 distinct option sets that examine the file's `mode`.  In previous versions, `-M`/`-m` looked solely at the permissions bits (i.e., `mode & 00007777`), whereas in NHC 1.5, this is done by the `-P`/`-p` "permissions" options.  The `-M`/`-m` "mode" options now look at the file type bits (`mode & 00170000`).
- Options to `check_file_test()` can now be bundled.
- When attempting to automatically fix a missing mount point, NHC will now accurately report the success or failure of the `mkdir` attempt.
- After loading checks from the config file, if the resulting check list is empty, a warning is now logged rather than `nhc` just exiting silently.
- Special handling of Bash exit codes `126` and `127` has been added to help point admins to the most likely causes.
- When running under Slurm, the online helper will no longer attempt to resume nodes in the `maint` state; `slurmctld` rejects this as an invalid state change.
- `check_file_contents()` now uses the same backend processing/matching functionality that `check_cmd_output()` uses, enabling use of all the same options and arguments.


## Version 1.4.3
Please note:  As with future releases in the 1.4.x series, this
release has largely been limited to bugfixes and incremental
improvements of existing code.  Active feature development has already
started (and has been going on for awhile now, truthfully) on what
will eventually be the development branch for a future 1.5 release.

### New Features:
 - Toggle BASH tracing or NHC debugging via SIGUSR1/SIGUSR2,
   respectively
 - check_nvsmi_healthmon():  New check from CSC for GPU health
   monitoring via "nvidia-smi"

### Fixes/Improvements:
 - Corrections/cleanups of SGE integration support
 - Provide added detail to tracing info ("-x" mode)
 - Based on feedback from Moe Jette of SchedMD, pull node job data
   directly from Slurm via "squeue" instead of the previous method
   that only worked for single-node jobs.
 - Support for recent additions to the Slurm node states (e.g.,
   "planned")
 - Pathname expansion has been disabled on startup, and re-enabled
   only when being actively used, to avoid "unintended" expansions of
   wildcards at random points throughout the code.
 - Correct clobbering of BASH built-in variables and add tests to
   prevent future recurrence
 - Switch "system UID" boundary handling to a more accurate source of
   truth, and ensure that the code matches the math, naming, and
   intent.
 - Reorder resource manager detection to improve accurate detection,
   especially with respect to Slurm vs. PBS (all variants)


## Version 1.4.2
### New features:
 - Support for negating *any* match string anywhere (configs and check
   parameters)
 - check_net_ping():  New check for monitoring of network connectivity
 - check_ps_*():  Process owner parameters now accept match strings,
   allowing them to take full advantage of wildcards, regular
   expressions, ranges, and/or external dynamic matching (e.g., UNIX
   group membership-based matching)
 - check_ps_service():  Additional options to tell NHC to execute
   stop/start/restart/cycle and/or user-defined actions synchronously
   (instead of backgrounding them) so that NHC can verify they worked
   correctly (or fail if not).
    - -v (Verify Sync) will only fail check if action fails
    - -V (Verify Check) additionally will make sure action appears to
      have worked (e.g., killed process is gone, started daemon is
      running, etc.)
 - check_cmd_dmesg():  New check to validate/verify or catch/flag
   certain important content in the output of the `dmesg` command.
   This check is also a working example to facilitate user wrapping of
   check_cmd_output() to generate custom/specific check failure
   messages.
 - New command-line flag:  "-e <check>" will override config file,
   execute just the specified <check>, and return success/failure
   based on that single check.  Useful for testing/troubleshooting new
   checks.  Essentially analogous to having a 1-line config file
   consisting of "* || <check>" and nothing else.
 - check_fs_mount():  Create missing mount points as necessary

### Fixes/improvements:
 - Silence warnings about watchdog timer and RM detection that were
   confusing to users and/or no longer useful
 - Refactored match string range checking to be comparative rather
   than iterative.  Large ranges will see a huge speed-up!
 - Refactored generation and handling of numerical quantities to avoid
   excessive rounding/truncation errors.  For example, truncation of
   1.5TB of RAM to 1TB is a significant error!  Now uses 1536GB
   instead.
 - Fixed issue with leading zeros in node range expressions causing
   numbers to be interpreted as octal.
 - Fixed typo in getent fallback handling that kept it from working in
   certain cases.
 - Simplified the killing of the watchdog timer to avoid apparent BASH
   bug causing aborts.
 - Fixed list of SLURM node states supported by node-mark-{on,off}line
 - Fix trimming of whitespace in config files to include tabs
