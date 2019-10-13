﻿function New-FreeNasIscsiTarget {
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter (Mandatory = $true)]
        [string]$TargetName,

        [Parameter (Mandatory = $false)]
        [string]$TargetAlias,


        [Parameter (Mandatory = $false)]
        [string]$TargetMode = "iscsi"


    )


    Begin {
        Get-FreeNasStatus
        switch ( $Script:status) {
            $true { }
            $false { Break }
        }


    }
    Process {
        $Uri = "api/v1.0/services/iscsi/target/"

        $Obj = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('TargetName') ) {
            $Obj | add-member -name "iscsi_target_name" -membertype NoteProperty -Value $TargetName.ToLower()
        }

        if ( $PsBoundParameters.ContainsKey('TargetAlias') ) {
            $Obj | add-member -name "iscsi_target_alias" -membertype NoteProperty -Value $TargetAlias.ToLower()
        }

        $Obj | add-member -name "iscsi_target_mode" -membertype NoteProperty -Value $TargetMode.ToLower()

        $response = Invoke-FreeNasRestMethod -method Post -body $Obj -Uri $Uri

    }
    End
    { }
}
