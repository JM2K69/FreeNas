#
# Copyright 2019, Jérôme Bezet-Torres <bezettorres dot jerome at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
#Requires -Modules @{ ModuleName="Pester"; RequiredVersion="4.9.0"}
#Requires -Modules @{ModuleName="FreeNas"; ModuleVersion="1.3.1" }

$TestsPath = Split-Path $MyInvocation.MyCommand.Path
$RootFolder = (get-item $TestsPath).Parent
Push-Location -Path $RootFolder.FullName
set-location -Path $RootFolder.FullName
Write-Verbose -Message "Importing module"
import-module .\Freenas -Force


Describe  "Get Configuration" {

    It "Secure Connection" {

        $IpsrvFreenas = Read-Host "Enter the IPaddress for the Tests"
        $query = Connect-FreeNasServer -Server $IpsrvFreenas -SkipCertificateCheck
        $query | Should not be Throw

    }

    It "Get FreeNas Disk configuration" {

        $query = Get-FreeNasDisk
        $query | Should not be $null
        $query | Should BeOfType System.Management.Automation.PSCustomObject
    }
    It "Get FreeNas Service" {

        $query = Get-FreeNasService
        $query | Should not be $null
    }

    It "Get FreeNas Global config" {

        $query = Get-FreeNasGlobalConfig
        $query.Id | Should -BeNullOrEmpty
        $query.Domain | Should -BeNullOrEmpty
        $query.Gateway | Should -BeNullOrEmpty
        $query.Hostname | Should -BeNullOrEmpty
        $query.Nameserver1 | Should -BeNullOrEmpty
        $query.Nameserver2 | Should -BeNullOrEmpty
        $query.Nameserver3 | Should -BeNullOrEmpty
        $query.Httpproxy | Should -BeNullOrEmpty
    }
    It "Get FreeNas system Advanced" {

        $query = Get-FreeNasSystemAdvanced
        $query.Advanced_mode | Should -BeNullOrEmpty
        $query.Advanced_Autotune | Should -BeNullOrEmpty
        $query.MOTD_Banner | Should  -BeNullOrEmpty
        $query.Advanced_Serial_Console | Should -BeNullOrEmpty
        $query.Advanced_Serial_port | Should BeNullOrEmpty
        $query.Advanced_Serial_speed | Should  BeNullOrEmpty
    }

}
