function New-FreeNasIscsiExtent
{

    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (

        [Parameter (Mandatory = $true)]
        [string]$ExtentName,

        [Parameter (Mandatory = $true)]
        [ValidateSet("Disk", "File")]
        [String]$ExtenType,

        [Parameter (Mandatory = $true)]
        [ValidateSet("Unknown", "SSD", "5400", "7200", "10000", "15000")]
        $ExtentSpeed,


        [Parameter (Mandatory = $true)]
        [String]$ExtenDiskPath


    )


    Begin
    {

        if (  $script:SrvFreenas -eq $null -or $script:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }
    }

    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/extent/"


        $Obj = [Ordered]@{
            iscsi_target_extent_type = $ExtenType
            iscsi_target_extent_name = $ExtentName
            iscsi_target_extent_disk = $ExtenDiskPath
            iscsi_target_extent_rpm  = $ExtentSpeed

        }

        $post = $Obj |convertto-json 
        invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"

    }

    End
    {}
}
