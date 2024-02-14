#!/bin/bash

set -euxo pipefail

utf8_dir="$_BUILDDIR/utf8"
mkdir -p "$utf8_dir"
cd "$utf8_dir"

build_dir="build"
mkdir -p "$build_dir"
{
  pushd "$build_dir"
  gcc -Os -fno-exceptions -nodefaultlibs -nostdlib -c -o "utf8init.o" "$_SRCDIR/utf8/utf8init.cpp"
  windres -O coff -o "utf8manifest.o" "$_SRCDIR/utf8/utf8manifest.rc"
  ar rcs libutf8.a utf8init.o utf8manifest.o

  cp "utf8init.o" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
  cp "utf8manifest.o" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
  cp "libutf8.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
  popd
}
