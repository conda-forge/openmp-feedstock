#!/bin/bash
set -ex

cd openmp/build

cmake --install .

rm -f $PREFIX/lib/libgomp$SHLIB_EXT

mkdir -p $PREFIX/lib/clang/$PKG_VERSION/include
# Standalone libomp build doesn't put omp.h in clang's default search path
cp $PREFIX/include/omp.h $PREFIX/lib/clang/$PKG_VERSION/include
if [[ "$target_platform" == linux-* ]]; then
  # move libarcher.so so that it doesn't interfere
  mv $PREFIX/lib/libarcher.so $PREFIX/lib/libarcher.so.bak
fi

# remove fortran bits from regular llvm-openmp package
if [[ "${PKG_NAME}" != "llvm-openmp-fortran" ]]; then
    rm $PREFIX/include/omp_lib.mod
    rm $PREFIX/include/omp_lib_kinds.mod
fi
