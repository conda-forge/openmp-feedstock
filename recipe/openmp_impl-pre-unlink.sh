
if [ "$PREFIX/lib/libgomp.so.1" -ef "$PREFIX/lib/libomp.so" ]; then
    # remove the file if it is a link
    rm $PREFIX/lib/libgomp.so.1
else
    echo "\
${PKG_NAME}-${PKG_VERSION}-${PKG_BUILDNUM}: \$PREFIX/lib/libgomp.so.1 \
was not a symlink so it was not removed!" >> $PREFIX/.messages.txt
fi
