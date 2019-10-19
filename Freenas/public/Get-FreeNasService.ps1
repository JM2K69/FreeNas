function Get-FreeNasService
{
    Param
    ( )

    Begin
    {

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
