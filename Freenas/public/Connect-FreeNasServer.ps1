function Connect-FreeNasServer
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Description d’aide Freenas
        [Parameter(Mandatory = $true)]

        [Alias("Freenas")] 
        $Server
    )

    Begin
    {
        $global:SrvFreenas = ""
        $global:Session = ""
        $Uri = "http://$Server/api/v1.0"
        New-banner -Text "Freenas Module v1.1" -Online 
        Write-Verbose "The Server URI i set to $Uri"

    }
    Process
    {
        $Script:SrvFreenas = $Server

        $creds = Get-Credential
        $User = $creds.UserName.ToString()

        $authInfo = [System.Text.Encoding]::UTF8.GetBytes((“{0}:{1}” -f $User, ([Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($creds.Password)))))
        $Headers = @{ Authorization = "Basic {0}" -f [System.Convert]::ToBase64String($authInfo) } 

        try
        {
            $result = Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Get -SessionVariable Freenas_S
        }
        catch
        {
            Write-Error "Error when try to connect to  $Uri"
            return
        }
        $Script:Session = $Freenas_S

        try
        {
            Write-Verbose "try to check Storage to verify the connection"

            $Uri = "http://$Script:SrvFreenas/api/v1.0/storage/disk/"

            $result2 = Invoke-RestMethod -Uri $Uri -WebSession $Script:Session -Method Get 
        }

        catch
        { 
            Write-Warning "Error querying the NAS using URI $Uri"
            return
        }


    }
    End
    {
        if ($result2 -ne $null)
        {
            Write-Host "Your are already connect to $Script:SrvFreenas "-ForegroundColor Cyan
        }
    }
}