<#
      .SYNOPSIS
      This function return all disk present  on your FreeNas Server
      .DESCRIPTION
      This function return all disk present  on your FreeNas Server
      .EXAMPLE
        PS C:\> Get-FreeNasDisk

        Name Size_GB
        ---- -------
        ada0      20
        da0       30
        da1       30
        da2       30
        da3       30
        da4       30
        da5       30
        da6       30
        .NOTES
      This command allow to find all disk available on your FreeNas or TrueNas server

      .FUNCTIONALITY
      Use this command when you want list your disk on your FreeNas or TrueNas server
      #>

function Get-FreeNasDisk
{
    [CmdletBinding()]
    Param( )

    $Uri = "api/v1.0/storage/disk/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    foreach ($disk in $results)
    {
        $Name = ($disk.disk_name)
        $Size_GB = ([Math]::Round($disk.disk_size / 1024 / 1024 / 1024, 2))
        Write-Verbose " Find the disk $name with the size $Size_GB  "
        [PSCustomObject]@{
            Name    = ($disk.disk_name)
            Size_GB = ([Math]::Round($disk.disk_size / 1024 / 1024 / 1024, 2))
        }
    }
}
