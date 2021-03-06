<#
.SYNOPSIS
Install-Winlogbeat downloads Winlogbeat and installs Winlogbeat
with a configuration file.
.DESCRIPTION
PowerShell script or module to install Winlogbeat with configuration
.PARAMETER path
The path to the working directory.  Default is user Documents.
.EXAMPLE
Install-Winlogeat.ps1 -path C:\Users\example\Desktop
#>

[CmdletBinding()]

#Establish parameters for path
param (
    [string]$path=[Environment]::GetFolderPath("Desktop")   
)

#Test path and create it if required

If(!(test-path $path))
{
	Write-Information -MessageData "Path does not exist.  Creating Path..." -InformationAction Continue;
	New-Item -ItemType Directory -Force -Path $path | Out-Null;
	Write-Information -MessageData "...Complete" -InformationAction Continue
}

Set-Location $path

Write-Host "Location set $path"

Write-Host "Retrieving Winlogbeat..."

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-Webrequest -Uri https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-6.6.0-windows-x86_64.zip -Outfile winlogbeat-6.6.0-windows-x86_64.zip

Write-Host "Winlogbeat Retrieved."

Write-Host "Retrieving Winlogbeat Configuration File..."

Invoke-WebRequest -Uri https://raw.githubusercontent.com/lock-wire/Install-Winlogbeat/master/winlogbeat.yml -OutFile winlogbeat.yml

Write-Host "Configuration File Retrieved."

Write-Host "Unzip Winlogbeat..."

Expand-Archive .\winlogbeat-6.6.0-windows-x86_64.zip -DestinationPath 'C:\Program Files\'

Rename-Item -Path 'C:\Program Files\winlogbeat-6.6.0-windows-x86_64' -NewName 'C:\Program Files\Winlogbeat' -force

Copy-Item winlogbeat.yml -Destination 'C:\Program Files\Winlogbeat\' -force

Write-Host "Unzip Complete.  Configuration File moved to C:\Program Files\Winlogbeat\"

Set-Location -Path 'C:\Program Files\Winlogbeat\'

Write-Host "Installing Winlogbeat..."

.\install-service-winlogbeat.ps1

Start-Service winlogbeat

Write-Host "Winlogbeat Installed!"
