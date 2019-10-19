function Set-FreeNasDedupZvol
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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
        Get-FreeNasStatus
        switch ( $Script:status)
        {
            $true { }
            $false { Break }
        }
    }
    Process
    {
        $Uri = "api/v1.0/storage/volume/$VolumeName/zvols/$ZvolName/"

        $Dedup = new-Object -TypeName PSObject

        $Dedup | add-member -name "dedup" -membertype NoteProperty -Value "on"
        $Dedup | add-member -name "force" -membertype NoteProperty -Value "true"

        $response = Invoke-FreeNasRestMethod -method Put -body $Dedup -Uri $Uri

    }
    End
    {

    }
}
