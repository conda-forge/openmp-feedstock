@echo on

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

if not exist "%LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include\" mkdir "%LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include"
if %ERRORLEVEL% neq 0 exit 1

:: Standalone libomp build doesn't put omp.h in clang's default search path
cp %LIBRARY_PREFIX%\include\omp.h %LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include
if %ERRORLEVEL% neq 0 exit 1
