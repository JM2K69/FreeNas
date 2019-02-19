function Get-FreeNasService
{
    Param
    ( )

    Begin
    {
        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }

    }
    Process
    {
        $Uri = "http://$global:SrvFreenas/api/v1.0/services/services/"

        try { $result = Invoke-RestMethod -Uri $Uri -WebSession $global:Session -Method Get }

        Catch {}

    }
    End
    {
        $result
    }
}
