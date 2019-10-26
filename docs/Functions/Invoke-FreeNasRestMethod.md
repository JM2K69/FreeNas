---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# Invoke-FreeNasRestMethod

## SYNOPSIS
Invoke RestMethod with FreeNas connection (internal) variable

## SYNTAX

```
Invoke-FreeNasRestMethod [-uri] <String> [-method <String>] [-body <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Invoke RestMethod with FreeNas connection variable (token,.)

## EXAMPLES

### EXEMPLE 1
```
Invoke-FreeNasRestMethod -method "get" -uri "api/v1.0/storage/disk/"
```

Invoke-RestMethod with FreeNas connection for get api/v1.0/storage/disk/ uri

## PARAMETERS

### -uri
{{Fill uri Description}}

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

### -method
{{Fill method Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -body
{{Fill body Description}}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
