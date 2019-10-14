<#
.SYNOPSIS
Shutdown your FreeNas server.
.DESCRIPTION
Shutdown your FreeNas server.
.EXAMPLE
    PS C:\> Stop-FreeNasSystem
#>
function Stop-FreeNasSystem
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param( )

    Get-FreeNasStatus
    switch ( $Script:status)
    {
        $true { }
        $false { Break }
    }

    $Uri = "api/v1.0/system/shutdown/"
    try
    {
        $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Post
    }
    Catch
    {
        Write-Warning "Error querying the NAS using URI $Uri"
        return
    }

    return $results
}
