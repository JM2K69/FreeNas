function Remove-FreeNasIscsiPortal {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter (Mandatory = $true)]
        [Int]$Id,

        [Parameter (Mandatory = $true)]
        [ValidateSet("False", "True")]
        [string]$Confirm

    )


    Begin {
        Get-FreeNasStatus
        switch ( $Script:status) {
            $true { $Uri = "api/v1.0/services/iscsi/portal/$Id/" }
            $false { Break }
        }




    }
    Process {
        switch ($Confirm) {
            'True' { $response = Invoke-FreeNasRestMethod -method Delete -body $post -Uri $Uri }
            'False' { Write-Host 'The operation is aborted' -ForegroundColor Red }
        }



    }
    End {

    }
}
