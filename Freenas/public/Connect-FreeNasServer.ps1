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
        $script:SrvFreenas = ""
        $script:Session = ""

        $Uri = "http://$Server/api/v1.0"
        $Headers = @{ Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username, $Password))) }

        $script:SrvFreenas = $Server

        New-banner -Text "Freenas Module v1.0" -Online 

    }
    Process
    {

        try { $result = Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Get -SessionVariable Freenas_S}
        catch {}

        try
        {
            $Uri = "http://$script:SrvFreenas/api/v1.0/storage/disk/"

            $result2 = Invoke-RestMethod -Uri $Uri -WebSession $script:Session -Method Get 
        }

        catch {}

        $script:Session = $Freenas_S

    }
    End
    {
        if ($result -ne $null)
        {
            Write-Host "Your are already connect to $script:SrvFreenas "-ForegroundColor Cyan
        }
    }
}
