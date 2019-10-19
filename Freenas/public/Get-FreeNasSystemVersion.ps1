<#
.SYNOPSIS
This function return inforamtions about your FreeNas server.
.DESCRIPTION
This function return inforamtions about your FreeNas server.
.EXAMPLE
    PS C:\> Get-FreeNasSystemVersion

    Name         : FreeNAS
    Full_version : FreeNAS-11.2-U2.1 (675d9aba9)
    Version      :
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-FreeNasSystemVersion {
    Param( )

    Get-FreeNasStatus
    switch ( $Script:status) {
        $true { }
        $false { Break }
    }

    $Uri = "api/v1.0/system/version/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    foreach ($Info in $results) {
        [PSCustomObject]@{
            Name         = ($Info.name)
            Full_version = ($Info.fullversion)
            Version      = ($Info.version)
        }
    }
}
