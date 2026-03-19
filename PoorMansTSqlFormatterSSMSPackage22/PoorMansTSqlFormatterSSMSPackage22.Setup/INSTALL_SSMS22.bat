@echo off
echo ========================================
echo Poor Man's T-SQL Formatter for SSMS 22
echo Installation Script
echo ========================================
echo.

REM Check for Administrator privileges
net session >/dev/null 2>&1
if %errorLevel% NEQ 0 (
    echo ERROR: Please run this script as Administrator
    echo Right-click the script and select "Run as administrator"
    pause
    exit /b 1
)

set EXTENSION_PATH=C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\PoorMansTSqlFormatter
set SCRIPT_DIR=%~dp0

echo Checking for SSMS 22 installation...
if not exist "C:\Program Files\Microsoft SQL Server Management Studio 22" (
    echo ERROR: SSMS 22 is not installed
    echo Please install SQL Server Management Studio 22 first
    pause
    exit /b 1
)
echo Found SSMS 22
echo.

echo Creating extension directory...
if exist "%EXTENSION_PATH%" (
    echo Removing existing installation...
    rmdir /s /q "%EXTENSION_PATH%"
)
mkdir "%EXTENSION_PATH%"
echo Extension directory created: %EXTENSION_PATH%
echo.

echo Copying extension files...
copy /y "%SCRIPT_DIR%*.dll" "%EXTENSION_PATH%\" > /dev/null
copy /y "%SCRIPT_DIR%*.vsix" "%EXTENSION_PATH%\" > /dev/null 2>/dev/null
copy /y "%SCRIPT_DIR%*.pkgdef" "%EXTENSION_PATH%\" > /dev/null 2>/dev/null
echo Files copied
echo.

echo Registering uninstall information...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22" /v "DisplayName" /t REG_SZ /d "Poor Man's T-SQL Formatter for SSMS 22" /f > /dev/null
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22" /v "DisplayVersion" /t REG_SZ /d "2.2.0.0" /f > /dev/null
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22" /v "Publisher" /t REG_SZ /d "Poor Man's T-SQL Formatter" /f > /dev/null
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22" /v "UninstallString" /t REG_SZ /d "\"%SCRIPT_DIR%UNINSTALL_SSMS22.bat\"" /f > /dev/null
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22" /v "NoModify" /t REG_DWORD /d 1 /f > /dev/null
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22" /v "NoRepair" /t REG_DWORD /d 1 /f > /dev/null
echo Uninstall information registered
echo.

echo Triggering extension refresh...
echo. > "C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\extensions.configurationchanged"
echo Extension refresh triggered
echo.

echo ========================================
echo Installation completed successfully!
echo ========================================
echo.
echo IMPORTANT: Please restart SSMS 22 completely!
echo.
echo After restart, look for:
echo   - Tools menu: Format T-SQL Code
echo   - Tools menu: T-SQL Formatting Options  
echo   - Keyboard shortcut: Ctrl+K, Ctrl+F
echo.
echo To uninstall, use Windows Apps ^& Features or run UNINSTALL_SSMS22.bat
echo.
pause
