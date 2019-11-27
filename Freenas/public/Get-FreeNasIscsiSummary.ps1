function Get-FreeNasIscsiSummary {
    [Alias()]
    Param
    ()

    Begin
    {

    }
    Process
    {
        $Conf_Iscsi = Get-FreenasIscsiConf
        $Extent_Iscsi = Get-FreenasIscsiExtent
        $Initiator_Iscsi = Get-FreenasIscsiInitiator
        $Association = Get-FreenasIscsiAssociat2Extent -Output Name
        $Target_Iscsi = Get-FreenasIscsiTarget

        New-banner -Text "____________" -Online -FontColor Green
        New-banner -Text "Iscsi Summary" -Online

        Write-Host -Object "Your Freenas Server" -NoNewline
        Write-Host -Object " $script:SrvFreenas" -NoNewline -ForegroundColor Cyan
        Write-Host -Object " Iscsi Configuration : "
        $Conf_Iscsi

        Write-Host -Object "The Iscsi Portal : "
        Get-FreenasIscsiPortal

        $TotalSize = ""
        for ($i = 0; $i -lt $Extent_Iscsi.Count; $i++) {
            [int]$Size = [Math]::Round($Extent_Iscsi[$i].Extent_Size , 2)
            [Int]$TotalSize = $TotalSize + $Size
        }
        Write-Host -Object "The Server have"$($Extent_Iscsi).count"Extent(s) with a total size" -NoNewline
        Write-Host -Object " $TotalSize " -NoNewline -ForegroundColor Cyan
        Write-Host -Object "GB"
        Write-Host -Object "The Iscsi Extent Type :"
        $Extent_Iscsi | FT
        Write-Host -Object "The Target Iscsi :"

        $Target_Iscsi | ft
        Write-Host -Object "The Association Target with Extend :"

        $Association | ft
    }
    End {
        New-banner -Text "End Summary"  -Online -FontColor Red

    }
}
