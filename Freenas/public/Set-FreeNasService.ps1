function Set-FreeNasService
{
    [CmdletBinding()]
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
        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }

    }
    Process
    {
        $Uri = "http://$global:SrvFreenas/api/v1.0/services/services/$Services/"
        
        $Status = new-Object -TypeName PSObject

        $Status | add-member -name "srv_enable" -membertype NoteProperty -Value $ServicesStatus


        $post = $Status |ConvertTo-Json

        $response = invoke-RestMethod -method Put -body $post -Uri $Uri -WebSession $global:Session -ContentType "application/json"

    }
    End
    {
             
    }
}
