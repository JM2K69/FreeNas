function Invoke-FreeNasRestMethod
{

    <#
      .SYNOPSIS
      Invoke RestMethod with FreeNas connection (internal) variable

      .DESCRIPTION
      Invoke RestMethod with FreeNas connection variable (token,.)

      .EXAMPLE
      Invoke-FreeNasRestMethod -method "get" -uri "api/v1.0/storage/disk/"

      Invoke-RestMethod with FreeNas connection for get api/v1.0/storage/disk/ uri
    #>

    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$uri,
        [Parameter(Mandatory = $false)]
        [ValidateSet("GET", "PUT", "POST", "DELETE")]
        [String]$method = "GET",
        [Parameter(Mandatory = $false)]
        [psobject]$body
    )

    Begin
    {

    }

    Process
    {

        if ($null -eq $Script:SrvFreenas)
        {
            Throw "Not Connected. Connect to the FreeNas with Connect-FreeNasServer"
        }

        $Server = $Script:SrvFreenas
        $sessionvariable = $Script:Session
        $headers = $Script:Headers
        $invokeParams = $Script:invokeParams
        $httpOnly = $Script:httpOnly
        $port = $Script:port

        if ($httpOnly)
        {
            $fullurl = "http://${Server}:${port}/${uri}"
        }
        else
        {
            $fullurl = "https://${Server}:${port}/${uri}"
        }

        try
        {
            if ($body)
            {
                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json -Compress -Depth 3) -WebSession $sessionvariable -headers $headers @invokeParams
            }
            else
            {
                $response = Invoke-RestMethod $fullurl -Method $method -WebSession $sessionvariable -headers $headers @invokeParams
            }
        }

        catch
        {
            Show-FreeNasException $_
            throw "Unable to use FreeNAS API"
        }
        $response

    }

}

function Set-FreeNasCipherSSL
{

    # Hack for allowing TLS 1.1 and TLS 1.2 (by default it is only SSL3 and TLS (1.0))
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
    [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

}
function Set-FreeNasUntrustedSSL
{

    # Hack for allowing untrusted SSL certs with https connections
    Add-Type -TypeDefinition @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@

    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy

}

function Show-FreeNasException()
{
    Param(
        [parameter(Mandatory = $true)]
        $Exception
    )

    #Check if certificate is valid
    if ($Exception.Exception.InnerException)
    {
        $exceptiontype = $Exception.Exception.InnerException.GetType()
        if ("AuthenticationException" -eq $exceptiontype.name)
        {
            Write-Warning "Invalid certificat (Untrusted, wrong date, invalid name...)"
            Write-Warning "Try to use Connect-FreeNasServer -SkipCertificateCheck for connection"
            throw "Unable to connect (certificate)"
        }
    }

    If ($Exception.Exception.Response)
    {
        if ("Desktop" -eq $PSVersionTable.PSEdition)
        {
            $result = $Exception.Exception.Response.GetResponseStream()
            $reader = New-Object -TypeName System.IO.StreamReader($result)
            $responseBody = $reader.ReadToEnd()
            $responseJson = $responseBody | ConvertFrom-Json
        }

        Write-Warning "The FreeNas  API sends an error message:"
        Write-Warning "Error description (code): $($Exception.Exception.Response.StatusDescription) ($($Exception.Exception.Response.StatusCode.Value__))"
        if ($responseBody)
        {
            if ($responseJson.message)
            {
                Write-Warning "Error details: $($responseJson.message)"
            }
            else
            {
                Write-Warning "Error details: $($responseBody)"
            }
        }
        elseif ($Exception.ErrorDetails.Message)
        {
            Write-Warning "Error details: $($Exception.ErrorDetails.Message)"
        }
    }
}
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
        [Parameter(Mandatory = $true)]
        [ValidateSet("v1.0", "v2.0")]
        [Alias("Api")]
        $ApiVersion,
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
            #New-banner -Text "FreeNas 2.0" -Online -ErrorAction stop
        }
        Catch
        {
            #New-banner -Text "FreeNas 2.0"
        }

    }
    Process
    {
        $Script:SrvFreenas = $Server


        #If there is a password (and a user), create a credentials
        if ($Password)
        {
            $Credentials = New-Object -TypeName System.Management.Automation.PSCredential($Username, $securecurepassword)
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
            switch ($ApiVersion)
            {
                'v1.0' { $uri = "http://${Server}:${port}/api/v1.0/system/version/" }
                'v2.0' { $uri = "http://${Server}:${port}/api/v2.0/system/info" }
                Default { }
            }

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
            switch ($ApiVersion)
            {
                'v1.0' { $uri = "http://${Server}:${port}/api/v1.0/system/version/" }
                'v2.0' { $uri = "http://${Server}:${port}/api/v2.0/system/info" }
                Default { }
            }

        }

        $script:port = $port
        $script:httpOnly = $httpOnly
        $Script:ApiVersion = $ApiVersion

        try
        {
            $result = Invoke-RestMethod -Uri $uri -Method Get -SessionVariable Freenas_S -headers $headers @invokeParams
        }
        catch
        {
            Show-FreeNasException -Exception $_
            throw "Unable to connect"
        }

        if ($null -eq $result.version )
        {
            throw "Unable to get data"
        }

        switch ($ApiVersion)
        {
            'v1.0' { Write-Host "Welcome on"$result.name"-"$result.fullversion"" }
            'v2.0' { Write-Host "Welcome on"$result.name"-"$result.version"-"$result.system_product"" }
            Default { }
        }

        $Script:Session = $Freenas_S


    }
    End
    {

    }
}

<#
      .SYNOPSIS
      This function return Certificate created on your FreeNas Server
      .DESCRIPTION
      This function return Certificate created on your FreeNas Server
      .EXAMPLE
       PS C:\> Get-FreeNasCertificate

        Name              : FreeNas
        Id                : 1
        CSR               :
        DN                : /C=US/ST=US/L=New York/O=JM2K69/CN=FreeNas/emailAddress=Freenas@JM2K69.it
        Certificate       : -----BEGIN CERTIFICATE-----
                          MIIDhDCCAmygAwIBAgIEAMoKjzANBgkqhkiG9w0BAQsFADBzMQswCQYDVQQGEwJV
                          UzELMAkGA1UE..........
                          -----END CERTIFICATE-----
        Chain             : False
        City              : New York
        Common            : FreeNas
        Country           : US
        Disgest Algorithm : SHA256
        Email             : Freenas@JM2K69.loc
        From              : Thu Oct 24 05:37:47 2019
        Issuer            : CAInternal
        Key Lenght        : 2048
        Lifetime          : 3650
        Organization      : JM2K69
        PrivateKey        : -----BEGIN PRIVATE KEY-----
                            MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCzO8EZwwvleN32
                            XO/mrAYrxfhDpjY+..........
                            -----END PRIVATE KEY-----

        Serial            : 13240975
        State             : US
        Type              : 16
        Type CSR          : False
        Type CSR existing : False
        Type Internal     : True
        Valid until       : Sun Oct 21 05:37:47 2029
        .NOTES
      This command allow to find all certificate created on your FreeNas or TrueNas server

      .FUNCTIONALITY
      Use this command when you want to enable Https on your FreeNas or TrueNas server
      #>

function Get-FreeNasCertificate
{
    [CmdletBinding()]
    [Alias()]
    Param
    ()

    Begin
    {
        switch ($ApiVersion)
        {
            'v1.0' { $uri = "api/v1.0/system/certificate/" }
            'v2.0' { $uri = "api/v2.0/certificate/" }
            Default { }
        }
    }
    Process
    {
        Write-Verbose $uri
        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $Certificate = New-Object -TypeName System.Collections.ArrayList

        switch ($ApiVersion)
        {
            'v1.0'
            {
                if ($null -eq $result.count)
                {

                    $temp = New-Object -TypeName System.Object
                    $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result.cert_name)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result.id)"
                    $temp | Add-Member -MemberType NoteProperty -Name "CSR" -Value "$($result.cert_CSR)"
                    $temp | Add-Member -MemberType NoteProperty -Name "DN" -Value "$($result.cert_DN)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Certificate" -Value "$($result.cert_certificate)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Chain" -Value "$($result.cert_chain)"
                    $temp | Add-Member -MemberType NoteProperty -Name "City" -Value "$($result.cert_city)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Common" -Value "$($result.cert_common)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Country" -Value "$($result.cert_country)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Disgest Algorithm" -Value "$($result.cert_digest_algorithm)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Email" -Value "$($result.cert_email)"
                    $temp | Add-Member -MemberType NoteProperty -Name "From" -Value "$($result.cert_from)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Issuer" -Value "$($result.cert_issuer)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Key Lenght" -Value "$($result.cert_key_length)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Lifetime" -Value "$($result.cert_lifetime)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Organization" -Value "$($result.cert_organization)"
                    $temp | Add-Member -MemberType NoteProperty -Name "PrivateKey" -Value "$($result.cert_privatekey)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Serial" -Value "$($result.cert_serial)"
                    $temp | Add-Member -MemberType NoteProperty -Name "State" -Value "$($result.cert_state)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Type" -Value "$($result.cert_type)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Type CSR" -Value "$($result.cert_type_CSR)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Type CSR existing" -Value "$($result.cert_type_existing)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Type Internal" -Value "$($result.cert_type_internal)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Valid until" -Value "$($result.cert_until)"
                    $Certificate.Add($temp) | Out-Null
                }
                else
                {
                    for ($i = 0; $i -lt $result.Count; $i++)
                    {
                        $temp = New-Object -TypeName System.Object
                        $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result[$i].cert_name)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
                        $temp | Add-Member -MemberType NoteProperty -Name "CSR" -Value "$($result[$i].cert_CSR)"
                        $temp | Add-Member -MemberType NoteProperty -Name "DN" -Value "$($result[$i].cert_DN)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Certificate" -Value "$($result[$i].cert_certificate)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Chain" -Value "$($result[$i].cert_chain)"
                        $temp | Add-Member -MemberType NoteProperty -Name "City" -Value "$($result[$i].cert_city)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Common" -Value "$($result[$i].cert_common)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Country" -Value "$($result[$i].cert_country)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Disgest Algorithm" -Value "$($result[$i].cert_digest_algorithm)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Email" -Value "$($result[$i].cert_email)"
                        $temp | Add-Member -MemberType NoteProperty -Name "From" -Value "$($result[$i].cert_from)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Issuer" -Value "$($result[$i].cert_issuer)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Key Lenght" -Value "$($result[$i].cert_key_length)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Lifetime" -Value "$($result[$i].cert_lifetime)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Organization" -Value "$($result[$i].cert_organization)"
                        $temp | Add-Member -MemberType NoteProperty -Name "PrivateKey" -Value "$($result[$i].cert_privatekey)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Serial" -Value "$($result[$i].cert_serial)"
                        $temp | Add-Member -MemberType NoteProperty -Name "State" -Value "$($result[$i].cert_state)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Type" -Value "$($result[$i].cert_type)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Type CSR" -Value "$($result[$i].cert_type_CSR)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Type CSR existing" -Value "$($result[$i].cert_type_existing)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Type Internal" -Value "$($result[$i].cert_type_internal)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Valid until" -Value "$($result[$i].cert_until)"
                        $Certificate.Add($temp) | Out-Null
                    }
                }
            }
            'v2.0'
            {
                if ($null -eq $result.count)
                {

                    $temp = New-Object -TypeName System.Object
                    $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result.name)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result.id)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Type" -Value "$($result.type)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Certificate" -Value "$($result.certificate)"
                    $temp | Add-Member -MemberType NoteProperty -Name "PrivateKey" -Value "$($result.privatekey)"
                    $temp | Add-Member -MemberType NoteProperty -Name "CSR" -Value "$($result.CSR)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Signedby" -Value "$($result.signedby)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Root path" -Value "$($result.root_path)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Certificate path" -Value "$($result.certificate_path)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Private key path" -Value "$($result.private_key_path)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Csr path" -Value "$($result.csr_path)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Cert type" -Value "$($result.cert_type)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Issuer" -Value "$($result.issuer)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Chain list" -Value "$($result.chain_list)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Country" -Value "$($result.country)"
                    $temp | Add-Member -MemberType NoteProperty -Name "State" -Value "$($result.state)"
                    $temp | Add-Member -MemberType NoteProperty -Name "City" -Value "$($result.city)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Organization" -Value "$($result.organization)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Organizational unit" -Value "$($result.organization_unit)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Common" -Value "$($result.Common)"
                    $temp | Add-Member -MemberType NoteProperty -Name "San" -Value "$($result.San)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Email" -Value "$($result.email)"
                    $temp | Add-Member -MemberType NoteProperty -Name "DN" -Value "$($result.DN)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Digest_algorithm" -Value "$($result.digest_algorithm)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Lifetime" -Value "$($result.lifetime)"
                    $temp | Add-Member -MemberType NoteProperty -Name "From" -Value "$($result.from)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Until" -Value "$($result.until)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Serial" -Value "$($result.serial)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Chain" -Value "$($result.chain)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Fingerprint" -Value "$($result.fingerprint)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Key lenght" -Value "$($result.key_length)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Key Type" -Value "$($result.key_type)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Parsed" -Value "$($result.parsed)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Internal" -Value "$($result.internal)"
                    $temp | Add-Member -MemberType NoteProperty -Name "CA Type Existing" -Value "$($result.CA_type_existing)"
                    $temp | Add-Member -MemberType NoteProperty -Name "CA type Internal" -Value "$($result.CA_type_internal)"
                    $temp | Add-Member -MemberType NoteProperty -Name "CA type Intermediate" -Value "$($result.CA_type_intermediate)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Cert type existing" -Value "$($result.cert_type_existing)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Cert type Internal" -Value "$($result.cert_type_internal)"
                    $temp | Add-Member -MemberType NoteProperty -Name "CA type CSR" -Value "$($result.cert_type_CSR)"
                    $Certificate.Add($temp) | Out-Null
                }
                else
                {
                    for ($i = 0; $i -lt $result.Count; $i++)
                    {
                        $temp = New-Object -TypeName System.Object
                        $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result[$i].name)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Type" -Value "$($result[$i].type)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Certificate" -Value "$($result[$i].certificate)"
                        $temp | Add-Member -MemberType NoteProperty -Name "PrivateKey" -Value "$($result[$i].privatekey)"
                        $temp | Add-Member -MemberType NoteProperty -Name "CSR" -Value "$($result[$i].CSR)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Signedby" -Value "$($result[$i].signedby)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Root path" -Value "$($result[$i].root_path)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Certificate path" -Value "$($result[$i].certificate_path)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Private key path" -Value "$($result[$i].private_key_path)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Csr path" -Value "$($result[$i].csr_path)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Cert type" -Value "$($result[$i].cert_type)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Issuer" -Value "$($result[$i].issuer)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Chain list" -Value "$($result[$i].chain_list)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Country" -Value "$($result[$i].country)"
                        $temp | Add-Member -MemberType NoteProperty -Name "State" -Value "$($result[$i].state)"
                        $temp | Add-Member -MemberType NoteProperty -Name "City" -Value "$($result[$i].city)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Organization" -Value "$($result[$i].organization)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Organizational unit" -Value "$($result[$i].organization_unit)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Common" -Value "$($result[$i].Common)"
                        $temp | Add-Member -MemberType NoteProperty -Name "San" -Value "$($result[$i].San)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Email" -Value "$($result[$i].email)"
                        $temp | Add-Member -MemberType NoteProperty -Name "DN" -Value "$($result[$i].DN)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Digest_algorithm" -Value "$($result[$i].digest_algorithm)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Lifetime" -Value "$($result[$i].lifetime)"
                        $temp | Add-Member -MemberType NoteProperty -Name "From" -Value "$($result[$i].from)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Until" -Value "$($result[$i].until)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Serial" -Value "$($result[$i].serial)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Chain" -Value "$($result[$i].chain)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Fingerprint" -Value "$($result[$i].fingerprint)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Key lenght" -Value "$($result[$i].key_length)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Key Type" -Value "$($result[$i].key_type)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Parsed" -Value "$($result[$i].parsed)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Internal" -Value "$($result[$i].internal)"
                        $temp | Add-Member -MemberType NoteProperty -Name "CA Type Existing" -Value "$($result[$i].CA_type_existing)"
                        $temp | Add-Member -MemberType NoteProperty -Name "CA type Internal" -Value "$($result[$i].CA_type_internal)"
                        $temp | Add-Member -MemberType NoteProperty -Name "CA type Intermediate" -Value "$($result[$i].CA_type_intermediate)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Cert type existing" -Value "$($result[$i].cert_type_existing)"
                        $temp | Add-Member -MemberType NoteProperty -Name "Cert type Internal" -Value "$($result[$i].cert_type_internal)"
                        $temp | Add-Member -MemberType NoteProperty -Name "CA type CSR" -Value "$($result[$i].cert_type_CSR)"
                        $Certificate.Add($temp) | Out-Null
                    }
                }
            }
            Default { }
        }
    }
    End
    {
        return $Certificate

    }
}


<#
      .SYNOPSIS
      This function return all disk present  on your FreeNas Server
      .DESCRIPTION
      This function return all disk present  on your FreeNas Server
      .EXAMPLE
        PS C:\> Get-FreeNasDisk

        Name Size_GB
        ---- -------
        ada0      20
        da0       30
        da1       30
        da2       30
        da3       30
        da4       30
        da5       30
        da6       30
        .NOTES
      This command allow to find all disk available on your FreeNas or TrueNas server

      .FUNCTIONALITY
      Use this command when you want list your disk on your FreeNas or TrueNas server
      #>

function Get-FreeNasDisk
{
    [CmdletBinding()]
    Param( )
    begin
    {
        switch ($ApiVersion)
        {
            'v1.0' { $uri = "api/v1.0/storage/disk/" }
            'v2.0' { $uri = "api/v2.0/disk" }
            Default { }
        }
    }
    process
    {
        $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        switch ($ApiVersion)
        {
            'v1.0'
            {
                foreach ($disk in $results)
                {
                    $Name = ($disk.disk_name)
                    $Size_GB = ([Math]::Round($disk.disk_size / 1024 / 1024 / 1024, 2))
                    Write-Verbose -Message " Find the disk $name with the size $Size_GB"
                    [PSCustomObject]@{
                        Name    = ($disk.disk_name)
                        Size_GB = ([Math]::Round($disk.disk_size / 1024 / 1024 / 1024, 2))
                    }
                }
            }
            'v2.0'
            {
                foreach ($disk in $results)
                {
                    $Name = ($disk.name)
                    $Size_GB = ([Math]::Round($disk.size / 1024 / 1024 / 1024, 2))
                    Write-Verbose -Message " Find the disk $name with the size $Size_GB"
                    [PSCustomObject]@{
                        Name    = ($disk.name)
                        Number  = ($disk.number)
                        Size_GB = ([Math]::Round($disk.size / 1024 / 1024 / 1024, 2))
                        Type    = ($disk.type)
                        Model   = ($disk.model)

                    }
                }
            }
            Default { }
        }
    }
    end
    { }
}

function Get-FreeNasDiskUnsed
{
    [CmdletBinding()]
    Param( )

    begin
    {
        switch ($ApiVersion)
        {
            'v1.0'
            {
                write-warning "This command doesn't exist in API v1.0"
                break
            }
            'v2.0' { $uri = "api/v2.0/disk/get_unused" }
            Default { }
        }
    }
    process
    {
        $results = Invoke-FreeNasRestMethod -Uri $Uri -Method POST

        foreach ($disk in $results)
        {
            $Name = ($disk.name)
            $Size_GB = ([Math]::Round($disk.size / 1024 / 1024 / 1024, 2))
            Write-Verbose -Message " Find the disk $name with the size $Size_GB"
            [PSCustomObject]@{
                Name    = ($disk.name)
                Number  = ($disk.number)
                Size_GB = ([Math]::Round($disk.size / 1024 / 1024 / 1024, 2))
                Type    = ($disk.type)
                Model   = ($disk.model)
            }
        }
    }
    end { }
}
###########TEST#######################################################
Connect-FreeNasServer -Server 192.168.0.20 -ApiVersion v2.0 -httpOnly
Get-FreeNasCertificate -Verbose
Get-FreeNasDisk -Verbose
Get-FreeNasDiskUnsed -Verbose
