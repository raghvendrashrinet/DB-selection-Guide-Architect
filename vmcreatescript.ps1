# Variables
$RG="rg1"
$LOCATION="centralindia"
$VMNAME="vm1"
$VNET="vnet1"
$SUBNET="subnet1"

# Login to Azure
az login

# Create Resource Group
az group create `
  --name $RG `
  --location $LOCATION

# Create VM with VNet, Subnet, NSG and Public IP
az vm create `
  --resource-group $RG `
  --name $VMNAME `
  --image Ubuntu2204 `
  --admin-username azureuser `
  --generate-ssh-keys `
  --public-ip-sku Standard `
  --vnet-name $VNET `
  --subnet $SUBNET

az vm show -d `
  --resource-group $RG `
  --name $VMNAME `
  --query publicIps `
  -o tsv
