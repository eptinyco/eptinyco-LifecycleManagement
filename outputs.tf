# Outputs for testing and logging
output "domain" {
  value = local.domain
}

output "department_groups" {
  description = "Auto-created department group object IDs"
  value       = { for k, v in azuread_group.dept_groups : k => v.object_id }
}

output "user_count" {
  description = "Total managed users"
  value       = length(azuread_user.users)
}