#!/bin/bash

set -euxo pipefail

raygui_dir="$_BUILDDIR/$_RAYGUI_DIR"
[[ -d "$raygui_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_RAYGUI_ARCHIVE"
cd "$raygui_dir"
cp src/raygui.h "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build"
mkdir -p "$build_dir"
{
  pushd "$build_dir"
  gcc -xc -Os -DNDEBUG -DRAYGUI_IMPLEMENTATION -c -o raygui.o "$raygui_dir/src/raygui.h"
  ar rcs libraygui.a raygui.o

  cp libraygui.a "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"

  [[ "$_ENABLE_SHARED" -eq 0 ]] && exit 0

  gcc -xc -Os -DNDEBUG -DRAYGUI_IMPLEMENTATION -DBUILD_LIBTYPE_SHARED -fPIC -shared -o libraygui.dll -Wl,--out-implib,libraygui.dll.a "$raygui_dir/src/raygui.h" -lraylib

  cp libraygui.dll "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
  cp libraygui.dll.a "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
  popd
}
