# Printer Installation Script

This PowerShell script installs a printer with specified configurations, including setting up a printer port, driver, and optionally applying a configuration file for additional settings.

## Prerequisites

- Ensure that you have administrative rights to run this script, or are running in the System Context.
- Place the required printer drivers in a `Driver` folder file containing the .inf, .cat files within a `.zip`. The install script unzips the Driver folder.
- There are some drivers already provided (e.g., `Brother_HL_L2350DW.zip`) with the correct structure - please follow these.
- If using a configuration file, prepare the `config.dat` file with the required printer settings using `printui.exe`

## Parameters

The script accepts the following parameters:

- **`-PrinterPortIPAddress`** (String)  
  IP address of the printer to be installed.  
  _Default_: `"10.195.100.200"`

- **`-PrinterPortName`** (String)  
  Name of the printer port to be created.  
  _Default_: `"Intune Deployed - Company - 10.195.100.200"`

- **`-PrinterName`** (String)  
  Name of the printer to be installed.  
  _Default_: `"Upstairs Printer"`

- **`-PrinterDriverModelName`** (String)  
  Model name of the printer driver.  
  _Default_: `"Brother HL-L2350DW series"`

- **`-PrinterDriverZipFileName`** (String)  
  Name of the ZIP file containing the printer driver.  
  _Default_: `"Brother_HL_L2350DW.zip"`

- **`-PrinterDriverModelFileName`** (String)  
  Model file (usually a `.INF` file) for the printer driver.  
  _Default_: `"BROHL17A.INF"`

- **`-ConfigFilePath`** (String, Optional)  
  Path to the printer configuration file (e.g., `config.dat`). If specified, the script will apply this configuration using `printui.exe`.

## Usage

Run the script using PowerShell with the required parameters. Ensure to add as a System context app.

### Install

powershell.exe -ExecutionPolicy Bypass -File Install.ps1 **-PrinterPortIPAddress** "10.195.100.200" **-PrinterPortName** "Intune Deployed - Company - 10.195.100.200" **-PrinterName** "Upstairs Printer" **-PrinterDriverModelName** "Brother HL-L2350DW series" **-PrinterDriverZipFileName** "Brother_HL_L2350DW.zip" **-PrinterDriverModelFileName** "BROHL17A.INF"

### Installation with config file

powershell.exe -ExecutionPolicy Bypass -File Install.ps1 **-PrinterPortIPAddress** "10.195.100.200" **-PrinterPortName** "Intune Deployed - Company - 10.195.100.200" **-PrinterName** "Upstairs Printer" **-PrinterDriverModelName** "Brother HL-L2350DW series" **-PrinterDriverZipFileName** "Brother_HL_L2350DW.zip" **-PrinterDriverModelFileName** "BROHL17A.INF" **-ConfigFilePath** "config.dat"

## Detection

The script detects whether the printer is successfully installed by checking if the Windows registry key for the printer name exists: (If Exists)

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\

Key: Upstairs Printer
```

## Uninstallation

To uninstall the printer and printer port, run the script with the following parameters:

powershell.exe -ExecutionPolicy Bypass -File Uninstall.ps1 **-PrinterName** "Upstairs Printer" **-PrinterPortName** "Intune Deployed - Company - 10.195.100.200"

## Notes

- **Registry Detection**: The script checks for the registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\$PrinterName` to detect if the printer is already installed. If this key exists, the printer is considered installed, eliminating the need for an additional detection script.

- **Configuration File**: If you choose to use a configuration file (`config.dat`), ensure that the file is correctly formatted and available on the system before running the script.
