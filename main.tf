data "azuread_domains" "aad_domains" {
  only_initial = true

}

locals {
  domain = data.azuread_domains.aad_domains.domains.*.domain_name
  users = csvdecode(file("users.csv"))
}

output "domain" {
  value = local.domain
}

output "username" {
  value = [ for user in local.users : "${user.firstName} ${user.lastName}" ]
}

resource "azuread_user" "users" {
  for_each = {for user in local.users: user.firstName => user }

  user_principal_name = format("%s%s%s@%s", 
    lower(each.value.firstName),
    ".",
    lower(each.value.lastName),
    "eptinyco.tech" )

  password = "H3llo_eptinyco_temp*"

  display_name = "${each.value.firstName} ${each.value.lastName}"

  force_password_change = true

  department = each.value.team

  job_title = each.value.jobTitle

}