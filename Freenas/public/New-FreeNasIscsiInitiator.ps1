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


    Begin
    {
        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }

    }
    Process
    {
        $Uri = "http://$global:SrvFreenas/api/v1.0/services/iscsi/authorizedinitiator/"



        $Obj = [Ordered]@{
            iscsi_target_initiator_initiators   = $AuthInitiators
            iscsi_target_initiator_auth_network = $AuthNetwork
        }
    
        $response = invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $global:Session -ContentType "application/json"


    }
    End
    {}
}
