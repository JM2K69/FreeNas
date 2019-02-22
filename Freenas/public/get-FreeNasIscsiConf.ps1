function Get-FreeNasIscsiConf
{
    Param
    ( )

    Begin
    {
        if (  $script:SrvFreenas -eq $null -or $script:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/scriptconfiguration/"

        try { $result = Invoke-RestMethod -Uri $Uri -WebSession $script:Session -Method Get }

        Catch {}

    }
    End
    {
        $IscsiConf = New-Object System.Collections.ArrayList

        $temp = New-Object PSObject
        $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value $result.id
        $temp | Add-Member -MemberType NoteProperty -Name "Base Name" -Value $result.iscsi_basename
        $temp | Add-Member -MemberType NoteProperty -Name "ISNS Server" -Value $result.iscsi_isns_servers
        $temp | Add-Member -MemberType NoteProperty -Name "Pool available space Threshold (%)" -Value $result.iscsi_pool_avail_threshold

        $IscsiConf.Add($temp) | Out-Null


        return $IscsiConf | fl
    }
}
