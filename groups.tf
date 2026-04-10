# Auto-created group per department, keyed by dept name
resource "azuread_group" "dept_groups" {
  for_each = toset(local.departments)

  display_name     = each.key
  mail_nickname    = "sg-dept-${lower(replace(each.key, " ", "-"))}"
  description      = "${each.key} department"
  security_enabled = true
}

# Membership: place each user in their department group
resource "azuread_group_member" "dept_memberships" {
  for_each = local.users_by_upn

  group_object_id  = azuread_group.dept_groups[each.value.department].id
  # member_object_id = azuread_user.users[each.key].id
  member_object_id = azuread_user.users[each.value.upn].id

}

# Manual extra groups from groups.csv
resource "azuread_group" "manual_groups" {
  for_each = local.manual_groups

  display_name     = each.value.name
  mail_nickname    = each.value.nickname
  description      = each.value.description
  security_enabled = true
}

