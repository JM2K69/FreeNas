function Get-FreeNasSystemNTP
{
    [Alias()]
    Param
    ()

    Begin
    {

    }
    Process
    {
        $Uri = "api/v1.0/system/ntpserver/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $FreenasConf = New-Object -TypeName System.Collections.ArrayList
        for ($i = 0; $i -lt $result.Count; $i++)
        {

            $temp = New-Object -TypeName System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_Server" -Value "$($result[$i].ntp_address)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_Burst" -Value "$($result[$i].ntp_burst)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_iBurst" -Value "$($result[$i].ntp_iburst)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_Max_Poll" -Value "$($result[$i].ntp_maxpoll)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_Prefrer" -Value "$($result[$i].ntp_prefer)"
            $FreenasConf.Add($temp) | Out-Null
        }

        return $FreenasConf | FT

    }
    End { }
}
