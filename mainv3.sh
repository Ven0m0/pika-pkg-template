#!/usr/bin/env bash
# shellcheck enable=all shell=bash source-path=SCRIPTDIR
set -e; shopt -s nullglob globstar; IFS=$'\n\t'

VERSION="1.0"
export DEBIAN_FRONTEND="noninteractive" LC_ALL=C DPKG_GENSYMBOLS_CHECK_LEVEL=0
export DEB_BUILD_MAINT_OPTIONS="optimize=+lto -march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32 -pipe -fno-semantic-interposition -fdata-sections -ffunction-sections"
export DEB_CFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32 -pipe -fno-semantic-interposition -fdata-sections -ffunction-sections"
export DEB_CPPFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32 -pipe -fno-semantic-interposition -fdata-sections -ffunction-sections"
export DEB_CXXFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32 -pipe -fno-semantic-interposition -fdata-sections -ffunction-sections"
export DEB_LDFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32 -pipe -fno-semantic-interposition -fdata-sections -ffunction-sections \
  -Wl,-O3,--sort-common,--as-needed,-gc-sections,--icf=safe,-z,relro,-z,pack-relative-relocs"
export DEB_BUILD_OPTIONS="nocheck notest terse"
# Clone Upstream
mkdir -p ./src-pkg-name && cp -rvf ./debian ./src-pkg-name/ && cd ./src-pkg-name/
# Get build deps
LOGNAME=root dh_make --createorig -y -l -p src-pkg-name_"$VERSION" || echo "dh-make: Ignoring Last Error"
apt-get build-dep ./ -y
# Build package
dpkg-buildpackage --no-sign
# Move the debs to output
cd ../ && mkdir -p ./output && mv ./*.deb ./output/
