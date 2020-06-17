#!/bin/sh
# See https://docs.conda.io/projects/conda-build/en/latest/resources/compiler-tools.html#an-aside-on-cmake-and-sysroots
declare -a CMAKE_PLATFORM_FLAGS
if [[ ${HOST} =~ .*darwin.* ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
  export LDFLAGS=$(echo "${LDFLAGS}" | sed "s/-Wl,-dead_strip_dylibs//g")
else
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

mkdir ../build && cd ../build

cmake \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=RELWITHDEBINFO \
  -DBUILD_SHARED_LIBS=ON \
  -DUSE_CIFTI_CODE=ON \
  -DUSE_NIFTI2_CODE=ON \
  -DDOWNLOAD_TEST_DATA=OFF \
  -DCMAKE_SKIP_INSTALL_RPATH=ON \
  -DTEST_INSTALL=OFF \
  ${CMAKE_PLATFORM_FLAGS[@]} \
  $SRC_DIR

make install

# Run all tests that do not require downloaded data
ctest -LE NEEDS_DATA
