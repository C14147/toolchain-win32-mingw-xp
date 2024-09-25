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
  popd
}
