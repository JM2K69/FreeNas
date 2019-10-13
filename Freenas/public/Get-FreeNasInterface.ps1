function Get-FreeNasInterface
{
    [CmdletBinding()]
    [Alias()]

    Param
    ()


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
        $Uri = "http://$script:SrvFreenas/api/v1.0/network/interface/"

        try { $result = Invoke-RestMethod -Uri $Uri -WebSession $script:Session -Method Get }

        Catch { throw }

    }
    End
    {
        $Global = new-Object -TypeName PSObject

        switch ($result.int_dhcp)
        {
            'True'
            {
                $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
                $Global | add-member -name "Satus" -membertype NoteProperty -Value "$($result.int_media_status)"
                $Global | add-member -name "Alias" -membertype NoteProperty -Value "$($result.int_aliases)"
                $Global | add-member -name "Dhcp" -membertype NoteProperty -Value "$($result.int_dhcp)"
                $Global | add-member -name "Name" -membertype NoteProperty -Value "$($result.int_interface)"
                $Global | add-member -name "Ipv6" -membertype NoteProperty -Value "$($result.int_ipv6auto)"
            }
            Default
            {
                $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
                $Global | add-member -name "Satus" -membertype NoteProperty -Value "$($result.int_media_status)"
                $Global | add-member -name "Alias" -membertype NoteProperty -Value "$($result.int_aliases)"
                $Global | add-member -name "Dhcp" -membertype NoteProperty -Value "$($result.int_dhcp)"
                $Global | add-member -name "Name" -membertype NoteProperty -Value "$($result.int_interface)"
                $Global | add-member -name "Ipv4" -membertype NoteProperty -Value "$($result.int_ipv4address)"
                $Global | add-member -name "Netmask" -membertype NoteProperty -Value "$($result.int_v4netmaskbit)"
                $Global | add-member -name "Ipv6" -membertype NoteProperty -Value "$($result.int_ipv6auto)"

            }
        }


        return $Global
    }

}
