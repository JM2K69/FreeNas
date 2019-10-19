function Get-FreeNasIscsiTargetGroup {
    Param( )

    $Uri = "api/v1.0/services/iscsi/targetgroup/"

    $results = Invoke-FreeNasRestMethod -Uri $Uri -Method Get

    foreach ($Target in $results) {
        [PSCustomObject]@{
            Id                     = ($Target.iscsi_target)
            Target_Auth_Group      = ($Target.iscsi_target_authgroup)
            Target_Portal_Group    = ($Target.iscsi_target_portalgroup)
            Target_Initiator_Group = ($Target.iscsi_target_initiatorgroup)
            Target_Auth_Type       = ($Target.iscsi_target_authtype)
            Target_Intial_Disgest  = ($Target.iscsi_target_initialdigest)

        }
    }
}
