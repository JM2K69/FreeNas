function Remove-FreeNasIscsiTargetGroup
{
    [CmdletBinding(SupportsShouldProcess)]
    [Alias()]
    Param
    (
        [Parameter (Mandatory = $true)]
        [Int]$Id
    )


    Begin
    {
        Get-FreeNasStatus
        switch ( $Script:status)
        {
            $true { $Uri = "/api/v1.0/services/iscsi/targetgroup/$Id/" }
            $false { Break }
        }
    }
    Process
    {

        if ($PSCmdlet.ShouldProcess("will be remove" , "The TargetGroup with the id $Id"))
        {
            $response = Invoke-FreeNasRestMethod -method Delete -body $post -Uri $Uri
        }

    }
    End
    {

    }
}
