function Remove-FreeNasIscsiAssociat2Extent
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

        $Uri = "api/v1.0/services/iscsi/extent/$Id/"

        if ($PSCmdlet.ShouldProcess("will be remove" , "The Association to Exent with the id $Id"))
        {
            $response = Invoke-FreeNasRestMethod -method Delete -body $post -Uri $Uri
        }

    }
    End
    {

    }
}
