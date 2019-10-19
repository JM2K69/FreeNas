function Get-FreeNasIscsiPortal
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
        $Uri = "api/v1.0/services/iscsi/portal/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $Obj = New-Object System.Collections.ArrayList
        $temp = New-Object System.Object
        $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value $result.id
        if ($null -eq $result.iscsi_target_portal_ips)
        {

        }
        else
        {
            $temp | Add-Member -MemberType NoteProperty -Name "Portal IPs" -Value $($result.iscsi_target_portal_ips).Split(":")[0]
            $temp | Add-Member -MemberType NoteProperty -Name "Portal ports" -Value $($result.iscsi_target_portal_ips).Split(":")[1]
            $temp | Add-Member -MemberType NoteProperty -Name "Portal Discovery Method" -Value $result.iscsi_target_portal_discoveryauthmethod

            $Obj.Add($temp) | Out-Null
        }

        return $Obj


    }
    End
    { }
}
