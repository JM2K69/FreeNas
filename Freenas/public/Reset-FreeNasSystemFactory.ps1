<#
.SYNOPSIS
Reset to the default factory your FreeNas server
.DESCRIPTION
Reset to the default factory your FreeNas server a reboot is necessary
.EXAMPLE
    PS C:\> Reset-FreeNasSystemFactory | Stop-FreeNasSystem
#>
function Reset-FreeNasSystemFactory {
    Param( )

    $Uri = "api/v1.0/system/config/factory_restore/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Post

    $results
}
