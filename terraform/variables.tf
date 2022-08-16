variable "prefix" {
  description = "The prefix for all resource"
  default = "Project1"
}

variable "resourcename" {
  description = "Name of resource"
  default = "Azuredevops"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "South Central US"
}

variable "imagename" {
  description = "Name of image"
  default = "myPackerImage"
}
# The number of vm that you want
variable "numberinstance" {
  description = "The number of vm that you want"
  default = "2"
}

variable "username" {
  description = "Admin user for VM"
  default = "adminuser"
}

variable "password" {
  description = "Password Admin user for VM"
  default = "Password1234!"
}

variable "numberVM" {
  description = "number of resources VM"
  default = 2
}
