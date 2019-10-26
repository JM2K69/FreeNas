<#
      .SYNOPSIS
      This function return configuration for you network interface for your FreeNas Server
      .DESCRIPTION
      This function return configuration for you network interface for your FreeNas Server
      .EXAMPLE
      Here an example with DHCP enable :

        PS C:\> Get-FreeNasInterface

        Id      :
        Status  :
        Alias   :
        Dhcp    :
        Name    :
        Ipv4    :
        Netmask :
        Ipv6    :

      .EXAMPLE
      Here an example with Static configuration :

        PS C:\> Get-FreeNasInterface

        Id      : 1
        Status  : Active
        Alias   :
        Dhcp    : False
        Name    : le0
        Ipv4    : 10.0.10.0
        Netmask : 8
        Ipv6    : False

        .NOTES
      This command return the network configuration for your FreeNas or TrueNas server

      .FUNCTIONALITY
      Use this command when you want find the network configuration FreeNas or TrueNas server
      #>
function Get-FreeNasInterface
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
        $Uri = "http://$script:SrvFreenas/api/v1.0/network/interface/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $Global = new-Object -TypeName PSObject

        switch ($result.int_dhcp)
        {
            'True' 
            {
                $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
                $Global | add-member -name "Status" -membertype NoteProperty -Value "$($result.int_media_status)"
                $Global | add-member -name "Alias" -membertype NoteProperty -Value "$($result.int_aliases)"
                $Global | add-member -name "Dhcp" -membertype NoteProperty -Value "$($result.int_dhcp)"
                $Global | add-member -name "Name" -membertype NoteProperty -Value "$($result.int_interface)"
                $Global | add-member -name "Ipv6" -membertype NoteProperty -Value "$($result.int_ipv6auto)"
            }
            Default 
            {
                $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
                $Global | add-member -name "Status" -membertype NoteProperty -Value "$($result.int_media_status)"
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
