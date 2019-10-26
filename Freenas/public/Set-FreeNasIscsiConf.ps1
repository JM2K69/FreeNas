function Set-FreeNasIscsiConf
{
    [CmdletBinding()]
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

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/services/iscsi/globalconfiguration/"

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

        $post = $IscsiConf |ConvertTo-Json

        $response = invoke-RestMethod -method Put -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"

    }
    End
    {

    }
}
