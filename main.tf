data "azuread_domains" "aad_domains" {
  only_initial = true

}

locals {
  # Get Azure Domain Name
  domain = data.azuread_domains.aad_domains.domains.*.domain_name

  # Parse CSVs
  users_raw       = csvdecode(file("users.csv"))
  groups_raw      = csvdecode(file("groups.csv"))
  apps_raw        = csvdecode(file("apps.csv"))
  dept_apps_raw   = csvdecode(file("dept_app_assignments.csv"))

  # Keyed maps for resource lookups
  users_by_upn    = { for u in local.users_raw : u.upn => u }
  apps_by_id      = { for a in local.apps_raw : a.app_id => a }

  # Derive unique departments from users.csv — drives auto-group creation
  departments     = distinct([for u in local.users_raw : u.department])

  # Manual groups keyed by name
  manual_groups   = { for g in local.groups_raw : g.name => g }

  # Dept app assignment map keyed as "dept|app_id"
  dept_app_map = {
    for row in local.dept_apps_raw :
    "${row.department}|${row.app_id}" => row
  }

  # Expand to per-user app assignments via department
  # Produces a flat map keyed as "upn|app_id"
  user_app_assignments = {
    for pair in flatten([
      for u in local.users_raw : [
        for da in local.dept_apps_raw : {
          key    = "${u.upn}|${da.app_id}"
          upn    = u.upn
          app_id = da.app_id
        }
        if da.department == u.department
      ]
    ]) : pair.key => pair
  }
}
