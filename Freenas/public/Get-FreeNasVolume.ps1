function Get-FreeNasVolume
{
    Param

    ( )

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
        $Uri = "api/v1.0/storage/volume/"

        try { $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get }

        Catch { throw }

    }
    End
    {
        $FreenasVolume = New-Object System.Collections.ArrayList
        for ($i = 0; $i -lt $result.Count; $i++)
        {
            $temp = New-Object System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result[$i].Name)"
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].Id)"
            $temp | Add-Member -MemberType NoteProperty -Name "MountPoint" -Value "$($result[$i].mountpoint)"
            $temp | Add-Member -MemberType NoteProperty -Name "Status" -Value "$($result[$i].status)"
            $temp | Add-Member -MemberType NoteProperty -Name "Space_Used_GB" -Value "$([Math]::Round($result[$i].used/1024/1024/1024,4))"
            $temp | Add-Member -MemberType NoteProperty -Name "Space_Available_GB" -Value "$([Math]::Round($result[$i].avail/1024/1024/1024,2)) "

            $FreenasVolume.Add($temp) | Out-Null
        }


        return $FreenasVolume



    }
}
