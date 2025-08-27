variable "aks_name" {}
variable "resource_group_name" {}
variable "rg_location" {}
variable "dns_prefix" {}
variable "tags" {}


variable "node_count" {
    type    = number
    default = 1
}

variable "vm_size" {
    type    = string
    default = "Standard_D2_v2"
}