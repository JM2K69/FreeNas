function New-FreeNasSystemNTP
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter (Mandatory = $true)]
        [string]$NtpServer,

        [Parameter (Mandatory = $False)]
        [ValidateSet("True", "False")]
        [string]$PreferServer,

        [Parameter (Mandatory = $False)]
        [int]$MinPoll = 6,

        [Parameter (Mandatory = $False)]
        [int]$MaxPoll = 10,

        [Parameter (Mandatory = $False)]
        [ValidateSet("True", "False")]
        [string]$NtpBurst = "Fasle",

        [Parameter (Mandatory = $False)]
        [ValidateSet("True", "False")]
        [string]$NtpIBurst = "True"

    )


    Begin {

    }
    Process
    {
        $Uri = "http://$script:SrvFreenas/api/v1.0/system/ntpserver/"

        $Obj = new-Object -TypeName PSObject
        $Obj | add-member -name "ntp_address" -membertype NoteProperty -Value $NtpServer
        $Obj | add-member -name "ntp_prefer" -membertype NoteProperty -Value $PreferServer
        $Obj | add-member -name "ntp_minpoll" -membertype NoteProperty -Value $MinPoll
        $Obj | add-member -name "ntp_maxpoll" -membertype NoteProperty -Value $MaxPoll
        $Obj | add-member -name "ntp_burst" -membertype NoteProperty -Value $NtpBurst
        $Obj | add-member -name "ntp_iburst" -membertype NoteProperty -Value $NtpIBurst 

        $post = $Obj |ConvertTo-Json
        $response = invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $script:Session -ContentType "application/json"

    }
    End
    {}
}
