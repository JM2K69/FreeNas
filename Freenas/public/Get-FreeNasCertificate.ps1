function Get-FreeNasCertificate
{
    [CmdletBinding()]
    [Alias()]
    Param
    ()


    Begin
    { }
    Process
    {
        $Uri = "/api/v1.0/system/certificate/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        $Certificate = New-Object System.Collections.ArrayList

        if ($null -eq $result.count)
        {

            $temp = New-Object System.Object
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

                $temp = New-Object System.Object
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
        return $Certificate



    }
    End
    {
    }
}
