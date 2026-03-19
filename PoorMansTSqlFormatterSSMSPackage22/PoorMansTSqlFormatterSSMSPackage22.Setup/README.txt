Poor Man's T-SQL Formatter for SSMS 22 - Setup
================================================

This directory contains the installation files for the Poor Man's T-SQL Formatter extension for SQL Server Management Studio 22.

FILES
-----
- INSTALL_SSMS22.bat  - Installation script (run as Administrator)
- UNINSTALL_SSMS22.bat - Uninstallation script (run as Administrator)
- *.dll, *.vsix, *.pkgdef - Extension files (after build)

INSTALLATION
------------
1. Build the extension first using Visual Studio or the BUILD_SSMS22_SETUP.bat script
2. Right-click on INSTALL_SSMS22.bat
3. Select "Run as administrator"
4. Follow the prompts
5. Restart SSMS 22 completely

UNINSTALLATION
--------------
Method 1 - Using Windows Apps & Features:
1. Go to Settings > Apps > Apps & Features
2. Find "Poor Man's T-SQL Formatter for SSMS 22"
3. Click Uninstall

Method 2 - Using uninstall script:
1. Right-click on UNINSTALL_SSMS22.bat
2. Select "Run as administrator"

REQUIREMENTS
------------
- SQL Server Management Studio 22 must be installed
- Administrator privileges for installation/uninstallation
- .NET Framework 4.7.2 or later (usually installed with SSMS)

TROUBLESHOOTING
---------------
If the extension doesn't appear in SSMS 22 after installation:
1. Make sure SSMS 22 is completely closed (check Task Manager)
2. Restart SSMS 22
3. Check Tools menu for "Format T-SQL Code" and "T-SQL Formatting Options"
4. Try the keyboard shortcut: Ctrl+K, Ctrl+F

If you still don't see the extension:
1. Check that the files were copied to: 
   C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\PoorMansTSqlFormatter
2. Make sure you have administrator privileges
3. Try reinstalling with the INSTALL_SSMS22.bat script

SUPPORT
-------
For issues and updates, visit:
https://github.com/TaoK/PoorMansTSqlFormatter

LICENSE
-------
This extension is released under the GNU Affero General Public License (AGPL) version 3.0.
See the LICENSE file for details.
