<#
.SYNOPSIS
    This function return All Alerts for your FreeNas Server
.DESCRIPTION
    This function return All Alerts for your FreeNas Server
.EXAMPLE
    PS C:\> Get-FreeNasSystemAlert
Id        : 256ad2f48e5e541e28388701e34409cc
Level     : OK
Message   : The volume tank (ZFS) status is HEALTHY
Dismissed : false
#>
function Get-FreeNasSystemAlert
{
    Param( )

    $Uri = "api/v1.0/system/alert/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    foreach ($Alert in $results)
    {
        [PSCustomObject]@{
            Id        = ($Alert.id)
            Level     = ($Alert.level)
            Message   = ($Alert.message)
            Dismissed = ($Alert.dismissed)
        } | fl
    }
}
