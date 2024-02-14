#!/bin/bash

set -euxo pipefail

tinyfiledialogs_dir="$_BUILDDIR/$_TINYFILEDIALOGS_DIR"
if [[ ! -d "$tinyfiledialogs_dir" ]]; then
  mkdir -p "$tinyfiledialogs_dir"
  pushd "$_ASSETSDIR/$_TINYFILEDIALOGS_REPO"
  git --work-tree="$tinyfiledialogs_dir" checkout -f "$TINYFILEDIALOGS_COMMIT"
  popd
fi
cd "$tinyfiledialogs_dir"
cp tinyfiledialogs.h more_dialogs/tinyfd_moredialogs.h "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build"
mkdir -p "$build_dir"
{
  pushd "$build_dir"
  gcc -Os -DNDEBUG -I"$tinyfiledialogs_dir" -c -o tinyfiledialogs.o "$tinyfiledialogs_dir/tinyfiledialogs.c"
  gcc -Os -DNDEBUG -I"$tinyfiledialogs_dir" -c -o tinyfd_moredialogs.o "$tinyfiledialogs_dir/more_dialogs/tinyfd_moredialogs.c"
  ar rcs libtinyfiledialogs.a tinyfiledialogs.o tinyfd_moredialogs.o

  cp "libtinyfiledialogs.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"

  [[ "$_ENABLE_SHARED" -eq 0 ]] && exit 0

  gcc -Os -DNDEBUG -I"$tinyfiledialogs_dir" -fPIC -shared -o libtinyfiledialogs.dll -Wl,--out-implib,libtinyfiledialogs.dll.a "$tinyfiledialogs_dir/tinyfiledialogs.c" "$tinyfiledialogs_dir/more_dialogs/tinyfd_moredialogs.c" -lcomdlg32 -lole32

  cp "libtinyfiledialogs.dll" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin"
  cp "libtinyfiledialogs.dll.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"

  popd
}
