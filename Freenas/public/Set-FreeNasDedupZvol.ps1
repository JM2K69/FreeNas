function Set-FreeNasDedupZvol
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter (Mandatory = $true)]
        [string]$VolumeName,

        [Parameter (Mandatory = $true)]
        [string]$ZvolName


    )


    Begin
    {

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/storage/volume/$VolumeName/zvols/$ZvolName/"

        $Dedup = new-Object -TypeName PSObject

        $Dedup | add-member -name "dedup" -membertype NoteProperty -Value "on"
        $Dedup | add-member -name "force" -membertype NoteProperty -Value "true"

        $response = Invoke-FreeNasRestMethod -method Put -body $Dedup -Uri $Uri

        $response = invoke-RestMethod -method Put -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"

    }
    End
    {
             
    }
}
