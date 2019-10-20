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
        Write-Verbose " Find the disk $name with the size $Size_GB"
        [PSCustomObject]@{
            Name    = ($disk.disk_name)
            Size_GB = ([Math]::Round($disk.disk_size / 1024 / 1024 / 1024, 2))
        }
    }
}
