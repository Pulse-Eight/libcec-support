@echo off

SET TOOLCHAIN32=""
SET TOOLCHAIN64=""
SET TOOLCHAINARM=""

SET CWD=%~dp0
for /f "usebackq tokens=*" %%i in (`%CWD%\vswhere.exe -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set VS2017DIR=%%i
)

IF "%VSVERSION%" == "15" (
  SET TOOLCHAIN32="%VS2017DIR%\VC\Auxiliary\Build\vcvars32.bat"
  SET TOOLCHAIN64="%VS2017DIR%\VC\Auxiliary\Build\vcvars64.bat"
  SET TOOLCHAINARM="%VS2017DIR%\VC\Auxiliary\Build\vcvarsx86_arm.bat"
  SET TOOLCHAIN_NAME=Visual Studio 15 2017
)
IF "%VSVERSION%" == "14" (
  SET TOOLCHAIN32="%VS140COMNTOOLS%..\..\VC\bin\vcvars32.bat"
  SET TOOLCHAIN64="%VS140COMNTOOLS%..\..\VC\bin\amd64\vcvars64.bat"
  SET TOOLCHAINARM="%VS140COMNTOOLS%..\..\VC\bin\x86_arm\vcvarsx86_arm.bat"
  SET TOOLCHAIN_NAME=Visual Studio 14 2015
)
IF "%VSVERSION%" == "12" (
  SET TOOLCHAIN32="%VS120COMNTOOLS%..\..\VC\bin\vcvars32.bat"
  SET TOOLCHAIN64="%VS120COMNTOOLS%..\..\VC\bin\amd64\vcvars64.bat"
  SET TOOLCHAIN_NAME=Visual Studio 12 2013
)
