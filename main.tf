# Using "az login" to login Azure Subscription.
# Provider
 provider "azurerm" {
    #Subscription_id = "var.azure_cloud_provider.subscription_id"
    #tenant_id = "var.azure_cloud_provider.tenant_id"    
    subscription_id = "54d87296-b91a-47cd-93dd-955bd57b3e9a"
    tenant_id       = "7d37f2bd-a1dc-4e2c-aaa3-c758dc77fff7"
    }

#Create virtual network
resource "azurerm_virtual_network" "marcelnguyennetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "southeastasia"
    resource_group_name = "RG_marcelnguyen113_20191227"

    tags = {
        environment = "Marcel Nguyen Terraform Demo"
    }
}

resource "azurerm_subnet" "marcelnguyensubnet" {
    name                 = "mySubnet"
    resource_group_name  = "RG_marcelnguyen113_20191227"
    virtual_network_name = azurerm_virtual_network.marcelnguyennetwork.name
    address_prefix       = "10.0.2.0/24"
}

#Create public IP address
resource "azurerm_public_ip" "marcelnguyenpublicip" {
    name                         = "myPublicIP"
    location                     = "southeastasia"
    resource_group_name          = "RG_marcelnguyen113_20191227"
    allocation_method            = "Dynamic"

    tags = {
        environment = "Marcel Nguyen Terraform Demo"
    }
}

#Create Network Security Group
resource "azurerm_network_security_group" "marcelnguyenNetworkSecurityGroup" {
    name                = "marcelnguyenNetworkSecurityGroup"
    location            = "southeastasia"
    resource_group_name = "RG_marcelnguyen113_20191227"
    
    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Marcel Nguyen Terraform Demo"
    }
}

#Create virtual network interface card
resource "azurerm_network_interface" "marcelnguyennic" {
    name                        = "myNIC"
    location                    = "southeastasia"
    resource_group_name         = "RG_marcelnguyen113_20191227"
    network_security_group_id   = azurerm_network_security_group.marcelnguyenNetworkSecurityGroup.id

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.marcelnguyensubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.marcelnguyenpublicip.id}"
    }

    tags = {
        environment = "Marcel Nguyen Terraform Demo"
    }
}

#Create storage account for diagnostics
resource "random_id" "randomId" {
    keepers = {
        #Generate a new ID only when a new resource group is defined
        resource_group = "RG_marcelnguyen_20191227"
    }

    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "RG_marcelnguyen113_20191227"
    location                    = "southeastasia"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        environment = "Marcel Nguyen Terraform Demo"
    }
}

#Create virtual machine
resource "azurerm_virtual_machine" "marcelnguyenvm" {
    name                  = "myVM_marcel.nguyen"
    location              = "southeastasia"
    resource_group_name   = "RG_marcelnguyen113_20191227"
    network_interface_ids = [azurerm_network_interface.marcelnguyennic.id]
    vm_size               = "Standard_DS1_v2"

    os_profile_windows_config {
        provision_vm_agent=true
        timezone="Romance Standard Time"
    }
    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
        os_type = "Windows"
    }

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myvm"
        admin_username = "marcelnguyen"
        admin_password = "Thu234567"
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Marcel Nguyen Terraform Demo"
    }
}