#!/bin/bash

set -euxo pipefail

rdrawing_dir="$_BUILDDIR/$_RDRAWING_DIR"
[[ -d "$rdrawing_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_RDRAWING_ARCHIVE"
cd "$rdrawing_dir"
cp src/{rdrawing,rturtle}.h "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

cat <<EOF >>src/CMakeLists.txt
add_dependencies(rturtle rdrawing)
target_link_libraries(rdrawing PUBLIC raylib)
target_link_libraries(rturtle PUBLIC rdrawing)
EOF

build_dir="build-static"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DBUILD_SHARED_LIBS=OFF
cmake --build "$build_dir" --parallel

cp "$build_dir"/src/{librdrawing,librturtle}.a "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"

[[ "$_ENABLE_SHARED" -eq 0 ]] && exit 0

build_dir="build-shared"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DBUILD_SHARED_LIBS=ON
cmake --build "$build_dir" --parallel

cp "$build_dir"/src/{librdrawing,librturtle}.dll "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin"
cp "$build_dir"/src/{librdrawing,librturtle}.dll.a "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
