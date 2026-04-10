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

  # Keyed maps for resource lookups
  users_by_upn    = { for u in local.users_raw : u.upn => u }
  apps_by_id      = { for a in local.apps_raw : a.app_id => a }

  # Derive unique departments from users.csv — drives auto-group creation
  departments     = distinct([for u in local.users_raw : u.department])

  # Manual groups keyed by name
  manual_groups   = { for g in local.groups_raw : g.name => g }

  # Normalize user object IDs to bare UUIDs — the azuread provider can return
  # full OData paths like /users/<uuid> depending on the provider version
  user_object_ids = {
    for upn, user in azuread_user.users :
    upn => regex("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", user.id)
  }

  # Normalize Group object IDs to bare UUIDs — the azuread provider can return
  # full OData paths like /groups/<uuid> depending on the provider version
  dept_group_object_ids = {
    for dept, group in azuread_group.dept_groups :
    dept => regex("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", group.id)
  }
}