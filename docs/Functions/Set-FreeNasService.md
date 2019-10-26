---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# Set-FreeNasService

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Set-FreeNasService [-Services] <String> [-ServicesStatus] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Nommé
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Services
{{Fill Services Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: afp, cifs, dynamicdns, ftp, iscsitarget, nfs, snmp, ssh, tftp, ups, rsync, smartd, domaincontroller, lldp, webdav, s3, netdata

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicesStatus
{{Fill ServicesStatus Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: True, False

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Nommé
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Aucun(e)


## OUTPUTS

### System.Int32


## NOTES

## RELATED LINKS
