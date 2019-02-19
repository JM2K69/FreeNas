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

        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }
    }

    Process
    {
        $Uri = "http://$global:SrvFreenas/api/v1.0/services/iscsi/targettoextent/"

        $Obj = [Ordered]@{
            iscsi_target = $TargetId
            iscsi_extent = $ExtentId
            iscsi_lunid  = 0

        }

        $post = $Obj |convertto-json 

        $result = invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $global:Session -ContentType "application/json"

    }

    End
    {}
}
