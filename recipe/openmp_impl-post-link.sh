
if [ ! -f "$PREFIX/lib/libgomp.so.1" ]; then
    ln -s $PREFIX/lib/libomp.so $PREFIX/lib/libgomp.so.1
else
    echo "\
${PKG_NAME}-${PKG_VERSION}-${PKG_BUILDNUM}: \$PREFIX/lib/libgomp.so.1 \
already exists so it was symlinked to \$PREFIX/lib/libomp.so!" >> $PREFIX/.messages.txt
fi
