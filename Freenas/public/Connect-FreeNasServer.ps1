<#
      .SYNOPSIS
      Connect FreeNas Server it use to connect to your FreeNas Server or TrueNas

      .DESCRIPTION
      Connect FreeNas Server it use to connect to your FreeNas Server or TrueNas
      Support connection to HTTPS (default) or HTTP

      .EXAMPLE
      Connect-FreeNasServer -Server 192.0.2.1

      Connect to an FreeNas using HTTPS with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      Connect-FreeNasServer -Server 192.0.2.1 -SkipCertificateCheck

      Connect to an FreeNas using HTTPS (without check certificate validation) with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      Connect-FreeNasServer -Server 192.0.2.1 -httpOnly

      Connect to an FreeNas using HTTP (unsecure !) with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      Connect-FreeNasServer -Server 192.0.2.1 -port 4443

      Connect to an FreeNas using HTTPS (with port 4443) with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      $cred = get-credential
      PS > Connect-FreeNasServer -Server 192.0.2.1 -credential $cred

      Connect to an FreeNas with IP 192.0.2.1 and passing (Get-)credential

      .EXAMPLE
      $mysecpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
      PS > Connect-FreeNasServer -Server 192.0.2.1 -Username root -Password $mysecpassword

      Connect to an FreeNas with IP 192.0.2.1 using Username and Password

      .NOTES
      By default the connection use the secure method to interact with FreeNas or TrueNas server

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
        Try
        {
            New-banner -Text "FreeNas 2.0" -Online -ErrorAction stop
        }
        Catch
        {
            New-banner -Text "FreeNas 2.0"
        }

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
                Write-Verbose -Message "Desktop Version try to Enable TLS 1.1 and 1.2"
                #Enable TLS 1.1 and 1.2
                Set-FreeNasCipherSSL
                if ($SkipCertificateCheck)
                {
                    Write-Verbose -Message "Disable SSL chain trust"

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