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
    -DLIBOMP_FORTRAN_MODULES=ON ^
    ..
if %ERRORLEVEL% neq 0 exit 1

cmake --build .
if %ERRORLEVEL% neq 0 exit 1
