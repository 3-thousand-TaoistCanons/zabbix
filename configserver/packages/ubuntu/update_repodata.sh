#!/bin/bash
base_dir=$(cd `dirname $0` && pwd)
cd $base_dir

trusty_dir=trusty/main
package_dir=./

cd $trusty_dir
rm -f InRelease  Release.gpg Packages Packages.gz Release

debs=`ls debs/*.deb`
for deb in $debs
do
	dpkg-sig --sign builder $deb
done

apt-ftparchive packages debs/  > $package_dir/Packages
gzip -c $package_dir/Packages > $package_dir/Packages.gz
apt-ftparchive release $package_dir > $package_dir/Release
gpg --clearsign -o $package_dir/InRelease $package_dir/Release
gpg -abs -o $package_dir/Release.gpg $package_dir/Release
