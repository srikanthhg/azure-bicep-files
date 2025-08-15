

//////////////////////////////
@description('This Bicep file defines a virtual network with a specified address space and subnets.')
param vNet_Name string

@description('Location for the virtual network')
param location string

@description('Address space for the virtual network')
param vNet_AddressSpace array

@description('List of subnets to be created within the virtual network')
param subnets array = [
  {
    name: 'default'
    addressPrefix: ''
    networkSecurityGroupId: '' // Optional, can be omitted if not needed
  }
]

@description('Optional tags for the VNet')
param tags object = {}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  
  name: vNet_Name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: vNet_AddressSpace
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          networkSecurityGroup: {
            id: subnet.networkSecurityGroupId // Optional, can be omitted if not needed
          }
        }
      }
  
    ]
  }
}

output vNetId string = virtualNetwork.id
output vNetName string = virtualNetwork.name
output subnetIds array = virtualNetwork.properties.subnets
