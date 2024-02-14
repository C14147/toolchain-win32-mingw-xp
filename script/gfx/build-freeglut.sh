#!/bin/bash

set -euxo pipefail

freeglut_dir="$_BUILDDIR/$_FREEGLUT_DIR"
[[ -d "$freeglut_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_FREEGLUT_ARCHIVE"
cd "$freeglut_dir"
cp -r include/GL "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DFREEGLUT_BUILD_SHARED_LIBS=ON -DFREEGLUT_BUILD_STATIC_LIBS=ON -DFREEGLUT_BUILD_DEMOS=OFF
cmake --build "$build_dir" --parallel

cp "$build_dir/lib/libfreeglut_static.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"

# always install the shared library, as freeglut has different interface for static and shared
cp "$build_dir/bin/libfreeglut.dll" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin"
cp "$build_dir/lib/libfreeglut.dll.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
