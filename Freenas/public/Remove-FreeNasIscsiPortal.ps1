function Remove-FreeNasIscsiPortal
{
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


    Begin
    {
        Get-FreeNasStatus
        switch ( $Script:status)
        {
            $true {  $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/portal/$Id/"  }
            $false {Break}
        }


      

    }
    Process
    {
        switch ($Confirm)
        {
            'True' { $response = invoke-RestMethod -method Delete -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"}
            'False' { Write-Host 'The operation is aborted' -ForegroundColor Red}
        }

        

    }
    End
    {
             
    }
}
