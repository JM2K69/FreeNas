function Get-FreeNasService
{
    Param
    ( )

    Begin
    {

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/services/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $result
    }
}
