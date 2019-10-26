---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# New-FreeNasInternalCA

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
New-FreeNasInternalCA [-Name] <String> [-CommonName] <String> [-City] <String> [-State] <String>
 [-Country] <String> [-Email] <String> [-Organization] <String> [-DigestAlgo] <String> [-Liftime] <Int32>
 [-KeyLenght] <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
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

### -City
{{Fill City Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommonName
{{Fill CommonName Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -Country
{{Fill Country Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DigestAlgo
{{Fill DigestAlgo Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: SHA1, SHA224, SHA256, SHA384, SHA512

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
{{Fill Email Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyLenght
{{Fill KeyLenght Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 1024, 2048, 4096

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Liftime
{{Fill Liftime Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
{{Fill Organization Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
{{Fill State Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
