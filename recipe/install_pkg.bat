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

:: this package creates a copy of 'libomp.dll' and installs it as 'libiomp5md.dll' to
:: replace Intel's openmp library. The issue with copying is that if a process loads
:: both 'libimp5md.dll' and 'libomp.dll', one of them will complain that another OpenMP
:: runtime is being loaded even though they are literally the same.
:: To avoid this, let's make 'libiomp5md.dll' a DLL that forwards to 'libomp.dll'
del /q "%LIBRARY_BIN%\\libiomp5md.dll"
python %SRC_DIR%\\create_forwarder_dll.py "%LIBRARY_BIN%\libomp.dll" "%LIBRARY_BIN%\libiomp5md.dll" --no-temp-dir

:: remove fortran bits from regular llvm-openmp package
if "%PKG_NAME%" NEQ "llvm-openmp-fortran" (
    del /s /q %LIBRARY_INC%\omp_lib.mod
    del /s /q %LIBRARY_INC%\omp_lib_kinds.mod
)
