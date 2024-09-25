#!/bin/bash

set -euxo pipefail

glew_dir="$_BUILDDIR/$_GLEW_DIR"
[[ -d "$glew_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_GLEW_ARCHIVE"
cd "$glew_dir"
cp include/GL/{glew,wglew}.h "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include/GL"

cd build/cmake

build_dir="build"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DBUILD_UTILS=OFF
cmake --build "$build_dir" --parallel

cp "$build_dir/lib/libglew32.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
