@ECHO OFF

SETLOCAL

rem Build a cmake generated project with nmake
rem Usage: build.cmd [arch] [build directory] [visual studio version]

rem set paths
SET BASEDIR=%CD%\..\..
SET BUILDDIR=%~2
SET MYDIR=%~dp0

call "%MYDIR%\..\config\toolchain.cmd"

IF "%TOOLCHAIN32%" == "" (
  echo Toolchain not set
  GOTO END
)

rem set Visual C++ build environment
IF "%1" == "amd64" (
  echo Compiling for win64 using %TOOLCHAIN_NAME%
  call "%TOOLCHAIN64%"
  SET INSTALLDIR=..\..\build\x64
) ELSE (
  IF "%1" == "arm" (
    echo Compiling for ARM using %TOOLCHAIN_NAME%
    call "%TOOLCHAINARM%"
    SET INSTALLDIR=..\..\build\arm
  ) ELSE (
    echo Compiling for win32 using %TOOLCHAIN_NAME%
    call "%TOOLCHAIN32%"
    SET INSTALLDIR=..\..\build
  )
)

rem go into the build directory
CD %BUILDDIR%
nmake install

:END