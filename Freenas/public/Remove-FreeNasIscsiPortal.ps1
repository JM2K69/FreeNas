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
        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }

        $Uri = "http://$global:SrvFreenas/api/v1.0/services/iscsi/portal/$Id/"

    }
    Process
    {
        switch ($Confirm)
        {
            'True' { $response = invoke-RestMethod -method Delete -body $post -Uri $Uri -WebSession $global:Session -ContentType "application/json"}
            'False' { Write-Host 'The operation is aborted' -ForegroundColor Red}
        }

        

    }
    End
    {
             
    }
}
