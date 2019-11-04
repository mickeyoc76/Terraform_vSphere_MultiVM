variable "vsphere_user" {
  }

variable "vsphere_password" {

}
variable "vsphere_server" {
  default = ""
}

variable "vsphere_datacenter" {
  default = ""
}

variable "vsphere_compute_cluster" {
  default = ""
}

variable "vsphere_datastore" {
  default = ""
}

variable "folder" {
  type = "list"
  default = []
}

variable "esxi_hosts" {
  type = "list"
  default = []
}
   
 variable "network_interfaces" {
description = "vmnics to be used" 
type = "list"
default = []
}

variable "vsphere_network" {
default = ""
}

variable "port_group_name" {
  type = "string"
  default = ""
}

variable "vsphere_dvs" {
    default = ""
  
}
variable "iso_path" {
    default = ""
}

variable "vsphere_hardware_version" {
    default = ""
  
}

variable "app" {
  type = "list"
  default = [ ]
}

variable "web" {
  type = "list"
  default = [ ]
}


variable "vlan_id" {
  default = ""
}
