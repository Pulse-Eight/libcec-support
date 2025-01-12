@echo off

SET TOOLCHAIN32=""
SET TOOLCHAIN32CFG=
SET TOOLCHAIN64=""
SET TOOLCHAIN64CFG=
SET TOOLCHAINARM=""
SET TOOLCHAINARMCFG=
SET TOOLCHAIN_NAME=
SET TOOLCHAIN_CMAKE_A_OPT=
SET CMWAKE_WIN64=
SET CMAKE="C:\Program Files\CMake\bin\cmake.exe"

IF "%VSVERSION%" == "" (
  SET VSVERSION=2019
)

IF "%BUILDARCH%" == "" (
  SET BUILDARCH="amd64"
)

IF "%VSVERSION%" == "2013" (
  SET TOOLCHAIN32="%VS120COMNTOOLS%..\..\VC\bin\vcvars32.bat"
  SET TOOLCHAIN64="%VS120COMNTOOLS%..\..\VC\bin\amd64\vcvars64.bat"
  SET TOOLCHAIN_NAME=Visual Studio 12 2013
)
IF "%VSVERSION%" == "2015" (
  SET TOOLCHAIN32="%VS140COMNTOOLS%..\..\VC\bin\vcvars32.bat"
  SET TOOLCHAIN64="%VS140COMNTOOLS%..\..\VC\bin\amd64\vcvars64.bat"
  SET TOOLCHAINARM="%VS140COMNTOOLS%..\..\VC\bin\x86_arm\vcvarsx86_arm.bat"
  SET TOOLCHAIN_NAME=Visual Studio 14 2015
)
IF "%VSVERSION%" == "2017" (
  IF "%VS150COMNTOOLS%" == "" (
    SET TOOLCHAIN32="%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
    SET TOOLCHAIN64="%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
    SET TOOLCHAINARM="%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
  ) ELSE (
    SET TOOLCHAIN32="%VS150COMNTOOLS%..\..\VC\Auxiliary\Build\vcvarsall.bat"
    SET TOOLCHAIN64="%VS150COMNTOOLS%..\..\VC\Auxiliary\Build\vcvarsall.bat"
    SET TOOLCHAINARM="%VS150COMNTOOLS%..\..\VC\Auxiliary\Build\vcvarsall.bat"
  )
  SET TOOLCHAIN32CFG=x86
  SET TOOLCHAIN64CFG=amd64
  SET TOOLCHAINARMCFG=amd64_arm
  SET TOOLCHAIN_NAME=Visual Studio 15 2017
)
IF "%VSVERSION%" == "2019" (
  IF "%VS160COMNTOOLS%" == "" (
    SET TOOLCHAIN32="%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"
    SET TOOLCHAIN64="%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"
    SET TOOLCHAINARM="%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"
  ) ELSE (
    SET TOOLCHAIN32="%VS160COMNTOOLS%..\..\VC\Auxiliary\Build\vcvarsall.bat"
    SET TOOLCHAIN64="%VS160COMNTOOLS%..\..\VC\Auxiliary\Build\vcvarsall.bat"
    SET TOOLCHAINARM="%VS160COMNTOOLS%..\..\VC\Auxiliary\Build\vcvarsall.bat"
  )
  SET TOOLCHAIN32CFG=x86
  SET TOOLCHAIN64CFG=amd64
  SET TOOLCHAINARMCFG=amd64_arm
  SET TOOLCHAIN_NAME=Visual Studio 16 2019
  SET TOOLCHAIN_CMAKE_A_OPT=-A
)

rem ===========================================================================

IF "%BUILDARCH%" == "amd64" (
  SET CMWAKE_WIN64=^-DWIN64^=1
  CALL %TOOLCHAIN64% %TOOLCHAIN64CFG%
  IF %errorlevel% neq 0 EXIT /b %errorlevel%
) ELSE (
  IF "%BUILDARCH%" == "arm64" (
    SET CMWAKE_WIN64=^-D_M_ARM64 ^-DCMAKE_SYSTEM_VERSION^=10.0
    CALL %TOOLCHAINARM% %TOOLCHAINARMCFG%
    IF %errorlevel% neq 0 EXIT /b %errorlevel%
  ) ELSE (  
    IF "%BUILDARCH%" == "arm" (
      SET CMWAKE_WIN64=^-DCMAKE_SYSTEM_NAME^=WindowsStore ^-DCMAKE_SYSTEM_VERSION^=10.0
      CALL %TOOLCHAINARM% %TOOLCHAINARMCFG%
      IF %errorlevel% neq 0 EXIT /b %errorlevel%
    ) ELSE (
      SET CMWAKE_WIN64=^-DWIN32^=1
      CALL %TOOLCHAIN32% %TOOLCHAIN32CFG%
      IF %errorlevel% neq 0 EXIT /b %errorlevel%
    )
  )  
)

rem ===========================================================================

IF "%CMWAKE_WIN64%" == "" (
  ECHO. Invalid BUILDARCH: %BUILDARCH%
  EXIT /b 1
)
IF "%TOOLCHAIN_NAME%" == "" (
  ECHO. Invalid VSVERSION: %VSVERSION%
  EXIT /b 1
)

:EXIT
