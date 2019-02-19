function New-FreeNasZvol
{

    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (

        [Parameter (Mandatory = $true)]
        [string]$VolumeName,

        [Parameter (Mandatory = $true)]
        [string]$ZvolName,

        [Parameter (Mandatory = $true)]
        [Int]$Volsize,

        [Parameter (Mandatory = $False)]
        [ValidateSet("KiB", "MiB", "GiB")] 
        [String]$Unit = "GiB",


        [Parameter (Mandatory = $False)]
        [ValidateSet("lz4", "gzip", "gzip-1" , "gzip-9", "zle", "lzjb")] 
        [String]$Compression = "lz4",

        [Parameter (Mandatory = $False)]
        [ValidateSet("True", "False")] 
        [String]$Sparse,

        [Parameter (Mandatory = $False)]
        [ValidateSet("4K", "8K", "16K" , "32K", "64K", "128K")] 
        [String]$BlokSize = "4K",

        [Parameter (Mandatory = $False)] 
        [String]$Comment




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

        $Uri = "http://$global:SrvFreenas/api/v1.0/storage/volume/$VolumeName/zvols/"


        $Zvolc = new-Object -TypeName PSObject


        if ( $PsBoundParameters.ContainsKey('ZvolName') ) 
        {
            $Zvolc | add-member -name "name" -membertype NoteProperty -Value $ZvolName
        } 

        if ( $PsBoundParameters.ContainsKey('Volsize') -and $PsBoundParameters.ContainsKey('Unit') )
        {
            [String]$Size = "$volsize" + "$Unit"
            $Zvolc | add-member -name "volsize" -membertype NoteProperty -Value $Size
        }
        if ( $PsBoundParameters.ContainsKey('Sparse') )
        {
            $Zvolc | add-member -name "sparse" -membertype NoteProperty -Value $Sparse
        }
        if ( $PsBoundParameters.ContainsKey('Force') )
        {
            $Zvolc | add-member -name "force" -membertype NoteProperty -Value $Force
        }

        if ( $PsBoundParameters.ContainsKey('Compression') )
        {
            $Zvolc | add-member -name "compression" -membertype NoteProperty -Value $Compression
        }

        if ( $PsBoundParameters.ContainsKey('Comment') )
        {
            $Zvolc | add-member -name "comments" -membertype NoteProperty -Value $Comment
        }

        if ( $PsBoundParameters.ContainsKey('BlokSize') )
        {
            $Zvolc | add-member -name "blocksize" -membertype NoteProperty -Value $BlokSize    
        }

        $post = $Zvolc |ConvertTo-Json

        $response = invoke-RestMethod -method Post -body $post -Uri $Uri -WebSession $global:Session -ContentType "application/json"

    }

    End
    {
    }
}
