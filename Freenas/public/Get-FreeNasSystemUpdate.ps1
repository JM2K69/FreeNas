<#
.SYNOPSIS
    This Function permit ta find Update for your FreeNas Server
.DESCRIPTION
This Function permit ta find Update for your FreeNas Server
.EXAMPLE
    PS C:\> Get-FreeNasSystemUpdate
    This function return all updates if they are available for your system
.NOTES
#>
function Get-FreeNasSystemUpdate {
    Param( )

    Get-FreeNasStatus
    switch ( $Script:status) {
        $true { }
        $false { Break }
    }

    $Uri = "api/v1.0/system/update/check/"
    try {
        $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get
    }
    Catch {
        Write-Warning "Error querying the NAS using URI $Uri"
        return
    }

    return $results
}
