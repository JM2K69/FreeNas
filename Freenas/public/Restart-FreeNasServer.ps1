function Restart-FreeNasServer {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [Alias()]
    Param
    (
    )


    Begin {
        Get-FreeNasStatus
        switch ( $Script:status) {
            $true { }
            $false { Break }
        }

    }
    Process {
        $Uri = "api/v1.0/system/reboot/"

        $post = Invoke-FreeNasRestMethod -method Post -body $post -Uri $Uri

    }
    End
    { }
}
