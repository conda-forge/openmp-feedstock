mkdir -p $PREFIX/lib

echo "Linking 'libgomp${SHLIB_EXT}.1' to 'libomp${SHLIB_EXT}'"
ln -s $PREFIX/lib/libomp${SHLIB_EXT} $PREFIX/lib/libgomp${SHLIB_EXT}.1

echo "Checking link"
pushd $PREFIX/lib
ls -lah
popd
