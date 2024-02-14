#!/bin/bash

set -euxo pipefail

glfw_dir="$_BUILDDIR/$_GLFW_DIR"
[[ -d "$glfw_dir" ]] || unzip -d "$_BUILDDIR" "$_ASSETSDIR/$_GLFW_ARCHIVE"
cd "$glfw_dir"
cp -r include/GLFW "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build-static"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF
cmake --build "$build_dir" --parallel

cp "$build_dir/src/libglfw3.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"

[[ "$_ENABLE_SHARED" -eq 0 ]] && exit 0

build_dir="build-shared"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=ON
cmake --build "$build_dir" --parallel

cp "$build_dir/src/glfw3.dll" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin/libglfw3.dll"
cp "$build_dir/src/libglfw3dll.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/libglfw3.dll.a"
