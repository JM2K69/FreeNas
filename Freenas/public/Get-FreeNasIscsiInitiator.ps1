function Get-FreeNasIscsiInitiator
{
    Param
    ( )


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
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/authorizedinitiator/"

        try { $result = Invoke-RestMethod -Uri $Uri -WebSession $script:Session -Method Get }
       
        Catch {}


        $Obj = New-Object System.Collections.ArrayList
       
        $temp = New-Object System.Object
        $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value $result.id            
        $temp | Add-Member -MemberType NoteProperty -Name "Initiator" -Value $result.iscsi_target_initiator_initiators
        $temp | Add-Member -MemberType NoteProperty -Name "Auth Network" -Value $result.iscsi_target_initiator_auth_network
        $temp | Add-Member -MemberType NoteProperty -Name "Comments" -Value $result.iscsi_target_initiator_comment
            
        $Obj.Add($temp) | Out-Null
        
    

        return $Obj
             

    }
    End
    {}
}
