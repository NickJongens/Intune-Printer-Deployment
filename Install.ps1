# ------------ MEM VARIABLES ----------------
[CmdletBinding()]
param
(
    [Parameter()]
    [String] $PrinterPortIPAddress = "IP Address",
    [Parameter()]
    [String] $PrinterPortName = "Intune Deployed - Company - IP Address",
    [Parameter()]
    [String] $PrinterName = "Printer Name",
    [Parameter()]
    [String] $PrinterDriverModelName = "Brother HL-L2350DW series",
    [Parameter()]
    [String] $PrinterDriverZipFileName = "Brother_HL_L2350DW.zip",
    [Parameter()]
    [String] $PrinterDriverModelFileName = "BROHL17A.INF", # Driver file used in 'have disk' prompt.
    [Parameter()]
    [String] $ConfigFilePath = $null  # parameter for config.dat file.
)

[bool] $ExitWithError = $true
[bool] $ExitWithNoError = $false

function Update-OutputOnExit
{
    param
    (
        [bool] $F_ExitCode,
        [String] $F_Message
    )
    
    Write-Host "STATUS=$F_Message" -ErrorAction SilentlyContinue

    if ($F_ExitCode)
    {
        exit 1
    }
    else
    {
        exit 0
    }
}

function Test-PrinterPortExists
{
    param
    (
        [String] $PrinterFPortName
    )
    
    if (Get-PrinterPort | Where-Object {$_.Name -like "*$($PrinterFPortName)*"})
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Test-PrinterExists
{
    param
    (
        [String] $PrinterFName
    )    

    if (Get-Printer -Name $PrinterFName -ErrorAction SilentlyContinue)
    {
        return $true
    }
    else
    {
        return $false
    }
}

# Installing the Driver
Expand-Archive -Path "$PSScriptRoot\$PrinterDriverZipFileName" -DestinationPath "$PSScriptRoot\" -Force
If (Test-Path -Path "$PSScriptRoot\Driver")
{
    try
    {
        cscript "C:\Windows\System32\Printing_Admin_Scripts\en-US\prndrvr.vbs" -a -m $PrinterDriverModelName -i "$PSScriptRoot\Driver\$PrinterDriverModelFileName" -h "$PSScriptRoot\Driver" -v 3
    }
    catch
    {
        Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
    }
}
else
{
    Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
}

# Installing the Printer Port
if (!(Test-PrinterPortExists -PrinterFPortName $PrinterPortName))
{
    try
    {
        Add-PrinterPort -Name $PrinterPortName -PrinterHostAddress $PrinterPortIPAddress -PortNumber 9100
    }
    catch
    {
        Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
    }
}
else
{
    write-host "$PrinterPortName already exists in the system!"
}

# Installing the Printer
if (!(Test-PrinterExists -PrinterFName $PrinterName))
{
    try
    {
        Add-Printer -Name $PrinterName -PortName $PrinterPortName -DriverName $PrinterDriverModelName
    }
    catch
    {
        Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
    }
}
else
{
    write-host "$PrinterName already exists in the system!"
}

# Install configuration if -ConfigFilePath parameter is passed
if ($ConfigFilePath) {
    try {
        & "printui.exe" /Sr /n "$PrinterName" /a "$ConfigFilePath"
        Write-Host "Printer configuration applied from $ConfigFilePath."
    }
    catch {
        Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "Configuration installation failed"
    }
}

Update-OutputOnExit -F_ExitCode $ExitWithNoError -F_Message "SUCCESS"
