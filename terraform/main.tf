terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_managed_disk" "azmanagedisk" {
  name                 = "acctestmd"
  location             = "${var.location}"
  resource_group_name  = "${var.resourcename}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"

  tags = {
    Name = "tagging-policy"
  }
}
data "azurerm_image" "search" {
  name                = "${var.imagename}"
  resource_group_name = "${var.resourcename}"
}

# resource "azurerm_storage_container" "search" {
#   name                  = "vhds"
#   storage_account_name  = azurerm_storage_account.example.name
#   container_access_type = "private"

# Create virtual network
resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = "${var.location}"
  resource_group_name = "${var.resourcename}"

  tags = {
    Name = "tagging-policy"
  }
}

# Create subnet
resource "azurerm_subnet" "Subnet" {
  name                 = "${var.prefix}-subnet-1"
  resource_group_name  = "${var.resourcename}"
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "Securitygroup" {
  name                = "myNetworkSecurityGroup"
  location            = "${var.location}"
  resource_group_name = "${var.resourcename}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Web"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name = "tagging-policy"
  }
}

# Create network interface
resource "azurerm_network_interface" "NetworkInterface" {
  count               = "${var.numberVM}"
  name                = "VM${count.index+1}"
  resource_group_name = "${var.resourcename}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    Name = "tagging-policy"
  }
}

# Create public IP
resource "azurerm_public_ip" "PublicIP" {
  name                = "PublicIPForLB"
  location            = "${var.location}"
  resource_group_name = "${var.resourcename}"
  allocation_method   = "Static"

  tags = {
    Name = "tagging-policy"
  }
}

# Create Loadbalancer
resource "azurerm_lb" "Loadbalancer" {
  name                = "LoadBalancer"
  location            = "${var.location}"
  resource_group_name = "${var.resourcename}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.PublicIP.id
  }

  tags = {
    Name = "tagging-policy"
  }
}

# Create load balancer Rules
resource "azurerm_lb_rule" "loadBalancerRule" {
  loadbalancer_id                = azurerm_lb.Loadbalancer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.IpAdresspool.id]

  depends_on = [
    azurerm_lb.Loadbalancer
  ]
}

# IpAdress pool 
resource "azurerm_lb_backend_address_pool" "IpAdresspool" {
  loadbalancer_id = azurerm_lb.Loadbalancer.id
  name            = "BackEndAddressPool"
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation" {
  subnet_id                 = azurerm_subnet.Subnet.id
  network_security_group_id = azurerm_network_security_group.Securitygroup.id
}

resource "azurerm_network_interface_backend_address_pool_association" "backend" {
  count                   = "${var.numberVM}"
  network_interface_id    = "${element(azurerm_network_interface.NetworkInterface.*.id, count.index)}"
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.IpAdresspool.id
}

resource "azurerm_availability_set" "AvailableSet" {
  name                    = "my-aset"
  location                = "${var.location}"
  resource_group_name     = "${var.resourcename}"

  tags = {
    Name = "tagging-policy"
  }
}

resource "azurerm_linux_virtual_machine" "VM" {
  count                            = "${var.numberVM}"
  name                             = "VM${count.index+1}"
  location                         = "${var.location}"
  resource_group_name              = "${var.resourcename}"
  size                             = "Standard_B1S"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  network_interface_ids            = [element(azurerm_network_interface.NetworkInterface.*.id, count.index)]
  disable_password_authentication  = false
  source_image_id                  = "${data.azurerm_image.search.id}"
  availability_set_id              = azurerm_availability_set.AvailableSet.id
  os_disk {
    name                 = "dns${count.index+1}_OsDisk"
    caching              = "ReadWrite"
    disk_size_gb         = "128"
    storage_account_type = "Standard_LRS"
  }

 tags = {
     Name = "tagging-policy"
   }

}