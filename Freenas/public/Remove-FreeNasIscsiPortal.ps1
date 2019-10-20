function Remove-FreeNasIscsiPortal
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

    }
    Process
    {
        $Uri = "api/v1.0/services/iscsi/portal/$Id/"

        if ($PSCmdlet.ShouldProcess("will be remove" , "The Portal with the id $Id"))
        {
            $response = Invoke-FreeNasRestMethod -method Delete -body $post -Uri $Uri
        }
    }
    End
    {

    }
}
