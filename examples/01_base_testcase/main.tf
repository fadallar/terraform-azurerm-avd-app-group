# Test case local inputs
locals {
  stack             = "avdappgroup-01"
  landing_zone_slug = "sbx"
  location          = "westeurope"

  # 
  extra_tags = {
    tag1 = "FirstTag",
    tag2 = "SecondTag"
  }

  # base tagging values
  environment     = "sbx"
  application     = "terra-module"
  cost_center     = "CCT"
  change          = "CHG666"
  owner           = "Fabrice"
  spoc            = "Fabrice"
  tlp_colour      = "WHITE"
  cia_rating      = "C1I1A1"
  technical_owner = "Fabrice"

  # AVD Host Pool
  avd_host_friendly_name                   = "my friendly name"
  avd_host_description                     = "my description"
  avd_host_private_endpoint                = false
  avd_host_custom_rdp_properties           = "enablerdsaadauth:i:1;audiocapturemode:i:1"
  avd_host_scheduled_agent_updates_enabled = true
  avd_host_schedule_agent_updates_schedules = [
    {
      "day_of_week" : "Monday"
      "hour_of_day" : 23
    },
    {
      "day_of_week" : "Friday"
      "hour_of_day" : 21

    }
  ]

  # AVD Workspace
  avd_workspace_friendly_name    = "My friendly name"
  avd_workspace_description      = "My description"
  avd_workspace_private_endpoint = false

  # AVD App Group
  avd_app_group_friendly_name                = "My friendly name"
  avd_app_group_description                  = "My description"
  avd_app_group_default_desktop_display_name = "This is not empty"
  avd_app_group_types                        = ["Desktop", "RemoteApp"]
}

module "regions" {
  source       = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module?ref=master"
  azure_region = local.location
}

module "base_tagging" {
  source          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module?ref=master"
  environment     = local.environment
  application     = local.application
  cost_center     = local.cost_center
  change          = local.change
  owner           = local.owner
  spoc            = local.spoc
  tlp_colour      = local.tlp_colour
  cia_rating      = local.cia_rating
  technical_owner = local.technical_owner
}

module "resource_group" {
  source            = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module?ref=master"
  stack             = local.stack
  landing_zone_slug = local.landing_zone_slug
  default_tags      = module.base_tagging.base_tags
  location          = module.regions.location
  location_short    = module.regions.location_short
}

module "diag_log_analytics_workspace" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-loganalyticsworkspace//module?ref=feature/use-tf-lock-file"

  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags

}

module "avd_host_pool_desktop" {
  source                          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdhostpool//module?ref=develop"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id
  workload_info                   = "desktop"

  # Module Parameters

  friendly_name                    = local.avd_host_friendly_name
  description                      = local.avd_host_description
  enable_private_endpoint          = local.avd_host_private_endpoint
  custom_rdp_properties            = local.avd_host_custom_rdp_properties
  scheduled_agent_updates_enabled  = local.avd_host_scheduled_agent_updates_enabled
  schedule_agent_updates_schedules = local.avd_host_schedule_agent_updates_schedules
  preferred_app_group_type         = "Desktop"
}

module "avd_host_pool_rail" {
  source                          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdhostpool//module?ref=develop"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id
  workload_info                   = "rail"
  # Module Parameters

  friendly_name                    = local.avd_host_friendly_name
  description                      = local.avd_host_description
  enable_private_endpoint          = local.avd_host_private_endpoint
  custom_rdp_properties            = local.avd_host_custom_rdp_properties
  scheduled_agent_updates_enabled  = local.avd_host_scheduled_agent_updates_enabled
  schedule_agent_updates_schedules = local.avd_host_schedule_agent_updates_schedules
  preferred_app_group_type         = "RailApplications"
}

module "avd_workspace" {
  source                          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdworkspace//module?ref=develop"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  # Module Parameters
  friendly_name           = local.avd_workspace_friendly_name
  description             = local.avd_workspace_description
  enable_private_endpoint = local.avd_workspace_private_endpoint
}

# Please specify source as git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/<<ADD_MODULE_NAME>>//module?ref=master or with specific tag
module "avd_app_group_desktop" {
  source                          = "../../module"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id
  workload_info                   = "desktop"

  # Module Parameters
  friendly_name                = local.avd_app_group_friendly_name
  description                  = local.avd_app_group_description
  type                         = local.avd_app_group_types[0]
  host_pool_id                 = module.avd_host_pool_desktop.avd_host_pool_id
  default_desktop_display_name = local.avd_app_group_default_desktop_display_name
  associated_workspace_id      = module.avd_workspace.avd_workspace_id
}

module "avd_app_group_rail" {
  source                          = "../../module"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id
  default_desktop_display_name    = local.avd_app_group_default_desktop_display_name
  workload_info                   = "rail"

  # Module Parameters
  friendly_name           = local.avd_app_group_friendly_name
  description             = local.avd_app_group_description
  type                    = local.avd_app_group_types[1]
  host_pool_id            = module.avd_host_pool_rail.avd_host_pool_id
  associated_workspace_id = module.avd_workspace.avd_workspace_id
}