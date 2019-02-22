function Get-FreeNasService
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
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/services/"

        try { $result = Invoke-RestMethod -Uri $Uri -WebSession $script:Session -Method Get }

        Catch {}

    }
    End
    {
        $result
    }
}
