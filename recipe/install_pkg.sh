#!/bin/bash
set -ex

cd openmp/build

cmake --install .

rm -f $PREFIX/lib/libgomp*${SHLIB_EXT}*

if [[ "$target_platform" == linux-* ]]; then
  # move libarcher.so so that it doesn't interfere
  mv $PREFIX/lib/libarcher.so $PREFIX/lib/libarcher.so.bak
fi
