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

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $result
    }
}
