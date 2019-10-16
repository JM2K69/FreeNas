class FreeNasServer
{
    [String] $NomCommun
    [ipaddress] $ServerAddress 
    [String]$Uri
    [String]$AuthToken
    [System.Collections.ArrayList]$ListDisk
        
    FreeNasServer()
    {}
    
    FreeNasServer ([String]$NomCommun, [ipaddress]$ServerAddress)
    {
        $this.NomCommun = $NomCommun
        $this.ServerAddress = $ServerAddress
        $this.Uri =  = "http://$ServerAddress/api/v1.0"
    }

   [void] connect()
    {
        Invoke-RestMethod -Uri $This.Uri  -Method Get -SessionVariable $This.AuthToken -Credential (Get-Credential)

    }

    [System.Collections.ArrayList] getdisks()
    {
        
        return $This.ListDisk
    }

}

class DDisk
{
   [String]$Backend = "/storage/disk/"
   [String]$Uri = "http://$ServerAddress/api/v1.0"
   [String]$AuthToken

   DDisk([String]$Uri,[String]$AuthToken)
   {
      $this.Uri = $Uri
      $This.AuthToken = $AuthToken
   }

    
   [System.Collections.ArrayList]getlist()
   {
   
    $results = Invoke-RestMethod -Uri $this.Uri -WebSession $this.AuthToken -Method Get
   
     foreach ($disk in $results)
    {
        $Name = ($disk.disk_name)
        $Size_GB = ([Math]::Round($disk.disk_size / 1024 / 1024 / 1024, 2))
        Write-Verbose " Find the disk $name with the size $Size_GB  "
        $diskFound = [Disk]::new()
        [DisK]@{
            Name    = ($disk.disk_name)
            Size_GB = ([Math]::Round($disk.disk_size / 1024 / 1024 / 1024, 2))
        }
    }


   }

   save([Disk]$D)
   {
   }
   update([Disk]$D)
   {
   }

   delete([Disk]$D)
   {
   }
}

class Disk
{
    [String]$Name
    [Int]$Size_GB

    Disk()
    {
    
        
    
    }
}