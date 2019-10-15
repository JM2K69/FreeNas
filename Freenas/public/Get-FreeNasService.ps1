function Get-FreeNasService
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
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/services/"

        try { $result = Invoke-RestMethod -Uri $Uri -WebSession $script:Session -Method Get }

        Catch {}

    }
    End
    {
        $result
    }
}
