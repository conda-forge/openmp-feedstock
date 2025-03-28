#!/bin/bash
set -ex

cd openmp/build

cmake --install .

rm -f $PREFIX/lib/libgomp$SHLIB_EXT

if [[ "${PKG_VERSION}" == *rc* ]]; then
  export PKG_VERSION=${PKG_VERSION::${#PKG_VERSION}-4}
elif [[ "${PKG_VERSION}" == *dev* ]]; then
  export PKG_VERSION=${PKG_VERSION::${#PKG_VERSION}-5}
fi

if [[ "$target_platform" == linux-* ]]; then
  # move libarcher.so so that it doesn't interfere
  mv $PREFIX/lib/libarcher.so $PREFIX/lib/libarcher.so.bak
fi
