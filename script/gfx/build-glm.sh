#!/bin/bash

set -euxo pipefail

glm_dir="$_BUILDDIR/$_GLM_DIR"
[[ -d "$glm_dir" ]] || (
  cd "$_BUILDDIR"
  7z x "$_ASSETSDIR/$_GLM_ARCHIVE"
)
cd "$glm_dir"
find glm -type f -name "*.h" -exec cp --parents {} "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include" \;
find glm -type f -name "*.hpp" -exec cp --parents {} "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include" \;
find glm -type f -name "*.inl" -exec cp --parents {} "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include" \;

build_dir="build"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_CXX_COMPILER="g++" -DGLM_TEST_ENABLE=OFF -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON
cmake --build "$build_dir" --parallel

cp "$build_dir/glm/libglm_static.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/libglm.a"

[[ "$_ENABLE_SHARED" -eq 0 ]] && exit 0

cp "$build_dir/glm/libglm_shared.dll" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin/libglm.dll"
cp "$build_dir/glm/libglm_shared.dll.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/libglm.dll.a"
