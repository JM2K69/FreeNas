---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# Get-FreeNasCertificate

## SYNOPSIS
This function return Certificate created on your FreeNas Server

## SYNTAX

```
Get-FreeNasCertificate [<CommonParameters>]
```

## DESCRIPTION
This function return Certificate created on your FreeNas Server

## EXAMPLES

### EXEMPLE 1
```
Get-FreeNasCertificate
```

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

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This command allow to find all certificate created on your FreeNas or TrueNas server

## RELATED LINKS
