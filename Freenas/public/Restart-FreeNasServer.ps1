function Restart-FreeNasServer
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [Alias()]
    Param
    (
    )


    Begin {

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/system/reboot/"

        $post = invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"

    }
    End
    {}
}
