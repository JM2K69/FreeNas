function New-FreeNasIscsiTargetGroup
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (

        [Parameter (Mandatory = $True)]
        [Int]$TargetId,

        [Parameter (Mandatory = $True)]
        [Int]$TargetPortalGroup

    )


    Begin {

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/targetgroup/"

        $Obj = [Ordered]@{
            iscsi_target                = $TargetId
            iscsi_target_authgroup      = $null
            iscsi_target_authtype       = "None"
            iscsi_target_portalgroup    = $TargetPortalGroup
            iscsi_target_initiatorgroup = "1"
            iscsi_target_initialdigest  = "Auto"
        }

        $response = Invoke-FreeNasRestMethod -method Post -body $Obj -Uri $Uri

    }
    End
    {

    }
}
