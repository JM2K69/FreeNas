function Get-FreeNasSystemEmail
{
    [Alias()]
    Param
    ()

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
        $Uri = "http://$script:SrvFreenas/api/v1.0/system/email/"

        try
        { 
            $result = Invoke-RestMethod -Uri $Uri -WebSession $script:Session -Method Get

        }

        Catch {}

        $FreeNasConf = New-Object System.Collections.ArrayList
        
        $temp = New-Object PSObject
        $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value $result.id
        $temp | Add-Member -MemberType NoteProperty -Name "From_Email" -Value $result.em_fromemail
        $temp | Add-Member -MemberType NoteProperty -Name "Outgoing_Mail_Server" -Value $result.em_outgoingserver
        $temp | Add-Member -MemberType NoteProperty -Name "Port" -Value $result.em_port
        $temp | Add-Member -MemberType NoteProperty -Name "SMTP" -Value $result.smtp
        $temp | Add-Member -MemberType NoteProperty -Name "User" -Value $result.em_user
        $temp | Add-Member -MemberType NoteProperty -Name "Security" -Value $result.em_security


        $FreeNasConf.Add($temp) | Out-Null
        

        return $FreeNasConf | fl


    }
    End {}
}
