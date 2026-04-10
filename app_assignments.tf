# Validate all app IDs in dept_app_assignments.csv exist in apps.csv
locals {
  invalid_app_ids = toset([
    for row in local.dept_apps_raw :
    row.app_id
    if !contains(keys(local.apps_by_id), row.app_id)
  ])

  invalid_departments = toset([
    for row in local.dept_apps_raw :
    row.department
    if !contains(local.departments, row.department)
  ])
}

resource "terraform_data" "validate_dept_app_assignments" {
  lifecycle {
    precondition {
      condition     = length(local.invalid_app_ids) == 0
      error_message = "dept_app_assignments.csv references unknown app IDs: ${join(", ", local.invalid_app_ids)}"
    }
    precondition {
      condition     = length(local.invalid_departments) == 0
      error_message = "dept_app_assignments.csv references unknown departments: ${join(", ", local.invalid_departments)}"
    }
  }
}

# Look up each enterprise app's service principal by client app ID
data "azuread_service_principal" "apps" {
  for_each  = local.apps_by_id
  client_id = each.key
}

# Assign users to apps based on their department mapping
#resource "azuread_app_role_assignment" "user_app_assignments" {
#  for_each = local.user_app_assignments

#  app_role_id         = "00000000-0000-0000-0000-000000000000"
  #principal_object_id = azuread_user.users[each.value.upn].id
#  principal_object_id = each.value.upn
#  resource_object_id  = data.azuread_service_principal.apps[each.value.app_id].object_id
#}
