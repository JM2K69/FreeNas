---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# New-FreeNasVolume

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
New-FreeNasVolume [-VolumeName] <String> [-Vdevtype] <String> [[-DiskNamebase] <String>] [-NbDisks] <Int32>
 [[-StartDisksNB] <Int32>] [<CommonParameters>]
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

### -DiskNamebase
{{Fill DiskNamebase Description}}

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

### -NbDisks
{{Fill NbDisks Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDisksNB
{{Fill StartDisksNB Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Vdevtype
{{Fill Vdevtype Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: stripe, mirror, raidz, raidz2, raidz3

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VolumeName
{{Fill VolumeName Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Aucun(e)


## OUTPUTS

### System.Int32


## NOTES

## RELATED LINKS
