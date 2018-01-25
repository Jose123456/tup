#! /bin/sh -e
# tup - A file-based build system
#
# Copyright (C) 2009-2018  Mike Shal <marfey@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Make sure we can use a symlink from the monitor
. ./tup.sh
check_monitor_supported
monitor

mkdir foo-x86
echo "#define PROCESSOR 86" > foo-x86/processor.h
ln -s foo-x86 foo

cat > foo.c << HERE
#include "foo/processor.h"
int foo(void) {return PROCESSOR;}
HERE

cat > Tupfile << HERE
: foreach *.c |> gcc -c %f -o %o |> %B.o
HERE
update

tup_dep_exist . foo.c . 'gcc -c foo.c -o foo.o'
tup_dep_exist foo-x86 processor.h . 'gcc -c foo.c -o foo.o'
tup_dep_exist . 'gcc -c foo.c -o foo.o' . foo.o

eotup
