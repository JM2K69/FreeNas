function New-FreeNasCertificate
{
    [CmdletBinding(SupportsShouldProcess)]
    [Alias()]
    [OutputType([int])]
    Param
    (

        [Parameter (Mandatory = $true)]
        [string]$Name,

        [Parameter (Mandatory = $true)]
        [String]$CommonName,

        [Parameter (Mandatory = $True)]
        [String]$City,

        [Parameter (Mandatory = $true)]
        [String]$State,

        [Parameter (Mandatory = $True)]
        [String]$Country,

        [Parameter (Mandatory = $True)]
        [String]$Email,

        [Parameter (Mandatory = $True)]
        [String]$Organization,

        [Parameter (Mandatory = $True)]
        [ValidateSet("SHA1", "SHA224", "SHA256", "SHA384", "SHA512")]
        [String]$DigestAlgo,

        [Parameter (Mandatory = $True)]
        [Int]$Liftime ,

        [Parameter (Mandatory = $True)]
        [ValidateSet("1024", "2048", "4096")]
        [Int]$KeyLenght,

        [Parameter (Mandatory = $true)]
        [Int]$Signedby

    )


    Begin
    { }

    Process
    {
        $Uri = "/api/v1.0/system/certificate/internal/"
        $Obj = new-Object -TypeName PSObject

        $Obj | add-member -name "cert_city" -membertype NoteProperty -Value $City
        $Obj | add-member -name "cert_email" -membertype NoteProperty -Value $Email
        $Obj | add-member -name "cert_common" -membertype NoteProperty -Value $CommonName
        $Obj | add-member -name "cert_country" -membertype NoteProperty -Value $Country
        $Obj | add-member -name "cert_digest_algorithm" -membertype NoteProperty -Value $DigestAlgo
        $Obj | add-member -name "cert_lifetime" -membertype NoteProperty -Value $Liftime
        $Obj | add-member -name "cert_name" -membertype NoteProperty -Value $Name
        $Obj | add-member -name "cert_organization" -membertype NoteProperty -Value $Organization
        $Obj | add-member -name "cert_state" -membertype NoteProperty -Value $State
        $Obj | add-member -name "cert_key_length" -membertype NoteProperty -Value $KeyLenght
        $Obj | add-member -name "cert_signedby" -membertype NoteProperty -Value $Signedby

        if ($PSCmdlet.ShouldProcess( "We are update FreeNas system "))
        {
            $response = Invoke-FreeNasRestMethod -Method Post -body $Obj -Uri $uri

        }
    }

    End
    { }
}
