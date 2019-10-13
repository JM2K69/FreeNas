<#
.SYNOPSIS
Shutdown your FreeNas server.
.DESCRIPTION
Shutdown your FreeNas server.
.EXAMPLE
    PS C:\> Stop-FreeNasSystem
#>
function Stop-FreeNasSystem {
    Param( )

    Get-FreeNasStatus
    switch ( $Script:status) {
        $true { }
        $false { Break }
    }

    $Uri = "http://$Script:SrvFreenas/api/v1.0/system/shutdown/"
    try {
        $results = Invoke-RestMethod -Uri $Uri -WebSession $Script:Session -Method Post
    }
    Catch {
        Write-Warning "Error querying the NAS using URI $Uri"
        return
    }

    return $results
}
