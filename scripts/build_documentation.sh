echo "Building documentation ..."

# Setup the build destinations
PROJECT_DIR="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
BUILD_ROOT="${PROJECT_DIR}/build/documentation"

current_build_dir="${BUILD_ROOT}"
cmake -E make_directory ${current_build_dir}
pushd ${current_build_dir}
cmake \
    -DPROJECT_SOURCE_DIR=${PROJECT_DIR} \
    -DCMAKE_C_COMPILER=$(command -v clang-9) \
    -DCMAKE_CXX_COMPILER=$(command -v clang++-9) \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DBUILD_TESTING=OFF \
    -DOAM_BUILD_DOCUMENTATION=ON \
    -DOAM_BUILD_LIBRARY=OFF \
    -DOAM_BUILD_MAYA_PLUGIN=OFF \
    -DOAM_BUILD_USD=OFF \
    -OAM_INCLUDE_USD_IN_PACKAGE=OFF \
    ${PROJECT_DIR}
if ! cmake --build . --target install; then
    echo "--[Make failed]--"
    popd
    exit 1
fi
popd

exit 0