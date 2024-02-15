# Windows XP MinGW Toolchain for Red Panda C++

Based on [our fork](https://github.com/redpanda-cpp/mingw-builds/tree/redpanda-11.4) of [Qt’s fork](https://github.com/cristianadam/mingw-builds) of [MinGW Builds](https://github.com/niXman/mingw-builds), with useful libs for beginners.

## Usage

Drop-in replacement for the main stream Red Panda C++ toolchain.

# Build

Run `./main.sh` in Git Bash.

Args:
- `--arch`: `32` or `64`.
- `--clean`: Clean build directory before building.
- `--enable-shared`: Build shared libraries.
