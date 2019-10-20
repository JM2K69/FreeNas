function Update-FreeNasSetting
{
    [CmdletBinding(SupportsShouldProcess)]
    [Alias()]
    Param
    (
        [Parameter (Mandatory = $true)]
        [string]$Id,

        [Parameter (Mandatory = $false)]
        [String]$GuiPort,

        [Parameter (Mandatory = $false)]
        [String]$GuiHttpsPort,

        [Parameter (Mandatory = $false)]
        [ValidateSet("true", "false")]
        [String]$GuiHttpsredirect,


        [Parameter (Mandatory = $false)]
        [ValidateSet("http", "httphttps", "https")]
        [String]$GuiProtocol,

        [Parameter (Mandatory = $false)]
        [String]$Guiv6Address = "::",

        [Parameter (Mandatory = $false)]
        [ipaddress]$Syslogserver,

        [Parameter (Mandatory = $false)]
        [String]$Language,

        [Parameter (Mandatory = $false)]
        [String]$Directoryservices,

        [Parameter (Mandatory = $false)]
        [ipaddress]$GuiAddress = "0.0.0.0",

        [Parameter (Mandatory = $false)]
        [Int]$GuiCertifiacteId

    )


    Begin
    { }
    Process
    {
        $Uri = "/api/v1.0/system/settings/"

        $Obj = new-Object -TypeName PSObject

        $Obj | add-member -name "id" -membertype NoteProperty -Value $Id

        if ( $PsBoundParameters.ContainsKey('GuiPort') )
        {

            $Obj | add-member -name "stg_guiport" -membertype NoteProperty -Value $GuiPort
        }
        if ( $PsBoundParameters.ContainsKey('GuiHttpsPort') )
        {

            $Obj | add-member -name "stg_guihttpsport" -membertype NoteProperty -Value $GuiHttpsPort
        }
        if ( $PsBoundParameters.ContainsKey('GuiHttpsredirect') )
        {

            $Obj | add-member -name "stg_guihttpsredirect" -membertype NoteProperty -Value $GuiHttpsredirect
        }
        if ( $PsBoundParameters.ContainsKey('GuiProtocol') )
        {

            $Obj | add-member -name "stg_guiprotocol" -membertype NoteProperty -Value $GuiProtocol
        }
        if ( $PsBoundParameters.ContainsKey('Guiv6Address') )
        {

            $Obj | add-member -name "stg_guiv6address" -membertype NoteProperty -Value $Guiv6Address
        }
        if ( $PsBoundParameters.ContainsKey('Syslogserver') )
        {

            $Obj | add-member -name "stg_syslogserver" -membertype NoteProperty -Value $Syslogserver
        }
        if ( $PsBoundParameters.ContainsKey('Language') )
        {

            $Obj | add-member -name "stg_language" -membertype NoteProperty -Value $Language
        }
        if ( $PsBoundParameters.ContainsKey('Directoryservices') )
        {

            $Obj | add-member -name "stg_directoryservice" -membertype NoteProperty -Value $Directoryservices
        }
        if ( $PsBoundParameters.ContainsKey('GuiAddress') )
        {

            $Obj | add-member -name "stg_guiaddress" -membertype NoteProperty -Value $GuiAddress
        }
        if ( $PsBoundParameters.ContainsKey('GuiCertifiacteId') )
        {

            $Obj | add-member -name "stg_guicertificate" -membertype NoteProperty -Value $GuiCertifiacteId
        }

        if ($PSCmdlet.ShouldProcess( "We are update FreeNas system "))
        {
            $response = Invoke-FreeNasRestMethod -method PUT -body $Obj -Uri $Uri
        }
    }
    End
    { }
}
