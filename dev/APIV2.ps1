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

            $uri = "http://${Server}:${port}/api/v2.0/system/info"

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
            $uri = "http://${Server}:${port}/api/v2.0/system/info"

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

        Write-Host "Welcome on"$result.name"-"$result.version"-"$result.system_product""

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
        $uri = "api/v2.0/certificate/"
    }
    Process
    {
        Write-Verbose $uri
        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $Certificate = New-Object -TypeName System.Collections.ArrayList

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
        $uri = "api/v2.0/disk"

    }
    process
    {
        $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

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
    end
    { }
}

function Get-FreeNasDiskUnsed
{
    [CmdletBinding()]
    Param( )

    begin
    {
        $uri = "api/v2.0/disk/get_unused"
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
function Get-FreeNasGlobalConfig
{
    [CmdletBinding()]
    [Alias()]
    Param
    ()


    Begin
    {
        $uri = "api/v2.0/network/configuration"
    }
    Process
    {

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $Global = new-Object -TypeName PSObject

        $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
        $Global | add-member -name "Domain" -membertype NoteProperty -Value "$($result.domain)"
        $Global | add-member -name "Gateway Ipv4" -membertype NoteProperty -Value "$($result.ipv4gateway)"
        $Global | add-member -name "Gateway Ipv6" -membertype NoteProperty -Value "$($result.ipv6gateway)"
        $Global | add-member -name "Hostname" -membertype NoteProperty -Value "$($result.hostname_local)"
        $Global | add-member -name "Nameserver1" -membertype NoteProperty -Value "$($result.nameserver1)"
        $Global | add-member -name "Nameserver2" -membertype NoteProperty -Value "$($result.nameserver3)"
        $Global | add-member -name "Nameserver3" -membertype NoteProperty -Value "$($result.nameserver3)"
        $Global | add-member -name "Httpproxy" -membertype NoteProperty -Value "$($result.httpproxy)"
        $Global | add-member -name "Netwait Enabled" -membertype NoteProperty -Value "$($result.netwait_enabled)"
        $Global | add-member -name "Netwait IP" -membertype NoteProperty -Value "$($result.netwait_ip)"
        $Global | add-member -name "Hosts" -membertype NoteProperty -Value "$($result.hosts)"
        return $Global
    }
}

function Get-FreeNasInterface
{
    [CmdletBinding()]
    [Alias()]

    Param
    ()


    Begin
    {
        $uri = "api/v2.0/interface"
    }
    Process
    {

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $Global = new-Object -TypeName PSObject
        $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
        $Global | add-member -name "Name" -membertype NoteProperty -Value "$($result.name)"
        $Global | add-member -name "Fake" -membertype NoteProperty -Value "$($result.fake)"
        $Global | add-member -name "type" -membertype NoteProperty -Value "$($result.type)"
        $Global | add-member -name "Aliases" -membertype NoteProperty -Value "$($result.aliases)"
        $Global | add-member -name "Dhcp ipv4" -membertype NoteProperty -Value "$($result.ipv4_dhcp)"
        $Global | add-member -name "Dhcp ipv6" -membertype NoteProperty -Value "$($result.ipv6_auto)"
        $Global | add-member -name "Description" -membertype NoteProperty -Value "$($result.description)"
        $Global | add-member -name "Options" -membertype NoteProperty -Value "$($result.options)"
        $Global | add-member -name "Name parent" -membertype NoteProperty -Value "$($result.state.name)"
        $Global | add-member -name "Origin Name" -membertype NoteProperty -Value "$($result.state.orig_name)"
        $Global | add-member -name "Description parent" -membertype NoteProperty -Value "$($result.state.description)"
        $Global | add-member -name "MTU" -membertype NoteProperty -Value "$($result.state.mtu)"
        $Global | add-member -name "Cloned" -membertype NoteProperty -Value "$($result.state.cloned)"
        $Global | add-member -name "Flags" -membertype NoteProperty -Value "$($result.state.flags)"
        $Global | add-member -name "Nd6_flags" -membertype NoteProperty -Value "$($result.state.nd6_flags)"
        $Global | add-member -name "Link state" -membertype NoteProperty -Value "$($result.state.link_state)"
        $Global | add-member -name "Media type" -membertype NoteProperty -Value "$($result.state.media_type)"
        $Global | add-member -name "Media subtype" -membertype NoteProperty -Value "$($result.state.media_subtype)"
        $Global | add-member -name "Active media type" -membertype NoteProperty -Value "$($result.state.active_media_type)"
        $Global | add-member -name "Active media subtype" -membertype NoteProperty -Value "$($result.state.active_media_subtype)"
        $Global | add-member -name "Supported_media" -membertype NoteProperty -Value "$($result.state.supported_media)"
        $Global | add-member -name "Media options" -membertype NoteProperty -Value "$($result.state.media_options)"
        $Global | add-member -name "Mac Address" -membertype NoteProperty -Value "$($result.state.link_address)"


        return $Global
    }
}

function Get-FreeNasInternalCA
{
    [CmdletBinding()]
    [Alias()]
    Param
    ()


    Begin
    { }
    Process
    {
        $Uri = "api/v2.0/certificateauthority"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get
        return $result
    }
    End
    {
    }
}

function Get-FreeNasIscsiConf
{
    Param
    ( )

    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/iscsi/global"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $IscsiConf = New-Object -TypeName System.Collections.ArrayList

        $temp = New-Object -TypeName PSObject
        $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value $result.id
        $temp | Add-Member -MemberType NoteProperty -Name "Base Name" -Value $result.basename
        $temp | Add-Member -MemberType NoteProperty -Name "ISNS Server" -Value $result.isns_servers
        $temp | Add-Member -MemberType NoteProperty -Name "Pool available space Threshold (%)" -Value $result.pool_avail_threshold
        $temp | Add-Member -MemberType NoteProperty -Name "Alua" -Value $result.alua


        $IscsiConf.Add($temp) | Out-Null

        return $IscsiConf | fl
    }
}

function Get-FreeNasIscsiExtent
{

    Param
    ()


    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/iscsi/extent"
        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $Extent = New-Object -TypeName System.Collections.ArrayList
        $temp = New-Object -TypeName System.Object

        if ($null -eq $result.Count)
        {

            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value  "$($result.id)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent Type" -Value "$($result.type)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent Name" -Value  "$($result.name)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent path" -Value  "$($result.path)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent Block Size" -Value  "$($result.blocksize)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent Speed Type" -Value "$($result.rpm)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent Naa" -Value "$($result.naa)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent enabled" -Value "$($result.enabled)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent disk" -Value "$($result.disk)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent Xen" -Value "$($result.xen)"

            $Extent.Add($temp) | Out-Null

        }
        else
        {
            for ($i = 0; $i -lt $result.Count; $i++)
            {
                $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value  "$($result[$i].id)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent Type" -Value "$($result[$i].type)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent Name" -Value  "$($result[$i].name)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent path" -Value  "$($result[$i].path)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent Block Size" -Value  "$($result[$i].blocksize)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent Speed Type" -Value "$($result[$i].rpm)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent Naa" -Value "$($result[$i].naa)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent enabled" -Value "$($result[$i].enabled)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent disk" -Value "$($result[$i].disk)"
                $temp | Add-Member -MemberType NoteProperty -Name "Extent Xen" -Value "$($result[$i].xen)"
                $Extent.Add($temp) | Out-Null
            }

        }

        return $Extent


    }
    End
    { }
}

function Get-FreeNasIscsiInitiator
{
    Param
    ( )


    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/iscsi/initiator"
        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $initiator = New-Object -TypeName System.Collections.ArrayList
        $temp = New-Object -TypeName System.Object

        if ($null -eq $result.Count)
        {
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value $result.id
            $temp | Add-Member -MemberType NoteProperty -Name "Tag" -Value $result.tag
            $temp | Add-Member -MemberType NoteProperty -Name "Initiator" -Value $result.initiators
            $temp | Add-Member -MemberType NoteProperty -Name "Auth Network" -Value $result.auth_network
            $temp | Add-Member -MemberType NoteProperty -Name "Comments" -Value $result.comment
            $initiator.Add($temp) | Out-Null

        }
        else
        {
            for ($i = 0; $i -lt $result.Count; $i++)
            {
                $temp = New-Object -TypeName System.Object
                $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
                $temp | Add-Member -MemberType NoteProperty -Name "Tag" -Value "$($result[$i].tag)"
                $temp | Add-Member -MemberType NoteProperty -Name "Initiator" -Value "$($result[$i].initiators)"
                $temp | Add-Member -MemberType NoteProperty -Name "Auth Network" -Value "$($result[$i].auth_network)"
                $temp | Add-Member -MemberType NoteProperty -Name "Comments" -Value "$($result[$i].comment)"
                $initiator.Add($temp) | Out-Null
            }

        }

        return $initiator


    }
    End
    { }
}

function Get-FreeNasIscsiPortal
{
    Param
    ( )


    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/iscsi/portal"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $Obj = New-Object -TypeName System.Collections.ArrayList
        $temp = New-Object -TypeName System.Object

        if ($null -eq $result.Count)
        {
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value $result.id
            $temp | Add-Member -MemberType NoteProperty -Name "Tag" -Value $result.tag
            $temp | Add-Member -MemberType NoteProperty -Name "Listen" -Value $result.listen.ip
            $temp | Add-Member -MemberType NoteProperty -Name "Port" -Value $result.listen.port
            $temp | Add-Member -MemberType NoteProperty -Name "Discovery authmethod" -Value $result.discovery_authmethod
            $temp | Add-Member -MemberType NoteProperty -Name "Discovery authgroup" -Value $result.discovery_authgroup
            $Obj.Add($temp) | Out-Null

        }
        else
        {
            for ($i = 0; $i -lt $result.Count; $i++)
            {
                $temp = New-Object -TypeName System.Object
                $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
                $temp | Add-Member -MemberType NoteProperty -Name "Tag" -Value "$($result[$i].tag)"
                $temp | Add-Member -MemberType NoteProperty -Name "Listen" -Value "$($result[$i].listen.ip)"
                $temp | Add-Member -MemberType NoteProperty -Name "Port" -Value "$($result[$i].listen.port)"
                $temp | Add-Member -MemberType NoteProperty -Name "Discovery authmethod" -Value "$($result[$i].discovery_authmethod)"
                $temp | Add-Member -MemberType NoteProperty -Name "Discovery authgroup" -Value "$($result[$i].discovery_authgroup)"
                $Obj.Add($temp) | Out-Null
            }

        }
        return $Obj
    }
    End
    { }
}

function Get-FreeNasIscsiTarget
{
    Param
    ( )


    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/iscsi/target"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $FreenasIscsiTarget = New-Object -TypeName System.Collections.ArrayList
        for ($i = 0; $i -lt $result.Count; $i++)
        {
            $temp = New-Object -TypeName System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
            $temp | Add-Member -MemberType NoteProperty -Name "Target alias" -Value "$($result[$i].alias)"
            $temp | Add-Member -MemberType NoteProperty -Name "Target name" -Value "$($result[$i].name)"
            $temp | Add-Member -MemberType NoteProperty -Name "Target mode" -Value "$($result[$i].mode)"
            $temp | Add-Member -MemberType NoteProperty -Name "Groups portal" -Value "$($result[$i].groups.portal)"
            $temp | Add-Member -MemberType NoteProperty -Name "Groups initiator" -Value "$($result[$i].groups.initiator)"
            $temp | Add-Member -MemberType NoteProperty -Name "Groups authentification" -Value "$($result[$i].groups.auth)"
            $temp | Add-Member -MemberType NoteProperty -Name "Groups authen-method" -Value "$($result[$i].groups.authmethod)"

            $FreenasIscsiTarget.Add($temp) | Out-Null
        }


        return $FreenasIscsiTarget
    }
    End
    { }
}

function Get-FreeNasIscsiAssociat2Extent
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [ValidateSet("Id", "Name")]
        [string]$Output = "Id"

    )


    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/iscsi/targetextent"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        switch ($Output)
        {
            'Id'
            {
                $FreenasIscsiAssociat2Extent = New-Object -TypeName System.Collections.ArrayList
                if ($null -eq $result.Count)
                {
                    $temp = New-Object -TypeName System.Object
                    $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi Extent Id" -Value "$($result[$i].extent)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi Lun Id" -Value "$($result[$i].lunid)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi Target Id" -Value "$($result[$i].target)"
                    $FreenasIscsiAssociat2Extent.Add($temp) | Out-Null
                }

                for ($i = 0; $i -lt $result.Count; $i++)
                {
                    $temp = New-Object -TypeName System.Object
                    $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi Extent Id" -Value "$($result[$i].extent)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi Lun Id" -Value "$($result[$i].lunid)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi Target Id" -Value "$($result[$i].target)"

                    $FreenasIscsiAssociat2Extent.Add($temp) | Out-Null
                }
            }
            'Name'
            {
                $FreenasIscsiAssociat2Extent = New-Object -TypeName System.Collections.ArrayList

                if ($null -eq $result.Count)
                {
                    $value = $result.extent
                    $value2 = $result.target
                    $TargetName = Get-FreenasIscsiTarget
                    $IscsiExtend = Get-FreenasIscsiExtent

                    foreach ($item in $TargetName)
                    {
                        if ( $Item.Id -eq $value2 )
                        {
                            $TargetNameF = $item.'Target name'
                        }

                    }

                    foreach ($item in $IscsiExtend)
                    {
                        if ( $Item.Id -eq $value )
                        {
                            $IscsiExtendF = $item.'Extent Name'
                        }
                    }
                    $temp = New-Object -TypeName System.Object
                    $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].Id)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi_Extent_Name" -Value $IscsiExtendF
                    $temp | Add-Member -MemberType NoteProperty -Name "LUN Id" -Value "$($result[$i].lunid)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Target_Name" -Value $TargetNameF

                    $FreenasIscsiAssociat2Extent.Add($temp) | Out-Null


                }


                for ($i = 0; $i -lt $result.Count; $i++)
                {
                    $value = $result[$i].extent
                    $value2 = $result[$i].target
                    $TargetName = Get-FreenasIscsiTarget
                    $IscsiExtend = Get-FreenasIscsiExtent


                    foreach ($item in $TargetName)
                    {
                        if ( $Item.Id -eq $value2 )
                        {
                            $TargetNameF = $item.'Target name'
                        }

                    }

                    foreach ($item in $IscsiExtend)
                    {
                        if ( $Item.Id -eq $value )
                        {
                            $IscsiExtendF = $item.'Extent Name'
                        }
                    }


                    $temp = New-Object -TypeName System.Object
                    $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].Id)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi_Extent_Name" -Value $IscsiExtendF
                    $temp | Add-Member -MemberType NoteProperty -Name "LUN Id" -Value "$($result[$i].lunid)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Target_Name" -Value $TargetNameF

                    $FreenasIscsiAssociat2Extent.Add($temp) | Out-Null
                }

            }

        }

        return $FreenasIscsiAssociat2Extent
    }
    End
    { }
}

function Get-FreeNasService
{
    Param
    ( )

    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/service"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    }
    End
    {
        $result
    }
}

function Get-FreeNasSetting
{
    [CmdletBinding()]
    [Alias()]
    Param
    ()


    Begin
    { }
    Process
    {
        $Uri = "api/v2.0/system/general"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get
    }
    End
    {
        $Global = new-Object -TypeName PSObject

        $Global | add-member -name "Id" -membertype NoteProperty -Value "$($result.id)"
        $Global | add-member -name "Language" -membertype NoteProperty -Value "$($result.language)"
        $Global | add-member -name "Keyboard map" -membertype NoteProperty -Value "$($result.kbdmap)"
        $Global | add-member -name "Time zone" -membertype NoteProperty -Value "$($result.timezone)"
        $Global | add-member -name "SysLog Level" -membertype NoteProperty -Value "$($result.sysloglevel)"
        $Global | add-member -name "Syslog server" -membertype NoteProperty -Value "$($result.syslogserver)"
        $Global | add-member -name "Crash reporting" -membertype NoteProperty -Value "$($result.crash_reporting )"
        $Global | add-member -name "WizardShonw" -membertype NoteProperty -Value "$($result.wizardshown)"
        $Global | add-member -name "Usage collection" -membertype NoteProperty -Value "$($result.usage_collection)"
        $Global | add-member -name "Ui certificate" -membertype NoteProperty -Value "$($result.ui_certificate)"
        $Global | add-member -name "Ui address" -membertype NoteProperty -Value "$($result.ui_address)"
        $Global | add-member -name "Ui v6address" -membertype NoteProperty -Value "$($result.ui_v6address)"
        $Global | add-member -name "Ui port" -membertype NoteProperty -Value "$($result.ui_port)"
        $Global | add-member -name "Ui https port" -membertype NoteProperty -Value "$($result.ui_httpsport)"
        $Global | add-member -name "Ui https redirect" -membertype NoteProperty -Value "$($result.ui_httpsredirect)"
        $Global | add-member -name "Crash reporting is set" -membertype NoteProperty -Value "$($result.crash_reporting_is_set)"
        $Global | add-member -name "usage collection is set" -membertype NoteProperty -Value "$($result.usage_collection_is_set)"

        return $Global
    }
}

function Get-FreeNasSystemAdvanced
{
    Param( )

    $Uri = "api/v2.0/system/advanced"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    foreach ($Info in $results)
    {
        [PSCustomObject]@{
            Id                      = ($Info.id)
            'Legacy UI'             = ($Info.legacy_ui)
            Consolemenu             = ($Info.consolemenu)
            'Serial console'        = ($Info.serialconsole)
            'Serial port'           = ($Info.serialport)
            'Serial speed'          = ($Info.serialspeed)
            'Power daemon'          = ($Info.powerdaemon)
            'Swap on drive'         = ($Info.swapondrive)
            'Console msg'           = ($Info.consolemsg)
            'Trace back'            = ($Info.traceback)
            'Advanced mode'         = ($Info.advancedmode)
            'Autotune'              = ($Info.autotune)
            'Debug kernel'          = ($Info.debugkernel)
            'Upload crash'          = ($Info.uploadcrash)
            'MOTD'                  = ($Info.motd)
            'Anonstats'             = ($Info.anonstats)
            'Boot scrub'            = ($Info.boot_scrub)
            'FQDN syslog'           = ($Info.fqdn_syslog)
            'Sed user'              = ($Info.sed_user)
            'Sed password'          = ($Info.sed_passwd)

        }
    }
}

function Get-FreeNasSystemAlert {
    Param( )

    $Uri = "api/v2.0/alertservice"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    foreach ($Alert in $results) {
        [PSCustomObject]@{
            Id              = ($Alert.id)
            Name            = ($Alert.name)
            Type            = ($Alert.type)
            Attributes      = ($Alert.attributes)
            Level           = ($Alert.level)
            Enabled         = ($Alert.enabled)
            'Type title'    = ($Alert.type__title)
        }
    }
}

function Get-FreeNasSystemNTP
{
    [Alias()]
    Param
    ()

    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/system/ntpserver"

        $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        foreach ($NTP in $results) {
            [PSCustomObject]@{
                Id                 = ($NTP.id)
                Address            = ($NTP.address)
                Burst              = ($NTP.burst)
                iburst             = ($NTP.iburst)
                prefer             = ($NTP.prefer)
                Minpoll            = ($NTP.minpoll)
                Maxpoll            = ($NTP.maxpoll)
            }
        }

    }
    End { }
}

function Get-FreeNasSystemUpdate {
    Param( )

    $Uri = "api/v2.0/update/get_trains"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get
    return $results.trains
}
function Get-FreeNasSystemVersion {
    Param( )

    $Uri = "api/v2.0/system/info"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get


        [PSCustomObject]@{
            Version                = ($results.version)
            'Build time'           = ($results.buildtime)
            'Physical Memory'      = ($results.physmem)
            Model                  = ($results.model)
            Cores                  = ($results.cores)
            'Load Average'         = ($results.loadavg)
            Uptime                 = ($results.uptime)
            'Uptime seconds'       = ($results.uptime_seconds)
            'System serial'        = ($results.system_serial)
            'System product'       = ($results.system_product)
            license                = ($results.license)
            'boot time'            = ($results.boottime)
            'Date time'            = ($results.datetime)
            Timezone               = ($results.timezone)
            'System manufacturer'  = ($results.system_manufacturer)

        }

}

function Get-FreeNasVolume
{
    Param

    ( )

    Begin
    {

    }
    Process
    {
        $Uri = "api/v2.0/pool/dataset"
        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        #for dev only
        $result = $result | where {$_.type -eq "Volume"}
    }
    End
    {
        $FreenasVolume = New-Object -TypeName System.Collections.ArrayList

        if ($null -eq $result.count)
        {
            $temp = New-Object -TypeName System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result.name)"
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result.id)"
            $temp | Add-Member -MemberType NoteProperty -Name "Children" -Value "$($result.children)"
            $temp | Add-Member -MemberType NoteProperty -Name "Type" -Value "$($result.type)"
            $temp | Add-Member -MemberType NoteProperty -Name "Deduplication" -Value "$($result.deduplication.value)"
            $temp | Add-Member -MemberType NoteProperty -Name "Sync" -Value "$($result.sync.value)"
            $temp | Add-Member -MemberType NoteProperty -Name "Compression" -Value "$($result.compression.value)"
            $temp | Add-Member -MemberType NoteProperty -Name "Compression ratio" -Value "$($result.compressratio.value)"
            $temp | Add-Member -MemberType NoteProperty -Name "Ref reservation" -Value "$($result.refreservation.value)"
            $temp | Add-Member -MemberType NoteProperty -Name "Readonly" -Value "$($result.readonly.value)"
            $temp | Add-Member -MemberType NoteProperty -Name "Volume size" -Value "$($result.volsize.value)"
            $temp | Add-Member -MemberType NoteProperty -Name "Volume block size" -Value "$($result.volblocksize.value)"
            $FreenasVolume.Add($temp) | Out-Null

        }
        else
        {
            for ($i = 0; $i -lt $result.Count; $i++)
            {
                $temp = New-Object -TypeName System.Object
                $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($result[$i].name)"
                $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
                $temp | Add-Member -MemberType NoteProperty -Name "Children" -Value "$($result[$i].children)"
                $temp | Add-Member -MemberType NoteProperty -Name "Type" -Value "$($result[$i].type)"
                $temp | Add-Member -MemberType NoteProperty -Name "Deduplication" -Value "$($result[$i].deduplication.value)"
                $temp | Add-Member -MemberType NoteProperty -Name "Sync" -Value "$($result[$i].sync.value)"
                $temp | Add-Member -MemberType NoteProperty -Name "Compression" -Value "$($result[$i].compression.value)"
                $temp | Add-Member -MemberType NoteProperty -Name "Compression ratio" -Value "$($result[$i].compressratio.value)"
                $temp | Add-Member -MemberType NoteProperty -Name "Ref reservation" -Value "$($result[$i].refreservation.value)"
                $temp | Add-Member -MemberType NoteProperty -Name "Readonly" -Value "$($result[$i].readonly.value)"
                $temp | Add-Member -MemberType NoteProperty -Name "Volume size" -Value "$($result[$i].volsize.value)"
                $temp | Add-Member -MemberType NoteProperty -Name "Volume block size" -Value "$($result[$i].volblocksize.value)"
                $FreenasVolume.Add($temp) | Out-Null
            }

        }


        return $FreenasVolume



    }
}

$Uri = "api/v2.0/pool"
$Uri = "api/v2.0/pool/dataset" | where {$_.type -eq "Volume"}
$result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get



###########TEST#######################################################
Connect-FreeNasServer -Server 10.30.103.103  -httpOnly
Get-FreeNasCertificate -Verbose
Get-FreeNasDisk -Verbose
Get-FreeNasDiskUnsed -Verbose
Get-FreeNasGlobalConfig
Get-FreeNasInterface
Get-FreeNasIscsiConf
Get-FreeNasIscsiExtent
Get-FreeNasIscsiInitiator
Get-FreeNasIscsiPortal
Get-FreeNasIscsiTarget
Get-FreeNasIscsiAssociat2Extent -Output Name
Get-FreeNasService
Get-FreeNasSetting
Get-FreeNasSystemAdvanced
Get-FreeNasSystemAlert
Get-FreeNasSystemNTP
Get-FreeNasSystemVersion
Get-FreeNasVolume
