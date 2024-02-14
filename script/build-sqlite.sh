#!/bin/bash

set -euxo pipefail

sqlite_dir="$_BUILDDIR/$_SQLITE_DIR"
[[ -d "$sqlite_dir" ]] || unzip -d "$_BUILDDIR" "$_ASSETSDIR/$_SQLITE_DIR.zip"
cd "$sqlite_dir"
cp sqlite3.h "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build"
mkdir -p "$build_dir"
{
  pushd "$build_dir"
  gcc -Os -DNDEBUG -c -o sqlite3.o "$sqlite_dir/sqlite3.c"
  ar rcs libsqlite3.a sqlite3.o 

  cp "libsqlite3.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"

  [[ "$_ENABLE_SHARED" -eq 0 ]] && exit 0

  gcc -Os -DNDEBUG -fPIC -shared -o libsqlite3.dll -Wl,--out-implib,libsqlite3.dll.a "$sqlite_dir/sqlite3.c"

  cp "libsqlite3.dll" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin"
  cp "libsqlite3.dll.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
  popd
}
