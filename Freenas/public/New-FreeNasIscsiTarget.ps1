function New-FreeNasIscsiTarget
{
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


    Begin
    {
        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red

        }

    }
    Process
    {
        $Uri = "http://$global:SrvFreenas/api/v1.0/services/iscsi/target/"

        $Obj = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('TargetName') ) 
        {
            $Obj | add-member -name "iscsi_target_name" -membertype NoteProperty -Value $TargetName.ToLower()
        } 

        if ( $PsBoundParameters.ContainsKey('TargetAlias') ) 
        {
            $Obj | add-member -name "iscsi_target_alias" -membertype NoteProperty -Value $TargetAlias.ToLower()
        } 

        $Obj | add-member -name "iscsi_target_mode" -membertype NoteProperty -Value $TargetMode.ToLower()

        $post = $Obj |ConvertTo-Json
        $response = invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $global:Session -ContentType "application/json"

    }
    End
    {}
}
