#!/bin/bash

set -euxo pipefail

raylib_dir="$_BUILDDIR/$_RAYLIB_DIR"
[[ -d "$raylib_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_RAYLIB_ARCHIVE"
cd "$raylib_dir"
cp src/{raylib,raymath,rlgl}.h "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build-static"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DOPENGL_VERSION="3.3" -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF
cmake --build "$build_dir" --parallel

cp "$build_dir/raylib/libraylib.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"

[[ "$_ENABLE_SHARED" -eq 0 ]] && exit 0

build_dir="build-shared"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DOPENGL_VERSION="3.3" -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=ON
cmake --build "$build_dir" --parallel

cp "$build_dir/raylib/libraylib.dll" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin"
cp "$build_dir/raylib/libraylib.dll.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
