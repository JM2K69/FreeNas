<#
.SYNOPSIS
Reset to the default factory your FreeNas server
.DESCRIPTION
Reset to the default factory your FreeNas server a reboot is necessary
.EXAMPLE
    PS C:\> Reset-FreeNasSystemFactory | Stop-FreeNasSystem
#>
function Reset-FreeNasSystemFactory
{
    Param( )

    Get-FreeNasStatus
    switch ( $Script:status)
    {
        $true {  }
        $false {Break}
    }

    $Uri = "http://$Script:SrvFreenas/api/v1.0/system/config/factory_restore/"
    try
    {
        $results = Invoke-RestMethod -Uri $Uri -WebSession $Script:Session -Method Post
    }
    Catch
    {
        Write-Warning "Error querying the NAS using URI $Uri"
        return
    }

    $results
}
