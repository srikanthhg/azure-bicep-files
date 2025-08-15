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

module nsg './vnet/nsg.bicep' = {
  scope: resourceGroup(resourceGroupName)
  params: {
    location: resourceGroupLocation
  }
  dependsOn: [
    rg
  ]
}

module vnet './vnet/vnet.bicep'= {
  scope: resourceGroup(resourceGroupName)
  name : 'myVNetModule'
  params: {
    vNet_Name: 'myVNet'
    location: resourceGroupLocation
    vNet_AddressSpace: ['172.19.0.0/16']
    subnets: [
      {
        name: 'Subnet-0'
        addressPrefix: '172.19.1.0/24'
        networkSecurityGroupId: nsg.outputs.nsgId // Optional, can be omitted if not needed
      }
      {
        name: 'Subnet-1'
        addressPrefix: '172.19.2.0/24'
        networkSecurityGroupId: nsg.outputs.nsgId // Optional, can be omitted if not needed
      }
    ]
  }
}
// az deployment group create --resource-group myRG --template test2.bicep
// az deployment group delete -g myRG -n myVNetModule 
// az network vnet delete --resource-group myRG --name myVNet

module aks './aks/aks.bicep' = {
  scope: resourceGroup(resourceGroupName)
  params: {
    location: resourceGroupLocation
    identityConfiguration: {
      type: 'SystemAssigned'
      userAssignedIdentities: {}
    }
    sshPublicKey: loadTextContent('./bicep.pub')
    subnetid: vnet.outputs.subnetIds[1].id
  }

}
//////////////////////////


module vm './aks/vm.bicep' = {
  scope: resourceGroup(resourceGroupName)
  params: {
    location: resourceGroupLocation
    name: 'BootstrapVM'
    adminPassword: 'HelloWorld@123!'
    adminUsername: 'adminUserName'
    vmSize: 'Standard_B1s'
    sshPublicKey: loadTextContent('./bicep.pub')
    subnetid: vnet.outputs.subnetIds[0].id

  }
  // dependsOn: [
  //   aks
  // ]
}
