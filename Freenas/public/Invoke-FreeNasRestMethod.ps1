
function Invoke-FreeNasRestMethod
{

    <#
      .SYNOPSIS
      Invoke RestMethod with FreeNas connection (internal) variable

      .DESCRIPTION
      Invoke RestMethod with FreeNas connection variable (token,.)

      .EXAMPLE
      Invoke-FreeNasRestMethod -method "get" -uri "api/v1.0/storage/disk/"

      Invoke-RestMethod with FreeNas connection for get api/v1.0/storage/disk/ uri
    #>

    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$uri,
        [Parameter(Mandatory = $false)]
        [ValidateSet("GET", "PUT", "POST", "DELETE")]
        [String]$method = "GET",
        [Parameter(Mandatory = $false)]
        [psobject]$body
    )

    Begin
    {

    }

    Process
    {

        if ($null -eq $Script:SrvFreenas)
        {
            Throw "Not Connected. Connect to the FreeNas with Connect-FreeNas"
        }

        $Server = $Script:SrvFreenas
        $sessionvariable = $Script:Session
        $headers = $Script:Headers
        $invokeParams = $Script:invokeParams
        $httpOnly = $Script:httpOnly

        if ($httpOnly) {
            $fullurl = "http://${Server}:${port}/${uri}"
        }
        else {
            $fullurl = "https://${Server}:${port}/${uri}"
        }

        try
        {
            if ($body)
            {
                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json -Compress -Depth 3) -WebSession $sessionvariable -headers $headers @invokeParams
            }
            else
            {
                $response = Invoke-RestMethod $fullurl -Method $method -WebSession $sessionvariable -headers $headers @invokeParams
            }
        }

        catch
        {
            Show-FreeNasException $_
            throw "Unable to use FreeNAS API"
        }
        $response

    }

}