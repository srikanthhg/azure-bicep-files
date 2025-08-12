
@description('This Bicep file defines a virtual network with a specified address space and subnets.')
param vNet_Name string
@description('Location for the virtual network')
param location string
@description('Address space for the virtual network')
param vNet_AddressSpace array

@minLength(1)
@maxLength(10)
@allowed([
  [
    {
      name: 'Subnet-1'
      addressPrefix: ''
    }
    {    
      name: 'Subnet-2'
      addressPrefix: ''
    }
  ]
])
param subnets array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vNet_Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vNet_AddressSpace
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
        }
      }
  
    ]
  }
}

