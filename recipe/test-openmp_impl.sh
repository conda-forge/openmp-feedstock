if [ ! -f $PREFIX/lib/libgomp.so.1 ]; then
    exit 1
fi

for action in post-link pre-unlink; do
    if [ ! -f $PREFIX/bin/.openmp_impl-${action}.sh ]; then
        exit 1
    fi
done
