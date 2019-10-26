#region Connection au serveur
Import-Module C:\Users\JM2K69\Documents\GitHub\FreeNas\Freenas\FreeNas.psm1 -Force
Connect-FreeNasServer -Server 192.168.0.25

#endregion Connection au serveur

#region Création de Volumes

Get-FreeNasDisk
New-FreeNasVolume -VolumeName data -Vdevtype stripe -NbDisks 2 -StartDisksNB 0
New-FreeNasVolume -VolumeName data2 -Vdevtype raidz -NbDisks 3 -StartDisksNB 2
Get-FreeNasVolume
#endregion Création de Volumes

#region Creation de Volumes Zvol
New-FreeNasZvol -VolumeName data -ZvolName Zvol1 -Volsize 15 -Unit GiB -Compression lz4 -Sparse True -Comment "Pwsh JM2K69"
New-FreeNasZvol -VolumeName data -ZvolName Zvol1a -Volsize 35 -Unit GiB -Compression lz4 -Sparse True -Comment "Pwsh JM2K69"
New-FreeNasZvol -VolumeName data2 -ZvolName Zvol2 -Volsize 20 -Unit GiB -Compression lz4 -Sparse True -Comment "Pwsh JM2K69"
New-FreeNasZvol -VolumeName data2 -ZvolName Zvol2a -Volsize 60 -Unit GiB -Compression lz4 -Sparse True -Comment "Pwsh JM2K69"
Get-FreeNasZvol -VolumeName data
Get-FreeNasZvol -VolumeName data2
#endregion Creation de Volumes Zvol

#region Confiuration de la depuplication sur un Zvol
Set-FreeNasDedupZvol -VolumeName data -ZvolName Zvol1
Get-FreeNasZvol -VolumeName data
#endregion Confiuration de la depuplication sur un Zvol


#region Configuration du partage ISCSI
# recupération des Infos
Get-FreeNasIscsiConf
#creation du Configurtation Global avec un nom qui commence par iqn
Set-FreeNasIscsiConf -BaseName "iqn.2019-10.org.JM2K69.Pwsh" -pool_avail_threshold 75
Get-FreeNasIscsiConf

#region Le Portail
Get-FreeNasIscsiPortal
New-FreenasIscsiPortal -IpPortal 0.0.0.0   -Port 3260
#endregion Le Portail

#region Initiateurs
Get-FreeNasIscsiInitiator
New-FreeNasIscsiInitiator -AuthInitiators ALL -AuthNetwork ALL
#endregion Initiateurs

#region Cible ou target
Get-FreeNasIscsiTarget
New-FreeNasIscsiTarget -TargetName lun1 -TargetAlias lun1
New-FreeNasIscsiTarget -TargetName lun2 -TargetAlias lun2
New-FreeNasIscsiTarget -TargetName lun3 -TargetAlias lun3
New-FreeNasIscsiTarget -TargetName lun4 -TargetAlias lun4
New-FreeNasIscsiTarget -TargetName lun5 -TargetAlias lun5
New-FreeNasIscsiTarget -TargetName lun6 -TargetAlias lun6

Get-FreeNasIscsiTarget
#endregion Cible ou target

#region Extent
Get-FreeNasIscsiExtent
New-FreeNasIscsiExtent -ExtentName Disk05 -ExtenType Disk -ExtentSpeed SSD -ExtenDiskPath da5
New-FreeNasIscsiExtent -ExtentName Disk06 -ExtenType Disk -ExtentSpeed SSD -ExtenDiskPath da6
New-FreeNasIscsiExtent -ExtentName Zvol1 -ExtenType Disk -ExtentSpeed SSD -ExtenDiskPath zvol/data/Zvol1
New-FreeNasIscsiExtent -ExtentName Zvol2 -ExtenType Disk -ExtentSpeed SSD -ExtenDiskPath zvol/data2/Zvol2
New-FreeNasIscsiExtent -ExtentName Zvol1a -ExtenType Disk -ExtentSpeed SSD -ExtenDiskPath zvol/data/Zvol1a
New-FreeNasIscsiExtent -ExtentName Zvol2a -ExtenType Disk -ExtentSpeed SSD -ExtenDiskPath zvol/data2/Zvol2a

Get-FreeNasIscsiExtent
#endregion Extent

#region Association
Get-FreeNasIscsiAssociat2Extent
Get-FreeNasIscsiTarget
New-FreeNasIscsiAssociat2Extent -TargetId 1 -ExtentId 1
New-FreeNasIscsiAssociat2Extent -TargetId 2 -ExtentId 2
New-FreeNasIscsiAssociat2Extent -TargetId 3 -ExtentId 3
New-FreeNasIscsiAssociat2Extent -TargetId 4 -ExtentId 4
New-FreeNasIscsiAssociat2Extent -TargetId 5 -ExtentId 5
New-FreeNasIscsiAssociat2Extent -TargetId 6 -ExtentId 6

Get-FreeNasIscsiAssociat2Extent -Output Name

New-FreeNasIscsiTargetGroup -TargetId 1 -TargetPortalGroup 1
New-FreeNasIscsiTargetGroup -TargetId 2 -TargetPortalGroup 1
New-FreeNasIscsiTargetGroup -TargetId 3 -TargetPortalGroup 1
New-FreeNasIscsiTargetGroup -TargetId 4 -TargetPortalGroup 1
New-FreeNasIscsiTargetGroup -TargetId 5 -TargetPortalGroup 1
New-FreeNasIscsiTargetGroup -TargetId 6 -TargetPortalGroup 1

#endregion Association

#endregion Configuration du partage ISCSI
Get-FreeNasService | Where-Object { $_.srv_service -eq "iscsitarget" }
Set-FreeNasService -Services iscsitarget -ServicesStatus True
Get-FreeNasService | Where-Object { $_.srv_service -eq "iscsitarget" }
Get-FreeNasIscsiSummary
#Region

#PowerCli ESXI
Connect-VIServer -Server 10.0.10.30
$vmhost = Get-VMHost
$vmhost | New-VirtualSwitch -Name vSwitch2 -Nic vmnic2, vmnic3 -Mtu 9000
$vmhost | New-VMHostNetworkAdapter -PortGroup iSCSI01 -VirtualSwitch vSwitch2 -IP 10.0.10.31 -SubnetMask 255.0.0.0 -Mtu 9000
$VMhost | Get-VMHostStorage | Set-VMHostStorage -SoftwareIScsiEnabled $True
$VMhost | Get-VMHostHba -Type iScsi | Select-Object Name, Status, IScsiName
$VMhost | Get-VMHostHba -Type iScsi | New-IScsiHbaTarget -Address 10.0.10.0
$VMhost | Get-VMHostStorage -RescanAllHba -RescanVmfs
function Get-FreeEsxiLUN
{
    ##############################
    #.SYNOPSIS
    #Shows free or unassigned SCSI LUNs/Disks on Esxi
    #
    #.DESCRIPTION
    #The Get-FreeEsxiLUNs cmdlet finds free or unassigned SCSI LUNs/Disks on VMWare Esxi server. Free or unassigned disks are unformatted LUNs and need to format VMFS datastore or use as RDM (Raw Device Mapping)
    #
    #.PARAMETER Esxihost
    #This is VMware Esxi host name
    #
    #.EXAMPLE
    #Get-FreeEsxiLUNs -Esxihost Esxi001.vcloud-lab.com
    #
    #Shows free unassigned storage Luns disks on Esxi host name Esxi001.vcloud-lab.com
    #
    #.NOTES
    #http://vcloud-lab.com
    #Written using powershell version 5
    #Script code version 1.0
    ###############################

    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [System.String]$Esxihost
    )
    Begin
    {
        if (-not(Get-Module vmware.vimautomation.core))
        {
            Import-Module vmware.vimautomation.core
        }
        #Connect-VIServer | Out-Null
    }
    Process
    {
        $VMhost = Get-VMhost $EsxiHost
        $AllLUNs = $VMhost | Get-ScsiLun -LunType disk
        $Datastores = $VMhost | Get-Datastore
        foreach ($lun in $AllLUNs)
        {
            $Datastore = $Datastores | Where-Object { $_.extensiondata.info.vmfs.extent.Diskname -Match $lun.CanonicalName }
            if ($null -eq $Datastore.Name)
            {
                $lun | Select-Object CanonicalName, CapacityGB, Vendor
            }
        }
    }
    End { }
}
$FreeESXILUN = Get-FreeEsxiLUN -Esxihost $vmhost | Select-Object -Property CanonicalName, CapacityGB, Vendor | where { $_.Vendor -eq "FreeNAS" }

foreach ($LUNS in $FreeESXILUN)
{

    $random_string = -join ((65..90) + (97..122) | Get-Random -Count 5 | % { [char]$_ })
    $Name = "LUN_" + "$random_string" + "_" + $LUNS.CapacityGB

    $VMhost | New-Datastore -Name $Name -Path $LUNS.CanonicalName -Vmfs -FileSystemVersion 6
}
<#Secure Http -> HTTPS

New-FreeNasInternalCA -Name Internalca -CommonName "FreeNas" -City "San Jose" -State CA -Country US -Email example@ixysystem.com -Organization iXsystems -DigestAlgo SHA256 -Liftime 3650 -KeyLenght 2048
Get-FreeNasInternalCA
Get-FreeNasSetting
New-FreeNasCertificate -Name ID2 -CommonName "FreeNas" -City "San Jose" -State CA -Country US -Email example@ixysystem.com -Organization iXsystems -DigestAlgo SHA256 -Liftime 3650 -KeyLenght 2048 -Signedby 2
Update-FreeNasSetting -Id 1 -GuiCertifiacteId 1 -GuiProtocol httphttps -Confirm
Restart-FreeNasServer

New-FreeNasInternalCA -Name Essai -CommonName demo -City "New York" `
-State "US" -Country PA -Email "toto@Gmail.com" -Organization "Demo" `
-DigestAlgo SHA256 -Liftime 3650 -KeyLenght 2048

#>
