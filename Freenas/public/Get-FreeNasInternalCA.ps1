function Get-FreeNasInternalCA
{
    [CmdletBinding()]
    [Alias()]
    Param
    ()


    Begin
    { }
    Process
    {
        $Uri = "/api/v1.0/system/certificateauthority/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get
        return $result
    }
    End
    {
    }
}
