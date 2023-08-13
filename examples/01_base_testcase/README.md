# AVD Application Group - Base test case

This is an example for setting-up a an Azure Virtual Application Group and associate it with an AVD Workspace

This test case:

- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- Creates the following resource dependencies
  - Resource Group
  - Log Analytics workspace
  - AVD Host Pools  (Desktop, Rail)
  - AVD Workspace
- Creates two  AVD Application Groups (Desktop, Rail) --> module "avdworkspace" which also
  - Set the default diagnostics settings (All Logs and metric) whith a Log Analytics workspace as destination
  - Associate with an AVD Workspace

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Main.tf file content

Please replace the modules source and version with your relevant information

```hcl
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
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_avd_app_group_desktop"></a> [avd\_app\_group\_desktop](#module\_avd\_app\_group\_desktop) | ../../module | n/a |
| <a name="module_avd_app_group_rail"></a> [avd\_app\_group\_rail](#module\_avd\_app\_group\_rail) | ../../module | n/a |
| <a name="module_avd_host_pool_desktop"></a> [avd\_host\_pool\_desktop](#module\_avd\_host\_pool\_desktop) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdhostpool//module | develop |
| <a name="module_avd_host_pool_rail"></a> [avd\_host\_pool\_rail](#module\_avd\_host\_pool\_rail) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdhostpool//module | develop |
| <a name="module_avd_workspace"></a> [avd\_workspace](#module\_avd\_workspace) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdworkspace//module | develop |
| <a name="module_base_tagging"></a> [base\_tagging](#module\_base\_tagging) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module | master |
| <a name="module_diag_log_analytics_workspace"></a> [diag\_log\_analytics\_workspace](#module\_diag\_log\_analytics\_workspace) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-loganalyticsworkspace//module | feature/use-tf-lock-file |
| <a name="module_regions"></a> [regions](#module\_regions) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module | master |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module | master |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_avd_desktop_app_group_id"></a> [avd\_desktop\_app\_group\_id](#output\_avd\_desktop\_app\_group\_id) | AVD Applicatopn Group Id |
| <a name="output_avd_rail_app_group_id"></a> [avd\_rail\_app\_group\_id](#output\_avd\_rail\_app\_group\_id) | AVD Applicatopn Group Id |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
