<#
.Synopsis
   This Function find the major version of Powershell
.EXAMPLE
   Get-PowerShellVersion
.EXAMPLE
   Get-PowerShellVersion -verbose
#>
function Get-PowerShellVersion {
   [CmdletBinding()]
   Param
   ()

   $Script:Version = $PSVersionTable.PSVersion.Major
   Write-Verbose "The module is running in Powershell $Version "

}
