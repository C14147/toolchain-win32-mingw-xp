#!/bin/bash

set -euxo pipefail

glfw_dir="$_BUILDDIR/$_GLFW_DIR"
[[ -d "$glfw_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_GLFW_ARCHIVE"
cd "$glfw_dir"
cp -r include/GLFW "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF
cmake --build "$build_dir" --parallel

cp "$build_dir/src/libglfw3.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
