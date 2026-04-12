# Generate a random password for the User 
resource "random_password" "initial" {
  for_each = local.users_by_upn
  length   = 16
  special  = true
}

# Create / Update users in azuread 
resource "azuread_user" "users" {
  for_each = local.users_by_upn

  user_principal_name = each.value.upn
  display_name        = "${each.value.firstName} ${each.value.lastName}"
  department          = each.value.department
  job_title           = each.value.jobTitle
  mail                = each.value.upn

  password              = random_password.initial[each.key].result
  force_password_change = true
  account_enabled       = lower(each.value.enabled)

  lifecycle {
    ignore_changes = [password]
  }
}

