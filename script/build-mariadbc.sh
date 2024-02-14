#!/bin/bash

set -euxo pipefail

mariadbc_dir="$_BUILDDIR/$_MARIADBC_DIR"
[[ -d "$mariadbc_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_MARIADBC_ARCHIVE"
cd "$mariadbc_dir"

sed -i 's/^  END()$/  ENDIF()/' cmake/ConnectorName.cmake

build_dir="build"
pkg_dir="pkg"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DWITH_UNIT_TESTS=OFF
cmake --build "$build_dir" --parallel

cmake --install "$build_dir" --prefix "$pkg_dir"
cp -r "$pkg_dir/include/mariadb" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"
cp -r "$pkg_dir/include/mariadb" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include/mysql"
cp "$pkg_dir/lib/mariadb/libmariadbclient.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
cp "$pkg_dir/lib/mariadb/libmariadbclient.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/libmysqlclient.a"

[[ "$_ENABLE_SHARED" -eq 0 ]] && exit 0

cp "$pkg_dir/lib/mariadb/libmariadb.dll" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin"
cp "$pkg_dir/lib/mariadb/libmariadb.dll" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin/libmysql.dll"
cp "$pkg_dir/lib/mariadb/liblibmariadb.dll.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/libmariadb.dll.a"
cp "$pkg_dir/lib/mariadb/liblibmariadb.dll.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/libmysql.dll.a"

mkdir -p "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin/plugin"
cp "$pkg_dir"/lib/plugin/*.dll "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/bin/plugin"
mkdir -p "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/plugin"
cp "$pkg_dir"/lib/plugin/*.dll.a "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/plugin"
