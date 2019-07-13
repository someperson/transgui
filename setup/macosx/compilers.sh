#!/bin/sh

set -x

fpc="fpc-3.0.4.intel-macosx"
lazarus="lazarus-2.0.2a-i686-macosx"

if [ -n "${sourceforge_mirror-}" ]; then
  mirror_string="&use_mirror=${sourceforge_mirror}"
fi

if [ ! -x "$(command -v fpc 2>&1)" ]; then
  wget "https://downloads.sourceforge.net/project/lazarus/Lazarus%20Mac%20OS%20X%20i386/Lazarus%201.8.2/$fpc.dmg?r=&ts=$(date +%s)${mirror_string-}" -O "$fpc.dmg"
  hdiutil attach -quiet "$fpc.dmg"
  pkgpath="$(hdiutil attach "$fpc.dmg" | command awk "/Apple_HFS/ { print \$3 }")"
  sudo installer -pkg "$pkgpath/$fpc.pkg" -target /
  hdiutil unmount "$pkgpath"
  rm "$fpc.dmg"
fi

if [ ! -x "$(command -v lazbuild 2>&1)" ]; then
  wget "https://downloads.sourceforge.net/project/lazarus/Lazarus%20Mac%20OS%20X%20i386/Lazarus%202.0.2/$lazarus.dmg?r=&ts=$(date +%s)${mirror_string-}" -O "$lazarus.dmg"
  hdiutil attach -quiet "$lazarus.dmg"
  pkgpath="$(hdiutil attach "$lazarus.dmg" | command awk "/Apple_HFS/ { print \$3 }")"
  sudo installer -pkg "$pkgpath/lazarus.pkg" -target /
  hdiutil unmount "$pkgpath"
  rm "$lazarus.dmg"
  lazbuild --build-ide= --compiler=ppcx64 --cpu=x86_64 --widgetset=cocoa
fi
