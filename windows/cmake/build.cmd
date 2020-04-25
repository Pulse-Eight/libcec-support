@ECHO OFF

SETLOCAL

rem Build a cmake generated project with nmake
rem Usage: build.cmd [arch] [build directory]

rem parameter: architecture
SET BUILDARCH=%1
rem parameter: build directory
SET BUILDDIR=%2
SET MYDIR=%~dp0

SET BUILDDIR=%BUILDDIR:"=%

rem Configure the toolchain
CALL "%MYDIR%..\config\toolchain.cmd" >nul
IF "%TOOLCHAIN_NAME%" == "" (
  ECHO.*** Visual Studio toolchain could not be configured for %BUILDARCH% ***
  ECHO.
  ECHO.See docs\README.windows.md
  EXIT /b 2
)

rem Compile
CD "%BUILDDIR%"
ECHO. Compiling "%BUILDDIR%" for %BUILDARCH% using %TOOLCHAIN_NAME%
nmake install
EXIT /b %errorlevel%
