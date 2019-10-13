﻿function Set-FreeNasIscsiPortal {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter (Mandatory = $true)]
        [Int]$Id,

        [Parameter (Mandatory = $true)]
        $IpPortal,

        [Parameter (Mandatory = $false)]
        [string]$Port = 3260 ,


        [Parameter (Mandatory = $true)]
        [ValidateSet("None", "Auto", "CHAP", "CHAP Mutual")]
        [String]$DiscoveryAuthMethod

    )


    Begin {
        Get-FreeNasStatus
        switch ( $Script:status) {
            $true { }
            $false { Break }
        }

    }
    Process {
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/portal/$Id/"
        $input = @($IpPortal + ":" + $Port)

        $IpPortalPort = @()
        $IpPortalPort += $input

        $Obj = [Ordered]@{
            iscsi_target_portal_ips                 = $IpPortalPort
            iscsi_target_portal_discoveryauthmethod = $DiscoveryAuthMethod
        }

        $post = $Obj | ConvertTo-Json
        $post
        $response = invoke-RestMethod -method Put -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"

    }
    End {

    }
}
