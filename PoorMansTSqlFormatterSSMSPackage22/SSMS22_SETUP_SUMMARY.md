# Poor Man's T-SQL Formatter for SSMS 22 - Setup Solution

This document describes the setup solution created for installing the Poor Man's T-SQL Formatter extension for SQL Server Management Studio 22 with proper Windows Installer integration.

## Created Files

### 1. Setup Project Structure
- `PoorMansTSqlFormatterSSMSPackage22.Setup/` - Main setup directory
- `PoorMansTSqlFormatterSSMSPackage22.Setup.action/` - Custom installer actions (if needed)

### 2. Installation Scripts
- `PoorMansTSqlFormatterSSMSPackage22.Setup/INSTALL_SSMS22.bat` - Installation script
- `PoorMansTSqlFormatterSSMSPackage22.Setup/UNINSTALL_SSMS22.bat` - Uninstallation script
- `BUILD_SSMS22_SETUP.bat` - Build script for creating the setup package

### 3. Project Files
- `PoorMansTSqlFormatterSSMSPackage22.Setup.action/PoorMansTSqlFormatterSSMSPackage22.Setup.action.csproj` - Custom actions project
- `PoorMansTSqlFormatterSSMSPackage22.Setup.action/SSMSPackageActions.cs` - Custom installer actions
- `PoorMansTSqlFormatterSSMSPackage22.Setup/PoorMansTSqlFormatterSSMSPackage22.Setup.wixproj` - WiX project (if WiX is available)
- `PoorMansTSqlFormatterSSMSPackage22.Setup/Product.wxs` - WiX installer definition

## Installation Process

### Quick Installation (Pre-built)
If you already have the extension built:
1. Copy all extension files (*.dll, *.vsix, *.pkgdef) to `PoorMansTSqlFormatterSSMSPackage22.Setup/`
2. Run `INSTALL_SSMS22.bat` as Administrator
3. Restart SSMS 22

### Full Build and Install
1. Ensure Visual Studio 2019/2022 is installed with:
   - .NET desktop development workload
   - Visual Studio extension development workload
   - .NET Framework 4.7.2 Developer Pack
2. Open Developer Command Prompt for Visual Studio
3. Navigate to the project root
4. Run: `BUILD_SSMS22_SETUP.bat`
5. Navigate to `PoorMansTSqlFormatterSSMSPackage22.Setup/`
6. Run `INSTALL_SSMS22.bat` as Administrator
7. Restart SSMS 22

## Features

### Windows Installer Integration
- Registers in Windows Apps & Features (Add/Remove Programs)
- Provides clean uninstall through Windows Settings
- Proper registry entries for uninstall tracking

### Extension Registration
- Copies extension files to SSMS 22 Extensions folder
- Triggers SSMS extension refresh mechanism
- Creates proper pkgdef entries

### Uninstallation
Two methods available:
1. Through Windows Settings > Apps > Apps & Features
2. Using UNINSTALL_SSMS22.bat script

## Extension Features After Installation

Once installed, the extension provides:
- **Tools Menu**: "Format T-SQL Code" option
- **Tools Menu**: "T-SQL Formatting Options"  
- **Keyboard Shortcut**: Ctrl+K, Ctrl+F for quick formatting
- Full integration with SSMS 22 editor

## Troubleshooting

### Extension doesn't appear after installation
1. Ensure SSMS 22 is completely closed (check Task Manager)
2. Restart SSMS 22
3. Verify files exist in: 
   `C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\PoorMansTSqlFormatter`

### Build errors
- Ensure Visual Studio 2019/2022 is installed with required workloads
- Use Developer Command Prompt for Visual Studio
- Verify .NET Framework 4.7.2 Developer Pack is installed

### Installation fails
- Run installation script as Administrator
- Ensure SSMS 22 is installed
- Check Windows Event Viewer for detailed error logs

## Technical Details

### Installation Paths
- SSMS 22 Extensions: `C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\`
- Extension Folder: `PoorMansTSqlFormatter\`
- Registry Key: `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22`

### Extension Refresh Mechanism
Creates/updates `extensions.configurationchanged` file to trigger SSMS extension discovery.

### Version Information
- Extension Version: 2.2.0.0
- Target Framework: .NET Framework 4.7.2
- Supported SSMS Versions: 21.0 - 23.0

## License

This extension is released under the GNU Affero General Public License (AGPL) version 3.0.

## Support

For issues, updates, and source code:
https://github.com/TaoK/PoorMansTSqlFormatter
