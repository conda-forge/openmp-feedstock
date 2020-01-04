# TODO remove with conda build > 3.18.11
# hack to make conda build happy
# mkdir -p $PREFIX/bin
# for action in post-link pre-unlink; do
#     cp $RECIPE_DIR/openmp_impl-${action}.sh $PREFIX/bin/.openmp_impl-${action}.sh
# done
# end of hack

# # actual script
mkdir -p $PREFIX/lib
echo "Linking 'libgomp${SHLIB_EXT}.1' to 'libomp${SHLIB_EXT}'"
ln -s $PREFIX/lib/libomp${SHLIB_EXT} $PREFIX/lib/libgomp${SHLIB_EXT}.1

echo "Checking link"
pushd $PREFIX/lib
ls -lah
popd
