module vnet './vNet/vNet.bicep'= {
  name : 'myVNetModule'
  params: {
    vNet_Name: 'myVNet'
    location: resourceGroup().location
    vNet_AddressSpace: ['172.19.0.0/16']
    subnets: [
      {
        name: 'Subnet-1'
        addressPrefix: '172.19.1.0/24'
      }
      {
        name: 'Subnet-2'
        addressPrefix: '172.19.2.0/24'
      }
    ]
  }
}
// az deployment group create --resource-group myRG --template test2.bicep
// az deployment group delete -g myRG -n myVNetModule 
// az network vnet delete --resource-group myRG --name myVNet
