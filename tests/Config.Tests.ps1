#
# Copyright 2019, Jérôme Bezet-Torres <bezettorres dot jerome at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
#Requires -Modules @{ ModuleName="Pester"; RequiredVersion="4.9.0"}
#Requires -Modules @{ModuleName="FreeNas"; ModuleVersion="1.3.1" }

$IpsrvFreenas = Read-Host "Enter the IPaddress for the test"
Connect-FreeNasServer -Server $IpsrvFreenas

Describe  "Get Configuration" {


    It "Get FreeNas Server" {

        $query = Get-FreeNasServer
        $query | Should be $IpsrvFreenas
    }

    It "Get FreeNas Disk configuration" {

        $query = Get-FreeNasDisk
        $query | Should not be $null
    }
    It "Get FreeNas Service" {

        $query = Get-FreeNasService
        $query | Should not be $null
    }

    It "Get FreeNas Global config" {

        $query = Get-FreeNasGlobalConfig
        $query.Id | Should -BeIn (1..10)
        $query.Domain | Should not be $null
        $query.Gateway | Should not be $null
        $query.Hostname | Should not be $null
        $query.Nameserver1 | Should -BeNullOrEmpty
        $query.Nameserver2 | Should -BeNullOrEmpty
        $query.Nameserver3 | Should -BeNullOrEmpty
        $query.Httpproxy | Should -BeNullOrEmpty
    }


}
