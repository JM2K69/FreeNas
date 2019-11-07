function Get-FreeNasIscsiSummary
{
    [Alias()]
    Param
    ()

    Begin
    {

    }
    Process
    {
        $Extent_Iscsi = Get-FreenasIscsiExtent
        $Association = Get-FreenasIscsiAssociat2Extent -Output Name
        $Target_Iscsi = Get-FreenasIscsiTarget

        New-banner -Text "____________" -Online -FontColor Green
        New-banner -Text "Iscsi Summary" -Online

        Write-Host "Your Freenas Server" -NoNewline
        Write-Host " $script:SrvFreenas" -NoNewline -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Iscsi Configuration : " -ForegroundColor Yellow
        Get-FreenasIscsiConf

        Write-host "The Iscsi Portal : " -ForegroundColor Yellow
        Get-FreenasIscsiPortal
        Write-host "The Target Iscsi :" -ForegroundColor Yellow
        write-host ""
        get-FreenasIscsiInitiator
        Write-host "The Iscsi Extent : " -ForegroundColor Yellow

        $TotalSize = ""
        for ($i = 0; $i -lt $Extent_Iscsi.Count; $i++)
        {
            [int]$Size = [Math]::Round($Extent_Iscsi[$i].Extent_Size , 2)
            [Int]$TotalSize = $TotalSize + $Size
        }
        Write-host "The Server have"$($Extent_Iscsi).count"Extent(s) with a total size" -NoNewline
        Write-Host " $TotalSize " -NoNewline -ForegroundColor Green
        Write-Host "GB"
        Write-host "The Iscsi Extent Type : " -ForegroundColor Yellow
        Get-FreenasIscsiExtent | FT
        Write-host "The Target Iscsi :" -ForegroundColor Yellow
        $Target_Iscsi | ft
        Write-host "The Association Target with Extend :" -ForegroundColor Yellow

        $Association | ft
    }
    End
    {
        New-banner -Text "End Summary"  -Online -FontColor Red

    }
}
