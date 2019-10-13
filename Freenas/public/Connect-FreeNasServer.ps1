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
        Get-PowerShellVersion
        $global:SrvFreenas = ""
        $global:Session = ""
        $global:Header
        $Uri = "http://$Server/api/v1.0"
        New-banner -Text "Freenas Module v1.3" -Online
        Write-Verbose "The Server URI i set to $Uri"

    }
    Process
    {
        $Script:SrvFreenas = $Server
        #headers, We need to have Content-type set to application/json...
        $script:headers = @{ "Content-type" = "application/json" }

        switch ($Script:Version)
        {
            '5'
            {
                Write-Verbose "Powershell $Script:Version is detected"
                try { $result = Invoke-RestMethod -Uri $Uri  -Method Get -SessionVariable Freenas_S -Credential (Get-Credential) }
                catch
                {
                    Write-Error "Error when try to connect to  $Uri"
                    return
                }
                $Script:Session = $Freenas_S

            }
            '6'
            {
                Write-Verbose "Powershell $Script:Version is detected"
                try { $result = Invoke-RestMethod -Uri $Uri -Authentication Basic -AllowUnencryptedAuthentication -Method Get -SessionVariable Freenas_S -Credential (Get-Credential) }
                catch
                {
                    Write-Error "Error when try to connect to  $Uri"
                    return
                }
                $Script:Session = $Freenas_S
            }
            '7'
            {
                Write-Verbose "Powershell $Script:Version is detected"
                try { $result = Invoke-RestMethod -Uri $Uri -Authentication Basic -AllowUnencryptedAuthentication -Method Get -SessionVariable Freenas_S -Credential (Get-Credential) }
                catch
                {
                    Write-Error "Error when try to connect to  $Uri"
                    return
                }
                $Script:Session = $Freenas_S
            }
        }
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
        if ($null -ne $result2)
        {
            Write-Host "Your are already connect to $Script:SrvFreenas "-ForegroundColor Cyan
        }
    }
}