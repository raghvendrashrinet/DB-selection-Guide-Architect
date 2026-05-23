## Azure CLI command to Create VM
### 1. Create the Resource Group (rg1)
```
az group create  --name rg1 --location centralindia
```
### 2. Create the Virtual Network (vnet1) and Subnet
This command creates the VNet along with a default subnet where your VM will reside
```
az network vnet create resource-group rg1 --name vnet1 --address-prefix 10.0.0.0/16 --subnet-name default --subnet-prefix 10.0.1.0/24
```
### 3. Create the Virtual Machine with a Public IP
The following command provisions an Ubuntu VM. By default, specifying --public-ip-address ""
  tells Azure to automatically generate and assign a new public IP resource to the VM.

```
az vm create --resource-group rg1 --name myVM --image Ubuntu2204 --vnet-name vnet1 --subnet default --public-ip-address "pip" --admin-username azureuser --generate-ssh-keys
  ```