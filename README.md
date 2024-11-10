# Intune Printer Installation Script

This PowerShell script installs a printer with specified configurations. 
Where other scripts deploy the printer, this script is more complete and also allows for uninstallation and optionally applying a configuration file for additional settings.

## Prerequisites

- Ensure that you have administrative rights to run this script, or are running in the System Context.
- Place the required printer drivers in a `Driver` folder file containing the .inf, .cat files within a `.zip`. The install script unzips the Driver folder.
- There are some drivers already provided (e.g., `Brother_HL_L2350DW.zip`) with the correct structure - please follow these.
- If using a configuration file, prepare the `config.dat` file with the required printer settings using `printui.exe`

## Parameters

The script accepts the following parameters:

- **`-PrinterPortIPAddress`** (String)  
  IP address of the printer to be installed.  
  _Example_: `"10.195.100.200"`

- **`-PrinterPortName`** (String)  
  Name of the printer port to be created.  
  _Example_: `"Intune Deployed - Company - 10.195.100.200"`

- **`-PrinterName`** (String)  
  Name of the printer to be installed.  
  _Example_: `"Upstairs Printer"`

- **`-PrinterDriverModelName`** (String)  
  Model name of the printer driver.  
  _Example_: `"Brother HL-L2350DW series"`

- **`-PrinterDriverZipFileName`** (String)  
  Name of the ZIP file containing the printer driver.  
  _Example_: `"Brother_HL_L2350DW.zip"`

- **`-PrinterDriverModelFileName`** (String)  
  Model file (usually a `.INF` file) for the printer driver.  
  _Example_: `"BROHL17A.INF"`

- **`-ConfigFilePath`** (String, Optional)  
  Path to the printer configuration file (e.g., `config.dat`). If specified, the script will apply this configuration using `printui.exe`.

## Config File Creation

You can export a printer config using the following command:
```
rundll32 printui.dll,PrintUIEntry /Ss /n "Upstairs Printer" /a "config.dat"
```
This should be placed in the root of the main folder you're packaging the script in.

## Packaging

  1. Download the Microsoft Win32 Content Prep Tool into a place you can access using CMD, PowerShell or Terminal.
     https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool
     
  2. Place the script (e.g., Install.ps1) and any supporting files (e.g., printer drivers, configuration files) into a single folder. e.g. C:\IntunePrinterDeployment

     For example, your folder might look like this:

     ```
     C:\IntunePrinterDeployment
     ├── Install.ps1
     ├── Unnstall.ps1 
     ├── config.dat # this is not required
     └── Brother_HL_L2350DW.zip # Driver files

     Your 'Brother_HL_L2350DW.zip' could look like this (but doesn't have to be exact):
     ── Brother_HL_L2350DW.zip
        └──Driver
          └── x64
          └── x86  
          └──BROHL17A.INF
          └──BROHL17A.cat
          └──dpinstx64.exe
     ```
  3. Run the IntuneWinAppUtil.exe from your favourite shell e.g.
     ```
     cmd.exe
     "C:\Users\<Username>\Downloads\IntuneWinAppUtil.exe"
   	 ```
     
  4. Select the source folder e.g.
     ```
     C:\IntunePrinterDeployment
     ```
     
  5. Set the 'Setup File' to:
     ```
     Install.ps1
     ``` 

  7. Set the output folder - easily press up twice, then add '\Output' to the source folder path:
     ```
     C:\IntunePrinterDeployment\Output
     ```
     
  8. Create the Output folder - specify 'Y'

  9. For the catalogue - specify 'N'

You now have an .IntuneWin file you can upload to Intune.
     
## Usage

Run the script using PowerShell with the required parameters. Ensure to add as a System context app.

### Install

powershell.exe -ExecutionPolicy Bypass -File Install.ps1 **-PrinterPortIPAddress** "10.195.100.200" **-PrinterPortName** "Intune Deployed - Company - 10.195.100.200" **-PrinterName** "Upstairs Printer" **-PrinterDriverModelName** "Brother HL-L2350DW series" **-PrinterDriverZipFileName** "Brother_HL_L2350DW.zip" **-PrinterDriverModelFileName** "BROHL17A.INF"

### Installation with config file

powershell.exe -ExecutionPolicy Bypass -File Install.ps1 **-PrinterPortIPAddress** "10.195.100.200" **-PrinterPortName** "Intune Deployed - Company - 10.195.100.200" **-PrinterName** "Upstairs Printer" **-PrinterDriverModelName** "Brother HL-L2350DW series" **-PrinterDriverZipFileName** "Brother_HL_L2350DW.zip" **-PrinterDriverModelFileName** "BROHL17A.INF" **-ConfigFilePath** "config.dat"

## Detection

The script detects whether the printer is successfully installed by checking if the Windows registry key for the printer name exists: (If Exists)

```
Registry
Key Path: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\<PrinterName> (Replace with your printer's name)
Value name: Name
Detection method: String
Operator: Equals
Value: <PrinterName> (Replace with your printer's name)

OR If you want to change the port/ip being used:

Registry
Path: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\<PrinterName> (Replace with your printer's name)
Value name: Port
Detection method: String
Operator: Equals
Value: <PrinterPortName> (Replace with your printer's Port name e.g. 'Intune Deployed - Company - 10.195.100.201' if you want to change the IP)
Don't forget to update your install command.

```

## Uninstallation

To uninstall the printer and printer port, run the script with the following parameters:

powershell.exe -ExecutionPolicy Bypass -File Uninstall.ps1 **-PrinterName** "Upstairs Printer" **-PrinterPortName** "Intune Deployed - Company - 10.195.100.200"

## Notes

- **Registry Detection**: The script checks for the registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\$PrinterName` to detect if the printer is already installed. If this key exists, the printer is considered installed, eliminating the need for an additional detection script.

- **Configuration File**: If you choose to use a configuration file (`config.dat`), ensure that the file is correctly formatted and available on the system before running the script.
