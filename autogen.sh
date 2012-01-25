#!/bin/sh

if autoreconf -V >/dev/null 2>&1 ; then
    set -x
    autoreconf -f -i
else
    set -x
    aclocal
    autoconf
    automake -ca -Wno-portability
fi

if [ -z "$NO_CONFIGURE" ]; then
   ./configure $@
fi

