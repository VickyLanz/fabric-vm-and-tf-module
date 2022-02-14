variable "mproject_id" {
  type = string
  description = "Project ID "
  default = ""
}
variable "mzone" {
  type = string
  description = "Zone Name"
  default = ""
}
variable "mregion" {
  type = string
  description = "Region Name"
  default = ""
}
variable "mnetwork_name" {
  type = string
  description = "Custom VPC name"
  default = ""
}
variable "mmtu" {
  type = string
  description = "MTU value for the VPC network"
  default = ""
}
variable "mauto_create_subnetworks" {
  type = bool
  description = "Auto creation of subnetworks"
}
variable "mpath" {
  type = string
  description = "Startup script path"
  default = ""
}
variable "msubnet_name" {
  type = string
  description = "Subnet Name"
  default = ""
}