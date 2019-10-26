---
external help file: FreeNas-help.xml
Module Name: Freenas
online version:
schema: 2.0.0
---

# Get-FreeNasInterface

## SYNOPSIS
This function return configuration for you network interface for your FreeNas Server

## SYNTAX

```
Get-FreeNasInterface [<CommonParameters>]
```

## DESCRIPTION
This function return configuration for you network interface for your FreeNas Server

## EXAMPLES

### EXEMPLE 1
```
Here an example with DHCP enable :
```

PS C:\\\> Get-FreeNasInterface

  Id      :
  Status  :
  Alias   :
  Dhcp    :
  Name    :
  Ipv4    :
  Netmask :
  Ipv6    :

### EXEMPLE 2
```
Here an example with Static configuration :
```

PS C:\\\> Get-FreeNasInterface

  Id      : 1
  Status  : Active
  Alias   :
  Dhcp    : False
  Name    : le0
  Ipv4    : 10.0.10.0
  Netmask : 8
  Ipv6    : False

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This command return the network configuration for your FreeNas or TrueNas server

## RELATED LINKS
