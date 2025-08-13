
param vNetName string
param subnetName string
param vnetRgName string


resource subnets 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' existing = {
  name: '${vNetName}/${subnetName}'
  scope: resourceGroup(vnetRgName)
}

output subnetId string = subnets.id
