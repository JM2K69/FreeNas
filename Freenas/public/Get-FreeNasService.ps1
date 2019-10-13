function Get-FreeNasService
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
        $Uri = "api/v1.0/services/services/"

        try { $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get }

        Catch { throw }

    }
    End
    {
        $result
    }
}
