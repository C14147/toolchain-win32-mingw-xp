#!/bin/bash

set -euxo pipefail

fmt_dir="$_BUILDDIR/$_FMT_DIR"
[[ -d "$fmt_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_FMT_ARCHIVE"
cd "$fmt_dir"
cp -r include/fmt "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_CXX_COMPILER="g++" -DFMT_TEST=OFF -DBUILD_SHARED_LIBS=OFF
cmake --build "$build_dir" --parallel

cp "$build_dir/libfmt.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
