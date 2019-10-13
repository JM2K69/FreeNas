function Set-FreeNasIscsiConf
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter (Mandatory = $false)]
        [string]$BaseName,

        [Parameter (Mandatory = $false)]
        [string]$isns_servers,

        [Parameter (Mandatory = $false)]
        [ValidateSet("50", "55", "60", "65", "70", "75", "80", "85", "90", "95")]
        [INT]$pool_avail_threshold


    )


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
        $Uri = "api/v1.0/services/iscsi/globalconfiguration/"

        $IscsiConf = new-Object -TypeName PSObject


        if ( $PsBoundParameters.ContainsKey('BaseName') )
        {
            $IscsiConf | add-member -name "iscsi_basename" -membertype NoteProperty -Value $BaseName
        }

        if ( $PsBoundParameters.ContainsKey('isns_servers') )
        {
            $IscsiConf | add-member -name "iscsi_isns_servers" -membertype NoteProperty -Value $isns_servers
        }

        if ( $PsBoundParameters.ContainsKey('pool_avail_threshold') )
        {

            $IscsiConf | add-member -name "iscsi_pool_avail_threshold" -membertype NoteProperty -Value $pool_avail_threshold
        }

        $response = Invoke-FreeNasRestMethod -method Put -body $IscsiConf -Uri $Uri

    }
    End
    {

    }
}
