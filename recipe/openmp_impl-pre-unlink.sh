
if [ "$PREFIX/lib/libgomp.so.1" -ef "$PREFIX/lib/libomp.so" ]; then
    # remove the file if it is a link
    rm $PREFIX/lib/libgomp.so.1
else
    echo "\
${PKG_NAME}-${PKG_VERSION}: \$PREFIX/lib/libgomp.so.1 \
is not a symlink to \$PREFIX/lib/libomp.so so it was not removed!" >> $PREFIX/.messages.txt
fi
