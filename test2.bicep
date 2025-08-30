
resource privatednszone 'Microsoft.Network/privateDnsZones@2024-06-01'={
  name: 'myzone.com'
  location: 'global'
  
}

resource privatednszonegroup 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01'={
  name: 'myzonegroup'
  parent: privatednszone
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vnet.outputs.vNetId
    }
    registrationEnabled: false
  }
}
