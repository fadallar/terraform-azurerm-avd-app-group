<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
# Azure Virtual Desktop Application Group

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)

Module which creates an Azure Virtual Desktop Application group and its diagnostic settings

## Examples

[01\_base\_testcase](./examples/01\_base\_testcase/README.md)

## Usage

Basic usage of this module is as follows:

```hcl
module "example" {
   source  = "<module-path>"

   # Required variables
   description =
   diag_log_analytics_workspace_id =
   friendly_name =
   host_pool_id =
   landing_zone_slug =
   location =
   location_short =
   resource_group_name =
   stack =

   # Optional variables
   associated_workspace_id = null
   custom_name = ""
   default_desktop_display_name = ""
   default_tags = {}
   diag_default_setting_name = "default"
   diag_log_categories = [
  "Checkpoint",
  "Error",
  "Management"
]
   diag_metric_categories = []
   diag_retention_days = 30
   diag_storage_account_id = null
   enable_workspace_association = true
   extra_tags = {}
   log_analytics_destination_type = "Dedicated"
   type = "Desktop"
   workload_info = ""
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >=1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_virtual_desktop_application_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | A description for the Virtual Desktop Host Pool. | `string` | n/a | yes |
| <a name="input_diag_log_analytics_workspace_id"></a> [diag\_log\_analytics\_workspace\_id](#input\_diag\_log\_analytics\_workspace\_id) | Log Analytics Workspace Id for logs and metrics diagnostics destination | `string` | n/a | yes |
| <a name="input_friendly_name"></a> [friendly\_name](#input\_friendly\_name) | A friendly name for the Virtual Desktop Workspace. | `string` | n/a | yes |
| <a name="input_host_pool_id"></a> [host\_pool\_id](#input\_host\_pool\_id) | Resource ID for a Virtual Desktop Host Pool to associate with the Virtual Desktop Application Group. Changing the name forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_landing_zone_slug"></a> [landing\_zone\_slug](#input\_landing\_zone\_slug) | Landing zone acronym,it will be used to generate the resource name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region to use. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Short string for Azure location. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group. | `string` | n/a | yes |
| <a name="input_stack"></a> [stack](#input\_stack) | Project stack name. | `string` | n/a | yes |
| <a name="input_associated_workspace_id"></a> [associated\_workspace\_id](#input\_associated\_workspace\_id) | Resource Id of the AVD workspcae this app group is associated with | `string` | `null` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Custom resource name, it will overide the generated name if set | `string` | `""` | no |
| <a name="input_default_desktop_display_name"></a> [default\_desktop\_display\_name](#input\_default\_desktop\_display\_name) | Option to set the display name for the default sessionDesktop desktop when type is set to Desktop. | `string` | `""` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Base tagging | `map(string)` | `{}` | no |
| <a name="input_diag_default_setting_name"></a> [diag\_default\_setting\_name](#input\_diag\_default\_setting\_name) | Name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| <a name="input_diag_log_categories"></a> [diag\_log\_categories](#input\_diag\_log\_categories) | List of categories to enable in the diagnostic settings | `list(string)` | <pre>[<br>  "Checkpoint",<br>  "Error",<br>  "Management"<br>]</pre> | no |
| <a name="input_diag_metric_categories"></a> [diag\_metric\_categories](#input\_diag\_metric\_categories) | List of metric categories to enable in the diagnostic settings | `list(string)` | `[]` | no |
| <a name="input_diag_retention_days"></a> [diag\_retention\_days](#input\_diag\_retention\_days) | The number of days for which the Retention Policy should apply | `number` | `30` | no |
| <a name="input_diag_storage_account_id"></a> [diag\_storage\_account\_id](#input\_diag\_storage\_account\_id) | Storage Account Id for logs and metrics diagnostics destination | `string` | `null` | no |
| <a name="input_enable_workspace_association"></a> [enable\_workspace\_association](#input\_enable\_workspace\_association) | Enable the association with an AVD workspace. If set to true an AVD App Workspace Id must be provided | `bool` | `true` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add. | `map(string)` | `{}` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | Possible values are AzureDiagnostics and Dedicated. Recommended value is Dedicated | `string` | `"Dedicated"` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of Virtual Desktop Application Group. Valid options are RemoteApp or Desktop application groups. Changing this forces a new resource to be created. | `string` | `"Desktop"` | no |
| <a name="input_workload_info"></a> [workload\_info](#input\_workload\_info) | Workload additional info to be used in the resource name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_avd_appgroup_id"></a> [avd\_appgroup\_id](#output\_avd\_appgroup\_id) | Virtual Desktop Application Group resource id |

## Contact

Atos

to regenerate this `README.md` file run in pwsh, in current directory:

`docker run --rm -v "$($pwd.path):/data" cytopia/terraform-docs terraform-docs-012 -c tfdocs-config.yml ./module`

`docker run --rm --name pre -v "$($pwd.path):/lint" -w /lint ghcr.io/antonbabenko/pre-commit-terraform run -a`

`docker stop pre; docker rm pre; docker run --name pre -v "$($pwd.path):/lint" -w /lint ghcr.io/antonbabenko/pre-commit-terraform run -a`
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->