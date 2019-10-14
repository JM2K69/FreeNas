function Update-FreeNasInterface
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [Alias()]

    Param
    (
        [Parameter (Mandatory = $true)]
        [Int]$Id,
        [Parameter (Mandatory = $true)]
        [String]$Ipv4,
        [Parameter (Mandatory = $true)]
        [ValidateSet("8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30")]
        [String]$NetMask

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
        $Uri = "api/v1.0/network/interface/$Id/"
        $Obj = new-Object -TypeName PSObject

        Write-verbose "Detect DHCP status"
        $Dhcp = Get-FreeNasInterface

        switch ($Dhcp.Dhcp)
        {
            'True'
            {
                $Obj | add-member -name "int_dhcp" -membertype NoteProperty -Value $false
                $Obj | add-member -name "int_ipv4address" -membertype NoteProperty -Value $Ipv4.ToLower()
                $Obj | add-member -name "int_v4netmaskbit" -membertype NoteProperty -Value $NetMask.ToLower()
            }

            'False'
            {
                $Obj | add-member -name "int_ipv4address" -membertype NoteProperty -Value $Ipv4.ToLower()
                $Obj | add-member -name "int_v4netmaskbit" -membertype NoteProperty -Value $NetMask.ToLower()

            }
            Default { }
        }




    }
    End
    {

        $response = Invoke-FreeNasRestMethod -method Put -body $Obj -Uri $Uri
        Write-Warning "You need to reconnect to the host $Ipv4/$NetMask"

    }

}
