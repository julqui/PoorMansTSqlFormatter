@echo off
echo ========================================
echo Building Poor Man's T-SQL Formatter
echo for SSMS 22 - Setup Package
echo ========================================
echo.

REM Check for Visual Studio or MSBuild
set MSBUILD_PATH=
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" (
    set "MSBUILD_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe" (
    if "%MSBUILD_PATH%"=="" (
        set "MSBUILD_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe"
    )
)

if "%MSBUILD_PATH%"=="" (
    echo ERROR: MSBuild not found
    echo.
    echo Please install Visual Studio 2019 or 2022 with the following workloads:
    echo   - .NET desktop development
    echo   - Visual Studio extension development
    echo.
    echo Or use the Developer Command Prompt for Visual Studio to run this script.
    echo.
    pause
    exit /b 1
)

echo Found MSBuild at: %MSBUILD_PATH%
echo.

set CONFIGURATION=Release
set SCRIPT_DIR=%~dp0
set BUILD_OUTPUT=%SCRIPT_DIR%
set SETUP_OUTPUT=%SCRIPT_DIR%PoorMansTSqlFormatterSSMSPackage22.Setup

echo Step 1: Building main extension project...
echo ========================================
"%MSBUILD_PATH%" "PoorMansTSqlFormatterSSMSPackage22.csproj" /p:Configuration=%CONFIGURATION% /p:Platform=AnyCPU /t:Rebuild
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to build extension project
    echo.
    echo Make sure you have the following prerequisites:
    echo   - Visual Studio 2019/2022 with VSSDK installed
    echo   - .NET Framework 4.7.2 Developer Pack
    echo.
    pause
    exit /b 1
)
echo.

echo Step 2: Copying extension files to setup directory...
echo ========================================
if not exist "%SETUP_OUTPUT%" mkdir "%SETUP_OUTPUT%"
copy /Y "%BUILD_OUTPUT%bin\%CONFIGURATION%\*.dll" "%SETUP_OUTPUT%\" > /dev/null
copy /Y "%BUILD_OUTPUT%bin\%CONFIGURATION%\*.vsix" "%SETUP_OUTPUT%\" > /dev/null 2>/dev/null
copy /Y "%BUILD_OUTPUT%bin\%CONFIGURATION%\*.pkgdef" "%SETUP_OUTPUT%\" > /dev/null 2>/dev/null
echo Files copied successfully.
echo.

echo ========================================
echo BUILD COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo Setup files are in: %SETUP_OUTPUT%
echo.
echo To install:
echo 1. Navigate to: %SETUP_OUTPUT%
echo 2. Right-click "INSTALL_SSMS22.bat"
echo 3. Select "Run as administrator"
echo 4. Restart SSMS 22
echo.
pause
