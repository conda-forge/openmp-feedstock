mkdir -p $PREFIX/lib

echo "Linking 'libgomp${SHLIB_EXT}.1' to 'libomp${SHLIB_EXT}'"

pushd $PREFIX/lib
ln -s libomp${SHLIB_EXT} libgomp${SHLIB_EXT}.1
ls -lah
popd
