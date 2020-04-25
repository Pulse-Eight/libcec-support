@ECHO OFF

SETLOCAL

rem Generate a cmake project
rem Usage: generate.cmd [arch] [generator] [project dir] [build dir] [install dir] [build type] [visual studio version] [static (optional)]

rem set paths
SET MYDIR=%~dp0
SET BASEDIR=%MYDIR%..\..
rem parameter: architecture
SET BUILDARCH=%1
rem parameter: project type
SET PROJECT_TYPE=%2
rem parameter: project directory
SET PROJECT_DIR=%3
rem parameter: build directory
SET BUILDDIR=%4
rem parameter: installation directory
SET INSTALLDIR=%5
rem parameter: build type
SET BUILDTYPE=%6
rem parameter: visual studio version
SET VSVERSION=%7
rem optional parameter: static library build
SET BUILDSTATIC=%8

IF [%7] == [] GOTO missingparams

SET PROJECT_DIR=%PROJECT_DIR:"=%
SET BUILDDIR=%BUILDDIR:"=%
SET INSTALLDIR=%INSTALLDIR:"=%

rem Configure the toolchain
CALL "%MYDIR%..\config\toolchain.cmd" >nul
IF "%TOOLCHAIN_NAME%" == "" (
  ECHO. Toolchain not configured
  EXIT /b 1
)

rem Set the project type to generate
SET GEN_PROJECT_TYPE="NMake Makefiles"
SET CMAKE_A_OPT=

IF "%PROJECT_TYPE%" == "vs" (
  SET GEN_PROJECT_TYPE="%TOOLCHAIN_NAME%"
  IF "%BUILDARCH%" == "amd64" (
    IF "%TOOLCHAIN_CMAKE_A_OPT%" == "" (
      SET GEN_PROJECT_TYPE="%TOOLCHAIN_NAME% Win64"
    ) ELSE (
      SET CMAKE_A_OPT=-A x64
    )
  ) ELSE (
    IF "%BUILDARCH%" == "arm" (
      IF "%TOOLCHAIN_CMAKE_A_OPT%" == "" (
        SET GEN_PROJECT_TYPE="%TOOLCHAIN_NAME% ARM"
      ) ELSE (
        SET CMAKE_A_OPT=-A ARM
      )
    ) ELSE (
      IF "%TOOLCHAIN_CMAKE_A_OPT%" == "" (
        SET CMAKE_A_OPT=
      ) ELSE (
        SET CMAKE_A_OPT=-A Win32
      )
    )
  )
)

rem Shared or static
SET GEN_SHARED_LIBS=^-DBUILD_SHARED_LIBS^=1
IF "%BUILDSTATIC%" == "static" (
  SET GEN_SHARED_LIBS=^-DBUILD_SHARED_LIBS^=0
)

rem Create the build directories
IF NOT EXIST "%INSTALLDIR%" MKDIR "%INSTALLDIR%"
IF NOT EXIST "%BUILDDIR%" MKDIR "%BUILDDIR%"

rem Execute cmake to generate makefiles processable by nmake
ECHO. --------------------------------------
ECHO. Generating cmake project:
ECHO. Architecture = %BUILDARCH%
ECHO. Project type = %GEN_PROJECT_TYPE%
ECHO. Cmake ARCH   = %CMAKE_A_OPT%
ECHO. Project      = "%PROJECT_DIR%"
ECHO. Target       = "%BUILDDIR%"
ECHO. Install      = "%INSTALLDIR%"
ECHO. Build type   = %BUILDTYPE%
ECHO. Toolchain    = %TOOLCHAIN_NAME%
ECHO. --------------------------------------
ECHO.

rem Cmake fails when there are quotes in the project directory path
CD "%BUILDDIR%"
%CMAKE% ^
      -G %GEN_PROJECT_TYPE% %CMAKE_A_OPT% ^
      -DCMAKE_BUILD_TYPE=%BUILDTYPE% ^
      -DCMAKE_USER_MAKE_RULES_OVERRIDE="%MYDIR%c-flag-overrides.cmake" ^
      -DCMAKE_USER_MAKE_RULES_OVERRIDE_CXX="%MYDIR%cxx-flag-overrides.cmake" ^
      -DCMAKE_INSTALL_PREFIX="%INSTALLDIR%" ^
      %GEN_SHARED_LIBS% ^
      %CMWAKE_WIN64% ^
      %PROJECT_DIR%
EXIT /b %errorlevel%

:missingparams
ECHO.%~dp0 requires 7 parameters
exit /b 99
