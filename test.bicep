targetScope='subscription'

param resourceGroupName string = 'myRG'
param resourceGroupLocation string = 'eastus'

module rg './resourcegroup/resourcegroup.bicep' = {

params: {
  resourceGroupName: resourceGroupName
  resourceGroupLocation: resourceGroupLocation
  tags: {
    environment: 'Development'
    project: 'MyProject'
    owner: 'YourName'
    costCenter: '12345'
    department: 'IT'
    application: 'MyApplication'
    version: '1.0'
    createdBy: 'Srikanth'
    updatedBy: 'Srikanth'
  }
}
}
output resourceGroupId string = rg.outputs.resourceGroupId

// az deployment sub create --location eastus --template-file test.bicep


module vnet './vNet/vNet.bicep'= {
  scope: resourceGroup(resourceGroupName)
  name : 'myVNetModule'
  params: {
    vNet_Name: 'myVNet'
    location: resourceGroupLocation
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


