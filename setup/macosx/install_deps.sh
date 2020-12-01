#!/bin/sh

set -x
set -e

lazarus_ver="2.0.10"
fpc="fpc-3.2.0.intel-macosx"
fpc_package="fpc-3.2.0-intel-macosx"
lazarus="Lazarus-2.0.10-x86_64-macosx"

if [ -n "${sourceforge_mirror-}" ]; then
  mirror_string="&use_mirror=${sourceforge_mirror}"
fi

if [ ! -x "$(command -v fpc 2>&1)" ]; then
  wget "https://downloads.sourceforge.net/project/lazarus/Lazarus%20macOS%20x86-64/Lazarus%20${lazarus_ver}/$fpc.dmg?r=&ts=$(date +%s)${mirror_string-}" -O "fpc.dmg"
  hdiutil attach fpc.dmg
  sudo installer -pkg "/Volumes/$fpc/$fpc_package.pkg" -target /
  hdiutil detach "/Volumes/$fpc"
  rm "fpc.dmg"
fi

if [ ! -x "$(command -v lazbuild 2>&1)" ]; then
  wget "https://downloads.sourceforge.net/project/lazarus/Lazarus%20macOS%20x86-64/Lazarus%20${lazarus_ver}/$lazarus.pkg?r=&ts=$(date +%s)${mirror_string-}" -O "lazarus.pkg"
  sudo installer -pkg "lazarus.pkg" -target /
  rm "lazarus.pkg"
fi

if [ ! -f /usr/local/lib/libcrypto.dylib ]; then
  ln -s /usr/local/Cellar/openssl*/*/lib/libcrypto.*.dylib /usr/local/lib/libcrypto.dylib
fi

if [ ! -f /usr/local/lib/libssl.dylib ]; then
  ln -s /usr/local/Cellar/openssl*/*/lib/libssl.*.dylib /usr/local/lib/libssl.dylib
fi
