function Connect-FreeNasServer {
    [CmdletBinding()]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Description d’aide Freenas
        [Parameter(Mandatory = $true)]

        [Alias("Freenas")]
        $Server,
        [Parameter(Mandatory = $false)]
        [String]$Username,
        [Parameter(Mandatory = $false)]
        [SecureString]$Password,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credentials
    )

    Begin {
        Get-PowerShellVersion
        $global:SrvFreenas = ""
        $global:Session = ""
        $global:Header
        $Uri = "http://$Server/api/v1.0"
        New-banner -Text "FreeNas dev" -Online
        Write-Verbose "The Server URI i set to $Uri"

    }
    Process {
        $Script:SrvFreenas = $Server


        #If there is a password (and a user), create a credentials
        if ($Password) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
        }
        #Not Credentials (and no password)
        if ($NULL -eq $Credentials) {
            $Credentials = Get-Credential -Message 'Please enter administrative credentials for your FreeNas'
        }
        $cred = $Credentials.username + ":" + $Credentials.GetNetworkCredential().Password
        $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($cred))
        #headers, We need to have Content-type set to application/json...
        $script:headers = @{ Authorization = "Basic " + $base64; "Content-type" = "application/json" }
        $script:invokeParams = @{ UseBasicParsing = $true }

        $uri = "http://${Server}/api/v1.0/system/version/"

        try {
            $result = Invoke-RestMethod -Uri $uri -Method Get -SessionVariable Freenas_S -headers $headers @invokeParams
        }
        catch {
            Show-FreeNasException -Exception $_
            throw "Unable to connect"
        }

        if ($null -eq $result.fullversion ) {
            throw "Unable to get data"
        }

        Write-Host "Welcome on"$result.name"-"$result.fullversion""

        $Script:Session = $Freenas_S


    }
    End {

    }
}