<#
.SYNOPSIS
Update your FreeNas Server
.DESCRIPTION
This function download all available update for your system and perform update
.EXAMPLE
    PS C:\> Update-FreeNasSystem
#>
function Update-FreeNasSystem
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param( )

    Get-FreeNasStatus
    switch ( $Script:status)
    {
        $true { }
        $false { Break }
    }

    $Uri = "api/v1.0/system/update/update/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Post

    return $results
}
