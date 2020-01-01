mkdir -p $PREFIX/lib

echo "Linking 'libgomp.${SHLIB_EXT}.1' to 'libgomp.${SHLIB_EXT}'"

ln -s $PREFIX/lib/libomp.${SHLIB_EXT} libgomp.${SHLIB_EXT}.1
