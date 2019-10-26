﻿function New-FreenasIscsiPortal
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter (Mandatory = $true)]
        $IpPortal,

        [Parameter (Mandatory = $false)]
        [string]$Port = 3260 ,

 
        [Parameter (Mandatory = $false)]
        [string]$Comment



    )


    Begin {

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/portal/"

        $input = @($IpPortal + ":" + $Port)

        $IpPortalPort = @()

        foreach ($item in $input)
        {
            $IpPortalPort += $item
        }

        $Obj = [Ordered]@{
            iscsi_target_portal_ips     = $IpPortalPort
            iscsi_target_portal_comment = $Comment
        }

        $post = $Obj |ConvertTo-Json
        $response = invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"

    }
    End
    {

    }
}
