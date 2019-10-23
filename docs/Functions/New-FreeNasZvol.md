---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# New-FreeNasZvol

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
New-FreeNasZvol [-VolumeName] <String> [-ZvolName] <String> [-Volsize] <Int32> [[-Unit] <String>]
 [[-Compression] <String>] [[-Sparse] <String>] [[-BlokSize] <String>] [[-Comment] <String>]
 [<CommonParameters>]
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

### -BlokSize
{{Fill BlokSize Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: 4K, 8K, 16K, 32K, 64K, 128K

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
{{Fill Comment Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Compression
{{Fill Compression Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: lz4, gzip, gzip-1, gzip-9, zle, lzjb

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sparse
{{Fill Sparse Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: True, False

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Unit
{{Fill Unit Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: KiB, MiB, GiB

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Volsize
{{Fill Volsize Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### -ZvolName
{{Fill ZvolName Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Aucun(e)


## OUTPUTS

### System.Int32


## NOTES

## RELATED LINKS
