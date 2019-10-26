function Update-FreeNasInterface
{
    [CmdletBinding()]
    [Alias()]
   
    Param
    (
         [Parameter (Mandatory = $true)]
         [Int]$Id,
         [Parameter (Mandatory = $true)]
         [String]$Ipv4,
         [Parameter (Mandatory = $true)]
         [ValidateSet("8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30")]
         [String]$NetMask

    $Uri = "api/v1.0/system/update/update/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Post

    return $results
}
