﻿function Set-FreeNasDedupZvol
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
        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }

    }
    Process
    {
        $Uri = "http://$global:SrvFreenas/api/v1.0/storage/volume/$VolumeName/zvols/$ZvolName/"

         
        $Dedup = new-Object -TypeName PSObject

        $Dedup | add-member -name "dedup" -membertype NoteProperty -Value "on"
        $Dedup | add-member -name "force" -membertype NoteProperty -Value "true"


        $post = $Dedup |ConvertTo-Json

        $response = invoke-RestMethod -method Put -body $post -Uri $Uri -WebSession $global:Session -ContentType "application/json"

    }
    End
    {
             
    }
}
