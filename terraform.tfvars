vsphere_user = "administrator@vsphere.local"
vsphere_password = "enterpass"
vsphere_server = "10.122.17.130"
vsphere_datacenter = "deise"
vsphere_compute_cluster = "Deise_Cluster"
vsphere_dvs = "dvs"
network_interfaces = ["vmnic1","vmnic2"]
esxi_hosts = ["10.122.17.128"]
vsphere_datastore = "DS01"
vsphere_network = "VM Network"
vlan_id = "800"
port_group_name = "prod"
vsphere_hardware_version = "10"
iso_path = "ISO/current.iso"

folder = [
    {
    name = "/Web"
    },
    {
    name = "/App"
    }
]

web  = [
    {
        hostname = "Web01"
        mac_Address = "AA:00:50:56:e8:d1"
        AssetTag = "1234322"
        CPU_Count = "1"
        RAM = "100"
        Tag = "Webserver01"
        disk1 = "10"
        disk2 = "20"
        folder_path = "Web"
    } ,
    {
        hostname = "Web02"
        mac_Address = "AA:00:50:56:e8:d4"
        AssetTag = "4354534"
        CPU_Count = "2"
        RAM = "100"
        Tag = "WebServer02"
        disk1 = "10"
        disk2 = "10"
        folder_path = "Web"
    }
]

app  = [
    {
        hostname = "App01"
        mac_Address = "AA:00:50:56:e8:d5"
        AssetTag = "243434"
        CPU_Count = "2"
        RAM = "100"
        Tag = "AppServer1"
        disk1 = "10"
        disk2 = "10"
        folder_path = "App"
    },
    {
        hostname = "App02"
        mac_Address = "AA:00:50:56:e8:d6"
        AssetTag = "345224"
        CPU_Count = "2"
        RAM = "200"
        Tag = "Appserver02"
        disk1 = "10"
        disk2 = "10"
        folder_path = "App"
    }
]
