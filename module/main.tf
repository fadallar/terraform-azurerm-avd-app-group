# Add Checkov skips here, if required.

resource "azurerm_virtual_desktop_application_group" "this" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type         = var.type
  host_pool_id = var.host_pool_id

  description                  = var.description
  friendly_name                = var.friendly_name
  default_desktop_display_name = var.default_desktop_display_name
  tags                         = merge(var.default_tags, var.extra_tags)
}

