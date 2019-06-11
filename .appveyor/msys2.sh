#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MINGW32" ]]; then
    export MSYS2_ARCH="i686"
else
    export MSYS2_ARCH="x86_64"
fi

pacman --noconfirm -Suy

# Install the required packages
pacman --noconfirm -S --needed \
    base-devel \
    mingw-w64-$MSYS2_ARCH-gcc \
    mingw-w64-$MSYS2_ARCH-ninja \
    mingw-w64-$MSYS2_ARCH-pkg-config \

pip3 install --upgrade --user meson==0.50.1
export PATH="$HOME/.local/bin:$PATH"

# Build
meson _build -Dstatic=true
cd _build
ninja

# Test
export MUTEST_OUTPUT=tap
meson test || {
  cat meson-logs/testlog.txt
  exit 1
}
