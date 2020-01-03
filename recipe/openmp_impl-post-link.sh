
if [ ! -f "$PREFIX/lib/libgomp.so.1" ]; then
    ln -s $PREFIX/lib/libomp.so $PREFIX/lib/libgomp.so.1
else
    echo "\
${PKG_NAME}-${PKG_VERSION}: \$PREFIX/lib/libgomp.so.1 \
already exists so it was not symlinked to \$PREFIX/lib/libomp.so!" >> $PREFIX/.messages.txt
fi
