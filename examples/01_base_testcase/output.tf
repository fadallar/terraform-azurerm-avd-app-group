# TODO: Add all outputs from outputs.tf file inside module folder

output "avd_desktop_app_group_id" {
  description = "AVD Applicatopn Group Id"
  value       = module.avdappgroup_desktop.avd_appgroup_id
}

output "avd_rail_app_group_id" {
  description = "AVD Applicatopn Group Id"
  value       = module.avdappgroup_rail.avd_appgroup_id
}