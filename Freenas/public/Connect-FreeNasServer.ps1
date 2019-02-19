function Connect-FreeNasServer
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Description d’aide Freenas
        [Parameter(Mandatory = $true)]

        [Alias("Freenas")] 
        $Server,

        # Description d’aide User
        [Parameter(Mandatory = $true)]
        $Username,

        # Description d’aide Password
        [Parameter(Mandatory = $true)]
        
        $Password
    )

    Begin
    {
        $global:SrvFreenas = ""
        $global:Session = ""

        $Uri = "http://$Server/api/v1.0"
        $Headers = @{ Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username, $Password))) }

        $global:SrvFreenas = $Server

        New-banner -Text "Freenas Module v1.0" -Online 

    }
    Process
    {

        try { $result = Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Get -SessionVariable Freenas_S}
        catch {}

        try
        {
            $Uri = "http://$global:SrvFreenas/api/v1.0/storage/disk/"

            $result2 = Invoke-RestMethod -Uri $Uri -WebSession $global:Session -Method Get 
        }

        catch {}

        $global:Session = $Freenas_S

    }
    End
    {
        if ($result -ne $null)
        {
            Write-Host "Your are already connect to $global:SrvFreenas "-ForegroundColor Cyan
        }
    }
}
