@echo off
echo ========================================
echo Poor Man's T-SQL Formatter for SSMS 22
echo Uninstallation Script
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

echo Removing extension files...
if exist "%EXTENSION_PATH%" (
    rmdir /s /q "%EXTENSION_PATH%"
    echo Extension files removed
) else (
    echo Extension not found (may have been already removed)
)
echo.

echo Removing uninstall registration...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22" /f > /dev/null 2>&1
echo Uninstall registration removed
echo.

echo Triggering extension refresh...
echo. > "C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\extensions.configurationchanged" 2>/dev/null
echo Extension refresh triggered
echo.

echo ========================================
echo Uninstallation completed successfully!
echo ========================================
echo.
pause
