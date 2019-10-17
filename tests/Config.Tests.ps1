#
# Copyright 2019, Jérôme Bezet-Torres <bezettorres dot jerome at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
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
        $query.id | Should not be $null
        $query.Domain | Should not be $null
        $query.Hostname | Should not be $null
        $query.Nameserver1 | Should not be $null

    }


}
