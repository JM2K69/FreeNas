<#
.SYNOPSIS
    This function return Advanced Informations about your FreeNas Server
.DESCRIPTION
    This function return Advanced Informations about your FreeNas Server
.EXAMPLE
    PS C:\> Get-FreeNasSystemAdvanced
#>
function Get-FreeNasSystemAdvanced
{
    Param( )

    $Uri = "api/v1.0/system/advanced/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    foreach ($Info in $results)
    {
        [PSCustomObject]@{
            Advanced_mode           = ($Info.adv_advancedmode)
            Advanced_Autotune       = ($Info.adv_autotune)
            MOTD_Banner             = ($Info.adv_motd)
            Advanced_Sawp_on_disk   = ($Info.adv_swapondrive)
            Advanced_Serial_Console = ($Info.adv_serialconsole)
            Advanced_Serial_port    = ($Info.adv_serialport)
            Advanced_Serial_speed   = ($Info.adv_serialspeed)

        }
    }
}
