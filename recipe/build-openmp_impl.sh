# TODO use this code and remove the link scripts below after conda-build >3.18.11
# mkdir -p $PREFIX/lib
#
# echo "Linking 'libgomp${SHLIB_EXT}.1' to 'libomp${SHLIB_EXT}'"
# ln -s $PREFIX/lib/libomp${SHLIB_EXT} $PREFIX/lib/libgomp${SHLIB_EXT}.1
#
# echo "Checking link"
# pushd $PREFIX/lib
# ls -lah
# popd

for action in post-link pre-unlink; do
    cp $RECIPE_DIR/openmp_impl-${action}.sh $PREFIX/bin/.openmp_impl-${action}.sh
done
