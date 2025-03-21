@echo on
setlocal enabledelayedexpansion

cd openmp/build

cmake --install .
if %ERRORLEVEL% neq 0 exit 1

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

:: remove fortran bits from regular llvm-openmp package
if "%PKG_NAME%" NEQ "llvm-openmp-fortran" (
    del /s /q %LIBRARY_INC%\omp_lib.mod
    del /s /q %LIBRARY_INC%\omp_lib_kinds.mod
)
