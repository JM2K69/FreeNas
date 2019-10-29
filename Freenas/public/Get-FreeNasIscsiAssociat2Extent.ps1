function Get-FreeNasIscsiAssociat2Extent
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [ValidateSet("Id", "Name")]
        [string]$Output = "Id"

    )


    Begin
    {

    }
    Process
    {
        $Uri = "api/v1.0/services/iscsi/targettoextent/"

        $result = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

        switch ($Output)
        {
            'Id'
            {
                $FreenasIscsiAssociat2Extent = New-Object System.Collections.ArrayList
                for ($i = 0; $i -lt $result.Count; $i++)
                {
                    $temp = New-Object System.Object
                    $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].Id)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi_Extent_Id" -Value "$($result[$i].iscsi_extent)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi_LunId" -Value "$($result[$i].iscsi_lunid)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi_Target_Id" -Value "$($result[$i].iscsi_target)"

                    $FreenasIscsiAssociat2Extent.Add($temp) | Out-Null
                }
            }
            'Name'
            {
                $FreenasIscsiAssociat2Extent = New-Object System.Collections.ArrayList
                for ($i = 0; $i -lt $result.Count; $i++)
                {
                    $value = $result[$i].iscsi_extent
                    $value2 = $result[$i].iscsi_target
                    $TargetName = Get-FreenasIscsiTarget
                    $IscsiExtend = Get-FreenasIscsiExtent


                    foreach ($item in $TargetName)
                    {
                        if ( $Item.Id -eq $value2 )
                        {
                            $TargetNameF = $item.Target_Name
                        }

                    }

                    foreach ($item in $IscsiExtend)
                    {
                        if ( $Item.Id -eq $value )
                        {
                            $IscsiExtendF = $item.Extent_Name
                        }
                    }


                    $temp = New-Object System.Object
                    $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].Id)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Iscsi_Extent_Name" -Value $IscsiExtendF
                    $temp | Add-Member -MemberType NoteProperty -Name "LUN Id" -Value "$($result[$i].iscsi_lunid)"
                    $temp | Add-Member -MemberType NoteProperty -Name "Target_Name" -Value $TargetNameF

                    $FreenasIscsiAssociat2Extent.Add($temp) | Out-Null
                }

            }

        }

        return $FreenasIscsiAssociat2Extent
    }
    End
    {}
}
