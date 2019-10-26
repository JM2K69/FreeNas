<#
      .SYNOPSIS
      Connect FreeNas Server it use to connect to your FreeNas Server or TrueNas
      .DESCRIPTION
      Connect FreeNas Server it use to connect to your FreeNas Server or TrueNas
      .EXAMPLE
      Connection not secure on Https protocol:

      PS C:\>Connect-FreeNasServer -Server 10.0.10.0 -httpOnly
      Welcome on FreeNAS - FreeNAS-11.2-U6 (5acc1dec66)

      .EXAMPLE
      Connection with Https by default if you have a self signed certificate use the parameter SkipCertificateCheck

      PS C:\>Connect-FreeNasServer -Server 10.0.10.0 -SkipCertificateCheck $true
      Welcome on FreeNAS - FreeNAS-11.2-U6 (5acc1dec66)

      .NOTES
      By default the connection use the secure method to interact with FreeNAs or TrueNas server

      .FUNCTIONALITY
      Use this command at the begining for established the connection to your FreeNas or TrueNas server
      #>
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
        [Parameter(Mandatory = $false)]
        [String]$Username,
        [Parameter(Mandatory = $false)]
        [SecureString]$Password,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credentials,
        [Parameter(Mandatory = $false)]
        [switch]$httpOnly = $false,
        [Parameter(Mandatory = $false)]
        [switch]$SkipCertificateCheck = $false,
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$port
    )

    Begin
    {
        $global:SrvFreenas = ""
        $global:Session = ""
        $Uri = "http://$Server/api/v1.0"
        New-banner -Text "FreeNas dev" -Online
        Write-Verbose "The Server URI i set to $Uri"

    }
    Process
    {
        $Script:SrvFreenas = $Server


        #If there is a password (and a user), create a credentials
        if ($Password)
        {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
        }
        #Not Credentials (and no password)
        if ($NULL -eq $Credentials)
        {
            $Credentials = Get-Credential -Message 'Please enter administrative credentials for your FreeNas'
        }
        $cred = $Credentials.username + ":" + $Credentials.GetNetworkCredential().Password
        $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($cred))
        #headers, We need to have Content-type set to application/json...
        $script:headers = @{ Authorization = "Basic " + $base64; "Content-type" = "application/json" }
        $script:invokeParams = @{ UseBasicParsing = $true; SkipCertificateCheck = $SkipCertificateCheck }

        if ("Desktop" -eq $PSVersionTable.PsEdition)
        {
            #Remove -SkipCertificateCheck from Invoke Parameter (not supported <= PS 5)
            $invokeParams.remove("SkipCertificateCheck")
        }

        if ($httpOnly)
        {
            if (!$port)
            {
                $port = 80
            }

            $uri = "http://${Server}:${port}/api/v1.0/system/version/"
        }
        else
        {
            if (!$port)
            {
                $port = 443
            }
            #for PowerShell (<=) 5 (Desktop), Enable TLS 1.1, 1.2 and Disable SSL chain trust
            if ("Desktop" -eq $PSVersionTable.PsEdition)
            {
                Write-Verbose "Desktop Version try to Enable TLS 1.1 and 1.2"
                #Enable TLS 1.1 and 1.2
                Set-FreeNasCipherSSL
                if ($SkipCertificateCheck)
                {
                    Write-Verbose "Disable SSL chain trust"

                    #Disable SSL chain trust...
                    Set-FreeNasuntrustedSSL
                }

            }
            $uri = "https://${Server}:${port}/api/v1.0/system/version/"
        }

        $script:port = $port
        $script:httpOnly = $httpOnly

        try
        {
            $result = Invoke-RestMethod -Uri $uri -Method Get -SessionVariable Freenas_S -headers $headers @invokeParams
        }
        catch
        {
            Show-FreeNasException -Exception $_
            throw "Unable to connect"
        }

        if ($null -eq $result.fullversion )
        {
            throw "Unable to get data"
        }

        Write-Host "Welcome on"$result.name"-"$result.fullversion""

        $Script:Session = $Freenas_S


    }
    End
    {

    }
}