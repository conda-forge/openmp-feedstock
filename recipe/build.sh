if [[ "$(uname)" == "Darwin" ]]
then
    export CPPFLAGS=$(echo "${CPPFLAGS}" | sed -E "s@ \-mmacosx\-version\-min=${MACOSX_DEPLOYMENT_TARGET}@@g")
    export CPPFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET} ${CPPFLAGS}"
fi

mkdir build
cd build

cmake \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    ..

make -j${CPU_COUNT}
make install

rm -f $PREFIX/lib/libgomp$SHLIB_EXT
rm -f $PREFIX/lib/libiomp5$SHLIB_EXT

mkdir -p $PREFIX/lib/clang/$PKG_VERSION/include
# Standalone libomp build doesn't put omp.h in clang's default search path
cp $PREFIX/include/omp.h $PREFIX/lib/clang/$PKG_VERSION/include
