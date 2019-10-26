﻿function New-FreeNasVolume
{

    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (

        [Parameter (Mandatory = $true)]
        [string]$VolumeName,

        [Parameter (Mandatory = $true)]
        [ValidateSet("stripe", "mirror", "raidz", "raidz2", "raidz3")]
        [String]$Vdevtype,

        [Parameter (Mandatory = $False)]
        [String]$DiskNamebase = "da",


        [Parameter (Mandatory = $true)]
        [Int]$NbDisks,

        [Parameter (Mandatory = $false)]
        [Int]$StartDisksNB = 1


    )


    Begin
    {

    }

    Process
    {

        $FreenasVolume = @()
       
        $StartDisksNB..$($StartDisksNB + $NbDisks - 1) | Foreach-Object { $freenasvolume += "$DiskNamebase$_"}       
        
        $Uri = "http://$script:SrvFreenas/api/v1.0/storage/volume/"


        $Uri = "api/v1.0/storage/volume/"

        $Obj = [Ordered]@{
            volume_name = $VolumeName
            layout      = @(@{
                    vdevtype = $Vdevtype
                    disks    = $FreenasVolume
                })
           
        }

        $response = Invoke-FreeNasRestMethod -Method Post -body $Obj -Uri $uri

        $post = $Obj |convertto-json -Depth 3

        $response = invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"

    }

    End
    {}
}
