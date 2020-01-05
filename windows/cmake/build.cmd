@ECHO OFF

SETLOCAL

rem Build a cmake generated project with nmake
rem Usage: build.cmd [arch] [build directory] [visual studio version]

rem set paths
SET BASEDIR=%CD%\..\..
SET BUILDARCH=%1
SET BUILDDIR=%~2
SET MYDIR=%~dp0

call "%MYDIR%\..\config\toolchain.cmd"

IF %TOOLCHAIN32% == "" (
  echo Toolchain not set: %VSVERSION%
  GOTO END
)

IF "%BUILDARCH%" == "x64" (
  echo Generating for win64 "%TOOLCHAIN_NAME%"
  call %TOOLCHAIN64%
  SET INSTALLDIR=..\..\build\x64
) ELSE (
  IF "%BUILDARCH%" == "arm" (
    echo Generating for ARM "%TOOLCHAIN_NAME%"
    call %TOOLCHAINARM%
    SET INSTALLDIR=..\..\build\arm
  ) ELSE (
    echo Generating for win32 "%TOOLCHAIN_NAME%"
    call %TOOLCHAIN32%
    SET INSTALLDIR=..\..\build\win32
  )
)

rem go into the build directory
CD %BUILDDIR%

nmake install

:END