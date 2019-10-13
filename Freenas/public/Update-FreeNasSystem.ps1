<#
.SYNOPSIS
Update your FreeNas Server
.DESCRIPTION
This function download all available update for your system and perform update
.EXAMPLE
    PS C:\> Update-FreeNasSystem
#>
function Update-FreeNasSystem {
    Param( )

    Get-FreeNasStatus
    switch ( $Script:status) {
        $true { }
        $false { Break }
    }

    $Uri = "http://$Script:SrvFreenas/api/v1.0/system/update/update/"
    try {
        $results = Invoke-RestMethod -Uri $Uri -WebSession $Script:Session -Method Post
    }
    Catch {
        Write-Warning "Error querying the NAS using URI $Uri"
        return
    }

    return $results
}
