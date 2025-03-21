@echo on
setlocal enabledelayedexpansion

:: using subproject sources has been effectively broken in LLVM 14,
:: so we use the entire project, but make sure we don't pick up
:: anything in-tree other than openmp & the shared cmake folder
robocopy llvm-project\openmp .\openmp /E >nul
robocopy llvm-project\cmake .\cmake /E >nul
:: do not check %ERRORLEVEL%! robocopy returns an exit code
:: of 1 if one or more files were successfully copied.
del /f /q llvm-project
cd openmp

mkdir build
cd build

set "CC=clang-cl.exe"
set "CXX=clang-cl.exe"

cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
    ..
if %ERRORLEVEL% neq 0 exit 1

cmake --build . --target install
if %ERRORLEVEL% neq 0 exit 1

:: delete libiomp5md.dll which is incorrectly copied over in the build
:: del /F /Q %LIBRARY_PREFIX%\bin\libiomp5md.dll
:: del /F /Q %LIBRARY_PREFIX%\lib\libiomp5md.dll

:: we want clang to use the omp.h from this package, but stand-alone openmp doesn't
:: put this on clang's default search path. On unix we can use a symlink, but those
:: are not generally usable on windows. As a work-around, copy omp.h to the respective
:: paths for several likely clang versions. Since we have basically no constraints on
:: the version of `llvm-openmp`, environments will tend to have the newest one. In turn,
:: this means that the compiler version is (almost) always ≤ the openmp version, hence
:: it suffices to loop until the major version here. We start from clang 18, because
:: https://github.com/conda-forge/clangdev-feedstock/pull/345 is not backported further.
for /L %%I in (18,1,%PKG_VERSION:~0,2%) do (
    if not exist "%LIBRARY_LIB%\clang\%%I\include\" mkdir "%LIBRARY_LIB%\clang\%%I\include"
    cp %LIBRARY_INC%\omp.h %LIBRARY_LIB%\clang\%%I\include
    if %ERRORLEVEL% neq 0 exit 1
)
