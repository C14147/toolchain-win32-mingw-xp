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
  popd
}
