function Get-FreeNasDisk
{
    [CmdletBinding()]
    Param( )

    Get-FreeNasStatus
    Write-Verbose "Test if you are connect to server FreeNas"
    switch ( $Script:status)
    {
        $true 
        { 
            Write-Verbose "Success"
        }
        $false 
        {
            Write-Error "You are not connected to a FreeNas Server"
            return
        }
    }

    $Uri = "http://$Script:SrvFreenas/api/v1.0/storage/disk/"
    try
    {
        $results = Invoke-RestMethod -Uri $Uri -WebSession $Script:Session -Method Get
    }
    Catch
    {
        Write-Warning "Error querying the NAS using URI $Uri"
        return
    }

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
