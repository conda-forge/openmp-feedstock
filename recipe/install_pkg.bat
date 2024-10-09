@echo on

cd openmp/build

cmake --install .
if %ERRORLEVEL% neq 0 exit 1

if not exist "%LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include\" mkdir "%LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include"
if %ERRORLEVEL% neq 0 exit 1

:: Standalone libomp build doesn't put omp.h in clang's default search path
cp %LIBRARY_PREFIX%\include\omp.h %LIBRARY_PREFIX%\lib\clang\%PKG_VERSION%\include
if %ERRORLEVEL% neq 0 exit 1

:: remove fortran bits from regular llvm-openmp package
if "%PKG_NAME%" NEQ "llvm-openmp-fortran" (
    del /s /q %LIBRARY_INC%\omp_lib.mod
    del /s /q %LIBRARY_INC%\omp_lib_kinds.mod
)
