variable "admin_username" {
  description = "Admin username for the Linux virtual machine"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "hostname" {
    description = "Azure VM hostname"
    type = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "address_prefixes" {
  description = "Address prefixes for the application subnet"
  type        = list(string)
}

variable "db_address_prefixes" {
  description = "Address prefixes for the database subnet"
  type        = list(string)
}

variable "vm_name" {
  description = "Name of the Linux virtual machine"
  type        = string
}

variable "ssh_public_key" {
  description = "Path to the SSH public key used for VM access"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}