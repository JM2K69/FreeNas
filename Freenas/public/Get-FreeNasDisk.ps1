function Get-FreeNasDisk
{
    Param
    (
        [Parameter (Mandatory = $False)]
        [ValidateSet("False", "True")] 
        [String]$Output = "True"
    
    )

    Begin
    {
        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }

    }
    Process
    {
        $Uri = "http://$global:SrvFreenas/api/v1.0/storage/disk/"

        try { $result = Invoke-RestMethod -Uri $Uri -WebSession $global:Session -Method Get }
       
        Catch {}

    }
    End
    {
        $FreenasDisk = New-Object System.Collections.ArrayList
        for ($i = 0; $i -lt $result.Count; $i++)
        {
            [int]$Size = [Math]::Round($result[$i].disk_size / 1024 / 1024 / 1024, 2)
            [Int]$TotalSize = $TotalSize + $Size
            $Name = $result[$i].disk_name
            $temp = New-Object System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Name" -Value "$Name"
            $temp | Add-Member -MemberType NoteProperty -Name "Size_GB" -Value "$Size"
            $FreenasDisk.Add($temp) | Out-Null
        }
    

        switch ($Output)
        {
            'True' 
            {        
                $Nbdisk = $FreenasDisk.count
                write-host "The Freenas Server $global:SrvFreenas have $Nbdisk Disk(s) with a total $TotalSize GB" -ForegroundColor Cyan
            }
            'False' {}
        }
        return $FreenasDisk
             


    }
}
