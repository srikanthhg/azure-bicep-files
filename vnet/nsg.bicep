@description('location for the VM')
param location string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: 'BootstrapVM-NSG'
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-ssh'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'default-allow-aks'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '0-65535'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }
}

output nsgId string = networkSecurityGroup.id
