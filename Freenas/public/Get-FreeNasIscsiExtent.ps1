function Get-FreeNasIscsiExtent
{

    Param
    ()


    Begin
    {
        Get-FreeNasStatus
        switch ( $Script:status)
        {
            $true { }
            $false { Break }
        }

    }
    Process
    {
        $Uri = "api/v1.0/services/iscsi/extent/"
        try { $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get }

        Catch { throw }

        $Extent = New-Object System.Collections.ArrayList


        for ($i = 0; $i -lt $result.Count; $i++)
        {
            try
            {
                if ($($result[$i].iscsi_target_extent_type) -eq "Disk")
                {

                    $Disk_path = $($result[$i].iscsi_target_extent_path)
                    $value = $Disk_path.Substring($Disk_path.Length - 3)

                    $DiskFreenas = Get-FreenasDisk -Output False

                    foreach ($item in $DiskFreenas)
                    {
                        if ($item.Name -eq $value)
                        {
                            $diskSize = $Item.Size_GB
                        }
                    }

                }
            }
            Catch { throw }
            $temp = New-Object System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value  "$($result[$i].id)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent_Type" -Value "$($result[$i].iscsi_target_extent_type)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent_Name" -Value  "$($result[$i].iscsi_target_extent_name)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent_Size" -Value   $diskSize
            $temp | Add-Member -MemberType NoteProperty -Name "Extent_path" -Value  "$($result[$i].iscsi_target_extent_path)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent_Block_Size" -Value  "$($result[$i].iscsi_target_extent_blocksize)"
            $temp | Add-Member -MemberType NoteProperty -Name "Extent_Speed_Type" -Value "$($result[$i].iscsi_target_extent_rpm)"

            $Extent.Add($temp) | Out-Null
        }


        return $Extent


    }
    End
    { }
}
