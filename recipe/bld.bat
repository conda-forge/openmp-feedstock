@echo on

:: delete existing LLVM setup in image that often gets higher precedence
rmdir /s /q "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\Llvm"

mkdir build
cd build

set "CC=clang-cl.exe"
set "CXX=clang-cl.exe"

cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
    -DLIBOMP_FORTRAN_MODULES=ON ^
    ../openmp
if %ERRORLEVEL% neq 0 exit 1

cmake --build .
if %ERRORLEVEL% neq 0 exit 1
