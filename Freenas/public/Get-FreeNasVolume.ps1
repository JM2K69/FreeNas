function Get-FreeNasVolume
{
    Param

    ( )

    Begin
    {

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/storage/volume/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $FreenasVolume = New-Object System.Collections.ArrayList

        if ($null -eq $result.count)
        {
            $temp = New-Object System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result.Name)"
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result.Id)"
            $temp | Add-Member -MemberType NoteProperty -Name "MountPoint" -Value "$($result.mountpoint)"
            $temp | Add-Member -MemberType NoteProperty -Name "Status" -Value "$($result.status)"
            $temp | Add-Member -MemberType NoteProperty -Name "Space_Used_GB" -Value "$([Math]::Round($result.used/1024/1024/1024,4))"
            $temp | Add-Member -MemberType NoteProperty -Name "Space_Available_GB" -Value "$([Math]::Round($result.avail/1024/1024/1024,2)) "

            $FreenasVolume.Add($temp) | Out-Null

        }
        else
        {
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

        }


        return $FreenasVolume
             


    }
}
