
function Invoke-FreeNasRestMethod {

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

    Begin {
    }

    Process {


        $Server = $Script:SrvFreenas
        $sessionvariable = $Script:Session

        $fullurl = "http://${Server}/${uri}"

        try {
            if ($body) {
                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json) -WebSession $sessionvariable
            }
            else {
                $response = Invoke-RestMethod $fullurl -Method $method -WebSession $sessionvariable
            }
        }

        catch {
            throw "Unable to use FreeNAS API"
        }
        $response

    }

}