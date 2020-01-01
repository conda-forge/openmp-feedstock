mkdir -p $PREFIX/lib

echo "Linking 'libgomp${SHLIB_EXT}.1' to 'libomp${SHLIB_EXT}'"

ln -s $PREFIX/lib/libomp${SHLIB_EXT} libgomp${SHLIB_EXT}.1

echo "OpenMP libs:"
ls -1 ${PREFIX}/lib/lib*omp*
