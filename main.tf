provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_compute_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_host" "host" {
  count         = "${length(var.esxi_hosts)}"
  name          = "${var.esxi_hosts[count.index]}" 
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_folder" "folder" {
  count         =  "${length(var.folder)}"
  path          =  "${lookup(var.folder[count.index], "name")}"
  type          =  "vm"
  datacenter_id =  "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_distributed_virtual_switch" "dvs" {
  name           = "${var.vsphere_dvs}"
  datacenter_id  =  "${data.vsphere_datacenter.dc.id}"
  uplinks        =  ["uplink1","uplink2"]
  active_uplinks =  ["uplink1","uplink2"]
  
  host {
    host_system_id = "${data.vsphere_host.host.0.id}"
    devices        =  "${var.network_interfaces}"
  }
}

resource "vsphere_distributed_port_group" "prod_port_group" {
  name           = "${var.port_group_name}"
  distributed_virtual_switch_uuid = "${vsphere_distributed_virtual_switch.dvs.id}"
  vlan_id        =  "${var.vlan_id}"
  teaming_policy =  "loadbalance_ip"
 }

resource "vsphere_virtual_machine" "web" {
  count            = "${length(var.web)}"
  name             = "${lookup(var.web[count.index], "hostname")}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = "${lookup(var.web[count.index], "CPU_Count")}"
  memory           = "${lookup(var.web[count.index], "RAM")}"
  annotation       =  "${lookup(var.web[count.index], "Tag")}"
  folder           =  "${lookup(var.web[count.index], "folder_path")}"


  cdrom {
   datastore_id     = "${data.vsphere_datastore.datastore.id}"
   path             = "${var.iso_path}"  
    }

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    use_static_mac = "true"
    mac_address = "${lookup(var.web[count.index], "mac_Address")}"
  }

 network_interface {
    network_id = "${vsphere_distributed_port_group.prod_port_group.id}"
    use_static_mac = "false"
  }

guest_id = "windows8Server64Guest"
scsi_type = "lsilogic"
firmware = "efi"
wait_for_guest_ip_timeout = "-1"
wait_for_guest_net_timeout = "-1"
enable_disk_uuid = "true"

extra_config = {
    AssetTag = "${lookup(var.web[count.index], "AssetTag")}"
}

disk = [
  {
    label = "disk0"  
    size  = "${lookup(var.web[count.index], "disk1")}"
    unit_number = "0"
  },
  {
    label = "disk1"  
    size  = "${lookup(var.web[count.index], "disk2")}"
    unit_number = "1"
  }
]
}

resource "vsphere_virtual_machine" "app" {
  count            = "${length(var.app)}"
  name             = "${lookup(var.app[count.index], "hostname")}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = "${lookup(var.app[count.index], "CPU_Count")}"
  memory           = "${lookup(var.app[count.index], "RAM")}"
  annotation       =  "${lookup(var.app[count.index], "Tag")}"
  folder           =  "${lookup(var.app[count.index], "folder_path")}"

  cdrom {
   datastore_id     = "${data.vsphere_datastore.datastore.id}"
   path             = "${var.iso_path}"  
  }

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    use_static_mac = "true"
    mac_address = "${lookup(var.app[count.index], "mac_Address")}"
  }

  
  network_interface {
    network_id = "${vsphere_distributed_port_group.prod_port_group.id}"
    use_static_mac = "false"
  }

guest_id = "windows8Server64Guest"
scsi_type = "lsilogic"
firmware = "efi"
wait_for_guest_ip_timeout = "-1"
wait_for_guest_net_timeout = "-1"
enable_disk_uuid = "true"

extra_config = {
  AssetTag = "${lookup(var.app[count.index], "AssetTag")}"
}

disk = [
 {
    label = "disk0"  
    size  = "${lookup(var.app[count.index], "disk1")}"
    unit_number = "0"
  },
  {
    label = "disk1"  
    size  = "${lookup(var.app[count.index], "disk2")}"
    unit_number = "1"
  }
]
}
