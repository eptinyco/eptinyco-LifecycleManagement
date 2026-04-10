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

  group_object_id  = local.dept_group_object_ids[each.value.department]
  member_object_id = local.user_object_ids[each.key]

}

# Membership: place each user in their department group
resource "azuread_group_member" "allCompany_membership" {
  for_each = local.users_by_upn

  group_object_id  = "0358259c-26d4-4326-999a-e95a2ef8fb99"
  member_object_id = local.user_object_ids[each.key]

}

# Manual extra groups from groups.csv
resource "azuread_group" "manual_groups" {
  for_each = local.manual_groups

  display_name       = each.value.name
  mail_nickname      = each.value.nickname
  description        = each.value.description
  security_enabled   = true
  assignable_to_role = true
}