@ECHO OFF

SETLOCAL

rem Generate a cmake project
rem Usage: generate.cmd [arch] [generator] [project dir] [build dir] [install dir] [build type] [visual studio version] [static (optional)]

rem set paths
SET MYDIR=%~dp0
SET BASEDIR=%MYDIR%..\..
SET BUILDARCH=%1
SET PROJECT_TYPE=%2
SET PROJECT_DIR=%3
SET BUILDDIR=%4
SET INSTALLDIR=%5
SET BUILDTYPE=%6
SET VSVERSION=%7
SET BUILDSTATIC=%8

echo --------------------------------------
echo Generating cmake project:
echo Architecture = %BUILDARCH%
echo Project type = %PROJECT_TYPE%
echo Project = %PROJECT_DIR%
echo Target = %BUILDDIR%
echo Install = %INSTALLDIR%
echo Build type = %BUILDTYPE%
echo Visual Studio version = %VSVERSION%
echo --------------------------------------

call %MYDIR%..\config\toolchain.cmd

IF %TOOLCHAIN32% == "" (
  echo Toolchain not set: %VSVERSION%
  pause
  GOTO END
)

rem set Visual C++ build environment
IF "%BUILDARCH%" == "amd64" (
  echo Generating for win64 using %TOOLCHAIN_NAME%
  call %TOOLCHAIN64%
  SET CMWAKE_WIN64=^-DWIN64^=1
) ELSE (
  IF "%BUILDARCH%" == "arm" (
    echo Generating for ARM using %TOOLCHAIN_NAME%
    call %TOOLCHAINARM%
    SET CMWAKE_WIN64=^-DCMAKE_SYSTEM_NAME^=WindowsStore ^-DCMAKE_SYSTEM_VERSION^=10.0 
  ) ELSE (
    echo Generating for win32 using %TOOLCHAIN_NAME%
    call %TOOLCHAIN32%
    SET CMWAKE_WIN64=^-DWIN32^=1
  )
)

SET GEN_PROJECT_TYPE="NMake Makefiles"
IF "%PROJECT_TYPE%" == "vs" (
  SET GEN_PROJECT_TYPE="%TOOLCHAIN_NAME%"
  IF "%BUILDARCH%" == "amd64" (
    SET GEN_PROJECT_TYPE="%TOOLCHAIN_NAME% Win64"
  ) ELSE (
    IF "%BUILDARCH%" == "arm" (
      SET GEN_PROJECT_TYPE="%TOOLCHAIN_NAME% ARM"
    )
  )
)

SET GEN_SHARED_LIBS=^-DBUILD_SHARED_LIBS^=1
if "%BUILDSTATIC%" == "static" (
  SET GEN_SHARED_LIBS=^-DBUILD_SHARED_LIBS^=0
)

rem create the build directories
IF NOT EXIST "%INSTALLDIR%" MKDIR "%INSTALLDIR%"
IF NOT EXIST "%BUILDDIR%" MKDIR "%BUILDDIR%"

echo Generating project files for %GEN_PROJECT_TYPE% from %PROJECT_DIR% in %BUILDDIR%, installing to %INSTALLDIR%

rem go into the build directory
CD "%BUILDDIR%"

rem execute cmake to generate makefiles processable by nmake
cmake %PROJECT_DIR% -G %GEN_PROJECT_TYPE% ^
      -DCMAKE_BUILD_TYPE=%BUILDTYPE% ^
      -DCMAKE_USER_MAKE_RULES_OVERRIDE="%MYDIR%c-flag-overrides.cmake" ^
      -DCMAKE_USER_MAKE_RULES_OVERRIDE_CXX="%MYDIR%cxx-flag-overrides.cmake" ^
      -DCMAKE_INSTALL_PREFIX="%INSTALLDIR%" ^
      %GEN_SHARED_LIBS% ^
      %CMWAKE_WIN64%

:END
