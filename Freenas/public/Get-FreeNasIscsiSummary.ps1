function Get-FreeNasIscsiSummary
{
    [Alias()]
    Param
    ()

    Begin
    {
        if (  $script:SrvFreenas -eq $null -or $script:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red
        }

    }
    Process
    {
        $Conf_Iscsi = Get-FreenasIscsiConf
        $Extent_Iscsi = Get-FreenasIscsiExtent
        $Initiator_Iscsi = Get-FreenasIscsiInitiator
        $Portal_Iscsi = Get-FreenasIscsiPortal
        $Target_Iscsi = Get-FreenasIscsiTarget
        $TargetAsso = Get-FreenasIscsiAssociat2Extent -Output Name
        $Service_ISCSI = Get-FreenasService

        New-banner -Text "____________" -Online -FontColor Green
        New-banner -Text "Iscsi Summary" -Online 

        Write-Host "Your Freenas Server" -NoNewline
        Write-Host " $script:SrvFreenas" -NoNewline -ForegroundColor Cyan
        Write-Host " Iscsi Configuration : " 
        $Conf_Iscsi

        $TotalSize = ""
        for ($i = 0; $i -lt $Extent_Iscsi.Count; $i++)
        {
            [int]$Size = [Math]::Round($Extent_Iscsi[$i].Extent_Size , 2)
            [Int]$TotalSize = $TotalSize + $Size
        }
        Write-host "The Server have"$($Extent_Iscsi).count"Extent(s) with a total size" -NoNewline
        Write-Host " $TotalSize " -NoNewline -ForegroundColor Cyan 
        Write-Host "GB"

        $Extent_Iscsi | FT

    }
    End {}
}
