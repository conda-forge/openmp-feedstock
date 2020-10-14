mkdir build
cd build

if [[ "${target_platform}" == osx-* ]]; then
  # See https://github.com/AnacondaRecipes/aggregate/issues/107
  export CPPFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET} -isystem ${PREFIX}/include -D_FORTIFY_SOURCE=2"
fi

if [[ "${target_platform}" == "linux"* ]]; then
  export LDFLAGS="$LDFLAGS -static-libgcc -static-libstdc++"
fi

if [[ "${PKG_VERSION}" == *rc* ]]; then
  export PKG_VERSION=${PKG_VERSION::${#PKG_VERSION}-4}
fi

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    ..

make -j${CPU_COUNT} VERBOSE=1
make install

rm -f $PREFIX/lib/libgomp$SHLIB_EXT

mkdir -p $PREFIX/lib/clang/$PKG_VERSION/include
# Standalone libomp build doesn't put omp.h in clang's default search path
cp $PREFIX/include/omp.h $PREFIX/lib/clang/$PKG_VERSION/include
