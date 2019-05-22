set LICENSE=lgpl3
set LINKAGE=shared
set RUNTIME_LIBRARY=MD
set Configuration=Release
set Platform=x86
set MSYS2_PATH_TYPE=inherit
@echo on
rem set up Visual Studio environment for specified toolset and platform
rem see https://www.appveyor.com/docs/lang/cpp/
rem and https://stackoverflow.com/a/46994531
rem (differenes: no need for SDK, use native amd64 instead of x86_amd64)
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" %PLATFORM% -vcvars_ver=14.2
rem run main build script
set SCRIPT_PATH=%cd%
C:\msys64\usr\bin\bash -l "%SCRIPT_PATH%\build.sh"
@echo off
