function New-FreeNasIscsiAssociat2Extent
{

    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (

        [Parameter (Mandatory = $true)]
        [INT]$TargetId,

        [Parameter (Mandatory = $true)]
        [INT]$ExtentId

    )


    Begin
    {

    }

    Process
    {
        $Uri = "api/v1.0/services/iscsi/targettoextent/"

        $Obj = [Ordered]@{
            iscsi_target = $TargetId
            iscsi_extent = $ExtentId
            iscsi_lunid  = 0

        }

        $result = Invoke-FreeNasRestMethod -method Post -body $Obj -Uri $Uri

    }

    End
    { }
}
