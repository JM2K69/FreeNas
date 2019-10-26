---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# New-FreeNasIscsiExtent

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
New-FreeNasIscsiExtent [-ExtentName] <String> [-ExtenType] <String> [-ExtentSpeed] <Object>
 [-ExtenDiskPath] <String> [<CommonParameters>]
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

### -ExtenDiskPath
{{Fill ExtenDiskPath Description}}

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

### -ExtenType
{{Fill ExtenType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Disk, File

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtentName
{{Fill ExtentName Description}}

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

### -ExtentSpeed
{{Fill ExtentSpeed Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: Unknown, SSD, 5400, 7200, 10000, 15000

Required: True
Position: 2
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
