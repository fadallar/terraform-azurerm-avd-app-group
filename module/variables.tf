
variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region to use."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
  validation {
    condition     = var.stack == "" || can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.stack))
    error_message = "Invalid variable: ${var.stack}. Variable name must start with a lowercase letter, end with an alphanumeric lowercase character, and contain only lowercase letters, digits, or a dash (-)."
  }
}

variable "friendly_name" {
  type        = string
  description = "A friendly name for the Virtual Desktop Workspace."
  ### TO-DO add Validation Block
}

variable "description" {
  type        = string
  description = "A description for the Virtual Desktop Host Pool."
  ### TO-DO add Validation Block
}

variable "default_desktop_display_name" {
  type        = string
  description = "Option to set the display name for the default sessionDesktop desktop when type is set to Desktop."
  default     = ""
  ### TO-DO add Validation Block
}

variable "type" {
  type        = string
  description = "Type of Virtual Desktop Application Group. Valid options are RemoteApp or Desktop application groups. Changing this forces a new resource to be created."
  default     = "Desktop"
  validation {
    condition     = contains(["RemoteApp", "Desktop"], var.type)
    error_message = "Invalid variable: type = ${var.type}. Select valid option from list: ${join(",", ["Desktop", "RemoteApp"])}."
  }
}

variable "host_pool_id" {
  type        = string
  description = "Resource ID for a Virtual Desktop Host Pool to associate with the Virtual Desktop Application Group. Changing the name forces a new resource to be created."
}