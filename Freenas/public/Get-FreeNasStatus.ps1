function Get-FreeNasStatus {
    Param
    ( )


    if (   $null -eq $script:SrvFreenas -or $null -eq $script:Session) {
        Write-Warning "Your aren't connected "
        $Script:status = $false
    }
    else {
        $Script:status = $true

    }
}
