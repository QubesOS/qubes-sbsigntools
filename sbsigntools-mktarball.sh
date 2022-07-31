#!/bin/bash

set -e

tmp=$(mktemp -d)

#trap cleanup EXIT
#cleanup() {
#    set +e
#    [ -z "$tmp" -o ! -d "$tmp" ] || rm -rf "$tmp"
#}

unset CDPATH
pwd=$(pwd)
version=0.9.4
commit=d52f7bbb73401aab8a1d59e8d0d686ad9641035e

pushd "$tmp"
git clone git://git.kernel.org/pub/scm/linux/kernel/git/jejb/sbsigntools.git
cd sbsigntools
git checkout ${commit}
ccan_modules="talloc read_write_all build_assert array_size endian"
git submodule init
git submodule update
lib/ccan.git/tools/create-ccan-tree --build-type=automake lib/ccan $ccan_modules
rm -r lib/ccan.git
(
	echo "Authors of sbsigntool:"
	echo
	git log --format='%an' | sort -u | sed 's,^,\t,'
) > AUTHORS
git log --date=short --format='%ad %t %an <%ae>%n%n  * %s%n' > ChangeLog
cd ..
mv sbsigntools sbsigntools-${version}
tar cJf "$pwd"/sbsigntools-${version}.tar.xz --exclude=.git sbsigntools-${version}
popd
