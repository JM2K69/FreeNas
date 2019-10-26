---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# Get-FreeNasInternalCA

## SYNOPSIS
This function return Internal CA for your FreeNas Server

## SYNTAX

```
Get-FreeNasInternalCA [<CommonParameters>]
```

## DESCRIPTION
This function return Internal CA for your FreeNas Server

## EXAMPLES

### EXEMPLE 1
```
Get-FreeNasInternalCA
```

CA_type_existing      : False
  CA_type_intermediate  : False
  CA_type_internal      : True
  cert_CSR              :
  cert_DN               : /C=US/ST=US/L=New York/O=FreeNas/CN=FreeNas/emailAddress=freenas@JM2K69.loc
  cert_certificate      : -----BEGIN CERTIFICATE-----
                          MIIDpjCCAo6gAwIBAgIEAMoKjjANBgkqhkiG9w0BAQsFADBzMQswCQYDVQQGEwJV
                          -----END CERTIFICATE-----

  cert_chain            : False
  cert_city             : New York
  cert_common           : FreeNas
  cert_country          : US
  cert_digest_algorithm : SHA256
  cert_email            : freenas@JM2K69.it
  cert_from             : Thu Oct 24 05:36:35 2019
  cert_internal         : YES
  cert_issuer           : self-signed
  cert_key_length       : 2048
  cert_lifetime         : 3650
  cert_name             : CAInternal
  cert_ncertificates    : 2
  cert_organization     : FreeNas
  cert_privatekey       : -----BEGIN PRIVATE KEY-----
                          MIIEwAIBADANBgkqhkiG9w0BAQEFAASCBKowggSmAgEAAoIBAQCn6q6U+PfVCqzl
                          8ZulOiwcns2zxxRK0uAU1VLsctQ=
                          -----END PRIVATE KEY-----
  cert_san              :
  cert_serial           : 13240974
  cert_state            : US
  cert_type             : 2
  cert_until            : Sun Oct 21 05:36:35 2029
  id                    : 1

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This command return the certification authority your FreeNas or TrueNas server

## RELATED LINKS
