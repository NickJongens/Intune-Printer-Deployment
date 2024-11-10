[CmdletBinding()]
param
(
    [Parameter()]
    [String] $PrinterName = $null,
    [Parameter()]
    [String] $PrinterPortName = $null
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
try 
{
    Remove-Printer -Name $PrinterName -ErrorAction SilentlyContinue
    Remove-PrinterPort -Name $PrinterPortName -ErrorAction SilentlyContinue
}
catch 
{
    Update-OutputOnExit -F_ExitCode $ExitWithError -F_Message "FAILED"
}
