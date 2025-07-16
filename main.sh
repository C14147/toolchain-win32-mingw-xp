#!/bin/bash

set -euxo pipefail

export REV="0"
export GCC_VERSION="15.1.0"
export MINGW_RELEASE="msvcrt-rt_v12-rev0"

export FMT_VERSION="11.0.2"
export SQLITE_RELEASE_YEAR="2024"
export SQLITE_VERSIONID="3460100"
export MARIADBC_VERSION="2.3.7"  # 3.x requires Vista
export TINYFILEDIALOGS_COMMIT="865c1c84bc824aa8fa5fd46f3a51a8c56fe237b4"

export GLM_VERSION="1.0.1"
export FREEGLUT_VERSION="3.6.0"
export GLFW_VERSION="3.4"
export GLEW_VERSION="2.2.0"
export RAYLIB_VERSION="5.0"
export RAYGUI_VERSION="4.0"
export RDRAWING_COMMIT="d032dfa84b48fc5b7da7c672fbface081b6930e4"
export XEGE_COMMIT="v24.04"

export _BIT=""
export _CLEAN=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --arch)
      _BIT="$2"
      shift
      shift
      ;;
    --clean)
      _CLEAN=1
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

case "$_BIT" in
  32)
    export _ARCH="i686"
    export _EH="dwarf"
    ;;
  64)
    export _ARCH="x86_64"
    export _EH="seh"
    ;;
  *)
    echo "Please specify --arch 32 or --arch 64"
    exit 1
    ;;
esac

export _TRIPLET="$_ARCH-w64-mingw32"

export _MINGW_DIR="mingw$_BIT"
export _MINGW_ARCHIVE="$_ARCH-$GCC_VERSION-release-posix-$_EH-$MINGW_RELEASE.7z"
export _MINGW_URL="https://github.com/niXman/mingw-builds-binaries/releases/download/$GCC_VERSION-$MINGW_RELEASE/$_MINGW_ARCHIVE"

export _FMT_DIR="fmt-$FMT_VERSION"
export _FMT_ARCHIVE="$_FMT_DIR.tar.gz"
_FMT_URL="https://github.com/fmtlib/fmt/archive/refs/tags/$FMT_VERSION.tar.gz"

export _SQLITE_DIR="sqlite-amalgamation-$SQLITE_VERSIONID"
export _SQLITE_ARCHIVE="$_SQLITE_DIR.zip"
_SQLITE_URL="https://www.sqlite.org/$SQLITE_RELEASE_YEAR/$_SQLITE_ARCHIVE"

export _MARIADBC_DIR="mariadb-connector-c-$MARIADBC_VERSION-src"
export _MARIADBC_ARCHIVE="$_MARIADBC_DIR.tar.gz"
_MARIADBC_URL="https://archive.mariadb.org/connector-c-$MARIADBC_VERSION/$_MARIADBC_ARCHIVE"

export _TINYFILEDIALOGS_DIR="tinyfiledialogs-$TINYFILEDIALOGS_COMMIT"
export _TINYFILEDIALOGS_REPO="tinyfiledialogs.git"
_TINYFILEDIALOGS_URL="https://git.code.sf.net/p/tinyfiledialogs/code"

export _GLM_DIR="glm-$GLM_VERSION"
export _GLM_ARCHIVE="$_GLM_DIR.tar.gz"
_GLM_URL="https://github.com/g-truc/glm/archive/refs/tags/$GLM_VERSION.tar.gz"

export _FREEGLUT_DIR="freeglut-$FREEGLUT_VERSION"
export _FREEGLUT_ARCHIVE="$_FREEGLUT_DIR.tar.gz"
_FREEGLUT_URL="https://github.com/freeglut/freeglut/releases/download/v$FREEGLUT_VERSION/$_FREEGLUT_ARCHIVE"

export _GLFW_DIR="glfw-$GLFW_VERSION"
export _GLFW_ARCHIVE="$_GLFW_DIR.zip"
_GLFW_URL="https://github.com/glfw/glfw/archive/refs/tags/$GLFW_VERSION.tar.gz"

export _GLEW_DIR="glew-$GLEW_VERSION"
export _GLEW_ARCHIVE="$_GLEW_DIR.tgz"
_GLEW_URL="https://github.com/nigels-com/glew/releases/download/glew-$GLEW_VERSION/$_GLEW_ARCHIVE"

export _RAYLIB_DIR="raylib-$RAYLIB_VERSION"
export _RAYLIB_ARCHIVE="$_RAYLIB_DIR.tar.gz"
_RAYLIB_URL="https://github.com/raysan5/raylib/archive/refs/tags/$RAYLIB_VERSION.tar.gz"

export _RAYGUI_DIR="raygui-$RAYGUI_VERSION"
export _RAYGUI_ARCHIVE="$_RAYGUI_DIR.tar.gz"
_RAYGUI_URL="https://github.com/raysan5/raygui/archive/refs/tags/$RAYGUI_VERSION.tar.gz"

export _RDRAWING_DIR="raylib-drawing-$RDRAWING_COMMIT"
export _RDRAWING_ARCHIVE="$_RDRAWING_DIR.tar.gz"
_RDRAWING_URL="https://github.com/royqh1979/raylib-drawing/archive/$RDRAWING_COMMIT.tar.gz"

export _XEGE_DIR="xege-$XEGE_COMMIT"
export _XEGE_REPO="xege.git"
_XEGE_URL="https://github.com/wysaid/xege.git"

export _PROJECT_ROOT="$PWD"
export _SRCDIR="$_PROJECT_ROOT/src"
export _ASSETSDIR="$_PROJECT_ROOT/assets"
export _BUILDDIR="$_PROJECT_ROOT/build/$_ARCH"
export _DISTDIR="$_PROJECT_ROOT/dist"

function prepare-dirs() {
  if [[ $_CLEAN -eq 1 ]]; then
    [[ -d "$_BUILDDIR" ]] && rm -rf "$_BUILDDIR"
  fi
  mkdir -p "$_ASSETSDIR" "$_BUILDDIR" "$_DISTDIR"
}

function download-assets() {
  [[ -f "$_ASSETSDIR/$_MINGW_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_MINGW_ARCHIVE" "$_MINGW_URL"
  [[ -f "$_ASSETSDIR/$_FMT_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_FMT_ARCHIVE" "$_FMT_URL"
  [[ -f "$_ASSETSDIR/$_SQLITE_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_SQLITE_ARCHIVE" "$_SQLITE_URL"
  [[ -f "$_ASSETSDIR/$_MARIADBC_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_MARIADBC_ARCHIVE" "$_MARIADBC_URL"
  {
    [[ -d "$_ASSETSDIR/$_TINYFILEDIALOGS_REPO" ]] || git clone --bare "$_TINYFILEDIALOGS_URL" "$_ASSETSDIR/$_TINYFILEDIALOGS_REPO"
    pushd "$_ASSETSDIR/$_TINYFILEDIALOGS_REPO"
    git fetch --all
    popd
  }
  [[ -f "$_ASSETSDIR/$_GLM_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_GLM_ARCHIVE" "$_GLM_URL"
  [[ -f "$_ASSETSDIR/$_FREEGLUT_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_FREEGLUT_ARCHIVE" "$_FREEGLUT_URL"
  [[ -f "$_ASSETSDIR/$_GLFW_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_GLFW_ARCHIVE" "$_GLFW_URL"
  [[ -f "$_ASSETSDIR/$_GLEW_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_GLEW_ARCHIVE" "$_GLEW_URL"
  [[ -f "$_ASSETSDIR/$_RAYLIB_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_RAYLIB_ARCHIVE" "$_RAYLIB_URL"
  [[ -f "$_ASSETSDIR/$_RAYGUI_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_RAYGUI_ARCHIVE" "$_RAYGUI_URL"
  [[ -f "$_ASSETSDIR/$_RDRAWING_ARCHIVE" ]] || curl -L -o "$_ASSETSDIR/$_RDRAWING_ARCHIVE" "$_RDRAWING_URL"
  {
    [[ -d "$_ASSETSDIR/$_XEGE_REPO" ]] || git clone --bare "$_XEGE_URL" "$_ASSETSDIR/$_XEGE_REPO"
    pushd "$_ASSETSDIR/$_XEGE_REPO"
    git fetch --all --tags
    popd
  }
}

function extract-mingw() {
  [[ -d "$_BUILDDIR/$_MINGW_DIR" ]] || (
    pushd "$_BUILDDIR"
    7z x "$_ASSETSDIR/$_MINGW_ARCHIVE"
    popd
  )
}

function package-mingw() {
  pushd "$_BUILDDIR"
  local archive="$_DISTDIR/mingw$_BIT-$GCC_VERSION-r$REV.7z"
  [[ -f "$archive" ]] && rm -f "$archive"
  7z a -t7z -mx=9 -ms=on -mqs=on -mf="BCJ2" -m0="LZMA2:d=32m:fb=273:c=512m" "$archive" "$_MINGW_DIR"
  popd
}

prepare-dirs
download-assets
extract-mingw
export PATH="$_BUILDDIR/$_MINGW_DIR/bin:$PATH"

./script/build-utf8.sh
./script/build-fmt.sh
./script/build-sqlite.sh
./script/build-mariadbc.sh
./script/build-tinyfiledialogs.sh

./script/gfx/build-glm.sh
./script/gfx/build-freeglut.sh
./script/gfx/build-glfw.sh
./script/gfx/build-glew.sh
./script/gfx/build-raylib.sh
./script/gfx/build-raygui.sh
./script/gfx/build-rdrawing.sh
./script/gfx/build-xege.sh

package-mingw
