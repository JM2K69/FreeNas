function Set-FreeNasService
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter (Mandatory = $true)]
        [ValidateSet("afp", "cifs", "dynamicdns" , "ftp", "iscsitarget", "nfs", "snmp", "ssh", "tftp", "ups", "rsync", "smartd", "domaincontroller", "lldp", "webdav", "s3", "netdata")]
        [string]$Services,

        [Parameter (Mandatory = $true)]
        [ValidateSet("True", "False")]
        [string]$ServicesStatus


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
        $Uri = "api/v1.0/services/services/$Services/"

        $Status = new-Object -TypeName PSObject

        $Status | add-member -name "srv_enable" -membertype NoteProperty -Value $ServicesStatus



        $response = Invoke-FreeNasRestMethod -method Put -body $status -Uri $Uri

    }
    End
    {

    }
}
