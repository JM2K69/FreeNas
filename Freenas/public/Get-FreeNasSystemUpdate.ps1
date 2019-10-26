﻿<#
.SYNOPSIS
    This Function permit ta find Update for your FreeNas Server
.DESCRIPTION
This Function permit ta find Update for your FreeNas Server
.EXAMPLE
    PS C:\> Get-FreeNasSystemUpdate
    This function return all updates if they are available for your system
.NOTES
#>
function Get-FreeNasSystemUpdate
{
    Param( )

    $Uri = "api/v1.0/system/update/check/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    return $results
}
