function Get-FreeNasSetting
{
    [CmdletBinding()]
    [Alias()]
    Param
    ()


    Begin
    { }
    Process
    {
        $Uri = "api/v1.0/system/settings/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get
    }
    End
    {
        $Global = new-Object -TypeName PSObject

        $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
        $Global | add-member -name "GUI address" -membertype NoteProperty -Value "$($result.stg_guiaddress)"
        $Global | add-member -name "GUI certificate" -membertype NoteProperty -Value "$($result.stg_guicertificate)"
        $Global | add-member -name "GUI https port" -membertype NoteProperty -Value "$($result.stg_guihttpsport)"
        $Global | add-member -name "GUI https redirect" -membertype NoteProperty -Value "$($result.stg_guihttpsredirect)"
        $Global | add-member -name "GUI port" -membertype NoteProperty -Value "$($result.stg_guiport)"
        $Global | add-member -name "GUI protocol" -membertype NoteProperty -Value "$($result.stg_guiprotocol)"
        $Global | add-member -name "Language" -membertype NoteProperty -Value "$($result.stg_language)"
        $Global | add-member -name "SysLog level" -membertype NoteProperty -Value "$($result.stg_sysloglevel)"
        $Global | add-member -name "SysLog server" -membertype NoteProperty -Value "$($result.stg_syslogserver)"
        $Global | add-member -name "Timezone" -membertype NoteProperty -Value "$($result.stg_timezone)"
        $Global | add-member -name "Wizard shown" -membertype NoteProperty -Value "$($result.stg_wizardshown)"
        return $Global
    }
}
