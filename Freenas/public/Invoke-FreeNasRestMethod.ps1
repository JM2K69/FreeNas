
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

        $fullurl = "http://${Server}/${uri}"

        try
        {
            if ($body)
            {
                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json -Compress -Depth 3) -WebSession $Script:Session -headers $headers
            }
            else
            {
                $response = Invoke-RestMethod $fullurl -Method $method -WebSession $Script:Session -headers $headers
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