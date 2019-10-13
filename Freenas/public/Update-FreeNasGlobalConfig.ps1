function Update-FreeNasGlobalConfig
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [Alias()]

    Param
    (
        [Parameter (Mandatory = $false)]
        [String]$Domain,
        [Parameter (Mandatory = $false)]
        [String]$Hostname,
        [Parameter (Mandatory = $false)]
        [String]$Ipv4gateway,
        [Parameter (Mandatory = $false)]
        [String]$Ipv6gateway,
        [Parameter (Mandatory = $false)]
        [String]$Nameserver1,
        [Parameter (Mandatory = $false)]
        [String]$Nameserver2,
        [Parameter (Mandatory = $false)]
        [String]$Nameserver3,
        [Parameter (Mandatory = $false)]
        [String]$Hosts,
        [Parameter (Mandatory = $false)]
        [String]$Proxy

    )


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
        $Uri = "api/v1.0/network/globalconfiguration/"

        $Obj = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('Domain') )
        {
            $Obj | add-member -name "gc_domain" -membertype NoteProperty -Value $Domain.ToLower()
        }
        if ( $PsBoundParameters.ContainsKey('Hostname') )
        {
            $Obj | add-member -name "gc_hostname" -membertype NoteProperty -Value $Hostname.ToLower()
        }
        if ( $PsBoundParameters.ContainsKey('Ipv4gateway') )
        {
            $Obj | add-member -name "gc_ipv4gateway" -membertype NoteProperty -Value $Ipv4gateway
        }
        if ( $PsBoundParameters.ContainsKey('Ipv6gateway') )
        {
            $Obj | add-member -name "gc_ipv6gateway" -membertype NoteProperty -Value $Ipv6gateway
        }
        if ( $PsBoundParameters.ContainsKey('Nameserver1') )
        {
            $Obj | add-member -name "gc_nameserver1" -membertype NoteProperty -Value $Nameserver1
        }
        if ( $PsBoundParameters.ContainsKey('Nameserver2') )
        {
            $Obj | add-member -name "gc_nameserver2" -membertype NoteProperty -Value $Nameserver2
        }
        if ( $PsBoundParameters.ContainsKey('Nameserver3') )
        {
            $Obj | add-member -name "gc_nameserver3" -membertype NoteProperty -Value $Nameserver3
        }
        if ( $PsBoundParameters.ContainsKey('Hosts') )
        {
            $Obj | add-member -name "gc_hosts" -membertype NoteProperty -Value $Hosts.ToLower()
        }
        if ( $PsBoundParameters.ContainsKey('Proxy') )
        {
            $Obj | add-member -name "gc_httpproxy" -membertype NoteProperty -Value $Proxy.ToLower()
        }

    }
    End
    {

        $response = Invoke-FreeNasRestMethod -method put -body $Obj -Uri $Uri


    }

}
