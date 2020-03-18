mkdir build
cd build

set "CC=cl.exe"
set "CXX=cl.exe"

cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
    -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON ^
    -DLIBOMP_INSTALL_ALIASES=OFF ^
    %SRC_DIR%

if errorlevel 1 exit 1

cmake --build . --target install
if errorlevel 1 exit 1

if not exist "%LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include\" mkdir "%LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include"
if errorlevel 1 exit 1

:: Standalone libomp build doesn't put omp.h in clang's default search path
cp %LIBRARY_PREFIX%\include\omp.h %LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include
if errorlevel 1 exit 1
