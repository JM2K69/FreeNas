function Get-FreeNasZvol
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter (Mandatory = $true)]
        [string]$VolumeName

    )


    Begin
    {
        Get-FreeNasStatus
        switch ( $Script:status)
        {
            $true {  }
            $false {Break}
        }

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/storage/volume/$VolumeName/zvols/"

        try { $result = Invoke-RestMethod -Uri $Uri -WebSession $script:Session -Method Get }
       
        Catch {}

    }
    End
    {
        $ZVolume = New-Object System.Collections.ArrayList
       
        for ($i = 0; $i -lt $result.Count; $i++)
        {
            $temp = New-Object System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result[$i].Name)"
            $temp | Add-Member -MemberType NoteProperty -Name "Comments" -Value "$($result[$i].comments)"
            $temp | Add-Member -MemberType NoteProperty -Name "Deduplication" -Value "$($result[$i].dedup)"
            $temp | Add-Member -MemberType NoteProperty -Name "Compression" -Value "$($result[$i].compression)"
            $temp | Add-Member -MemberType NoteProperty -Name "Space Used in GB" -Value "$([Math]::Round($result[$i].used /1024/1024/1024,4))"
            $temp | Add-Member -MemberType NoteProperty -Name "Volume Size in GB" -Value "$([Math]::Round($result[$i].volsize /1024/1024/1024,2)) "
            
            $ZVolume.Add($temp) | Out-Null
        }
    

        return $ZVolume
             


    }
}
