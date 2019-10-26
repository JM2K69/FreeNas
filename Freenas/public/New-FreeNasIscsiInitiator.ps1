function New-FreeNasIscsiInitiator
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (

        [Parameter (Mandatory = $False)]
        [ValidateSet("ALL")]
        [string]$AuthInitiators,

        [Parameter (Mandatory = $False)]
        [ValidateSet("ALL")]
        [String]$AuthNetwork

    )


    Begin {

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/authorizedinitiator/"

        $Obj = [Ordered]@{
            iscsi_target_initiator_initiators   = $AuthInitiators
            iscsi_target_initiator_auth_network = $AuthNetwork
        }
        
        $post = $Obj |ConvertTo-Json

        $response = Invoke-FreeNasRestMethod -method Post -body $Obj -Uri $Uri

    }
    End
    {

    }
}
