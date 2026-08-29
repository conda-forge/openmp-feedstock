@echo on
setlocal enabledelayedexpansion

mkdir build
cd build

set "CC=clang-cl.exe"
set "CXX=clang-cl.exe"
set "MT=%BUILD_PREFIX%\Library\bin\llvm-mt.exe"
set "RC=%BUILD_PREFIX%\Library\bin\llvm-rc.exe"

if "%target_platform%" == "win-arm64" (
    set "CFLAGS=%CFLAGS% --target=aarch64-pc-windows-msvc"
    set "CXXFLAGS=%CXXFLAGS% --target=aarch64-pc-windows-msvc"
    for /f "delims=" %%I in ('where armasm64.exe') do (
        set "ASM_MASM=%%I"
    )
)

:: remove other MSVC installs in the image that interfere
RMDIR /s /q "C:\Program Files\LLVM" || (echo Ignoring failure to delete C:\Program Files\LLVM)
RMDIR /s /q "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\Llvm" ^
    || (echo Ignoring failure to delete C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\Llvm)
RMDIR /s /q "C:\Program Files\Microsoft Visual Studio\2026\Enterprise\VC\Tools\Llvm" ^
    || (echo Ignoring failure to delete C:\Program Files\Microsoft Visual Studio\2026\Enterprise\VC\Tools\Llvm)

cmake -G "Ninja" !CMAKE_ARGS! ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
    -DLIBOMP_FORTRAN_MODULES=ON ^
    ../openmp
if %ERRORLEVEL% neq 0 exit 1

cmake --build .
if %ERRORLEVEL% neq 0 exit 1
