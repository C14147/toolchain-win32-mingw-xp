#!/bin/bash

set -euxo pipefail

glm_dir="$_BUILDDIR/$_GLM_DIR"
[[ -d "$glm_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_GLM_ARCHIVE"
cd "$glm_dir"
find glm -type f -name "*.h" -exec cp --parents {} "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include" \;
find glm -type f -name "*.hpp" -exec cp --parents {} "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include" \;
find glm -type f -name "*.inl" -exec cp --parents {} "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include" \;

build_dir="build"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_CXX_COMPILER="g++" -DGLM_TEST_ENABLE=OFF -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
cmake --build "$build_dir" --parallel

cp "$build_dir/glm/libglm.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/"
