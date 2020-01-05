@echo off
SET TOOLCHAIN32=""
SET TOOLCHAIN64=""
SET TOOLCHAINARM=""

IF "%VSVERSION%" == "16" (
  SET TOOLCHAIN32="%VS160COMNTOOLS%\..\..\VC\Auxiliary\Build\vcvars32.bat"
  SET TOOLCHAIN64="%VS160COMNTOOLS%\..\..\VC\Auxiliary\Build\vcvars64.bat"
  SET TOOLCHAINARM="%VS160COMNTOOLS%\..\..\VC\Auxiliary\Build\vcvarsx86_arm.bat"
  SET TOOLCHAIN_NAME=Visual Studio 16 2019
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
