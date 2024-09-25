#!/bin/bash

set -euxo pipefail

rdrawing_dir="$_BUILDDIR/$_RDRAWING_DIR"
[[ -d "$rdrawing_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_RDRAWING_ARCHIVE"
cd "$rdrawing_dir"
cp src/{rdrawing,rturtle}.h "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DBUILD_SHARED_LIBS=OFF
cmake --build "$build_dir" --parallel

cp "$build_dir"/src/{librdrawing,librturtle}.a "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
