@echo on
setlocal enabledelayedexpansion

mkdir build
cd build

set "CC=clang-cl.exe"
set "CXX=clang-cl.exe"

if "%target_platform%" == "win-64" (
    set "CMAKE_ARGS=%CMAKE_ARGS% -DLIBOMP_FORTRAN_MODULES=ON"
) else (
    set "CMAKE_ARGS=%CMAKE_ARGS% -DLIBOMP_FORTRAN_MODULES=OFF"
)

cmake -G "Ninja" !CMAKE_ARGS! ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
    ../openmp
if %ERRORLEVEL% neq 0 exit 1

cmake --build .
if %ERRORLEVEL% neq 0 exit 1
