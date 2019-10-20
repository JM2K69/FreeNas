function Get-FreeNasGlobalConfig
{
    [CmdletBinding()]
    [Alias()]
    Param
    ()


    Begin
    {

    }
    Process
    {
        $Uri = "api/v1.0/network/globalconfiguration/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $Global = new-Object -TypeName PSObject

        $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
        $Global | add-member -name "Domain" -membertype NoteProperty -Value "$($result.gc_domain)"
        $Global | add-member -name "Gateway" -membertype NoteProperty -Value "$($result.gc_ipv4gateway)"
        $Global | add-member -name "Hostname" -membertype NoteProperty -Value "$($result.gc_hostname)"
        $Global | add-member -name "Nameserver1" -membertype NoteProperty -Value "$($result.gc_nameserver1)"
        $Global | add-member -name "Nameserver2" -membertype NoteProperty -Value "$($result.gc_nameserver2)"
        $Global | add-member -name "Nameserver3" -membertype NoteProperty -Value "$($result.gc_nameserver3)"
        $Global | add-member -name "Httpproxy" -membertype NoteProperty -Value "$($result.gc_httpproxy)"
        return $Global
    }
}
