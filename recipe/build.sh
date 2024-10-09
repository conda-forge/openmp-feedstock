#!/bin/bash
set -ex

# using subproject sources has been effectively broken in LLVM 14,
# so we use the entire project, but make sure we don't pick up
# anything in-tree other than openmp & the shared cmake folder
mv llvm-project/openmp ./openmp
mv llvm-project/cmake ./cmake
rm -rf llvm-project
cd openmp

if [[ "${target_platform}" == "linux"* ]]; then
  # Make sure libomptarget does not link to libLLVM.so
  find . -name CMakeLists.txt -print0 | xargs -0 sed -i 's/LLVM_LINK_LLVM_DYLIB/LLVM_LINK_LLVM_DYLIB2/g'
  find . -name CMakeLists.txt -print0 | xargs -0 sed -i 's/NO_INSTALL_RPATH/NO_INSTALL_RPATH DISABLE_LLVM_LINK_LLVM_DYLIB/g'
fi

if [[ "$target_platform" == "linux-ppc64le" ]]; then
  # avoid error 'relocation truncated to fit: R_PPC64_REL24'
  CFLAGS="$(echo ${CFLAGS} | sed 's/-fno-plt//g')"
  CXXFLAGS="$(echo ${CXXFLAGS} | sed 's/-fno-plt//g')"
fi

mkdir build
cd build

if [[ "${target_platform}" == osx-* ]]; then
  # See https://github.com/AnacondaRecipes/aggregate/issues/107
  export CPPFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET} -isystem ${PREFIX}/include -D_FORTIFY_SOURCE=2"
fi

if [[ "${target_platform}" == "linux"* ]]; then
  export LDFLAGS="$LDFLAGS -static-libgcc -static-libstdc++"
  # This should have been defined by HandleLLVMOptions.cmake
  # Not sure why it is not.
  export CXXFLAGS="$CXXFLAGS -D__STDC_FORMAT_MACROS"
fi

if [[ "${PKG_VERSION}" == *rc* ]]; then
  export PKG_VERSION=${PKG_VERSION::${#PKG_VERSION}-4}
fi
# used in patch to construct path to libclang_rt.builtins
export PKG_VERSION_MAJOR=$(echo ${PKG_VERSION} | cut -d "." -f1)

cmake -G Ninja \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    ..

cmake --build .
