---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# Connect-FreeNasServer

## SYNOPSIS
Connect FreeNas Server it use to connect to your FreeNas Server or TrueNas

## SYNTAX

```
Connect-FreeNasServer [-Server] <Object> [[-Username] <String>] [[-Password] <SecureString>]
 [[-Credentials] <PSCredential>] [-httpOnly] [-SkipCertificateCheck] [[-port] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Connect FreeNas Server it use to connect to your FreeNas Server or TrueNas

## EXAMPLES

### EXEMPLE 1
```
Connection not secure on Https protocol:
```

PS C:\\\>Connect-FreeNasServer -Server 10.0.10.0 -httpOnly
Welcome on FreeNAS - FreeNAS-11.2-U6 (5acc1dec66)

### EXEMPLE 2
```
Connection with Https by default if you have a self signed certificate use the parameter SkipCertificateCheck
```

PS C:\\\>Connect-FreeNasServer -Server 10.0.10.0 -SkipCertificateCheck $true
Welcome on FreeNAS - FreeNAS-11.2-U6 (5acc1dec66)

## PARAMETERS

### -Server
Description d'aide Freenas

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Freenas

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
{{Fill Username Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
{{Fill Password Description}}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credentials
{{Fill Credentials Description}}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -httpOnly
{{Fill httpOnly Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
{{Fill SkipCertificateCheck Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -port
{{Fill port Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

## NOTES
By default the connection use the secure method to interact with FreeNAs or TrueNas server

## RELATED LINKS
